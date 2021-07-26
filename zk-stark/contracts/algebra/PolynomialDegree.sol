// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

library PolynomialDegree {
    struct integral_t {
        int64 degree;
    }

    function getZeroPolyDegree() public pure returns (integral_t memory) {
        return integral_t(-1);
    }

    function isInteger(integral_t calldata deg) public pure returns (bool) {
        return deg.degree >= 0;
    }

    function isConstantPolyDeg(integral_t calldata deg)
        public
        pure
        returns (bool)
    {
        return deg.degree < 1;
    }

    function degreeOfProduct(integral_t calldata deg1, integral_t calldata deg2)
        public
        pure
        returns (integral_t memory)
    {
        if (!isInteger(deg1) || !isInteger(deg2)) return getZeroPolyDegree();
        return integral_t(deg1.degree + deg2.degree);
    }

    function degreeOfComposition(
        integral_t calldata deg1,
        integral_t calldata deg2
    ) public pure returns (integral_t memory) {
        if (!isInteger(deg1)) return getZeroPolyDegree();
        if (deg1.degree <= 0) return integral_t(0);
        return integral_t(deg1.degree * deg2.degree);
    }

    function less(integral_t calldata deg1, integral_t calldata deg2)
        public
        pure
        returns (bool)
    {
        return deg1.degree < deg2.degree;
    }

    function equals(integral_t calldata deg1, integral_t calldata deg2)
        public
        pure
        returns (bool)
    {
        return
            (isInteger(deg1) && isInteger(deg2))
                ? (deg1.degree == deg2.degree)
                : !(isInteger(deg1) || isInteger(deg2));
    }

    function notEquals(integral_t calldata deg1, integral_t calldata deg2)
        public
        pure
        returns (bool)
    {
        return !equals(deg1, deg2);
    }
}
