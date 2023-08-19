// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Teleporter.sol";
import "./common/Enum.sol";

contract TeleporterFactory {
    // 1. Get bytecode of contract to be deployed
    // NOTE: _owner and _foo are arguments of the DAOContract's constructor
    function getBytecode(
        address _owner,
        address _contractToCall,
        uint256 _value,
        Enum.Operation _operation,
        uint256 _safeTxGas,
        uint256 _baseGas,
        uint256 _gasPrice,
        address _gasToken,
        address payable _refundReceiver
    ) public pure returns (bytes memory) {
        bytes memory bytecode = type(Teleporter).creationCode;

        return abi.encodePacked(bytecode,
            abi.encode(
                _owner,
                _contractToCall,
                _value,
                _operation,
                _safeTxGas,
                _baseGas,
                _gasPrice,
                _gasToken,
                _refundReceiver
            ));
    }

    // 2. Compute the address of the contract to be deployed
    // NOTE: _salt is a random number used to create an address
    function getAddress(bytes memory bytecode, uint _salt)
        public
        view
        returns (address)
    {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }

    // 3. Deploy the contract
    // NOTE:
    // Check the event log Deployed which contains the address of the deployed DAOContract.
    // The address in the log should equal the address computed from above.
    function deploy(bytes memory bytecode, uint _salt) public payable {
        address addr;

        /*
        NOTE: How to call create2

        create2(v, p, n, s)
        create new contract with code at memory p to p + n
        and send v wei
        and return the new address
        where new address = first 20 bytes of keccak256(0xff + address(this) + s + keccak256(mem[p…(p+n)))
              s = big-endian 256-bit value
        */
        assembly {
            addr := create2(
                callvalue(), // wei sent with current call
                // Actual code starts after skipping the first 32 bytes
                add(bytecode, 0x20),
                mload(bytecode), // Load the size of code contained in the first 32 bytes
                _salt // Salt from function arguments
            )

            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
    }
}
