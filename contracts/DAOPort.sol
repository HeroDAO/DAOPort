// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./TeleporterFactory.sol";
import "hardhat/console.sol";

contract DAOPort {
    event Deployed(address addr, uint salt);

    address last_deployed_address;

    function deployTeleporter(
        address _owner,
        address _contractToCall,
        uint256 _value,
        Enum.Operation _operation,
        uint256 _safeTxGas,
        uint256 _baseGas,
        uint256 _gasPrice,
        address _gasToken,
        address payable _refundReceiver,
        uint _salt)
        public payable returns (address) {
        TeleporterFactory factory_instance = new TeleporterFactory();
        bytes memory bytecode =
            factory_instance.getBytecode(
                _owner,
                _contractToCall,
                _value,
                _operation,
                _safeTxGas,
                _baseGas,
                _gasPrice,
                _gasToken,
                _refundReceiver
            );
        address contract_address = factory_instance.getAddress(bytecode, _salt);
        factory_instance.deploy(bytecode, _salt);
        last_deployed_address = contract_address;
        emit Deployed(contract_address, _salt);
        return contract_address;
    }

    function lastDeployedAddress() public view returns (address) {
        return last_deployed_address;
    }
}
