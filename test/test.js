const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Deployment", () => {
    before( async () => {
      mainContractFactory = await ethers.getContractFactory("Main");
      [deployer,gov,doctor,patient1] = await ethers.getSigners();
      console.log("deployer address : " + deployer.address);
      mainContract = await mainContractFactory.deploy("Dharwad-office", "7975578890");
      await mainContract.deployed();
    });

  it("Sets deployer as the first government Office", async () => {
    expect(await mainContract.isGovernment(deployer.address)).to.be.true;
  });
});


describe("Adding new government office", () => {
  before(async () => {
    await mainContract.addGovernmentOffice("Hubli-office", "9433387654", "0x70997970C51812dc3A010C7d01b50e0d17dc79C8");  
  });
  it("Checks newly added government is added to role", async () => {
    expect(await mainContract.isGovernment('0x70997970C51812dc3A010C7d01b50e0d17dc79C8')).to.be.true;
  });

});




describe("Adding new government office", function () {
  it("Should returns new government office details", async function () {

    // expect(await mainContract.addGovernmentOffice("Hubli-office", "9433387654","0x70997970C51812dc3A010C7d01b50e0d17dc79C8"))
    // .to.emit(mainContract, "newOffice")
    // .withArgs("Hubli-office", "9433387654","0x70997970C51812dc3A010C7d01b50e0d17dc79C8");

  });
});

describe("Adding new hospital", function () {
  it("Should returns new hospital details", async function () {

    expect(await mainContract.addHospital("K C General Hospital", "9712091212","0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"))
    .to.emit(mainContract, "newHospital")
    .withArgs("K C General Hospital", "9712091212","0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC");

  });
});

describe("Adding new doctor", function () {
  it("Should returns new doctor details", async function () {

    expect(await mainContract.addDoctor("Dr.M.N.Rayangoudar","7611198762","MBBS","photo","01/12/1968","0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC","0x90F79bf6EB2c4f870365E785982E1f101E93b906","Cardiology"))
    .to.emit(mainContract, "newDoctor")
    .withArgs("Dr.M.N.Rayangoudar","7611198762","MBBS","photo","01/12/1968","0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC","0x90F79bf6EB2c4f870365E785982E1f101E93b906","Cardiology");
    
  });
});

describe("Adding new patient", function () {
  it("Should returns new patient details", async function () {

    const pd = {
      "details": {
        "name": "Sahil",
        "DOB": "19-12-2020",
        "gender": "male",
        "height": 19,
        "weight": 20,
        "bloodGroup": "o",
        "email": "ashjjsjk.gmail.com",
        "phone": 12345678,
        "address": "abc",
        "Ename": "afzal",
        "EPhone": 123456,
        "drugAllergies": ["a", "b"],
        "otherIllness": ["pleg"],
        "anyOperations": ["none"],
        "anySurgery": ["dust"],
        "currentMedications": ["aaaa"],
        "healthyAndUnhealthyHabits": ["3 cup coffe perday"],
        "dietType": "roti",
        "caffeineConsumption": 4,
        "smokingPerDay": "none",
        "otherMedicalConditions": "asd"
      }
    };
    expect(await mainContract.addPatient(JSON.stringify(pd),patient1.address))
    .to.emit(mainContract, "newPatient")
    .withArgs(JSON.stringify(pd),patient1.address);

  });
});
