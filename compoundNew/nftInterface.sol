// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Contract{
    function mint(address add) external ;
    function burn(uint256 tokenId)  external ;
    function totalSupply() external view returns (uint);
    function transferFrom(address from,address to, uint id) external  returns(bool);
}