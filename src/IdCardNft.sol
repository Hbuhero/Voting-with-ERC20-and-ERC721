// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base} from "./Base.sol";

contract IdCardNft is ERC721, Base {
    string private constant PT_TOKEN_URI =
        "ipfs://QmYY9LKLEGSji64JFoyMziLjmsTbNaMV78tJhXjNzqxZZB/?filename=pt.json";
    string private constant INTERN_TOKEN_URI =
        "ipfs://QmQvdBMTJYMbg5F7P5KrB3wRK1fkQT9xzv4EZoU339JBaz/?filename=intern.json";
    string private constant STAFF_TOKEN_URI =
        "ipfs://QmZApToC1V9BciMVMe2Bg9kr4EpUZxAAqjzTghN7c8JL62/?filename=staff.json";

    address private immutable i_owner;

    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;
    mapping(address => uint256) private s_addressToTokenId;

    constructor() ERC721("IdCard", "ID") {
        i_owner = msg.sender;
    }

    function mintNft(
        User memory _user,
        address to
    ) public returns (uint256 currentId) {
        currentId = s_tokenCounter;

        if (_user.position == Position.PT) {
            s_tokenIdToUri[currentId] = PT_TOKEN_URI;
            _safeMint(to, currentId);
            s_addressToTokenId[to] = currentId;
            s_tokenCounter++;
            return currentId;
        }

        if (_user.position == Position.INTERN) {
            s_tokenIdToUri[currentId] = INTERN_TOKEN_URI;
            _safeMint(to, currentId);
            s_addressToTokenId[to] = currentId;
            s_tokenCounter++;
            return currentId;
        }
        if (_user.position == Position.STAFF) {
            s_tokenIdToUri[currentId] = STAFF_TOKEN_URI;
            _safeMint(to, currentId);
            s_addressToTokenId[to] = currentId;
            s_tokenCounter++;
            return currentId;
        }
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
