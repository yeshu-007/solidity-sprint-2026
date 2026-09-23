import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.getOrCreate();

describe("MyToken", function () {
  async function deployFixture() {
    const [owner, alice, bob] = await ethers.getSigners();
    const initialSupply = ethers.parseUnits("1000", 18);

    const Token = await ethers.getContractFactory("MyToken");
    const token = await Token.deploy(initialSupply);
    await token.waitForDeployment();

    return { token, owner, alice, bob, initialSupply };
  }

  it("mints the initial supply to the deployer", async function () {
    const { token, owner, initialSupply } = await deployFixture();
    expect(await token.balanceOf(owner.address)).to.equal(initialSupply);
  });

  it("transfers tokens successfully", async function () {
    const { token, alice } = await deployFixture();
    const amount = ethers.parseUnits("100", 18);
    await token.transfer(alice.address, amount);
    expect(await token.balanceOf(alice.address)).to.equal(amount);
  });

  it("reverts on transfer with insufficient balance", async function () {
  const { token, alice, bob } = await deployFixture();
  const amount = ethers.parseUnits("1", 18);
  await expect(
    token.connect(alice).transfer(bob.address, amount)
  ).to.revert(ethers);
  });

  it("allows only the owner to mint", async function () {
    const { token, alice } = await deployFixture();
    const amount = ethers.parseUnits("50", 18);
    await token.mint(alice.address, amount);
    expect(await token.balanceOf(alice.address)).to.equal(amount);
  });

  it("reverts when a non-owner tries to mint", async function () {
  const { token, alice, bob } = await deployFixture();
  const amount = ethers.parseUnits("50", 18);
  await expect(
    token.connect(alice).mint(bob.address, amount)
  ).to.be.revertedWith("Only the owner can mint tokens");
  });
  
});