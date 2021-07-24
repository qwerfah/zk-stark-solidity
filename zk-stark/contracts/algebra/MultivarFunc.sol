// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "./FieldElement.sol";

// Multivariable function with the arguments over binary finite field
interface MultivarFunc {
    function numVars() external view returns (uint64);

    function eval(FieldElement[] calldata assignment)
        external
        view
        returns (FieldElement);
}
