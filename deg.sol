// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegreeVerification {
    address public dataEntryManager;
    address public viceChancellor;
    address public chancellor;
    address public registrar;

    enum DegreeApprovalStatus { Pending, Approved, Rejected }
    
    struct Student {
        string rollNo;
        string name;
        DegreeApprovalStatus status;
        address[] approvals;
    }

    mapping(address => bool) public isAuthorized;
    mapping(string => Student) public students;
    mapping(string => mapping(address => bool)) public studentApprovals;

    event DegreeApproval(address indexed approver, string indexed rollNo, DegreeApprovalStatus status);

    constructor(address _viceChancellor, address _chancellor, address _registrar) {
        viceChancellor = _viceChancellor;
        chancellor = _chancellor;
        registrar = _registrar;
        
        // Assign the roles who can approve degrees
        isAuthorized[_viceChancellor] = true;
        isAuthorized[_chancellor] = true;
        isAuthorized[_registrar] = true;
    }

    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender], "Not authorized");
        _;
    }

    function addStudent(string memory _rollNo, string memory _name) external onlyAuthorized {
        require(bytes(_rollNo).length > 0, "Roll number cannot be empty");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(students[_rollNo].status == DegreeApprovalStatus.Pending, "Student already exists");
        
        students[_rollNo] = Student({
            rollNo: _rollNo,
            name: _name,
            status: DegreeApprovalStatus.Pending,
            approvals: new address[](0)
        });
    }

    function approveDegree(string memory _rollNo) external onlyAuthorized {
        require(bytes(_rollNo).length > 0, "Roll number cannot be empty");
        require(students[_rollNo].status == DegreeApprovalStatus.Pending, "Student not found or degree already approved");
        require(!studentApprovals[_rollNo][msg.sender], "Already approved");

        students[_rollNo].approvals.push(msg.sender);
        studentApprovals[_rollNo][msg.sender] = true;
        emit DegreeApproval(msg.sender, _rollNo, DegreeApprovalStatus.Approved);

        // Check if all approvals are granted
        if (students[_rollNo].approvals.length == 3) { // Assuming there are 4 roles in total
            students[_rollNo].status = DegreeApprovalStatus.Approved;
        }
    }

    function rejectDegree(string memory _rollNo) external onlyAuthorized {
        require(bytes(_rollNo).length > 0, "Roll number cannot be empty");
        require(students[_rollNo].status == DegreeApprovalStatus.Pending, "Student not found or degree already approved");

        students[_rollNo].status = DegreeApprovalStatus.Rejected;
        emit DegreeApproval(msg.sender, _rollNo, DegreeApprovalStatus.Rejected);
    }
}
