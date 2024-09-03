// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

// import "forge-std/Test.sol";
// import "../src/Voting.sol";
// import "../src/IdCardNft.sol";
// import "../src/VotingToken.sol";
// import "src/Base.sol";

// contract VotingTest is Test, Base {
//     Voting private voting;
//     IdCardNft private idCardNft;
//     VotingToken private votingToken;
//     address private owner;
//     address private user1;
//     address private user2;

//     function setUp() public {
//         owner = address(this);
//         user1 = address(0x123);
//         user2 = address(0x456);

//         // Deploy NFT and ERC20 contracts
//         idCardNft = new IdCardNft();
//         votingToken = new VotingToken();

//         // Deploy Voting contract
//         voting = new Voting(address(idCardNft), address(votingToken));

//         // Distribute tokens
//         votingToken.mint(user1, 1000 * 1e18);
//         votingToken.mint(user2, 500 * 1e18);

//         // Register users
//         voting.register("User1", 0, user1); // Position.ADMIN
//         voting.register("User2", 1, user2); // Position.PT
//     }

//     function testSetTopic() public {
//         Position;
//         allowedVoters[0] = Position.ADMIN;
//         allowedVoters[1] = Position.PT;

//         voting.setTopic("Topic 1", allowedVoters, 60);

//         Voting.Topic memory topic = voting.topic();
//         assertEq(topic.topic, "Topic 1");
//         assertEq(topic.yes, 0);
//         assertEq(topic.no, 0);
//         assertEq(topic.allowedVoters.length, 2);
//         assertEq(uint(topic.allowedVoters[0]), uint(Position.ADMIN));
//         assertEq(uint(topic.allowedVoters[1]), uint(Position.PT));
//         assertEq(voting.votingTime(), 60);
//     }

//     function testVoteYes() public {
//         Position;
//         allowedVoters[0] = Position.ADMIN;

//         voting.setTopic("Topic 1", allowedVoters, 60);

//         vm.prank(user1);
//         voting.vote(uint256(Voting.Choice.YES));

//         uint yesVotes = voting.numberOfYesVote();
//         assertEq(yesVotes, 1000); // 1000 tokens for user1
//     }

//     function testVoteNo() public {
//         Position;
//         allowedVoters[0] = Position.PT;

//         voting.setTopic("Topic 1", allowedVoters, 60);

//         vm.prank(user2);
//         voting.vote(uint256(Voting.Choice.NO));

//         uint noVotes = voting.numberOfNoVote();
//         assertEq(noVotes, 500); // 500 tokens for user2
//     }

//     function testVotingClosedAfterPerformUpkeep() public {
//         Position;
//         allowedVoters[0] = Position.ADMIN;

//         voting.setTopic("Topic 1", allowedVoters, 1); // 1 second duration

//         // Wait for the voting period to end
//         vm.warp(block.timestamp + 2);

//         Voting.Choice winningChoice = voting.performUpkeep();
//         assertEq(uint256(winningChoice), uint256(Voting.Choice.YES));
//         assertEq(voting.votingTime(), 1);
//     }

//     function testRegisterUser() public {
//         address newUser = address(0x789);
//         uint tokenId = voting.register("NewUser", 2, newUser); // Position.INTERN

//         assertEq(tokenId, 1);
//         assertEq(voting.getUserRole(newUser), Position.INTERN);
//         assertEq(voting.users().length, 3);
//     }

//     function testRevertIfNotOwnerSetsTopic() public {
//         vm.prank(user1);
//         Position;
//         allowedVoters[0] = Position.ADMIN;

//         vm.expectRevert("Not owner");
//         voting.setTopic("Unauthorized Topic", allowedVoters, 60);
//     }

//     function testVoteRevertsIfAlreadyVoted() public {
//         Position;
//         allowedVoters[0] = Position.ADMIN;

//         voting.setTopic("Topic 1", allowedVoters, 60);

//         vm.prank(user1);
//         voting.vote(uint256(Voting.Choice.YES));

//         vm.prank(user1);
//         vm.expectRevert("Voting is only once");
//         voting.vote(uint256(Voting.Choice.YES));
//     }
// }
