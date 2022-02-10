const { expect } = require("chai");
const { ethers } = require("hardhat");
const TestGreeter = artifacts.require("contracts/Greeter.sol:Greeter");

const deployTestGreeter = () => {
    return TestGreeter.new("Test Greeter")
}

describe("DeployAndTestGreeter", function () {
  let testGreeterInstance

  beforeEach(async () => {
    testGreeterInstance = await deployTestGreeter();
    assert.ok(testGreeterInstance);
  })

  it("Should change Greeter greeting", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("test");
    await greeter.deployed();

    const DAOPort = await ethers.getContractFactory("DAOPort");
    const daoport = await DAOPort.deploy();
    await daoport.deployed();

    const daoport_address = daoport.address;
    const greeter_address = greeter.address;

    await daoport.deployTeleporter(daoport_address, greeter_address, 1, 0, 1, 1, 1, "0x0000000000000000000000000000000000000000", daoport_address, 1);
    const new_greeter_address = await daoport.lastDeployedAddress();

    const Teleporter = await ethers.getContractFactory("Teleporter");
    const teleporter = await Teleporter.attach(new_greeter_address);
    
    const greetEncoded = testGreeterInstance.contract.greet.getData("");
    await teleporter.executeTransaction(greetEncoded);


  });
    /*
  it("Should return the new greeting once it's changed", async function () {
    const greeterAddress = '0xea2e558e23E2C76D597262499edbE4ff41c35d6E';
    const holaMundo = "Hola, mundo!";
    const helloWorld = "Hello, world!";
    const salt = 1;
    const DAOPort = await ethers.getContractFactory("DAOPort");
    const daoport = await DAOPort.deploy();
    await daoport.deployed();

    // Deploy Greeter, expect `Deployed` event
    await expect(daoport.deployTeleporter(holaMundo, salt))
      .to.emit(daoport, 'Deployed')
      .withArgs(greeterAddress, salt);;

    expect(await daoport.lastDeployedAddress())
      .to.equal(greeterAddress);
    
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.attach(greeterAddress);

    expect(await greeter.greet())
      .to.equal(holaMundo);

    await greeter.setGreeting(helloWorld);
    
    expect(await greeter.greet())
      .to.equal(helloWorld);
    
    expect(await greeter.greet())
      .to.not.equal(helloWorld + "!");
  });
    */
});
