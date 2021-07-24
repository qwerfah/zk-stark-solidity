// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "./MultivarFunc.sol";

abstract contract PolynomialInterface is MultivarFunc {
    function evalOnSet(FieldElement[][] calldata x_set)
        external
        view
        returns (FieldElement[] memory result)
    {
        uint256 numEvals = x_set.length;
        result = new FieldElement[](numEvals);
        uint256 i = 0;

        for (; i < numEvals; i++) {
            result[i] = this.eval(x_set[i]);
        }
    }
}
