// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Naruto is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("Naruto", "Uzumaki") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

//0x7D3AEfa484C43D78c8f3BE6521A0578Ea5038A36