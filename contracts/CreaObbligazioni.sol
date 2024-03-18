// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";


contract CreaObbligazioni is ERC721,ERC721Burnable {
     uint256 private _nextTokenId;
    constructor() ERC721("SuChOb", "SCO") {
    }

    function safeMint(address to,string memory metadata) public{
        uint256 _tokenId = _nextTokenId++;
        uint256 newNFTId = _tokenId;
        _safeMint(to, newNFTId);
        _metadata[newNFTId] = metadata;
    }

    mapping (uint256 => string) private _metadata;
    
    function getMetadata(uint256 tokenId) public view returns (string memory) {
        return _metadata[tokenId];
    }
}
