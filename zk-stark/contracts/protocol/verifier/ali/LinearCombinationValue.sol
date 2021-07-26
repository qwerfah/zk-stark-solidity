// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "../../../algebra/FieldElement.sol";
import "../../message/PartyState.sol";

library ResultLocation {
    // Fields
    struct ResultLocation {
        // Private
        FieldElement[] _answerLocations;
    }

    // Add new answer location
    function addAnswer(FieldElement element, ResultLocation memory self)
        public
        returns (ResultLocation memory)
    {
        self._answerLocations.push(element);
        return self;
    }

    // Write specified element to all answer locations
    function answer(FieldElement element, ResultLocation memory self)
        public
        returns (ResultLocation memory)
    {
        uint256 i = 0;
        for (; i < self._answerLocations.length; i++) {
            self._answerLocations[i] = element;
        }
        return self;
    }
}

library LinearCombinationValue {
    // Fields
    struct LinearCombinationValue {
        // Public
        FieldElement.FieldElement[] boundaryEval_res;
        FieldElement.FieldElement compositionEval_res;
        FieldElement.FieldElement ZK_mask_res;
        // Private
        FieldElement.FieldElement _x;
        uint32 _combId;
        ResultLocation.ResultLocation _result;
    }

    function initLocation(
        FieldElement x,
        uint32 combId,
        LinearCombinationValue memory self
    ) public returns (LinearCombinationValue memory) {
        self._x = x;
        self._combId = combId;
        return self;
    }

    function calculateWitness(
        RandomCoeffsSet memory coeffs,
        LinearCombinationValue memory self
    ) public view {
        FieldElement.FieldElement res = self.ZK_mask_res;
        uint256 i = 0;

        for (; i < coeffs.boundary.length; i++) {
            res = FieldElement.sum(
                coeffs.boundary[i].coeffUnshifted[self._combId]
            );
        }
    }
}
