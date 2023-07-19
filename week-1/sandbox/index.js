// global variables are: ethers, $chains, $contracts, $getSigner, Chain

const wait = ms => new Promise(resolve => setTimeout(resolve, ms))

const srcSigner = await $getSigner(Chain.MOONBEAM);

const srcContractFactory = new ethers.ContractFactory(
  $contracts["MessageSender"].abi,
  $contracts["MessageSender"].bytecode,
  srcSigner
);

console.log("[[Step 1: Deploy]] Deploying MessageSender contract...");
const srcContract = await srcContractFactory.deploy(
  $chains.moonbeam.gateway,
  $chains.moonbeam.gasReceiver
);
await srcContract.deployed();
console.log(
  "[[Step 1: Deploy]] MessageSender deployed at",
  srcContract.address
);

const destSigner = await $getSigner(Chain.AVALANCHE);
const destContractFactory = new ethers.ContractFactory(
  $contracts["MessageReceiver"].abi,
  $contracts["MessageReceiver"].bytecode,
  destSigner
);

const destProvider = new ethers.providers.JsonRpcProvider(
  $chains.avalanche.rpcUrl
);
console.log("[[Step 1: Deploy]] Deploying MessageReceiver contract...");
const destContract = await destContractFactory
  .deploy($chains.avalanche.gateway, $chains.avalanche.gasReceiver, srcContract.address)
  .then((contract) => contract.connect(destProvider));
await destContract.deployed();
console.log(
  "[[Step 1: Deploy]] MessageReceiver deployed at",
  destContract.address
);

console.log("[[Step 1: Deploy]] Connect destination contract to the source contract...");
await srcContract.connect(srcSigner).setDestinationAddress(destContract.address)

console.log(
  `[[Step 2: Sent Tx]] Mint 10000 Token on Moonbeam...`
);

await srcContract.connect(srcSigner).mint(srcSigner.address, ethers.utils.parseEther("10000"));
await wait(3000); // Because of .then(tx => tx.wait()) freezing bug

console.log(
  `[[Step 2: Sent Tx]] Bridge 1000 Token to Avalanche...`,
);

const receipt = await srcContract
  .connect(srcSigner)
  .bridge("avalanche", ethers.utils.parseEther("1000"), {
    value: ethers.utils.parseEther("0.03"),
  })
await wait(3000); // Because of .then(tx => tx.wait()) freezing bug

console.log(
  "[[Step 3: Relaying...]] Wait for relayer to process transaction..."
);

const waitForEvent = async (contract, eventName) => {
  return new Promise((resolve, _reject) => {
    contract.once(eventName, (...args) => {
      resolve(args);
    });
  });
};

// Wait for the receiver Execute event to be emitted
const args = await waitForEvent(destContract, "Unlock");

console.log(
  "[[Step 4: Verify]] Balance in the source (Moonbeam) chain",
  ethers.utils.formatEther(await srcContract.balanceOf(srcSigner.address)),
);
console.log(
  "[[Step 4: Verify]] Balance in the destination (Avalance) chain",
  ethers.utils.formatEther(await destContract.balanceOf(srcSigner.address)),
);

console.success("[[Step 5: Done]]Execution Complete!");
