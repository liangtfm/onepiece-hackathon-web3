// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract HomeownerBadge is ERC721Enumerable, ReentrancyGuard, Ownable2Step {
    uint256 public currentTokenId;
    string public _baseTokenURI;

    constructor() ERC721("Homeowner Badge", "HMOWNR") Ownable(msg.sender) {}

    function mint() public nonReentrant {
        require(balanceOf(msg.sender) == 0, "User can only mint 1");
        currentTokenId += 1;
        _safeMint(msg.sender, currentTokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseTokenURI) public onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }
}
