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
        public
        pure
        restrictSize(n)
        returns (uint8 res)
    {
        assembly {
            res := gt(and(num, exp(2, n)), 0)
        }
    }

    // Set specified bit in given 128-bit integer
    function setBit(
        uint128 num,
        uint8 n,
        bool bit
    ) public pure restrictSize(n) returns (uint128 res) {
        assembly {
            switch bit
                case 0 {
                    res := and(num, not(exp(2, n)))
                }
                case 1 {
                    res := or(num, exp(2, n))
                }
        }
    }

    // Carryless xor of a and b
    function clMulXor(uint128 a, uint128 b) public pure returns (uint128 res) {
        assembly {
            function getBit(num, n) -> result {
                result := gt(and(num, exp(2, n)), 0)
            }

            function setBit(num, n, bit) -> result {
                result := and(num, not(exp(2, n)))
            }

            res := setBit(0, 0, mul(getBit(a, 0), getBit(b, 0)))
            let xor1

            for {
                let i := 0
            } lt(i, 64) {
                i := add(i, 1)
            } {
                xor1 := mul(getBit(a, 0), getBit(b, i))

                for {
                    let j := 1
                } or(lt(j, i), eq(j, i)) {
                    j := add(j, 1)
                } {
                    if mul(getBit(a, j), getBit(b, sub(i, j))) {
                        xor1 := xor(xor1, 1)
                    }
                }

                if xor1 {
                    res := setBit(res, i, xor1)
                }
            }

            for {
                let i := 64
            } lt(i, 127) {
                i := add(i, 1)
            } {
                xor1 := mul(getBit(a, sub(i, 63)), getBit(b, 63))

                for {
                    let j := sub(i, 62)
                } lt(j, 64) {
                    j := add(j, 1)
                } {
                    if mul(getBit(a, j), getBit(b, sub(i, j))) {
                        xor1 := xor(xor1, 1)
                    }
                }

                if xor1 {
                    res := setBit(res, i, xor1)
                }
            }
        }

        /*
        uint128 res = setBit(0, 0, getBit(a, 0) * getBit(b, 0) == 1);
        uint8 i = 1;

        for (; i < 64; i++) {
            uint8 xor1 = getBit(a, 0) * getBit(b, i);
            uint8 j1 = 1;

            for (; j1 <= i; j1++) {
                xor1 ^= (getBit(a, j1) * getBit(b, i - j1));
            }

            res = setBit(res, i, xor1 == 1);
        }

        for (; i < 127; i++) {
            uint8 xor2 = getBit(a, i - 63) * getBit(b, 63);
            uint8 j2 = i - 62;

            for (; j2 < 64; j2++) {
                xor2 ^= (getBit(a, j2) * getBit(b, i - j2));
            }

            res = setBit(res, i, xor2 == 1);
        }
        
        return res;
        */
    }

    //
    function reduce(uint256 clMulRes) public view returns (uint256) {}

    // Carryless multiplication of a and b,
    function clMul(uint256 a, uint256 b) public view returns (uint256) {}

    function equals(uint256 a, uint256 b) public view returns (bool) {}

    function setElementMul(uint256 e) public view {}
}
