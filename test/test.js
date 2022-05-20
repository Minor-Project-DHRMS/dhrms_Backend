const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Deployment", () => {
  before(async () => {
    ROLE_BASED_ACCESS_ContractFactory = await hre.ethers.getContractFactory(
      "ROLE_BASED_ACCESS"
    );
    STORAGE_ContractFactory = await hre.ethers.getContractFactory("STORAGE");
    ApproveDetails_ContractFactory = await hre.ethers.getContractFactory(
      "ApproveDetails"
    );
    ApproveDetails2_ContractFactory = await hre.ethers.getContractFactory(
      "ApproveDetails2"
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
      STORAGEContract.address,
      RBACContract.address
    );
    await DHRMS_GOV_Contarct.deployed();

    DHRMS_HOS_Contarct = await DHRMS_HOS_ContractFactory.deploy(
      STORAGEContract.address,
      RBACContract.address
    );
    await DHRMS_HOS_Contarct.deployed();

    DHRMS_DOC_Contarct = await DHRMS_DOC_ContractFactory.deploy(
      STORAGEContract.address,
      RBACContract.address
    );
    await DHRMS_DOC_Contarct.deployed();

    DHRMS_PAT_Contarct = await DHRMS_PAT_ContractFactory.deploy(
      STORAGEContract.address,
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

    approveContract2 = await ApproveDetails2_ContractFactory.deploy(
      approveContract.address,
      RBACContract.address
    );
    await approveContract2.deployed();

    console.log("RBACContract add:", RBACContract.address);
    console.log("DHRMSContract add:", STORAGEContract.address);
    console.log("approveContract add:", approveContract.address);

    RBACContract.setContracts(approveContract.address);
    RBACContract.setContracts(STORAGEContract.address);
    RBACContract.setContracts(DHRMS_PAT_Contarct.address);
    RBACContract.setContracts(DHRMS_HOS_Contarct.address);
    RBACContract.setContracts(DHRMS_DOC_Contarct.address);
    RBACContract.setContracts(DHRMS_GOV_Contarct.address);

    // await DHRMSContract.addGovernmentOffice("ApproveContract", "0000000000", approveContract.address);
    // await DHRMSContract.addGovernmentOffice("DHRMSContract", "0000000000", DHRMSContract.address);
  });
  it("Sets deployer as the first government Office", async () => {
    expect(await RBACContract.isGovernment(deployer.address)).to.be.true;
  });
});

