// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IDAOExecutable {
  function execute(string calldata message) external;
}

contract DAOExecutable {
  address public immutable executor;

  constructor(address _executor) {
    executor = _executor;
  }

  event ProposalExecuted(string message);
  function execute(string calldata message) public {
    require(msg.sender == executor, "Forbidden");
    emit ProposalExecuted(message);
  }
}