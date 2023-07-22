//SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.9.0;

import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";

contract MessageReceiver is AxelarExecutable {
    string public value;
    string public sourceChain;
    string public sourceAddress;
    IAxelarGasService gasReceiver;

    constructor(address _gateway, address _gasReceiver)
        AxelarExecutable(_gateway)
    {
        gasReceiver = IAxelarGasService(_gasReceiver);
    }

    event Executed();

    // Handles calls created by setAndSend. Updates this contract's value
    function _execute(
        string calldata sourceChain_,
        string calldata sourceAddress_,
        bytes calldata payload_
    ) internal override {
        (value) = abi.decode(payload_, (string));
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;

        emit Executed();
    }
}
