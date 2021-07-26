// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "../fft/Element.sol";

// Element of finite field
library FieldElement {
    struct FieldElement {
        // Private
        Element.Element _element;
    }

    function sum(FieldElement calldata a, FieldElement calldata b)
        public
        pure
        returns (FieldElement memory)
    {
        return FieldElement(Element.c_add(a._element, b._element));
    }

    function mul(FieldElement calldata a, FieldElement calldata b)
        public
        pure
        returns (FieldElement memory)
    {
        return FieldElement(Element.c_mul(a._element, b._element));
    }
}
