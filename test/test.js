const { expect, assert } = require("chai");
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

  it("Checking for unauthorized access to patient datails (doctor)", async () => { 
    
    try{
      expect(await mainContract.connect(doc2).getPatientDetails(patient1.address)).to.equal(JSON.stringify(pd));
      console.log("unauthorized access is happend");
      assert(false);
    }catch(error){
      assert(true);
    }
    
  });
  
});

describe("Giving write permission", function () {
  it("Should returns new hospital ID to which permission given", async function () {

    expect(await mainContract.connect(patient1).giveWriteAccess(hospital1.address))
    .to.emit(mainContract, "newWriteAccess")
    .withArgs(hospital1.address);
  });

  it("Checking for unauthorized access to patient datails (hospital)", async () => { 
    
    try{
      expect(await mainContract.connect(hospital2).getPatientDetails(patient1.address)).to.equal(JSON.stringify(pd));
      console.log("unauthorized access is happend");
      assert(false);
    }catch(error){
      assert(true);
    }
    
  });

});

describe("Removing read permission", function () {
  it("Should returns new doctor ID to which permission reverted", async function () {

    expect(await mainContract.connect(patient1).removeReadAccess(doc1.address))
    .to.emit(mainContract, "removeReadAccessDoctor")
    .withArgs(doc1.address);
  
  });
});

describe("Removing write permission", function () {
  it("Should returns new hospital ID to which permission reverted", async function () {

    expect(await mainContract.connect(patient1).removeWriteAccess(hospital1.address))
    .to.emit(mainContract, "removeWriteAccessHospital")
    .withArgs(hospital1.address);
  
  });
});

describe("Send Records for upload", function () {
  it("Should returns new uploaded records", async function () {

    expect(await mainContract.connect(doc1).sendRecordsForUpload("CID",patient1.address))
    .to.emit(mainContract, "newRecordForUpload")
    .withArgs("CID",patient1.address);
  
  });
});

describe("Send Records for upload (Hospital)", function () {
  it("Should returns new uploaded recorded (Hospital)", async function () {

    expect(await mainContract.connect(hospital1).sendRecordsForUploadH("CID",patient1.address,hospital1.address))
    .to.emit(mainContract, "newRecordForUploadH")
    .withArgs("CID",patient1.address,hospital1.address);
  
  });
});

describe("Adding records to patient history", function () {
  it("Should returns all records of patient", async function () {

    await mainContract.connect(hospital1).reportUploaded(patient1.address,"CID");

    expect(await mainContract.connect(hospital1).getRecordsHistory(patient1.address)).to.eql(["CID"]);
  
  });
});


describe("Retrieving patient information", function () {
  it("Should return particular patient details", async function () {

    expect(await mainContract.connect(patient1).getPatientDetails(patient1.address)).to.equal(JSON.stringify(pd));
  
  });

  it("Should return doctors list of particular patient", async function () {

    expect(await mainContract.connect(patient1).getDoctorsList(patient1.address)).to.eql([doc1.address]);
  
  });

  it("Should return hospital list of particular patient", async function () {

    expect(await mainContract.connect(patient1).getHospitalsList(patient1.address)).to.eql([hospital1.address]);
  
  });

});

describe("Retrieving Doctor information", function () {
  it("Should return particular doctor details", async function () {

    expect(await mainContract.connect(doc1).getDoctorDetails(doc1.address)).to.eql(["Dr.M.N.Rayangoudar","7611198762","MBBS","photo","01/12/1968","Cardiology"]);
  
  });

  it("Should return patient list of particular doctor", async function () {

    expect(await mainContract.connect(doc1).getPatientList(doc1.address)).to.eql([patient1.address]);
  
  });

  it("Should return hospital name in which doctor is working", async function () {

    expect(await mainContract.connect(doc1).getDoctorH(doc1.address)).to.eql(hospital1.address);
  
  });

});

describe("Retrieving hospital information", function () {
    it("Should return particular hospital details", async function () {
  
      expect(await mainContract.connect(hospital1).getHospitalDetails(hospital1.address)).to.eql(["SDM Medical College Dharwad", "9203251212"]);
    
    });
  
    it("Should return doctor list of particular hospital", async function () {
  
      expect(await mainContract.connect(hospital1).getHospitalDoctorList(hospital1.address)).to.eql([]);
    
    });

    it("Should return patient list of particular hospital", async function () {
  
      expect(await mainContract.connect(hospital1).getHospitalPatientList(hospital1.address)).to.eql([patient1.address]);
    
    });

});

describe("Retrieving Government information", function () {
  it("Should return particular government office details", async function () {

    expect(await mainContract.connect(gov2).getGovernmentDetails(gov2.address)).to.eql(["Hubli-office", "9433387654"]);
  
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