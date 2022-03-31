const assert = require("assert");
const ganache = require("ganache-cli");
const Web3 = require("web3");
const web3 = new Web3(ganache.provider());
const compiledFile = require("./compile");
 
const interface = compiledFile.abi;
const bytecode = compiledFile.evm.bytecode.object;

let accounts;
let inbox;

beforeEach(async () => {
    //Get a list of all accounts
    accounts = await web3.eth.getAccounts();
   
    //Use one of those accounts to deploy the contract
    inbox = await new web3.eth.Contract(interface)
    .deploy({
      data: bytecode,
      arguments: ['Hi there!']
    })
    .send({
      from: accounts[0], gas: '1000000'
    });
  });
  
  describe('Inbox', () =>{
    it('deploy a contract', () => {
      assert.ok(inbox.options.address);
    });
  
    it('has a default message', async () => {
        const message = await inbox.methods.Current_Bet().call();
        assert.equal(message, 'O dolar vai estar acima de 5 reais em julho/2022?');
    });

    it('try divide', async () => {
      const result = await inbox.methods.tryDiv(4,2).call();
      assert.equal(result, true);
  });
    
  });