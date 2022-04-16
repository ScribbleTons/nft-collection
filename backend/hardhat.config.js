require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });

//Uncomment when you add your API key
const ALCHEMY_API_KEY_URL = process.env.ALCHEMY_API_KEY_URL;

const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY;

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: ALCHEMY_API_KEY_URL,
      accounts: [RINKEBY_PRIVATE_KEY],
    },
  },
  paths: {
    artifacts: "../client/artifacts",
  }
};
