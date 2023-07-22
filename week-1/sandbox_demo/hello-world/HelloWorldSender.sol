//SPDX-License-Identifier: MIT
pragma solidity >=0.8.9 <0.9.0;

import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";

contract MessageSender is AxelarExecutable {
    IAxelarGasService gasReceiver;

    constructor(address gateway_, address gasReceiver_)
        AxelarExecutable(gateway_)
    {
        gasReceiver = IAxelarGasService(gasReceiver_);
    }

    // Call this function to update the value of this contract along with all its siblings'.
    function setRemoteValue(
        string memory destinationChain,
        string memory destinationAddress,
        string calldata value_
    ) external payable {
        bytes memory payload = abi.encode(value_);
        if (msg.value > 0) {
            gasReceiver.payNativeGasForContractCall{value: msg.value}(
                address(this),
                destinationChain,
                destinationAddress,
                payload,
                msg.sender
            );
        }
        gateway.callContract(destinationChain, destinationAddress, payload);
    }
}
