// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

abstract contract Base {
    struct User {
        string name;
        Position position;
    }

    enum Position {
        ADMIN,
        PT,
        INTERN,
        STAFF
    }

    struct Topic {
        uint id;
        string topic;
        uint yes;
        uint no;
        Position[3] allowedVoters;
        uint256 duration;
        uint256 startingTime;
        bool closed;
    }

    enum VotingState {
        OPEN,
        CLOSED
    }

    enum Choice {
        NO,
        YES
    }
}
