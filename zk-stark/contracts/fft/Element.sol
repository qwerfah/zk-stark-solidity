// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

contract Element {
    uint256[] c;

    function generateOrdElement(Element e) public {}

    modifier restrictSize(uint8 size) {
        require(size < 128, "Function works only with 128-bit integers.");
        _;
    }

    // Get specified bit from given 128-bit integer
    function getBit(uint128 num, uint8 n)
        internal
        pure
        restrictSize(n)
        returns (uint8)
    {
        uint128 shifted = 1 * uint128(2)**n;
        return num & shifted > 0 ? 1 : 0;
    }

    // Set specified bit in given 128-bit integer
    function setBit(
        uint128 num,
        uint8 n,
        bool bit
    ) internal pure restrictSize(n) returns (uint128) {
        uint128 shifted = 1 * uint128(2)**n;

        return bit ? num | shifted : num & ~shifted;
    }

    // Carryless xor of a and b
    function clMulXor(uint128 a, uint128 b) public pure returns (uint128) {
        uint128 res = setBit(0, 0, getBit(a, 0) * getBit(b, 0) == 1);
        uint8 i = 1;

        for (; i < 64; i++) {
            uint8 xor = getBit(a, 0) * getBit(b, i);
            uint8 j = 1;

            for (; j <= i; j++) {
                xor ^= (getBit(a, j) * getBit(b, i - j));
            }

            res = setBit(res, i, xor == 1);
        }

        for (; i < 127; i++) {
            uint8 xor = getBit(a, i - 63) * getBit(b, 63);
            uint8 j = i - 62;

            for (; j < 64; j++) {
                xor ^= (getBit(a, j) * getBit(b, i - j));
            }

            res = setBit(res, i, xor == 1);
        }

        return res;
    }

    //
    function reduce(uint256 clMulRes) public view returns (uint256) {}

    // Carryless multiplication of a and b,
    function clMul(uint256 a, uint256 b) public view returns (uint256) {}

    function equals(uint256 a, uint256 b) public view returns (bool) {}

    function setElementMul(uint256 e) public view {}
}
