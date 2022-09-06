import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { BalancerPegOracle } from "../typechain-types";
import { Contract } from "ethers";

const VAULT = "0xEE1c8DbfBf958484c6a4571F5FB7b99B74A54AA7";
const AMES_POOL = "0x9AA867870d5775A3C155325DB0cb0B116bbF4b6a";
const AMES_TREASURY_ORACLE = "0x298be24C55BF89B114FE66972C787ec78530fCd7";
const AMES = "0xb9E05B4C168B56F73940980aE6EF366354357009";

describe("BalancerPegOracle", () => {
  let oracle: BalancerPegOracle;
  let currentOracle: Contract;

  beforeEach(async () => {
    const factory = await ethers.getContractFactory("BalancerPegOracle");

    currentOracle = await ethers.getContractAt(
      [
        "function getStartTime() public view returns (uint256)",
        "function getCurrentEpoch() public view returns (uint256)",
        "function getPeriod() public view returns (uint256)",
      ],
      AMES_TREASURY_ORACLE
    );

    const [period, start, epoch] = await Promise.all([
      currentOracle.getPeriod(),
      currentOracle.getStartTime(),
      currentOracle.getCurrentEpoch(),
    ]);

    const oc = await factory.deploy(VAULT, AMES_POOL, AMES, period, start, epoch);
    oracle = <BalancerPegOracle>await oc.deployed();
  });

  it("Should ", async () => {
    expect(true).to.be.true;
  });
});
