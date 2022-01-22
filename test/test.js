const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Deployment", () => {
    before( async () => {
      mainContractFactory = await ethers.getContractFactory("Main");
      [deployer, gov2, hospital1, hospital2, doc1, doc2, patient1, patient2] = await ethers.getSigners();
      console.log(`
      
      Government 1 : ${deployer.address}
      Government 2 : ${gov2.address}
      Hospital 1   : ${hospital1.address}
      Hospital 2   : ${hospital2.address}
      Doctor 1     : ${doc1.address}
      Doctor 2     : ${doc2.address}
      Patient 1    : ${patient1.address}
      Patient 2    : ${patient1.address}
      
      `);
      
      console.log("deployer address : " + deployer.address);
      mainContract = await mainContractFactory.deploy("Dharwad-office", "7975578890");
      await mainContract.deployed();
    });

  it("Sets deployer as the first government Office", async () => {
    expect(await mainContract.isGovernment(deployer.address)).to.be.true;
  });
});


describe("Adding new government office", () => {
  it("Checking event is emitted correctly with added details", async () => {
    expect(await mainContract.addGovernmentOffice("Hubli-office", "9433387654",gov2.address))
    .to.emit(mainContract, "newOffice")
      .withArgs("Hubli-office", "9433387654", gov2.address);
  });
  it("Checks newly added government is added to the GOVERNMENT ROLE", async () => {
    expect(await mainContract.isGovernment(gov2.address)).to.be.true;
  });
  
});

describe("Adding new hospital(hospital1)", async () =>  {
  it("Checking event is emitted correctly with added details", async  () => {

    expect(await mainContract.addHospital("SDM Medical College Dharwad", "9203251212",hospital1.address))
    .to.emit(mainContract, "newHospital")
    .withArgs("SDM Medical College Dharwad", "9203251212",hospital1.address);
  });
  it("Checks newly added hospital1 is added to the HOSPITAL ROLE", async () => {
    expect(await mainContract.isHospital(hospital1.address)).to.be.true;
  });
});


describe("Adding new hospital(hospital2)", async () =>  {
  it("Checking event is emitted correctly with added details", async  () => {

    expect(await mainContract.addHospital("K C General Hospital", "9712091212", hospital2.address))
    .to.emit(mainContract, "newHospital")
    .withArgs("K C General Hospital", "9712091212",hospital2.address);
  });
  it("Checks newly added hospital1 is added to the HOSPITAL ROLE", async () => {
    expect(await mainContract.isHospital(hospital2.address)).to.be.true;
  });
});



describe("Adding new doctor(doc1)", () => {
  it("Checking event is emitted correctly with added details", async function () {
    expect(await mainContract.addDoctor("Dr.M.N.Rayangoudar", "7611198762", "MBBS", "photo", "01/12/1968", hospital1.address, doc1.address,"Cardiology"))
    .to.emit(mainContract, "newDoctor")
    .withArgs("Dr.M.N.Rayangoudar","7611198762","MBBS","photo","01/12/1968", hospital1.address, doc1.address,"Cardiology");
  });
  it("Checking newly added doc1 is added to the DOCTOR ROLE", async () => {
    expect(await mainContract.isDoctor(doc1.address)).to.be.true;
  });
});

describe("Adding new patient(Patient1)", function () {
  it("Should returns new patient details", async function () {

    
    expect(await mainContract.addPatient(JSON.stringify(pd),patient1.address))
    .to.emit(mainContract, "newPatient")
    .withArgs(JSON.stringify(pd),patient1.address);

  });
});


describe("Giving read permission", function () {
  it("Should returns new doctor ID", async function () {
    expect(await mainContract.connect(patient1).giveReadAccess(doc1.address))
    .to.emit(mainContract, "newReadAccess")
    .withArgs(doc1.address);
  });
  it("Checking that doctor is able to get patient1 datails", async () => { 
    expect(await mainContract.connect(doc1).getPatientDetails(patient1.address)).to.equal(JSON.stringify(pd));
  });
});



var pd = {
  "details": {
    "name": "Patient",
    "DOB": "19-12-2020",
    "gender": "male",
    "height": 19,
    "weight": 20,
    "bloodGroup": "B+ve",
    "email": "patient@gmail.com",
    "phone": 12345678,
    "address": "abc",
    "Ename": "afzal",
    "EPhone": 7975578890,
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