// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFTFactory is ERC721URIStorage, Ownable {
    uint256 private tokenCounter;

    constructor(address initialOwner) ERC721("MyNFT", "MNFT") Ownable(initialOwner) {
        tokenCounter = 0;
    }

    function createNFT(address owner, string memory tokenURI) external returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(owner, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        tokenCounter++;
        return newTokenId;
    }

    function getTokenURI(uint256 tokenId) external view returns (string memory) {
        // Use ownerOf to check if the token exists
        try this.ownerOf(tokenId) returns (address) {
            return tokenURI(tokenId);
        } catch {
            revert("Token does not exist");
        }
    }

    function getTokenIdsByOwner(address owner) external view returns (uint256[] memory) {
        uint256[] memory tokenIds = new uint256[](tokenCounter);
        uint256 count = 0;
        for (uint256 i = 0; i < tokenCounter; i++) {
            if (this.ownerOf(i) == owner) {
                tokenIds[count] = i;
                count++;
            }
        }
        // Trim the array to remove empty slots
        uint256[] memory result = new uint256[](count);
        for (uint256 j = 0; j < count; j++) {
            result[j] = tokenIds[j];
        }
        return result;
    }
}
