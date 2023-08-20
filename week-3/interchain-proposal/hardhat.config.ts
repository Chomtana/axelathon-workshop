import { config as dotenv } from "dotenv"
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

dotenv();

const PRIVATE_KEY: string = process.env.PRIVATE_KEY as string

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  etherscan: {
    apiKey: {
      ftmTestnet: "KHS7ZTEFRZWRPTC95I8KGJ6YUY5JV47M5E",
      avalancheFujiTestnet: "41FFT9AVVWKFVY3DUYGVNU739SEZX4UM3S",
    }
  },
  networks: {
    fantom_testnet: {
      url: "https://rpc.testnet.fantom.network",
      chainId: 4002,
      accounts: [ PRIVATE_KEY ],
    },
    avax_testnet: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      chainId: 43113,
      accounts: [ PRIVATE_KEY ],
    },
  }
};

export default config;
