//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract todo{
    struct Task{
    uint id ;
    string name;
    string date;
}
    address owner;
    Task task;
    mapping (uint=>Task) tasks;
    uint taskId=1;

    modifier checkId(uint id){
        require (id!=0 && id<taskId,"Invalid ID");
        _;
    }

    constructor(){
        owner=msg.sender;
    }

    function createTask(string calldata _taskName,string calldata _date) public{
        tasks[taskId] = Task(taskId,_taskName,_date);
        taskId++;
    }

    function updateTask(uint _taskId,string calldata _taskName,string calldata _date) checkId(_taskId) public {
        tasks[_taskId] = Task(_taskId,_taskName,_date);
    }

    function alltask() public view returns(Task[] memory){
        Task[] memory tasklist = new Task[](taskId-1);
        for(uint i=0;i<taskId-1;i++){
            tasklist[i]=tasks[i+1];
        }
        return tasklist;
    }

    function viewtask(uint _taskId) checkId(_taskId) public view returns (Task memory){
        return tasks[_taskId]; 
    }

    function deletetask(uint _taskId) checkId(_taskId) public {
        delete tasks[_taskId];
    }
}

//0x2d131416eb8e34881eeda2e615ff57bc2e8b821c