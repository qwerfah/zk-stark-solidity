// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

contract Element {
    uint256[] c;

    function generateOrdElement(Element e) public {}

    // 
    function clMulXor(uint128 a, uint128 b) public pure returns (uint128 res) {
        assembly {
            function getBit(num, n) -> result {
                result := gt(and(num, shl(n, 1)), 0)
            }

            function setBit(num, n) -> result {
                result := or(num, shl(n, 1))
            }

            if mul(getBit(a, 0), getBit(b, 0)) {
                res := setBit(0, 0)
            }

            for {
                let i := 1
            } lt(i, 64) {
                i := add(i, 1)
            } {
                let xor1 := mul(getBit(a, 0), getBit(b, i))

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
                    res := setBit(res, i)
                }
            }

            for {
                let i := 64
            } lt(i, 127) {
                i := add(i, 1)
            } {
                let xor1 := mul(getBit(a, sub(i, 63)), getBit(b, 63))

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
                    res := setBit(res, i)
                }
            }
        }

        res = a ^ res;
    }

    //
    function reduce(uint256 clMulRes) public view returns (uint256) {}

    // Carryless multiplication of a and b,
    function clMul(uint256 a, uint256 b) public view returns (uint256) {}

    function equals(uint256 a, uint256 b) public view returns (bool) {}

    function setElementMul(uint256 e) public view {}
}
