// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface USDT {
    function totalSupply() external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);    
    function transferFrom(address src, address dst, uint256 amount)   external returns (bool);
    function approve(address _spender, uint256 amount) external returns (bool);
    function transfer(address to , uint amt) external returns(bool);
}