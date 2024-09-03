// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";
import {Base} from "src/Base.sol";
import {VotingToken} from "src/VotingToken.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract DeployVoting is Script, Base {
    function run() external returns (Voting) {
        address mostRecentVOTContract = DevOpsTools.get_most_recent_deployment(
            "VotingToken",
            block.chainid
        );
        address mostRecentNftContract = DevOpsTools.get_most_recent_deployment(
            "IdCardNft",
            block.chainid
        );
        vm.startBroadcast();
        Voting voting = new Voting(
            mostRecentVOTContract,
            mostRecentNftContract
        );
        voting.registerAdmin("Hud", 0, msg.sender);
        vm.stopBroadcast();

        return voting;
    }
}
