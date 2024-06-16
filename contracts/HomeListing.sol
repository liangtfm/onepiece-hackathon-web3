// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "./HomeownerBadge.sol";

contract HomeListing is ERC721Enumerable, ReentrancyGuard, Ownable2Step {
    uint256 public currentTokenId;
    string public _baseTokenURI;
    mapping(string => uint256) public addressMap;
    mapping(uint256 => string) public listingAddressMap;
    mapping(uint256 => address) public ownerMap;
    HomeownerBadge public homeownerBadge;

    constructor(address _homeownerBadgeAddress) ERC721("Home Listing", "HOME") Ownable(msg.sender) {
        homeownerBadge = HomeownerBadge(_homeownerBadgeAddress);
    }

    function mint(string memory _homeAddress) public nonReentrant {
        require(homeownerBadge.balanceOf(msg.sender) > 0, "Homeowner Badge Required");
        require(addressMap[_homeAddress] == 0, "Address already exists");
        currentTokenId += 1;
        addressMap[_homeAddress] = currentTokenId;
        listingAddressMap[currentTokenId] = _homeAddress;
        ownerMap[currentTokenId] = msg.sender;
        _safeMint(msg.sender, currentTokenId);
    }

    function checkAddressListingId(string memory _homeAddress) public view returns (uint256) {
        return addressMap[_homeAddress];
    }

    function getListingAddress(uint256 _tokenId) public view returns (string memory) {
        return listingAddressMap[_tokenId];
    }

    function getOwnerAddressForListing(uint256 _listingId) public view returns (address) {
        return ownerMap[_listingId];
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
