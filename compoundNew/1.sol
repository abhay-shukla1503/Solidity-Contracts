// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface CUSDT {  
    // function count() external view returns (uint);
    function mint(uint amt) external;
    function redeem(uint redeemTokens) external returns (uint);
    // function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    // function approve(address spender, uint256 amount) external returns (bool);
    function borrowRatePerBlock() external view returns (uint);
    function exchangeRateStored() external view returns (uint256);
}