/*SPDX-License-Identifier: GPL-3.0*/

//Contributors, Manager, minContribution, deadline
//raisedAmount, noOfContributors

pragma solidity ^0.8.17;

contract CrowdFunding2 {
    mapping (address => uint) public Contributors;
    address public manager;
    uint256 public minContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public raisedAmount;
    uint256 public noOfContributors;

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool isCompleted;
        uint noOfVoters;
        mapping (address => bool) voters;
    }

    mapping (uint => Request) public requests;
    uint public numRequests;

    constructor(uint256 _target, uint256 _deadline){
        target = _target;
        deadline = block.timestamp+ _deadline;
        minContribution = 100 wei;
        manager = msg.sender;
    }

    function sendEth() public payable {
        require(block.timestamp < deadline, "Deadline has been passed");
        require(msg.value >= 100 wei, "Minimum contribution not met");
        
        if(Contributors[msg.sender] == 0){
            noOfContributors++;
        }
        Contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getContactBalance() public view returns(uint){
        return address(this).balance;
    }

    function refund() public {
        require( block.timestamp > deadline && raisedAmount < target);
        require( Contributors[msg.sender] > 0 );
        address payable user = payable( msg.sender );
        user.transfer(Contributors[msg.sender]);
        Contributors[msg.sender] = 0;
    }

    modifier onlyManager() {
        require( msg.sender == manager, "only manager can call this function" );
        _;
    }

    function createRequest(
        string memory _description, 
        address payable _recipient, 
        uint _value
    ) public onlyManager {
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.isCompleted = false;
        newRequest.noOfVoters = 0;
    } 

    function voteRequest( uint _requestNo ) public {
        require( Contributors[msg.sender] > 0, "you are not a contributor" );
        Request storage thisRequest = requests[_requestNo];
        require( thisRequest.voters[msg.sender] == false, "you have already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment( uint _requestNo ) public onlyManager {
        require( raisedAmount >= target, "raised amount must be greater than target amount" );
        Request storage thisRequest = requests[_requestNo];
        require( thisRequest.isCompleted == false, "already distributed the amount" );
        require( thisRequest.noOfVoters > noOfContributors / 2, "majority support marks not crossed" );
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.isCompleted = true;
    }
}