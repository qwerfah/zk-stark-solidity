const MetaCoin = artifacts.require("MetaCoin");
const truffleAssert = require('truffle-assertions');

contract('MetaCoin', (accounts) => {
  let instance;
  beforeEach('should setup the contract instance', async () => {
    instance = await MetaCoin.deployed();
  });

  it('should put 10000 MetaCoin in the first account', async () => {
    const balance = await instance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });

  it('should call a function that depends on a linked library', async () => {
    const metaCoinBalance = (await instance.getBalance.call(accounts[0])).toNumber();
    const metaCoinEthBalance = (await instance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });
  
  it('should send coin correctly', async () => {
    // Setup 2 accounts.
    // accounts[0] = 0;
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await instance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await instance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    const result = await instance.sendCoin(accountTwo, amount, { from: accountOne });
    
    // Check if event was emitted and it has correct arguments
    truffleAssert.eventEmitted(result, 'Transfer', (event) =>{
      return event._from == accountOne 
          && event._to == accountTwo 
          && event._value == amount;
    });
;
    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await instance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await instance.getBalance.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
