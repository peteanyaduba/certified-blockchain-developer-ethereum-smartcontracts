/*SPDX-License-Identifier: GPL-3.0*/

//Contributors, Manager, minContribution, deadline
//raisedAmount, noOfContributors

pragma solidity ^0.8.17;

contract CrowdFunding {
    mapping (address => uint) public Contributors;
    address public manager;
    uint256 public minContribution;
    uint256 public deadline;
    uint256 public target;
    uint256 public raisedAmount;
    uint256 public noOfContributors;

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
}