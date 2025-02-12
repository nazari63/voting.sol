// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    address public owner;
    mapping(address => bool) public hasVoted;  // ثبت رای‌دهندگان
    mapping(string => uint256) public votes;    // تعداد آراء برای هر گزینه

    string[] public options; // گزینه‌های رای‌گیری

    event Voted(address indexed voter, string option);
    event VotingStarted();
    event VotingEnded();

    bool public votingActive;

    constructor() {
        owner = msg.sender;
        votingActive = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // شروع رای‌گیری
    function startVoting(string[] memory _options) public onlyOwner {
        require(!votingActive, "Voting is already active");
        options = _options;
        votingActive = true;
        emit VotingStarted();
    }

    // پایان رای‌گیری
    function endVoting() public onlyOwner {
        require(votingActive, "Voting is not active");
        votingActive = false;
        emit VotingEnded();
    }

    // رای دادن به یک گزینه
    function vote(string memory _option) public {
        require(votingActive, "Voting is not active");
        require(!hasVoted[msg.sender], "You have already voted");

        bool validOption = false;

        // بررسی اینکه گزینه رای‌دهی معتبر است یا خیر
        for (uint i = 0; i < options.length; i++) {
            if (keccak256(abi.encodePacked(options[i])) == keccak256(abi.encodePacked(_option))) {
                validOption = true;
                break;
            }
        }
        
        require(validOption, "Invalid voting option");

        hasVoted[msg.sender] = true;  // ثبت رای‌دهنده
        votes[_option] += 1;           // افزایش تعداد آراء برای گزینه انتخاب شده

        emit Voted(msg.sender, _option);
    }

    // مشاهده تعداد آراء برای یک گزینه
    function getVotes(string memory _option) public view returns (uint256) {
        return votes[_option];
    }
}