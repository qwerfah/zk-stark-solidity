const AssertionError = require("assertion-error");

const Element = artifacts.require("Element");

contract('Element', () => {
  let instance;

  beforeEach('should setup the contract instance', async () => {
    instance = await Element.deployed();
  });

  it('should perform carry-less multiplication of two 128-bit integers', async () => {
    const result = (await instance.clMulXor.call(100, 200)).toNumber();

    AssertionError.equal(result, 10272, 'Invalid carry-less multiplication product');
  });
});