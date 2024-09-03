// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {IdCardNft} from "./IdCardNft.sol";
import {VotingToken} from "./VotingToken.sol";
import {Base} from "./Base.sol";

/*
 * @title Voting contract
 * @author Hud Saidi
 * @notice A sample of a voting system
 */

error Voting__UpKeepNotNeeded();
error Voting__NoIDFound();
error Voting__Locked();

contract Voting is Base {
    address private immutable i_owner;
    IdCardNft private immutable i_idCardNft;
    VotingToken private immutable i_votingToken;

    uint private s_topicCounter = 0;
    bool private s_upkeepNeeded;
    Choice private s_winningChoice;
    User[] private userList;
    Topic[] private s_topicList;

    mapping(uint256 => mapping(address => bool)) alreadyVoted;
    mapping(address => bool) registered;
    mapping(address => Position) addressToRole;

    event VotedSuccessful(address voter);
    event TopicAdded(Topic topic);
    event Winner(string winner);

    modifier OnlyOwner() {
        require(msg.sender == i_owner, "Not owner");
        _;
    }

    modifier NotOwner() {
        require(msg.sender != i_owner, "Not owner");
        _;
    }

    modifier Voted(uint256 topicId) {
        require(
            alreadyVoted[topicId][msg.sender] != true,
            "Voting is only once"
        );
        _;
    }

    modifier AlreadyRegistered(address to) {
        require(registered[to] != true, "Registration is only once");
        _;
    }

    constructor(address votingTokenContract, address nftContract) {
        i_owner = msg.sender;
        i_votingToken = VotingToken(votingTokenContract);
        i_idCardNft = IdCardNft(nftContract);
    }

    function register(
        string memory _name,
        uint8 _position,
        address to
    ) public AlreadyRegistered(to) OnlyOwner returns (uint) {
        User memory _user = User({name: _name, position: Position(_position)});
        // mint nft
        uint id = IdCardNft(i_idCardNft).mintNft(_user, to);

        registered[to] = true;
        addressToRole[to] = _user.position;
        userList.push(_user);
        return id;
    }

    function registerAdmin(
        string memory _name,
        uint8 _position,
        address to
    ) public AlreadyRegistered(to) {
        User memory _user = User({name: _name, position: Position(_position)});
        registered[to] = true;
        addressToRole[to] = _user.position;
        userList.push(_user);
    }

    function setTopic(
        string memory _topic,
        Position[3] memory _allowedVoters,
        uint256 _duration
    ) public OnlyOwner {
        Topic memory tempTopic = Topic({
            id: s_topicCounter++,
            topic: _topic,
            yes: 0,
            no: 0,
            allowedVoters: _allowedVoters,
            duration: _duration,
            startingTime: block.timestamp,
            closed: false
        });

        s_topicList.push(tempTopic);
        emit TopicAdded(tempTopic);
    }

    // Set time period eligible for voting
    function vote(
        uint256 choiceNumber,
        uint topicId
    ) public NotOwner Voted(topicId) {
        if (i_idCardNft.balanceOf(msg.sender) == 0) {
            revert Voting__NoIDFound();
        }

        if (
            (block.timestamp - s_topicList[topicId].startingTime) >
            s_topicList[topicId].duration
        ) {
            revert Voting__Locked();
        }

        if (choiceNumber == uint256(Choice.YES)) {
            s_topicList[topicId].yes +=
                i_votingToken.balanceOf(msg.sender) /
                1e18;
        } else {
            s_topicList[topicId].no +=
                i_votingToken.balanceOf(msg.sender) /
                1e18;
        }

        alreadyVoted[topicId][msg.sender] = true;

        emit VotedSuccessful(msg.sender);
    }

    function checkUpkeep(uint topicId) public view returns (bool) {
        return
            (block.timestamp - s_topicList[topicId].startingTime) >
            s_topicList[topicId].duration;
    }

    // Getting vote results
    // Should be called automatically when time is up
    function performUpkeep(uint topicId) external OnlyOwner returns (Choice) {
        if (!checkUpkeep(topicId)) {
            revert Voting__Locked();
        }
        s_topicList[topicId].closed = true;

        if (s_topicList[topicId].no > s_topicList[topicId].yes) {
            s_winningChoice = Choice.NO;

            return s_winningChoice;
        } else {
            s_winningChoice = Choice.YES;

            return s_winningChoice;
        }
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function currentTopic() public view returns (Topic memory) {
        return s_topicList[s_topicList.length - 1];
    }

    function winningChoice() public view returns (Choice) {
        return s_winningChoice;
    }

    function users() public view returns (User[] memory) {
        return userList;
    }

    function getUserRole(address userAddress) public view returns (Position) {
        return addressToRole[userAddress];
    }

    function numberOfYesVote(uint topicId) public view returns (uint) {
        return s_topicList[topicId].yes;
    }

    function numberOfNoVote(uint topicId) public view returns (uint) {
        return s_topicList[topicId].no;
    }

    function listOfTopics() public view returns (Topic[] memory) {
        return s_topicList;
    }
}
