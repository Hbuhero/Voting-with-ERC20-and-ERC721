// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {IdCardNft} from "src/IdCardNft.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VotingToken} from "src/VotingToken.sol";
import {Base} from "src/Base.sol";
import {Voting} from "src/Voting.sol";

contract Registration is Script, Base {
    User public pt = User({name: "hud", position: Position.PT});
    User public intern = User({name: "hud", position: Position.INTERN});
    User public staff = User({name: "hud", position: Position.STAFF});

    function run() external returns (uint, address) {
        address mostRecentVOTContract = DevOpsTools.get_most_recent_deployment(
            "VotingToken",
            block.chainid
        );
        address mostRecentVotingContract = DevOpsTools
            .get_most_recent_deployment("Voting", block.chainid);

        uint id = mintAndTransfer(mostRecentVotingContract);
        return (id, mostRecentVOTContract);
    }

    function mintAndTransfer(address votingContract) public returns (uint) {
        vm.startBroadcast();
        uint id = Voting(votingContract).register(
            "Hud",
            1,
            0x14dC79964da2C08b23698B3D3cc7Ca32193d9955
        );

        vm.stopBroadcast();
        console.log(msg.sender, id);

        return id;
    }
}

contract Vote is Script, Base {
    function run() external {
        address mostRecentVotingContract = DevOpsTools
            .get_most_recent_deployment("Voting", block.chainid);

        doVote(mostRecentVotingContract);
    }

    function doVote(address votingContract) public {
        vm.startBroadcast(0x029f792F12c2111A0d5A8Ba6270ae102372DF17E);
        Voting(votingContract).vote(1, 0);
        vm.stopBroadcast();
    }
}

// contract Results is Script, Base {
//     function run() external returns (Choice) {
//         address mostRecentVotingContract = DevOpsTools
//             .get_most_recent_deployment("Voting", block.chainid);
//         return checkResult(mostRecentVotingContract);
//     }

//     function checkResult(address votingContract) public returns (Choice) {
//         vm.startBroadcast();
//         Choice choice = Voting(votingContract).performUpkeep();
//         vm.stopBroadcast();
//         return choice;
//     }
// }

// contract Check is Script {
//     function run() external returns (bool) {
//         address mostRecentVotingContract = DevOpsTools
//             .get_most_recent_deployment("Voting", block.chainid);
//         return check(mostRecentVotingContract);
//     }

//     function check(address votingContract) public returns (bool) {
//         vm.startBroadcast();
//         bool checkNeeded = Voting(votingContract).checkUpkeep();
//         vm.stopBroadcast();
//         return checkNeeded;
//     }
// }

contract SetTopic is Script, Base {
    function run() external {
        address mostRecentVotingContract = DevOpsTools
            .get_most_recent_deployment("Voting", block.chainid);
        setTopic(mostRecentVotingContract);
    }

    function setTopic(address votingAddress) public {
        vm.startBroadcast();
        Voting(votingAddress).setTopic(
            "Is ok",
            [Position.INTERN, Position.PT, Position.STAFF],
            60
        );
        vm.stopBroadcast();
    }
}
