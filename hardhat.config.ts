import * as dotenv from "dotenv";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      forking: {
        url: process.env.BSC_ARCHIVE_NODE || "",
        blockNumber: 20956556, // 9/1 ~12:30PM
      },
      // loggingEnabled: true,
      // mining: {
      //   auto: false,
      //   interval: 2000,
      // },
    },
    bsc: {
      url: process.env.BSC_MAINNET_URL || "",
      accounts:
        process.env.LOTTERY_OPERATOR_KEY !== undefined ? [process.env.LOTTERY_OPERATOR_KEY] : [],
    },
    goerli: {
      url: process.env.GOERLI_RPC || "",
      accounts: process.env.DEV_KEY !== undefined ? [process.env.DEV_KEY] : [],
    },
  },
};

export default config;
