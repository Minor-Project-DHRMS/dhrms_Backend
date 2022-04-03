const main = async () => {
  const mainContractFactory = await hre.ethers.getContractFactory('Main');
  const [deployer] = await hre.ethers.getSigners();
  const mainContract = await mainContractFactory.deploy("Dharwad-office", "7975578890");
  await mainContract.deployed();

  console.log('Contract add:', mainContract.address);



  // /*
  //  * Let's try two waves now
  //  */
  // const waveTxn = await waveContract.wave('This is wave #1');
  // await waveTxn.wait();

  // const waveTxn2 = await waveContract.wave('This is wave #2');
  // await waveTxn2.wait();

  // contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  // console.log(
  //     'Contract balance:',
  //     hre.ethers.utils.formatEther(contractBalance)
  // );

  // let allWaves = await waveContract.getAllWaves();
  // console.log(allWaves);

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


  const addPtxn = await mainContract.addPatient(JSON.stringify(pd), "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
  await addPtxn.wait();

  const getGovD = await mainContract.getGovernmentDetails(deployer.address);
  console.log(getGovD);

  // const addGtxn = await mainContract.addGovernmentOffice("Dharwad-Office","2343423424","0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
  // await addGtxn.wait();

  // const addHtxn = await mainContract.addHospital("XYZ", "241231","0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
  // await addHtxn.wait();

  // const addDtxn = await mainContract.addDoctor("ABCD", "2343214234","MBBS","photo","1/3/1999","0x5B38Da6a701c568545dCfcB03FcB875f56b00000eddC4","DGGGGG");
  // await addDtxn.wait();



  const getDtxn = await mainContract.getPatientDetails("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
  console.log(getDtxn);

  const isGov = await mainContract.isGovernment("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
  console.log(isGov);

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();