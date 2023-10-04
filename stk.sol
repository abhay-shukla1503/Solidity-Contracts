// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract StakingContract is Context {
    using SafeMath for uint256;

    IERC20 public token; // The ERC-20 token to be staked
    uint256 public rewardRate = 1; // Reward rate (1% per second)
    uint256 public minStakeAmount = 100; // Minimum staking amount

    struct Stake {
        uint256 amount; // Staked amount
        uint256 startTime; // Staking start time
        uint256 duration; // Duration of the stake in seconds
    }

    mapping(address => Stake[]) private stakes;
    mapping(address => uint256) private rewards;

    event Staked(address indexed user, uint256 amount, uint256 duration);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
    }

    // Stake tokens
    function stake(uint256 _amount, uint256 _duration) external {
        require(_amount >= minStakeAmount, "Amount is below minimum stake");
        require(_duration > 0, "Duration must be greater than zero");
        require(token.transferFrom(_msgSender(), address(this), _amount), "Transfer failed");

        stakes[_msgSender()].push(Stake(_amount, block.timestamp, _duration));
        emit Staked(_msgSender(), _amount, _duration);
    }

    // Unstake tokens
    function unstake(uint256 _index) external {
        require(_index < stakes[_msgSender()].length, "Invalid stake index");
        Stake storage stakeInfo = stakes[_msgSender()][_index];
        require(block.timestamp >= stakeInfo.startTime, "Staking period not completed");

        uint256 stakedAmount = stakeInfo.amount;
        stakes[_msgSender()][_index] = stakes[_msgSender()][stakes[_msgSender()].length - 1];
        stakes[_msgSender()].pop();

        require(token.transfer(_msgSender(), stakedAmount), "Transfer failed");
        emit Unstaked(_msgSender(), stakedAmount);
    }

    // Claim rewards
    function claimReward() external {
        uint256 totalReward = calculateReward(_msgSender());
        require(totalReward > 0, "No rewards to claim");

        rewards[_msgSender()] = 0;
        require(token.transfer(_msgSender(), totalReward), "Transfer failed");
        emit RewardClaimed(_msgSender(), totalReward);
    }

    // Calculate the pending reward for a user
    function calculateReward(address _user) public view returns (uint256) {
        uint256 totalReward = 0;
        Stake[] storage userStakes = stakes[_user];

        for (uint256 i = 0; i < userStakes.length; i++) {
            Stake storage stakeInfo = userStakes[i];
            uint256 elapsedTime = block.timestamp.sub(stakeInfo.startTime);
            uint256 reward = stakeInfo.amount.mul(elapsedTime).mul(rewardRate).div(1e18); // 1% per second
            totalReward = totalReward.add(reward);
        }

        return totalReward;
    }

    // Get the number of stakes for a user
    function getStakeCount(address _user) external view returns (uint256) {
        return stakes[_user].length;
    }

    // Get stake details for a user
    function getStakeDetails(address _user, uint256 _index) external view returns (uint256, uint256) {
        require(_index < stakes[_user].length, "Invalid stake index");
        Stake storage stakeInfo = stakes[_user][_index];
        return (stakeInfo.amount, stakeInfo.startTime);
    }

    // Get the user's total reward balance
    function getRewardBalance(address _user) external view returns (uint256) {
        return rewards[_user];
    }

    
}
