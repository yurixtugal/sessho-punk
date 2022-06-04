const { expect } = require("chai");

describe("SesshoPunks  Contract", () => {
  const setup = async ({ maxSupply = 10000 }) => {
    const [owner] = await ethers.getSigners();
    const SesshoPunks = await ethers.getContractFactory("SesshoPunks");
    const deployed = await SesshoPunks.deploy(maxSupply);

    return {
      owner,
      deployed,
    };
  };

  describe("Deployment",()=>{
    it ("Sets max supply to passed param", async ()=>{
      const maxSupply = 4000;

      const {deployed} = await setup({maxSupply});
      const returnedMaxSupply = await deployed.maxSupply();

      expect(maxSupply).to.equal(returnedMaxSupply);

    })
  })


  describe("Minting",()=>{
    it ("Mints a new SesshoToken and assigns it to owner", async ()=>{
      const maxSupply = 4000;

      const {owner, deployed} = await setup({maxSupply});
      await deployed.mint();

      const ownerOfMinted = await deployed.ownerOf(0);
      
      expect(ownerOfMinted).to.equal(owner.address);

    })

    it ("Has a minting limit", async ()=>{
      const maxSupply = 2;

      const {owner, deployed} = await setup({maxSupply});

      await Promise.all([deployed.mint(),deployed.mint()]);

      await expect(deployed.mint()).to.be.revertedWith("No SesshoPunks left");

    })

  })

  describe("TokenURI",()=>{
    it ("Return a valid MetaData", async ()=>{
      const maxSupply = 4000;

      const {owner, deployed} = await setup({maxSupply});
      await deployed.mint();

      let tokenURI = await deployed.tokenURI(0);
      
      let stringifiedTokenURI = await tokenURI.toString();
      
      let [,base64JSON] = stringifiedTokenURI.split("data:application/json;base64,");
      
      let stringmetadata = await Buffer.from(base64JSON,"base64").toString("ascii")
      
      let metadata = JSON.parse(stringmetadata);
      
      expect(metadata).to.have.all.keys("name","description","image");

    })


  })

});