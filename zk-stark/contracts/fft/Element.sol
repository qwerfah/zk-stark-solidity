// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

library Element {
    struct Element {
        uint64[] c;
    }

    uint32 constant sizeof_cell_t = 64;
    uint32 constant log_bits_in_byte = 3;
    uint32 constant bits_in_byte = uint32(1) << log_bits_in_byte;
    uint32 constant log_ord = 6;
    uint32 constant ord = uint32(1) << log_ord;
    uint32 constant log_bits_in_cell = 6;
    uint32 constant bits_in_cell = uint32(1) << log_bits_in_cell;
    uint32 constant element_len = (ord >> log_bits_in_byte) / sizeof_cell_t;

    function generateOrdElement(Element storage e) public {}

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

    function c_add(Element calldata a, Element calldata b)
        public
        pure
        returns (Element memory)
    {
        Element memory element = Element(new uint64[](element_len));
        uint256 i = 0;

        for (; i < element_len; i++) {
            element.c[i] = a.c[i] ^ b.c[i];
        }

        return element;
    }

    function c_mul(Element calldata a, Element calldata b)
        public
        pure
        returns (Element memory)
    {
        Element memory element = Element(new uint64[](element_len));
        uint256 i = 0;

        for (; i < element_len; i++) {
            element.c[i] = a.c[i] ^ b.c[i];
        }

        return element;
    }
}
