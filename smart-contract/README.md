# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```

Instructions to Deploy the Contract on Sepolia

Create a .env file in the smart-contract directory with the following content:

```
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
PRIVATE_KEY=your_private_key
```

Replace YOUR_INFURA_KEY with your Infura/Alchemy RPC URL.
Replace your_private_key with your Metamask wallet's private key (Sepolia).

2. Deploy contract:

```
npx hardhat run scripts/deploy.js --network sepolia
```

After deployment, the contract address will be displayed on the screen.
