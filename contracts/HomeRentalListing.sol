// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "./HomeListing.sol";
import "./RenterBadge.sol";

contract HomeRentalListing is ERC721Enumerable, ReentrancyGuard, Ownable2Step {
    enum Status {
        Closed,
        Open,
        Pending,
        Rented,
        Sold
    }

    uint256 public currentTokenId;
    string public _baseTokenURI;
    string public homeAddress;
    string public renterAddress;
    HomeListing public homeListing;
    RenterBadge public renterBadge;
    mapping(uint256 => Status) public listingStatus;
    mapping(uint256 => uint256) public homeListingMap;
    

    constructor(address _homeListingAddress, address _renterBadgeAddress) ERC721("Home Rental Listing", "HMRNTL") Ownable(msg.sender) {
        homeListing = HomeListing(_homeListingAddress);
        renterBadge = RenterBadge(_renterBadgeAddress);
    }

    function mint(uint256 _listingId) public nonReentrant {
        require(renterBadge.balanceOf(msg.sender) > 0, "Renter Badge Required");
        currentTokenId += 1;
        homeListingMap[currentTokenId] = _listingId;
        listingStatus[currentTokenId] = Status.Closed;
        _safeMint(msg.sender, currentTokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function getStatusForListing(uint256 _listingId) public view returns (Status) {
        return listingStatus[_listingId];
    }

    function set(uint256 _listingId, Status _status) public {
        require(homeListing.getOwnerAddressForListing(_listingId) == msg.sender, "Not owner");
        listingStatus[_listingId] = _status;
    }

    function setBaseURI(string memory baseTokenURI) public onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }
}
