// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "../../algebra/FieldElement.sol";

// Set of 64-bit unsigned integer values
contract Set64 {
    struct Set {
        uint64[] values;
        mapping(uint256 => bool) is_in;
    }

    Set my_set;

    function add(uint64 a) public {
        require(!my_set.is_in[a], "Element already in set");
        my_set.values.push(a);
        my_set.is_in[a] = true;
    }
}

// Random coefficients structure
struct RandomCoefs {
    uint64 degShift;
    FieldElement[] coeffUnshifted;
    FieldElement[] coeffShifted;
}

// Random coefficients set structure
struct RandomCoeffsSet {
    RandomCoefs[] boundary;
    RandomCoefs boundaryPolysMatrix;
    RandomCoefs ZK_mask_boundary;
    RandomCoefs[] ZK_mask_composition;
}

// Raw queries set structure
struct RawQueries {
    Set64[] boundary;
    Set64 boundaryPolysMatrix;
    Set64 ZK_mask_boundary;
    Set64[] ZK_mask_composition;
}
