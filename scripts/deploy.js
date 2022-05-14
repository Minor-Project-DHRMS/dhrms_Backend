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