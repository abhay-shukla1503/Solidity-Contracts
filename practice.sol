// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract studentDetails{

    struct det{
        uint256 roll;
        string name;
        uint256 aadhar;
    }
    mapping(address=>det) details;

    function setter(uint256 _roll, string memory _name, uint256 _aadhar) public{
        det memory x ;
        x.roll = _roll;
        x.name = _name;
        x.aadhar = _aadhar;
        details[msg.sender]=x;
    }

    function getter(address ad) public view returns(det memory){
        return details[ad];
    }
}