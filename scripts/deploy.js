const main = async () => {
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
  DHRMS_GOV_ContractFactory = await hre.ethers.getContractFactory("DHRMS_GOV");
  DHRMS_HOS_ContractFactory = await hre.ethers.getContractFactory("DHRMS_HOS");
  DHRMS_DOC_ContractFactory = await hre.ethers.getContractFactory("DHRMS_DOC");
  DHRMS_PAT_ContractFactory = await hre.ethers.getContractFactory("DHRMS_PAT");

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
  console.log("DHRMS_GOV_Contract add:", DHRMS_GOV_Contarct.address);
  console.log("DHRMS_HOS_Contract add:", DHRMS_HOS_Contarct.address);
  console.log("DHRMS_DOC_Contract add:", DHRMS_DOC_Contarct.address);
  console.log("DHRMS_PAT_Contract add:", DHRMS_PAT_Contarct.address);
  console.log("approveContract1 add:", approveContract.address);
  console.log("approveContract2 add:", approveContract2.address);

  RBACContract.setContracts(approveContract.address);
  RBACContract.setContracts(STORAGEContract.address);
  RBACContract.setContracts(DHRMS_PAT_Contarct.address);
  RBACContract.setContracts(DHRMS_HOS_Contarct.address);
  RBACContract.setContracts(DHRMS_DOC_Contarct.address);
  RBACContract.setContracts(DHRMS_GOV_Contarct.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
