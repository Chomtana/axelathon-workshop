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

    // TODO: Link contract in the destination chain


    // Send message
    function bridge(
        string calldata destinationChain,
        uint256 tokenId
    ) external payable {
        // TODO: Fetch destinationAddress from destinationChain


        // TODO: Lock (Burn) token in the source chain


        // TODO: ABI encode payload


        // TODO: Pay gas fee to gas receiver contract


        // TODO: Submit a cross-chain message passing transaction


        // TODO: Emit event

    }

    // Receive message

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload
    ) internal override {
        // TODO: Validate sourceChain and sourceAddress


        // TODO: Decode payload


        // TODO: Unlock (Mint) token


        // TODO: Emit event

    }

    function _executeWithToken(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload,
        string calldata tokenSymbol,
        uint256 amount
    ) internal override {
        // TODO: Execute unlock flow


        // TODO: Decode payload


        // TODO: Get token address


        // TODO: Transfer token back to the target

    }
}