describe("Adding to the Approve List", function () {
  it("Adding the Government", async function () {
    await approveContract2.addGovernmentOfficetoList(
      "Hubli-office",
      "9433387654",
      gov2.address
    );
  });
  it("Adding the Hospital", async function () {
    await approveContract2.addHospitaltoList(
      "SDM Medical College Dharwad",
      "9203251212",
      hospital1.address
    );
  });
  it("Adding the Hospital2", async function () {
    await approveContract2.addHospitaltoList(
      "K C General Hospital",
      "9712091212",
      hospital2.address
    );
  });

  it("Adding the Doctor", async function () {
    await approveContract2.addDoctortoList(
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
    await approveContract2.addPatienttoList(
      JSON.stringify(pd),
      patient1.address
    );
  });
  it("Printing List", async function () {
    console.log(await approveContract.getApproveList());
  });
});
describe("Checking the Government is added from the approve List", () => {
  it("Checking event is emitted correctly with added details", async () => {
    expect(await approveContract.approve(gov2.address))
      .to.emit(DHRMS_GOV_Contarct, "newOffice")
      .withArgs("Hubli-office", "9433387654", gov2.address);
  });
  // it("Printing Approve List after Approval", async function () {
  //     console.log(await approveContract.getApproveList())
  // });
  it("Checks newly added government is added to the GOVERNMENT ROLE", async () => {
    expect(await RBACContract.isGovernment(gov2.address)).to.be.true;
  });
});

describe("Checking the hospital(hospital1) is added from the approve List", async () => {
  it("Checking event is emitted correctly with added details", async () => {
    expect(await approveContract.approve(hospital1.address))
      .to.emit(DHRMS_HOS_Contarct, "newHospital")
      .withArgs("SDM Medical College Dharwad", "9203251212", hospital1.address);
  });
  // it("Printing Approve List after Approval", async function () {
  //     console.log(await approveContract.getApproveList())
  // });
  it("Checks newly added hospital1 is added to the HOSPITAL ROLE", async () => {
    expect(await RBACContract.isHospital(hospital1.address)).to.be.true;
  });
});

describe("Checking the hospital(hospital2) is added from the approve List", async () => {
  it("Checking event is emitted correctly with added details", async () => {
    expect(await approveContract.approve(hospital2.address))
      .to.emit(DHRMS_HOS_Contarct, "newHospital")
      .withArgs("K C General Hospital", "9712091212", hospital2.address);
  });
  // it("Printing Approve List after Approval", async function () {
  //     console.log(await approveContract.getApproveList())
  // });
  it("Checks newly added hospital1 is added to the HOSPITAL ROLE", async () => {
    expect(await RBACContract.isHospital(hospital2.address)).to.be.true;
  });
});

describe("Checking the doctor(doc1) is added from the approve List", () => {
  it("Checking event is emitted correctly with added details", async function () {
    expect(await approveContract.approve(doc1.address))
      .to.emit(DHRMS_DOC_Contarct, "newDoctor")
      .withArgs(
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
  // it("Printing Approve List after Approval", async function () {
  //     console.log(await approveContract.getApproveList())
  // });
  it("Checking newly added doc1 is added to the DOCTOR ROLE", async () => {
    expect(await RBACContract.isDoctor(doc1.address)).to.be.true;
  });
});

describe("Checking the patient(Patient1) is added from the approve List", function () {
  it("Should returns new patient details", async function () {
    expect(await approveContract.approve(patient1.address))
      .to.emit(DHRMS_PAT_Contarct, "newPatient")
      .withArgs(JSON.stringify(pd), patient1.address);
  });
  // it("Printing Approve List after Approval", async function () {
  //     console.log(await approveContract.getApproveList())
  // });
  it("Checking newly added Patient is added to the PATIENT ROLE", async function () {
    expect(await RBACContract.isPatient(patient1.address)).to.be.true;
  });
});

describe("Giving read permission", function () {
  it("Should returns new doctor ID", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).giveReadAccess(doc1.address)
    )
      .to.emit(DHRMS_PAT_Contarct, "newReadAccess")
      .withArgs(doc1.address);
  });
  it("Checking that doctor is able to get patient1 details", async () => {
    expect(
      await DHRMS_PAT_Contarct.connect(doc1).getPatientDetails(patient1.address)
    ).to.equal(JSON.stringify(pd));
  });

  it("Checking that unauthorized doctors are not allowed to access the details", async () => {
    try {
      expect(
        await DHRMS_PAT_Contarct.connect(doc2).getPatientDetails(
          patient1.address
        )
      ).to.equal(JSON.stringify(pd));
      console.log("unauthorized access is happend");
      assert(false);
    } catch (error) {
      assert(true);
    }
  });
});

describe("Giving write permission", function () {
  it("Should returns new hospital ID to which permission given", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).giveWriteAccess(
        hospital1.address
      )
    )
      .to.emit(DHRMS_PAT_Contarct, "newWriteAccess")
      .withArgs(hospital1.address);
  });

  it("Checking that unauthorized hospitals are not allowed to access the details", async () => {
    try {
      expect(
        await DHRMS_PAT_Contarct.connect(hospital2).getPatientDetails(
          patient1.address
        )
      ).to.equal(JSON.stringify(pd));
      console.log("unauthorized access is happend");
      assert(false);
    } catch (error) {
      assert(true);
    }
  });
});

describe("Retrieving Doctor information", function () {
  it("Should return particular doctor details", async function () {
    expect(
      await DHRMS_DOC_Contarct.connect(doc1).getDoctorDetails(doc1.address)
    ).to.eql([
      "Dr.M.N.Rayangoudar",
      "7611198762",
      "MBBS",
      "photo",
      "01/12/1968",
      "Cardiology",
    ]);
  });

  it("Should return patient list of particular doctor", async function () {
    console.log(
      await DHRMS_DOC_Contarct.connect(doc1).getPatientListOfDoc(doc1.address)
    );
    expect(
      await DHRMS_DOC_Contarct.connect(doc1).getPatientListOfDoc(doc1.address)
    ).to.eql([patient1.address]);
  });

  it("Should return hospital name in which doctor is working", async function () {
    expect(
      await DHRMS_DOC_Contarct.connect(doc1).getDoctorH(doc1.address)
    ).to.eql(hospital1.address);
  });
});

