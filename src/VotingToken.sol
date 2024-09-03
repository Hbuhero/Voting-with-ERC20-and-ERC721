// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base} from "./Base.sol";
import {console} from "forge-std/Script.sol";

contract VotingToken is ERC20, Ownable, Base {
    address private i_owner;

    modifier OnlyOwner() {
        require(msg.sender == i_owner, "Not owner");
        _;
    }

    constructor() ERC20("Voting Token", "VOT") Ownable(msg.sender) {
        i_owner = msg.sender;
        _mint(i_owner, 1000e18);
    }

    function transferTokenAfterMintingNft(
        User memory _user,
        address to
    ) public {
        console.log("Passed");
        if (_user.position == Position.PT) {
            transferFrom(i_owner, to, 1 ether);
            return;
        }
        if (_user.position == Position.INTERN) {
            transferFrom(i_owner, to, 2 ether);
            return;
        }
        if (_user.position == Position.STAFF) {
            transferFrom(i_owner, to, 3 ether);
            return;
        }
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override onlyOwner {
        super._update(from, to, value);
    }

    function reducePower(address from, uint256 value) external onlyOwner {
        _update(from, address(0), value);
    }

    function increasePower(address from, uint256 value) external onlyOwner {
        _update(from, address(0), value);
    }

    function revokePower(address from) external onlyOwner {
        _update(from, address(0), balanceOf(msg.sender));
    }

    function approve(address spender) public {
        _approve(i_owner, spender, 1000 ether);
    }

    function owner() public view override returns (address) {
        return i_owner;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18; // Default is 18
    }
}
