const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Deployment", () => {
  before(async () => {
    ROLE_BASED_ACCESS_ContractFactory = await hre.ethers.getContractFactory(
      "ROLE_BASED_ACCESS"
    );
    STORAGE_ContractFactory = await hre.ethers.getContractFactory("STORAGE");
    ApproveDetails_ContractFactory = await hre.ethers.getContractFactory(
      "APPROVE"
    );
    DHRMS_GOV_ContractFactory = await hre.ethers.getContractFactory(
      "DHRMS_GOV"
    );
    DHRMS_HOS_ContractFactory = await hre.ethers.getContractFactory(
      "DHRMS_HOS"
    );
    DHRMS_DOC_ContractFactory = await hre.ethers.getContractFactory(
      "DHRMS_DOC"
    );
    DHRMS_PAT_ContractFactory = await hre.ethers.getContractFactory(
      "DHRMS_PAT"
    );
    [deployer, gov2, hospital1, hospital2, doc1, doc2, patient1, patient2] =
      await ethers.getSigners();
    console.log(`
        Government 1 : ${deployer.address}
        Government 2 : ${gov2.address}
        Hospital 1   : ${hospital1.address}
        Hospital 2   : ${hospital2.address}
        Doctor 1     : ${doc1.address}
        Doctor 2     : ${doc2.address}
        Patient 1    : ${patient1.address}
        Patient 2    : ${patient2.address}
        `);

    console.log("deployer address : " + deployer.address);
    RBACContract = await ROLE_BASED_ACCESS_ContractFactory.deploy();
    await RBACContract.deployed();

    STORAGEContract = await STORAGE_ContractFactory.deploy(
      "Dharwad-office",
      "7975578890",
      RBACContract.address
    );
    await STORAGEContract.deployed();

    DHRMS_GOV_Contarct = await DHRMS_GOV_ContractFactory.deploy(
      DHRMSContract.address,
      RBACContract.address
    );
    await DHRMS_GOV_Contarct.deployed();

    DHRMS_HOS_Contarct = await DHRMS_HOS_ContractFactory.deploy(
      DHRMSContract.address,
      RBACContract.address
    );
    await DHRMS_HOS_Contarct.deployed();

    DHRMS_DOC_Contarct = await DHRMS_DOC_ContractFactory.deploy(
      DHRMSContract.address,
      RBACContract.address
    );
    await DHRMS_DOC_Contarct.deployed();

    DHRMS_PAT_Contarct = await DHRMS_PAT_ContractFactory.deploy(
      DHRMSContract.address,
      RBACContract.address
    );
    await DHRMS_PAT_Contarct.deployed();

    approveContract = await ApproveDetails_ContractFactory.deploy(
      DHRMS_PAT_Contarct.address,
      DHRMS_HOS_Contarct.address,
      DHRMS_DOC_Contarct.address,
      DHRMS_GOV_Contarct.address
    );
    await approveContract.deployed();

    console.log("RBACContract add:", RBACContract.address);
    console.log("DHRMSContract add:", STORAGEContract.address);
    console.log("approveContract add:", approveContract.address);

    RBACContract.setContracts(approveContract.address);
    RBACContract.setContracts(STORAGEContract.address);

    // await DHRMSContract.addGovernmentOffice("ApproveContract", "0000000000", approveContract.address);
    // await DHRMSContract.addGovernmentOffice("DHRMSContract", "0000000000", DHRMSContract.address);
    it("Sets deployer as the first government Office", async () => {
      expect(await RBACContract.isGovernment(deployer.address)).to.be.true;
    });
  });
});

describe("Adding to the Approve List", function () {
  it("Adding the Government", async function () {
    await approveContract.addGovernmentOfficetoList(
      "Hubli-office",
      "9433387654",
      gov2.address
    );
  });
  it("Adding the Hospital", async function () {
    await approveContract.addHospitaltoList(
      "SDM Medical College Dharwad",
      "9203251212",
      hospital1.address
    );
  });
  it("Adding the Hospital2", async function () {
    await approveContract.addHospitaltoList(
      "K C General Hospital",
      "9712091212",
      hospital2.address
    );
  });
  it("Adding the Doctor", async function () {
    await approveContract.addDoctortoList(
      "Dr.M.N.Rayangoudar",
      "7611198762",
      "MBBS",
      "photo",
      "01/12/1968",
      hospital1.address,
      doc1.address,
      "Cardiology"
    );
  });
  it("Adding the Patient", async function () {
    await approveContract.addPatienttoList(
      JSON.stringify(pd),
      patient1.address
    );
  });
  it("Printing List", async function () {
    console.log(await approveContract.getApproveList());
  });
});
var pd = {
  details: {
    name: "Patient",
    DOB: "19-12-2020",
    gender: "male",
    height: 19,
    weight: 20,
    bloodGroup: "B+ve",
    email: "patient@gmail.com",
    phone: 12345678,
    address: "abc",
    Ename: "afzal",
    EPhone: 7975578890,
    drugAllergies: ["a", "b"],
    otherIllness: ["pleg"],
    anyOperations: ["none"],
    anySurgery: ["dust"],
    currentMedications: ["aaaa"],
    healthyAndUnhealthyHabits: ["3 cup coffe perday"],
    dietType: "roti",
    caffeineConsumption: 4,
    smokingPerDay: "none",
    otherMedicalConditions: "asd",
  },
};
