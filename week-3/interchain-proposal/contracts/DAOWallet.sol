// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { IInterchainProposalSender } from './interfaces/IInterchainProposalSender.sol';
import { InterchainCalls } from './lib/InterchainCalls.sol';

bytes4 constant EXECUTE_SELECTOR = bytes4(keccak256("execute(string)"));

contract DAOWallet is Ownable {
    IInterchainProposalSender public immutable messenger;

    mapping(bytes32 => string) public destinationAddressMapping;

    constructor(IInterchainProposalSender _messenger) {
        messenger = _messenger;
    }

    function setDestinationAddressMapping(string calldata destinationChain, string calldata destinationAddress) public onlyOwner {
        destinationAddressMapping[keccak256(bytes(destinationChain))] = destinationAddress;
    }

    // This is just mock for easy use. 
    // In real life, DAO will send low level calldata to InterchainProposalSender from their smart contract wallet themselves.
    // However, DAO can choose to use this pattern but don't forget to check msg.sender!
    function sendMessage(string calldata destinationChain, address executableAddress, string calldata message) public payable {
        // require(msg.sender == <DAO_WALLET>, "Forbidden");

        InterchainCalls.Call[] memory calls = new InterchainCalls.Call[](1);

        calls[0] = InterchainCalls.Call({
            target: executableAddress,
            value: 0,
            callData: abi.encodeWithSelector(EXECUTE_SELECTOR, message)
        });

        messenger.sendProposal{value: msg.value}(
            destinationChain,
            destinationAddressMapping[keccak256(bytes(destinationChain))],
            calls
        );
    }
}
