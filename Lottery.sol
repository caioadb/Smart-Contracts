//SPDX-License-Identifier: GPL-3.0
 
pragma solidity ^0.8.0;
 
contract Lottery{
	address payable[] public players;
	address public manager;

	//adds contract deployer as manager
	constructor(){
		manager = msg.sender;
	}

	//modifier allows only owner to call function
	modifier onlyOwner(){
		require(msg.sender == manager);
		_;
	}

	//modifier require price to be met
	modifier priceMet(){
		require(msg.value == 0.1 ether, "Value sent is not 0.1 ether.");
		_;
	}

	//modifier require transaction sender to not be the contract owner
	modifier notOwner(){
		require(msg.sender != manager);
		_;
	}

	//receive ether function
	receive()  payable external priceMet() notOwner(){
		players.push(payable(msg.sender) );
	}

	//get balance of contract, only usable by manager
	function getBalance() public view onlyOwner() returns(uint){
		return address(this).balance;
	}
    
    //generate a random uint256
    function random() internal view returns(uint){
    	return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    //sends entire contract balance to winner and resets the lottery
    function pickWinner() public onlyOwner(){
    	require(players.length >= 3);

    	uint r = random();
    	address payable winner;

    	uint index = r % players.length;
    	winner = players[index];
    	
        uint managerFee = (getBalance() ) / 100; // manager fee is 1%
        uint winnerPrize = (getBalance() * 99 ) / 100;    // winner prize is 99%
        
        // transferring 99% of contract's balance to the winner
        winner.transfer(winnerPrize);
        
        // transferring 1% of contract's balance to the manager
        payable(manager).transfer(managerFee);


    	players = new address payable[](0);

    }
}