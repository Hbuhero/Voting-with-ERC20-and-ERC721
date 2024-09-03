// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {IdCardNft} from "src/IdCardNft.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VotingToken} from "src/VotingToken.sol";
import {Voting} from "src/Voting.sol";

contract DeployTokenContract is Script {
    VotingToken token;

    function run() external returns (VotingToken) {
        vm.startBroadcast();
        token = new VotingToken();
        vm.stopBroadcast();

        return token;
    }
}
