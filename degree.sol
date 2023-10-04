// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Degree {
    address owner;
    struct StudentDetails {
    uint rollNo;
    string name;
    uint marks;
    string deenPermission;
    string registrarPermission;
    string VCPermission;
    bytes32 hashcode;
}

StudentDetails[] passesList;
mapping(bytes32 => uint) hashToIndex;
mapping(uint => bool) usedRollNumbers; 

constructor() {
    owner = msg.sender;
}


function registrarAdvice(uint _rollNo, string memory _name, uint _marks) public {
    require(msg.sender == owner, "You are not authorized");
    require(!usedRollNumbers[_rollNo], "Roll number already used");
    if (_marks >= 33) {
        bytes32 hashNumber = keccak256(abi.encodePacked(_rollNo,_name));
        StudentDetails memory s1 = StudentDetails(_rollNo, _name, _marks,"Pass", "Pass", "Pass",hashNumber);
        passesList.push(s1);
        hashToIndex[hashNumber] = passesList.length - 1;
        usedRollNumbers[_rollNo] = true; // Mark the roll number as used
    }
}

function getStudentDetailsByHash(bytes32 _hash) public view returns (StudentDetails memory) {
    uint index = hashToIndex[_hash];
    require(index < passesList.length, "Data not found for the given hash");
    return passesList[index];
}

function getStudentDetailsByIndex(uint _index) public view returns (StudentDetails memory) {
    require(_index < passesList.length, "Invalid index");
    return passesList[_index];
}

function getAllStudentDetails() public view returns (StudentDetails[] memory) {
        return passesList;
    }
}