// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherTransfer {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Function to receive Ether and transfer it to another address
    function transferEther(address payable receiver) public payable {
        require(msg.sender == owner, "Only the owner can initiate this transfer");
        require(receiver != address(0), "Invalid receiver address");
        require(msg.value > 0, "Transfer amount must be greater than 0");
        receiver.transfer(msg.value);
    }

    // Function to check the contract's balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

