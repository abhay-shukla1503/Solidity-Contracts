// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Import necessary contracts from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // ERC20 token standard
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol"; // ERC20 with burnable functionality
import "@openzeppelin/contracts/access/Ownable.sol"; // Ownable contract for ownership control

// MyToken contract inherits from ERC20, ERC20Burnable, and Ownable
contract MyToken is ERC20, ERC20Burnable, Ownable {

    // Constructor to initialize the token with a name and symbol
    constructor() ERC20("MyToken", "MTK") {}

    // Function to mint new tokens and assign them to an address
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); // Mint new tokens and assign to the specified address
    }
}