describe("Retrieving hospital information", function () {
  it("Should return particular hospital details", async function () {
    expect(
      await DHRMS_HOS_Contarct.connect(hospital1).getHospitalDetails(
        hospital1.address
      )
    ).to.eql(["SDM Medical College Dharwad", "9203251212"]);
  });

  it("Should return doctor list of particular hospital", async function () {
    expect(
      await DHRMS_HOS_Contarct.connect(hospital1).getHospitalDoctorList(
        hospital1.address
      )
    ).to.eql([doc1.address]);
  });

  it("Should return patient list of particular hospital", async function () {
    expect(
      await DHRMS_HOS_Contarct.connect(hospital1).getHospitalPatientList(
        hospital1.address
      )
    ).to.eql([patient1.address]);
  });
});

describe("Retrieving patient information", function () {
  it("Should return particular patient details", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).getPatientDetails(
        patient1.address
      )
    ).to.equal(JSON.stringify(pd));
  });

  it("Should return doctors list of particular patient", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).getDoctorsList(
        patient1.address
      )
    ).to.eql([doc1.address]);
  });

  it("Should return hospital list of particular patient", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).getHospitalsList(
        patient1.address
      )
    ).to.eql([hospital1.address]);
  });
});

describe("Removing read permission", function () {
  it("Should returns new doctor ID to which permission reverted", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).removeReadAccess(doc1.address)
    )
      .to.emit(DHRMS_PAT_Contarct, "removeReadAccessDoctor")
      .withArgs(doc1.address);
  });
});

describe("Removing write permission", function () {
  it("Should returns new hospital ID to which permission reverted", async function () {
    expect(
      await DHRMS_PAT_Contarct.connect(patient1).removeWriteAccess(
        hospital1.address
      )
    )
      .to.emit(DHRMS_PAT_Contarct, "removeWriteAccessHospital")
      .withArgs(hospital1.address);
  });
});

describe("Send Records for upload", function () {
  it("Should returns new uploaded records", async function () {
    expect(
      await DHRMS_DOC_Contarct.connect(doc1).sendRecordsForUpload(
        "CID"
      )
    )
      .to.emit(DHRMS_DOC_Contarct, "newRecordForUpload")
      .withArgs("CID");
  });
});

describe("Send Records for upload (Hospital)", function () {
  it("Should returns new uploaded recorded (Hospital)", async function () {
    expect(
      await DHRMS_HOS_Contarct.connect(hospital1).sendRecordsForUploadH(
        "record2"
      )
    )
      .to.emit(DHRMS_HOS_Contarct, "newRecordForUploadH")
      .withArgs("record2");
  });
});

describe("Retrieving upload queue", function () {
  it("Should returns uploaded queue", async function () {
    expect(
      await DHRMS_HOS_Contarct.connect(hospital1).getUploadQueue()
    ).to.eql(["CID","record2"]);
  });
});




describe("Adding records to patient history", function () {
  it("Should returns all records of patient", async function () {
    await DHRMS_HOS_Contarct.connect(hospital1).reportUploaded(
      patient1.address,
      "CID",
      "CID"
    );

    expect(
      await DHRMS_PAT_Contarct.connect(hospital1).getRecordsHistory(
        patient1.address
      )
    ).to.eql(["CID"]);
  });
});

describe("Retrieving Government information", function () {
  it("Should return particular government office details", async function () {
    expect(
      await DHRMS_GOV_Contarct.connect(gov2).getGovernmentDetails(gov2.address)
    ).to.eql(["Hubli-office", "9433387654"]);
  });
});

describe("checking whether we can remove members", () => {
  it("Removing the Patient", async function () {
    await DHRMS_PAT_Contarct.connect(patient1).removePatient(patient1.address);
  });
  it("Checking Patient is removed from the contract", async function () {
    expect(await RBACContract.isPatient(patient1.address)).to.be.false;
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
