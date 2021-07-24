// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "../algebra/Mappings.sol";
import "../algebra/FieldElement.sol";
import "../algebra/PolynomialInterface.sol";


abstract contract Constraint is Mappings {
    function numMappings() external view override returns (uint64) {}

    function getLinearComb(FieldElement[] calldata coefs)
        external
        view
        override
        returns (MultivarFunc)
    {}

    function constraints() public view returns (PolynomialInterface[] memory) {}

    function varUsed(uint64 varId) public view returns (bool) {

    }

    function verify(FieldElement[] assignment) public view returns (bool) {
        
    }
}
