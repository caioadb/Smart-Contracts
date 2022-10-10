Deploy the following contract to the same network
```solidity
object "Exploit" {
    code {
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return (0, datasize("runtime"))
    }

    object "runtime" {
        code {
            mstore(0, 0x2A)
            return(0, 0x20)
        }
    }
}
```
- Set this contract as the solver in the MagicNumber contract
- Submit instance
