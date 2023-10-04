// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract KYC {
    struct User {
        string name;
        string contact;
        string residentialInfo;
        string aadharNumber;
    }

    mapping(address => User) private users;

    function setUserDetails(string memory _name,string memory _contact,string memory _residentialInfo,string memory _aadharNumber) public {
        users[msg.sender] = User(_name, _contact, _residentialInfo, _aadharNumber);
    }

    function getUserDetails() public view returns (string memory name,string memory contact,string memory residentialInfo,string memory aadharNumber) {
        User memory user = users[msg.sender];
        return (user.name, user.contact, user.residentialInfo, user.aadharNumber);
    }
}