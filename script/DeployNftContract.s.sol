// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {IdCardNft} from "src/IdCardNft.sol";

contract DeployNftContract is Script {
    IdCardNft idnftcontract;

    function run() external returns (IdCardNft) {
        vm.startBroadcast();
        idnftcontract = new IdCardNft();
        vm.stopBroadcast();

        return idnftcontract;
    }
}
