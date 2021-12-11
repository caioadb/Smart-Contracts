//SPDX-License-Identifier: GPL-3.0
 
pragma solidity ^0.8.0;
 
contract CrowdFunding{
	mapping(address=>uint) public contributors;
	address public admin;
	uint public numOfContributors;
	uint public minContribution;
	uint public deadline;
	uint public goal;
	uint public raisedAmount;
	uint public numRequests;

	struct Request{
		string description;
		address payable recipient;

		uint value;
		uint numOfVoters;

		bool completed;

		mapping(address=>bool) voters;
	}

	mapping(uint=>Request) public requests;

	constructor(uint _goal, uint _deadline){
		goal = _goal;
		deadline = block.timestamp + _deadline;
		admin = msg.sender;
	}

	event ContributeEvent(address _sender, uint _value);
	event CreateRequestEvent(string _description, address _recipient, uint _value);
	event MakePaymentEvent(address _recipient, uint _value);


	//modifier allows only owner to call function
	modifier onlyOwner(){
		require(msg.sender == admin);
		_;
	}

	function contribute() public payable{
		require(block.timestamp < deadline, "Deadline has passed.");
		require(msg.value >= minContribution, "Minimum contribution not met.");

		if(contributors[msg.sender] == 0){
			numOfContributors++;
		}

		contributors[msg.sender] += msg.value;
		raisedAmount += msg.value;

		emit ContributeEvent(msg.sender, msg.value);
	}

	receive() payable external{
		contribute();
	}

	function getBalance() public view returns(uint){
		return address(this).balance;
	}

	//allows contributors to get refund if goal was not met
	function getRefund() public{
		require(block.timestamp > deadline && raisedAmount < goal);
		require(contributors[msg.sender] > 0);

		address payable recipient = payable(msg.sender);
		uint value = contributors[msg.sender];
		
		recipient.transfer(value);
		contributors[msg.sender] = 0;
	}

	//allows admin to create a new request
	function createRequest(string memory _description, address payable _recipient, uint _value) public onlyOwner(){
		Request storage newRequest = requests[numRequests];
		numRequests++;

		newRequest.description = _description;
		newRequest.recipient = _recipient;
		newRequest.value = _value;
		newRequest.completed = false;
		newRequest.numOfVoters = 0;

		emit CreateRequestEvent(_description, _recipient, _value);
	}

	//allows contributors to vote on a request
	function voteRequest(uint _requestNum) public{
		require(contributors[msg.sender] > 0, "You must be a contributor to vote.");

		Request storage thisRequest = requests[_requestNum];

		require(thisRequest.voters[msg.sender] == false, "You have already voted on this request.");
		thisRequest.voters[msg.sender] = true;
		thisRequest.numOfVoters++;
	}

	//makes a payment and concludes a request
	function makePayment(uint _requestNum) public onlyOwner(){
		require(raisedAmount >= goal);
		Request storage thisRequest = requests[_requestNum];

		require(thisRequest.completed == false, "The request has been completed.");
		require(thisRequest.numOfVoters > numOfContributors/2);

		thisRequest.recipient.transfer(thisRequest.value);
		thisRequest.completed = true;

		emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
	}
}