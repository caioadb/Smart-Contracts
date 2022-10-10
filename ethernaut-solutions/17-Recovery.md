- Open a block explorer
- Go to the transaction you initiated, that created the contract instance
- Grab the SimpleToken contract address (last recipient of the 0.001 ether)
- Use the following interface to interact with it, calling destroy()

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract SimpleToken {

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}
```
