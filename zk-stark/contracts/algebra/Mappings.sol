// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "./FieldElement.sol";
import "./MultivarFunc.sol";

interface Mappings {
    function numVars() external view returns (uint64);

    function numMappings() external view returns (uint64);

    function eval(FieldElement[] calldata assignment)
        external
        view
        returns (FieldElement[] memory);

    function getLinearComb(FieldElement[] calldata coefs)
        external
        view
        returns (MultivarFunc);
}
