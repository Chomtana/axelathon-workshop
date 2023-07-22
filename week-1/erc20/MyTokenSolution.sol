// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";

contract ChomToken is ERC20, ERC20Burnable, Ownable, AxelarExecutable {
    IAxelarGasService public immutable gasService;
    mapping(bytes32 => string) public destinationAddressMapping; // destinationAddressMapping[keccak256(destinationChain)] => destinationAddress / token contract

    constructor(
        address gateway_, address gasService_
    ) ERC20("Chom Token", "CHOM") AxelarExecutable(gateway_) {
        gasService = IAxelarGasService(gasService_);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    event SetDestinationAddress(string destinationChain, string destinationAddress);
    function setDestinationAddress(string calldata destinationChain, string calldata destinationAddress) public onlyOwner {
        destinationAddressMapping[keccak256(abi.encode(destinationChain))] = destinationAddress;
        emit SetDestinationAddress(destinationChain, destinationAddress);
    }

    event Lock(string destinationChain, string destinationAddress, uint256 amount);

    function bridge(
        string calldata destinationChain,
        uint256 amount
    ) external payable {
        // TODO: Fetch destinationAddress from destinationChain
        string memory destinationAddress = destinationAddressMapping[keccak256(abi.encode(destinationChain))];

        // TODO: Lock (Burn) token in the source chain
        _burn(msg.sender, amount);

        // TODO: ABI encode payload
        bytes memory payload = abi.encode(msg.sender, amount);

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
        emit Lock(destinationChain, destinationAddress, amount);
    }

    event Unlock(address indexed to, uint256 amount);

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal override {
        // TODO: Validate sourceChain and sourceAddress
        require(
            keccak256(abi.encode(sourceAddress)) == keccak256(abi.encode( destinationAddressMapping[keccak256(abi.encode(sourceChain))] )),
            "Malicious"
        );

        // TODO: Decode payload
        (address to, uint256 amount) = abi.decode(payload, (address, uint256));

        // TODO: Unlock (Mint) token
        _mint(to, amount);

        // TODO: Emit event
        emit Unlock(to, amount);
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
