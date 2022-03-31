const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require('web3');
const compiledFile = require("./compile");
 
const interface = compiledFile.abi;
const bytecode = compiledFile.evm.bytecode.object;

const provider = new HDWalletProvider(

    'soccer stable clock balcony man become fancy admit business arrange journey clean',
    'https://rinkeby.infura.io/v3/e2614991c51942479ee0c8fafdff3f38'
);

const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(interface)
    .deploy({ data: bytecode, arguments: null })
    .send({ gas: '1000000', from: accounts[0] });
 
  console.log('Contract deployed to', result.options.address);
  provider.engine.stop();
};
deploy();