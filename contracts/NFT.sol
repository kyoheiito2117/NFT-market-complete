// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// erc 721
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
// ERC721URIStorage (inherits from erc 721)
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// utils
import "@openzeppelin/contracts/utils/Counters.sol";
import "./INFTMarket.sol";

contract NFT is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter public _tokensIds; // for minting incrementing
    address _marketplaceAddress; // market place address we gonna give ability to transact the tokens;
    string public name = "HowToPulse";
    string public symbol = "HTP";

    constructor(address marketplaceAddress) ERC1155("") {
        _marketplaceAddress = marketplaceAddress;
    }

    event Mint(uint256 newItemId);

    function createToken(
        string memory tokenURI,
        uint256 amount,
        uint256 royalty
    ) public returns (uint256) {
        _tokensIds.increment();
        uint256 newItemId = _tokensIds.current();
        // minting
        _mint(msg.sender, newItemId, amount, "00x0");
        //
        _setURI(tokenURI);
        // give the marketplace approval to transcat this token between users
        setApprovalForAll(_marketplaceAddress, true);

        INFTMarket(_marketplaceAddress).initializeItem(
            address(this),
            newItemId,
            msg.sender,
            royalty
        );

        emit Mint(newItemId);
        return newItemId;
    }

    // Whenever tokens are transferred, add the market contract allowance to handle the tokens
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        if (_marketplaceAddress != to) {
            // Allow marketplace to transfer tokens from the new owner
            _setApprovalForAll(to, _marketplaceAddress, true);
        }
    }
}
