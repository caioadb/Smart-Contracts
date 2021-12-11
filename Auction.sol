//SPDX-License-Identifier: GPL-3.0
 
pragma solidity ^0.8.0;
 
contract AuctionCreator{
	Auction[] public auctions;

	function createAuction() public{
		Auction newAuction = new Auction(msg.sender);
		auctions.push(newAuction);
	}
}

contract Auction{
	address payable public owner;

	uint public startBlock;
	uint public endBlock;
	string public ipfsHash;

	enum State {Started, Running, Ended, Canceled}
	State public auctionState;

	uint public highestBindingBid;
	address payable public highestBidder;

	mapping(address=>uint) public bids;

	uint bidIncrement;

	//starts auction on current block and ends 1 week after
	constructor(address eoa){
		owner = payable(eoa);
		auctionState = State.Running;

		startBlock = block.number;
		endBlock = startBlock + 40320;

		ipfsHash = "";
		bidIncrement = 100 wei;
	}
	
	//modifier allows only owner to call function
	modifier onlyOwner(){
		require(msg.sender == owner);
		_;
	}

	//modifier require transaction sender to not be the contract owner
	modifier notOwner(){
		require(msg.sender != owner);
		_;
	}

	//requires time to be within auction period
	modifier insideAuctionPeriod(){
		require(block.number >= startBlock);
		require(block.number <= endBlock);
		_;
	}

	//helper function to calculate min between two values
	function min(uint a, uint b) pure internal returns(uint){
		if (a <= b){
			return a;
		}
		else{
			return b;
		}
	}

	function placeBid() public payable notOwner() insideAuctionPeriod(){
		require(auctionState == State.Running);
		require(msg.value >= 100);

		uint currentBid = bids[msg.sender] + msg.value;
		require(currentBid > highestBindingBid);

		bids[msg.sender] = currentBid;

		if (currentBid <= bids[highestBidder]){
			highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
		}
		else{
			highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
			highestBidder = payable(msg.sender);
		}
	}

	function cancelAuction() public onlyOwner(){
		auctionState = State.Canceled;
	}

	function finalizeAuction() public{
		require(auctionState == State.Canceled || block.number > endBlock);
		require(msg.sender == owner || bids[msg.sender] > 0);

		address payable recipient;
		uint value;

		if (auctionState == State.Canceled){
			recipient = payable(msg.sender);
			value = bids[msg.sender];
		}
		else{
			if (msg.sender == owner){
				recipient = owner;
				value = highestBindingBid;
			}
			else{
				if (msg.sender == highestBidder){
					recipient = highestBidder;
					value = bids[highestBidder] - highestBindingBid;
				}
				else{
					recipient = payable(msg.sender);
					value = bids[msg.sender];
				}
			}
		}

		bids[recipient] = 0;
		recipient.transfer(value);
	}
}