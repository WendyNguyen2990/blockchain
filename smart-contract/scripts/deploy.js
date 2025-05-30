require("dotenv").config();
const { ethers } = require("hardhat");

async function main() {
  const FootballBetting = await ethers.getContractFactory("FootballBetting");
  const contract = await FootballBetting.deploy();
  console.log("FootballBetting deployed to:", contract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });