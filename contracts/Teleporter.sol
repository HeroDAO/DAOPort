// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./TxnExecutor.sol";
import "./common/Enum.sol";

contract Teleporter is TxnExecutor{
    event Success();

    address public owner;
    address public contractToCall;
    uint256 value;
    Enum.Operation operation;
    uint256 safeTxGas;
    uint256 baseGas;
    uint256 gasPrice;
    address gasToken;
    address payable refundReceiver;

    // TODO: make below args to constructor compatible with Executor
    // data
    constructor(
        address _owner,
        address _contractToCall,
        uint256 _value,
        Enum.Operation _operation,
        uint256 _safeTxGas,
        uint256 _baseGas,
        uint256 _gasPrice,
        address _gasToken,
        address payable _refundReceiver
    ) {
        owner = _owner;
	contractToCall = _contractToCall;
	value = _value;
	operation = _operation;
	safeTxGas = _safeTxGas;
	baseGas = _baseGas;
	gasPrice = _gasPrice;
	gasToken = _gasToken;
	refundReceiver = _refundReceiver;
    }

    function executeTransaction(bytes calldata data) public {
        execTransaction(
            contractToCall,
            value,
            data,
            operation,
            safeTxGas,
            baseGas,
            gasPrice,
            gasToken,
            refundReceiver
        );
	emit Success();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
