// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Import axelar libraries
import "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";

contract ChomToken is ERC721, ERC721Burnable, Ownable, AxelarExecutable {
    // Store gas service
    IAxelarGasService public immutable gasService;
    mapping(bytes32 => string) public destinationAddressMapping;

    // Receive gateway and gas service
    constructor(
        IAxelarGateway _gateway,
        IAxelarGasService _gasService
    ) ERC721("Chom Token", "CHOM") AxelarExecutable(address(_gateway)) {
        gasService = _gasService;
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    // Link contract in the destination chain
    event SetDestinationMapping(string chainName, string contractAddress);
    function setDestinationMapping(string calldata chainName, string calldata contractAddress) public onlyOwner {
        destinationAddressMapping[keccak256(abi.encode(chainName))] = contractAddress;
        emit SetDestinationMapping(chainName, contractAddress);
    }

    event Lock(string destinationChain, string destinationAddress, uint256 tokenId);

    // Send message
    function bridge(
        string calldata destinationChain,
        uint256 tokenId
    ) external payable {
        // TODO: Fetch destinationAddress from destinationChain
        string memory destinationAddress = destinationAddressMapping[keccak256(abi.encode(destinationChain))];

        // TODO: Lock (Burn) token in the source chain
        _burn(tokenId);

        // TODO: ABI encode payload
        bytes memory payload = abi.encode(msg.sender, tokenId);

        // TODO: Pay gas fee to gas receiver contract
        if (msg.value > 0) {
            gasService.payNativeGasForContractCall{value: msg.value}(
                address(this),
                destinationChain,
                destinationAddress,
                payload,
                msg.sender
            );
        }

        // TODO: Submit a cross-chain message passing transaction
        gateway.callContract(destinationChain, destinationAddress, payload);

        // TODO: Emit event
        emit Lock(destinationChain, destinationAddress, tokenId);
    }

    // Receive message
    event Unlock(address indexed to, uint256 amount);

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal override {
        // TODO: Validate sourceChain and sourceAddress
        require(
            keccak256(abi.encode(sourceAddress)) == keccak256(abi.encode( destinationAddressMapping[
                keccak256(abi.encode(sourceChain))
            ] )),
            "Forbidden"
        );

        // TODO: Decode payload
        (address to, uint256 tokenId) = abi.decode(payload, (address, uint256));

        // TODO: Unlock (Mint) token
        _mint(to, tokenId);

        // TODO: Emit event
        emit Unlock(to, tokenId);
    }

    function _executeWithToken(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) internal override {
        // TODO: Execute unlock flow
        _execute(sourceChain, sourceAddress, payload);

        // TODO: Decode payload
        (address to) = abi.decode(payload, (address));

        // TODO: Get token address
        IERC20 token = IERC20(gateway.tokenAddresses(tokenSymbol));

        // TODO: Transfer token back to the target
        token.transfer(to, amount);
    }
}
