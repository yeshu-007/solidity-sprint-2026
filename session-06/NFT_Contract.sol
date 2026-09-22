// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RYNFT is ERC721URIStorage, Ownable {
    uint256 public tokenId;

    constructor() ERC721("RY Collection", "RYC") Ownable(msg.sender) {}

    // Mint one NFT to your own wallet
    function mint(string memory _uri) external onlyOwner returns (uint256) {
        tokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _uri);
        return tokenId;
    }

    function totalMinted() external view returns (uint256) {
        return tokenId;
    }
}