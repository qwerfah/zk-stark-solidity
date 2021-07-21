const Element = artifacts.require("Element");

contract('Element', () => {
  let instance;

  beforeEach('should setup the contract instance', async () => {
    instance = await Element.deployed();
  });

  it('should perform carry-less multiplication of two 128-bit integers', async () => {
    const result = (await instance.clMulXor.call(1, 1)).toNumber();

    assert.equal(result, 0, 'Invalid carry-less multiplication product');
  });

  it('should perform carry-less multiplication of two 128-bit integers', async () => {
    const result = (await instance.clMulXor.call(100, 200)).toNumber();

    assert.equal(result, 10308, 'Invalid carry-less multiplication product');
  });

  it('should perform carry-less multiplication of two 128-bit integers', async () => {
    const result = (await instance.clMulXor.call(4471615, 6745115)).toString();

    assert.equal(result, "26566810318966", 'Invalid carry-less multiplication product');
  });
});

26566810318966