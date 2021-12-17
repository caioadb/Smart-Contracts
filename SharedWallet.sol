//SPDX-License-Identifier: GPL-3.0
 
pragma solidity ^0.8.0;
 
contract SharedWallet{
	address owner;
	mapping(address=>uint) allowance;

	constructor(){
		owner = msg.sender;
	}

	modifier onlyOwner(){
		require(msg.sender == owner);
		_;
	}

	event Deposit(address _from, uint _amount);
	event Withdraw(address _to, uint _amount);

	function deposit() public payable {
		emit Deposit(msg.sender, msg.value);
	}

	function withdraw(uint _amount) public payable {
		require (_amount <= address(this).balance, "Not enough balance.");
		address payable addr = payable (msg.sender);
		if (msg.sender == owner){
			addr.transfer((_amount));
		}	
		else{
			require (_amount <= allowance[msg.sender], "Not allowed to withdraw that amount.");
			allowance[msg.sender] -= _amount;
			addr.transfer(_amount);
		}
		emit Withdraw(msg.sender, _amount);
	}

	function changeOwner(address _newOwner) public onlyOwner() {
		owner = _newOwner;
	}

	function changeAllowance(address _allowed, uint _amount) public onlyOwner() {
		allowance[_allowed] = _amount;
	}

	receive() external payable {
		deposit();
	}
}