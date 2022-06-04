const hre = require("hardhat");

async function deploy() {

  const SesshoPunks = await hre.ethers.getContractFactory("SesshoPunks");
  const sesshoPunks = await SesshoPunks.deploy(10000);

  await sesshoPunks.deployed();

  console.log("My cripto NFT:", await sesshoPunks.name());
  console.log("Deployed at:", sesshoPunks.address);
}

deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });