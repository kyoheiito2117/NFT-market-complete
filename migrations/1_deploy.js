const NFT = artifacts.require("NFT");
const NFTMarket = artifacts.require("NFTMarket");

module.exports = async function (deployer) {
  console.log("pre deployed");
  await deployer.deploy(NFTMarket);
  const nftMarket = await NFTMarket.deployed();
  console.log("nftMarket address", nftMarket.address);
  await deployer.deploy(NFT, nftMarket.address);
  const nft = await NFT.deployed();
  console.log("nft address", nft.address);
  console.log("deployed");
};
