// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BlacklistableERC20 is ERC20, Ownable {
    mapping(address => bool) private _blacklist;

    event Blacklisted(address indexed account);
    event Unblacklisted(address indexed account);

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
    {
        _mint(msg.sender,5);
    }

    function mint(address account, uint256 amount) public onlyOwner {
        require(_blacklist[account]==false, "Account is blacklisted");
        _mint(account, amount);
    }

    function blacklist(address account) public onlyOwner {
        require(account != owner() , "Cannot blacklist the owner");
        require(account != address(0), "Cannot blacklist zero address");
        _blacklist[account] = true;
        emit Blacklisted(account);
    }

    function unblacklist(address account) public onlyOwner {
        require(account != address(0), "Cannot unblacklist zero address");
        _blacklist[account] = false;
        emit Unblacklisted(account);
    }

    function isBlacklisted(address account) public view returns (bool) {
        return _blacklist[account];
    }

    function transfer(address recipient, uint256 amount)public override returns (bool) {
        require(!_blacklist[msg.sender], "Sender is blacklisted");
        require(!_blacklist[recipient], "Recipient is blacklisted");
        return super.transfer(recipient, amount);
    }

    function transferFrom( address sender, address recipient, uint256 amount) public override returns (bool) {
        require(!_blacklist[sender], "Sender is blacklisted");
        require(!_blacklist[recipient], "Recipient is blacklisted");
        return super.transferFrom(sender, recipient, amount);
    }
}

//0x4ff4A0ffB583f0FBD9b611f6eAc6179F76d6eB54