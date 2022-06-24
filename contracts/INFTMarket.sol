// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface INFTMarket {
    function initializeItem(
        address nftContract,
        uint256 tokenId,
        address creator,
        uint256 royalty
    ) external;
}
