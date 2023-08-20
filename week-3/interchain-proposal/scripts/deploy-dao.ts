import { ethers, network } from "hardhat";

// TODO: Put messenger contracts here
const MESSENGER_CONTRACTS: any = {
  4002: {
    name: "Fantom",
    sender: "0x32324174F5632368D739f91a26C2904402aD94AD",
    executor: "0xd62582E0e5d8A347E0117f89fd7f35fAca827A33",
  },
  43113: {
    name: "Avalanche",
    sender: "0xB0A6892f8b4eCdcc1B5ccAE88ac3dBbb321818A7",
    executor: "0x8D12eFB88D6a74e9c138198A097aF595EF86793B",
  }
}

async function main() {
  const accounts = await ethers.getSigners();
  const chainId: number = network.config.chainId || 0;

  const daoWallet = await ethers.deployContract("DAOWallet", [
    MESSENGER_CONTRACTS[chainId].sender,
  ])

  await daoWallet.waitForDeployment();

  console.log("DAOWallet", await daoWallet.getAddress())

  // const daoExecutable = await ethers.deployContract("DAOExecutable", [
  //   MESSENGER_CONTRACTS[chainId].executor,
  // ])

  // await daoExecutable.waitForDeployment();

  // console.log("DAOExecutable", await daoExecutable.getAddress())

  // Setup destination address mapping
  for (const chainId in MESSENGER_CONTRACTS) {
    const tx = await daoWallet.setDestinationAddressMapping(
      MESSENGER_CONTRACTS[chainId].name,
      MESSENGER_CONTRACTS[chainId].executor,
    )

    await tx.wait();
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
