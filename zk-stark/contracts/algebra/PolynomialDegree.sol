// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

library PolynomialDegree {
    struct integral_t {
        int64 degree;
    }

    function getZeroPolyDegree() external pure returns (integral_t memory) {
        return integral_t(-1);
    }
}
