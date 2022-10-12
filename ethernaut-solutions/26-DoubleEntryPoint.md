- Use `await contract.cryptoVault()` to find the cryptoVault address
- Deploy the following contract to the same network, sending your cryptoVault address
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

contract Exploit {

    IForta public forta;
    address cryptoVault;

    constructor(address _cryptoVault) public {
        cryptoVault = _cryptoVault;
    }

    function handleTransaction(address user, bytes calldata ) external {
        address origSender;
        assembly {
            origSender := calldataload(0xa8)
        }
        if (origSender == cryptoVault){
            forta.raiseAlert(user);
        }
    }
}
```
- Call setDetectionBot(), sending your Exploit contract address
- Submit
