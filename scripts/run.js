const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const oracleContractFactory = await hre.ethers.getContractFactory("Oracle");
    const oracleContract = await oracleContractFactory.deploy();
    await oracleContract.deployed();

    console.log("Contract deployed to:", oracleContract.address);
    console.log("Contract deployed by:", owner.address);

    let oracleCount;
    oracleCount = await oracleContract.getResult();

   // let oracleTxn = await oracleContract.setResult([{firstMatchLocal: 1, firstMatchVisitor: 2, secondMatchLocal: 2, secondMatchVisitor: 4, penaltyMatchLocal:0, penaltyMatchVisitor:0},
   //                                             {firstMatchLocal: 2, firstMatchVisitor: 2, secondMatchLocal: 2, secondMatchVisitor: 1, penaltyMatchLocal:0, penaltyMatchVisitor:0}]);

    let oracleTxn3 = await oracleContract.setResultArray([{matches:[{score:[1,2]}, {score:[1,2]}, {score:[4,5]}]},
                                                      {matches:[{score:[3,3]}, {score:[2,1]}]},
                                                      {matches:[{score:[3,1]}, {score:[1,2]}]}]);

    await oracleTxn3.wait();


    oracleCount = await oracleContract.getResult();
    console.log("oracleCount: ", oracleCount);
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