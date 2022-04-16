const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crypto Devs", function (accounts) {
  let cryptoDev;
  beforeEach(async function () {
    const CryptoDev = await ethers.getContractFactory("CryptoDevs");
    cryptoDev = await CryptoDev.deploy(
      "https://nft-collection-sneh1999.vercel.app/api/",
      "0xdebf9d0a4b7745872d256d392a6d4cf853cef01d"
    );
    await cryptoDev.deployed();
  });

  it("Should deploy the crpto dev contract", async function () {
    expect(cryptoDev.address).to.be.a("string");
    expect(cryptoDev.address).not.equal(
      "0x0000000000000000000000000000000000000000"
    );
  });
});
