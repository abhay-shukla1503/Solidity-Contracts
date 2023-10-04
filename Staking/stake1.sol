// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/** 
@title Staking ERC-20 Token
@author Abhay Shukla
@notice You can stake an ERC20 token for 2, 4, 6, 8 & 10 minutes and reieve reward of 1% per second
@dev You have to make an erc20 token say MyToken in this case then,
        convert the IERC20 instance to it. You can see the example in the constructor.
        MyToken is the name of my contract in which erc20 token is made
*/

/* To run this staking contract first the owner have to mint or transfer some tokens to this contract*/

contract Staking {
    IERC20 token; 
    using Counters for Counters.Counter;

/** Pass the address of the erc20 contract at the deployment of this staking contract*/

    constructor(IERC20 _token) {
        token = _token; 
    }

/** This struct datatype stores information about particular stake id*/

    struct StakeInfo {
        uint256 tokenId; 
        uint256 amount; 
        uint256 startTime; 
        uint256 timePeriod; 
    }

    /** Mapping to track stakes for each user */

    mapping(address => StakeInfo[]) public userStakes; 
    Counters.Counter private _tokenIdCounter; 

        /*  For staking {condition}
        1 --- you have enough token in your account
        2 --- you have to approve this contract an amount how much you want to stake
        3 --- you stake amount 1 or greater value
        4 --- choose a specific plan i.e., 2,4,6,8,10 minutes
        */

    function Stake(uint256 _amount, uint256 tarrif) public returns (StakeInfo memory) {
        require(tarrif == 2 || 
                tarrif == 4 || 
                tarrif == 6 || 
                tarrif == 8 || 
                tarrif == 10,
            "Please Enter Valid Tariff Plan");
        uint256 startTime = block.timestamp; 
        uint256 tokenId = _tokenIdCounter.current(); 
        StakeInfo memory newStake = StakeInfo(tokenId, _amount, startTime, tarrif * 1 minutes);
        userStakes[msg.sender].push(newStake);
        require(token.transferFrom(msg.sender, address(this), _amount), "Give approval from initial to stake"); 
        _tokenIdCounter.increment(); 
        return newStake;
    }

    /* This function gives the contract's balance */
    function ContractBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    /** This function calculate the reward based on your choosen plan */

    function calculateReward(StakeInfo memory stake1) public view returns (uint256) {
        uint256 currentTime = block.timestamp - stake1.startTime;
        uint256 reward = (stake1.amount * currentTime) / 100; 
        return reward;
    }

    /** This function returns all stakes taken by a specific user */

    function UserStakes(address user) public view returns (StakeInfo[] memory) {
        return userStakes[user];
    }

    /* Function to claim rewards for a specific stake */

    function claimReward(uint256 stakeIndex) public {
        StakeInfo[] storage stakes = userStakes[msg.sender];
        require(stakeIndex < stakes.length, "Invalid stake index");
        StakeInfo storage userStake = stakes[stakeIndex];
        require(block.timestamp >= userStake.startTime, "Staking has not started yet");
        uint256 reward = calculateReward(userStake);
        require(reward > 0, "No reward available");
        require(block.timestamp >= userStake.startTime + userStake.timePeriod, "Staking duration not completed");
        token.transfer(msg.sender, reward);
        removeStake(stakeIndex);
    }

    /** Internal function to remove a stake from the user's list */

    function removeStake(uint256 stakeIndex) internal {
        StakeInfo[] storage stakes = userStakes[msg.sender];
        require(stakeIndex < stakes.length, "Invalid stake index");
        if (stakeIndex < stakes.length - 1) {
            stakes[stakeIndex] = stakes[stakes.length - 1];
        }
        stakes.pop();
    }   

    /** Function to claim the staked amount for a specific stake */

    function claimAmount(StakeInfo memory _stk) public {
        require(block.timestamp >= _stk.startTime + _stk.timePeriod, "Staking duration not completed");
        token.transfer(msg.sender, _stk.amount);
         
    }
}
