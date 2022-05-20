const main = async () => {
        ROLE_BASED_ACCESS_ContractFactory = await hre.ethers.getContractFactory("ROLE_BASED_ACCESS");
        DHRMS_ContractFactory = await hre.ethers.getContractFactory("DHRMS");
        ApproveDetails_ContractFactory = await hre.ethers.getContractFactory("ApproveDetails");

        RBACContract = await ROLE_BASED_ACCESS_ContractFactory.deploy();
        await RBACContract.deployed();

        DHRMSContract = await DHRMS_ContractFactory.deploy("Dharwad-office", "7975578890", RBACContract.address);
        await DHRMSContract.deployed();

        approveContract = await ApproveDetails_ContractFactory.deploy(DHRMSContract.address);
        await approveContract.deployed();

        console.log("RBACContract add:", RBACContract.address);
        console.log("DHRMSContract add:", DHRMSContract.address);
        console.log("approveContract add:", approveContract.address);

        RBACContract.setContracts(approveContract.address);
        RBACContract.setContracts(DHRMSContract.address);

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
