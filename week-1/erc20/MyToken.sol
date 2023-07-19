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

    // NOTE: These section will copy code from axelar sandbox and adopt it to remix version for deploying to the testnet

    // TODO: Link contract in the destination chain
    

    function bridge(
        string calldata destinationChain,
        uint256 amount
    ) external payable {
        // TODO: Fetch destinationAddress from destinationChain


        // TODO: Lock (Burn) token in the source chain


        // TODO: ABI encode payload


        // TODO: Pay gas fee to gas receiver contract


        // TODO: Submit a cross-chain message passing transaction


        // TODO: Emit event

    }

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
