// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC20Token.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract VotingContract is Ownable {
    using SafeMath for uint256;

    IERC20Token private _token;

    uint256 private _priceWithTheStrongestVoice;
    address private _userWithTheStrongestVoice;
    uint256 private _minTokenAmount = 5; // 5%
    uint256 private _timeToVote = 60 * 60 * 2; // 2 hours
    uint256 private _votingStartedTime;
    uint256 private _votingNumber = 0;
    mapping (uint256 => mapping (address => bool)) private _hasVoted;
    uint256 private _feePercentage = 1; // 1%
    uint256 private _fees;
    uint256 private _feeCollectTime = 60 * 60 * 24 * 7;
    uint256 private _lastTimeFeeCollected;
    address payable private _feeTransferAddress;


    event VotingStarted(uint256 time, uint256 number);
    event VotingEnded(uint256 time, uint256 number, address winner, uint256 newPrice);

    constructor(address token, address payable feeTransferAddress) {
        _token = IERC20Token(token);
        _token.addPriceVotingAdmin(address(this));
        _feeTransferAddress = feeTransferAddress;
    }

    function startVoting() public {
        require(_checkIfUserIsAllowed(msg.sender), "Sender doesn't have 0.05% of total supply");
        require(_votingStartedTime == 0, "Voting already started");
        _increaseVotingNumber();
        _votingStartedTime = block.timestamp;

        emit VotingStarted(_votingStartedTime, _votingNumber);
    }

    function vote(uint256 price) public {
        require(_checkIfUserIsAllowed(msg.sender), "Sender doesn't have 0.05% of total supply");
        require(_votingStartedTime != 0, "Voting hasn't started");
        require(!_hasVoted[_votingNumber][msg.sender], "You already voted!");

        if(_token.balanceOf(msg.sender) > _token.balanceOf(_userWithTheStrongestVoice)) {
            _userWithTheStrongestVoice = msg.sender;
            _priceWithTheStrongestVoice = price;
        }
    }

    function endVoting() public {
        require(block.timestamp - _votingStartedTime > _timeToVote, "Voting time has not ended");
        require(_checkIfUserIsAllowed(msg.sender), "Sender doesn't have 0.05% of total supply");

        _token.changeTokenPrice(_priceWithTheStrongestVoice);
        _votingStartedTime = 0;
        _userWithTheStrongestVoice = address(0);
        _priceWithTheStrongestVoice = 0;
        emit VotingEnded(block.timestamp, _votingNumber, _userWithTheStrongestVoice, _priceWithTheStrongestVoice);
    }

    function changeVotingTime (uint256 newVotingTime) onlyOwner public {
        _timeToVote = newVotingTime;
    }

    function buy() payable public {
        require(msg.value > 0, "User needs some ether to buy token");
        uint256 fee = _feePercentage.mul(10).div(100).mul(msg.value);
        _fees += fee;
        uint256 tokenAmount = (msg.value - fee).div(_token.getTokenPrice());
        _token.mint(tokenAmount, msg.sender);
    }

    function sell(uint256 amount) public {
        require(amount > 0);
        uint256 etherAmount = amount * _token.getTokenPrice();
        require(
            _token.balanceOf(msg.sender) >= amount,
            "User doesn't have this amount of tokens"
        );
        require(
            address(this).balance >= etherAmount,
            "Contract doesn't have this amount"
        );
        uint256 fee = _feePercentage.mul(amount).div(100);
        _fees += fee;
        _token.burn(amount, msg.sender);
        payable(msg.sender).transfer(etherAmount - fee);
    }

    function collectFees() onlyOwner public {
        require(block.timestamp - _lastTimeFeeCollected > _feeCollectTime, "Fee was collected this week");
        require(_fees > 0);
        _feeTransferAddress.transfer(_fees);
        _fees = 0;
        _lastTimeFeeCollected = block.timestamp;
    }

    function _increaseVotingNumber() private returns (uint256) {
        return ++_votingNumber;
    }

    function _checkIfUserIsAllowed (address user) private view returns (bool) {
        uint256 userTokenAmount = _token.balanceOf(user);
        uint256 totalSupply = _token.totalSupply();

        return userTokenAmount >= totalSupply.div(10000).mul(_minTokenAmount);
    }
}
