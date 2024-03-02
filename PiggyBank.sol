// CCMP 606 Assignment 1
// Piggy Bank Smart Contract
// Author: LOVEPREET KAUR

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// My contract address: 0xB119021B70A0184602ed060736738705Dd203404      

contract PiggyBank {

    address public immutable owner;
    uint public savingsGoal;
    mapping(address=>uint) public deposits;
    
    // Set up an event to emit once you reach the savings goal 
    event SavingsGoalReached(address indexed depositor, uint amount);

    // Set up so that the owner is the person who deployed the contract.
    constructor(uint _savingsGoal) {
        owner = msg.sender;
        savingsGoal = _savingsGoal;
    }
    
    // Create a modifier onlyOwner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to receive ETH, called depositToTheBank
    function depositToTheBank() external payable {
        uint amount = msg.value;
        deposits[msg.sender] += amount;
        emit SavingsGoalReached(msg.sender, amount);
        if(address(this).balance >= savingsGoal) {
            _reachSavingsGoal();
        }
    }
    
    // Function to return the balance of the contract, called getBalance
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    // Function to look up how much any depositor has deposited, called getDepositsValue
    function getDepositsValue(address depositor) external view returns(uint) {
        return deposits[depositor];
    }

    // Function to withdraw (send) ETH, called emptyTheBank
    // -- Only the owner of the contract can withdraw the ETH from the contract
    function emptyTheBank() external onlyOwner {
        uint balance = address(this).balance;
        payable(owner).transfer(balance);
    }

    // Internal function to handle the savings goal reached event
    function _reachSavingsGoal() internal {
        emit SavingsGoalReached(owner, savingsGoal);
    }
}