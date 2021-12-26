# DAOPort
A library for DAOs to call deterministic functions on mainnet from the sidechain where the DAO lives.

## Problem
DAOs run on sidechains, for example, Hero DAO runs on Gnosis Chain (previously xdai) because it is cheap to operate there. But we want to be able to do things on mainnet. All we can do with the Omnibridge and 

## Solution
DAOPort is like a teleport system for the code that DAOs want to run on mainnet, which lets them vote on running it via cheaper side chain

## How Does it work
1. DAOPort is deployed to mainnet at *redacted*
2. Call the `createTeleporter()` function on DAOport with the paramters of any arbitrary call to any mainnet dapp you want to interact with
3. DAOPort deploys a new mini contract (a "teleporter"). Every Teleporter has only 1 public function which is also deterministic, so everyone knows exactly what it will do when it is called.  
4. Teleporters can easily be created to do things like: buy a specific NFT from a less-popular marketplace, fund a yield farm, call arbitrary functions on any mainnet smart contract.
5. Any DAO can now vote to send funds over a bridge to a Teleporter. Anyone can activate the Teleporter to move those funds where the DAO has decided, and also make a function call that the DAO has approved. 

### Example
- Bob and Alice are in a DAO and want to fund a yield farm with tokens in their DAO's treasury
- A yield farm is deployed independently at Contract A
- Bob uses DAOPort to create smart contract B, a teleporter contract that has 1 function on it that calls the fund function in contract A's yield farm.
- Alice and Bob and all other DAO members vote to move tokens from their DAO on xdai through the omnibridge, to the teleporter contract B
- Alice, or anyone, calls the single function in contract B which moves all the tokens sent by the DAO to, and calls the fund function on, contract A.


## Running this library

Hardhat docs --> https://hardhat.org/getting-started/
