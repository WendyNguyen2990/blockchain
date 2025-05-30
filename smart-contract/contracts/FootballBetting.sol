// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FootballBetting {
    struct Match {
        string teamA;
        string teamB;
        uint256 startTime;
        bool finished;
        uint8 result; 
        uint256 totalBetA;
        uint256 totalBetB;
        uint256 totalBetDraw;
    }

    struct Bet {
        uint256 amount;
        uint8 team; // 1: teamA, 2: teamB, 3: hòa
        bool claimed;
    }

    address public owner;
    uint256 public matchCount;
    mapping(uint256 => Match) public matches;
    mapping(uint256 => mapping(address => Bet)) public bets;

    event MatchCreated(uint256 matchId, string teamA, string teamB, uint256 startTime);
    event BetPlaced(uint256 matchId, address user, uint8 team, uint256 amount);
    event ResultSet(uint256 matchId, uint8 result);
    event RewardClaimed(uint256 matchId, address user, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier matchExists(uint256 matchId) {
        require(matchId < matchCount, "Match does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createMatch(string memory teamA, string memory teamB, uint256 startTime) external onlyOwner {
        matches[matchCount] = Match(teamA, teamB, startTime, false, 0, 0, 0, 0);
        emit MatchCreated(matchCount, teamA, teamB, startTime);
        matchCount++;
    }

    function bet(uint256 matchId, uint8 team) external payable matchExists(matchId) {
        require(block.timestamp < matches[matchId].startTime, "Match already started");
        require(team == 1 || team == 2 || team == 3, "Invalid team");
        require(msg.value > 0, "Bet amount must be > 0");
        require(bets[matchId][msg.sender].amount == 0, "Already bet");

        bets[matchId][msg.sender] = Bet(msg.value, team, false);
        if (team == 1) matches[matchId].totalBetA += msg.value;
        else if (team == 2) matches[matchId].totalBetB += msg.value;
        else matches[matchId].totalBetDraw += msg.value;
        emit BetPlaced(matchId, msg.sender, team, msg.value);
    }

    function setResult(uint256 matchId, uint8 result) external onlyOwner matchExists(matchId) {
        require(!matches[matchId].finished, "Already finished");
        require(result == 1 || result == 2 || result == 3, "Invalid result");
        matches[matchId].result = result;
        matches[matchId].finished = true;
        emit ResultSet(matchId, result);
    }

    function claimReward(uint256 matchId) external matchExists(matchId) {
        Match storage m = matches[matchId];
        Bet storage b = bets[matchId][msg.sender];
        require(m.finished, "Match not finished");
        require(!b.claimed, "Already claimed");
        require(b.amount > 0, "No bet");
        require(b.team == m.result, "Not winner");

        uint256 totalPool = m.totalBetA + m.totalBetB + m.totalBetDraw;
        uint256 totalWin;
        uint256 totalLose;
        uint256 reward;

        if (m.result == 1) {
            totalWin = m.totalBetA;
            totalLose = m.totalBetB + m.totalBetDraw;
        } else if (m.result == 2) {
            totalWin = m.totalBetB;
            totalLose = m.totalBetA + m.totalBetDraw;
        } else {
            uint256 loserPool = m.totalBetA + m.totalBetB;
            if (loserPool > 0 && m.totalBetDraw > 0) {
                uint256 fee = (loserPool * 5) / 100;
                uint256 rewardPool = loserPool - fee;
                reward = b.amount + (rewardPool * b.amount) / m.totalBetDraw;
            } else {
                reward = b.amount;
            }
            b.claimed = true;
            (bool sent1, ) = msg.sender.call{value: reward}("");
            require(sent1, "Failed to send reward");
            emit RewardClaimed(matchId, msg.sender, reward);
            return;
        }

        if (totalWin == 0 || totalLose == 0) {
            reward = b.amount;
        } else {
            uint256 fee = (totalPool * 5) / 100;
            uint256 loseAfterFee = totalLose > fee ? (totalLose - fee) : 0;
            reward = b.amount + (b.amount * loseAfterFee) / totalWin;
        }

        b.claimed = true;
        (bool sent2, ) = msg.sender.call{value: reward}("");
        require(sent2, "Failed to send reward");
        emit RewardClaimed(matchId, msg.sender, reward);
    }

    function getMatch(uint256 matchId) external view matchExists(matchId) returns (
        string memory, string memory, uint256, bool, uint8, uint256, uint256, uint256
    ) {
        Match memory m = matches[matchId];
        return (m.teamA, m.teamB, m.startTime, m.finished, m.result, m.totalBetA, m.totalBetB, m.totalBetDraw);
    }

    function getMyBet(uint256 matchId) external view matchExists(matchId) returns (uint256, uint8, bool) {
        Bet memory b = bets[matchId][msg.sender];
        return (b.amount, b.team, b.claimed);
    }

    receive() external payable {}
} 