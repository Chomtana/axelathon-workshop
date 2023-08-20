import { ethers, network } from "hardhat";

const AXELAR_CONTRACTS: any = {
  4002: {
    gateway: "0x97837985Ec0494E7b9C71f5D3f9250188477ae14",
    gasService: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
  },
  43113: {
    gateway: "0xC249632c2D40b9001FE907806902f63038B737Ab",
    gasService: "0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6",
  }
}

async function main() {
  const accounts = await ethers.getSigners();
  const chainId: number = network.config.chainId || 0;

  const interchainProposalSender = await ethers.deployContract("InterchainProposalSender", [
    AXELAR_CONTRACTS[chainId].gateway,
    AXELAR_CONTRACTS[chainId].gasService,
  ])

  await interchainProposalSender.waitForDeployment();

  console.log("InterchainProposalSender", await interchainProposalSender.getAddress())

  const interchainProposalExecutor = await ethers.deployContract("InterchainProposalExecutor", [
    AXELAR_CONTRACTS[chainId].gateway,
    accounts[0].address,
  ])

  await interchainProposalExecutor.waitForDeployment();

  console.log("InterchainProposalExecutor", await interchainProposalExecutor.getAddress())
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
