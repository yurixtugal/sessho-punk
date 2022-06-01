require("@nomiclabs/hardhat-waffle");
require('dotenv').config();
const projectID = process.env.INFURA_PROJECT_ID;
const privateKey = process.env.DEPLOYER_SIGNER_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.4",
  networks: {
              rinkeby: {
                url: 'https://rinkeby.infura.io/v3/${projectID}',
                accounts: [privateKey]
              }
  }
};
