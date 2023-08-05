# Axelathon Workshop



## Axelar Sandbox

https://xchainbox.axelar.dev/

## Add chain to metamask

Go to Chainlist

https://chainlist.org/

Check "Include Testnets"

Then search for "Fantom testnet" and "Polygon mumbai"

Add corresponding testnet to your metamask

## Faucet

* Fantom testnet: https://faucet.fantom.network/
* Avalanche fuji testnet: https://core.app/en/tools/testnet-faucet/?subnet=c&token=c
* Polygon mumbai: https://faucet.polygon.technology/

## Remix IDE

https://remix.ethereum.org/

## Axelarscan

Testnet: https://testnet.axelarscan.io

Axelar Gateway and Gas Service address: https://testnet.axelarscan.io/resources/chains

## Interchain token service

https://testnet.services.axelar.dev/interchain-token

## AxelarSea source code

* Smart contract: https://github.com/AxelarSea/axelarnft-contract
    * [AxelarSeaSampleNft (NFT)](https://github.com/AxelarSea/axelarnft-contract/blob/main/contracts/AxelarSeaSampleNft.sol)
    * [AxelarSeaNftBridgeController (BridgeController)](https://github.com/AxelarSea/axelarnft-contract/blob/main/contracts/nft-bridge/AxelarSeaNftBridgeController.sol)
    * [AxelarSeaNftAxelarBridge (Messenger)](https://github.com/AxelarSea/axelarnft-contract/blob/main/contracts/nft-bridge/bridges/AxelarSeaNftAxelarBridge.sol)
* Frontend: https://github.com/AxelarSea/axelarnft-frontend
    * [Gas Estimation (Legacy Method)](https://github.com/AxelarSea/axelarnft-frontend/blob/5c3188ef5685ea410ddba1500a3d07dece5cbf55/src/utils/api.js#L564-L565)
    * [Gas Estimation (New Method)](https://docs.axelar.dev/dev/axelarjs-sdk/axelar-query-api#estimategasfee)
    * [Trace transaction status (Legacy Method)](https://github.com/AxelarSea/axelarnft-frontend/blob/5c3188ef5685ea410ddba1500a3d07dece5cbf55/src/utils/api.js#L593-L603)
    * [Trace transaction status (New Method)](https://docs.axelar.dev/dev/axelarjs-sdk/tx-status-query-recovery)
