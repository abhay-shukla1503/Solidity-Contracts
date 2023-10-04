// SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 <0.9.0;
import "./getsmart.sol";

contract Manager is Smart{
    mapping(address=>string) private Users;
    string Sponser;
    string Student;
    constructor(string memory _Sponser,string memory _Student) {
        Sponser=_Sponser;
        Student=_Student;
    }
    mapping(address=>bool) UserRegistered;
    function Register(string memory t) public{
        require(!UserRegistered[msg.sender],"User already Registered");
        require(sha256(abi.encodePacked(t))==sha256(abi.encodePacked(Sponser)) || sha256(abi.encodePacked(t))==sha256(abi.encodePacked(Student)),"User already Registered");
        UserRegistered[msg.sender]=true;
        Users[msg.sender] = t;
    }

    function UserType() public view returns (string memory) {
        return Users[msg.sender];
    }

    function isRegistered() public view returns (bool) {
        return UserRegistered[msg.sender];
    }

    function checkUserRegistered(address a) public view returns (bool) {
        return UserRegistered[a];
    }

    function checkUserType(address a) public view returns (string memory) {
        return Users[a];
    }

    function buyTokens(uint256 _numTokens) external payable {
        uint256 totalCost = _numTokens * tokenPrice;
        require(msg.value >= totalCost, "Insufficient ethers sent");
        require(sha256(abi.encodePacked(Users[msg.sender]))==sha256(abi.encodePacked(Sponser)), "You are not allowed to buy");
        require(balanceOf(owner()) >= _numTokens, "Not enough tokens in owner's balance");
        _transfer(owner(),msg.sender,_numTokens);
    }
}