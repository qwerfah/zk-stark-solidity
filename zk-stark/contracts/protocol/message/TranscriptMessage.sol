// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "./PartyState.sol";
import "../../algebra/FieldElement.sol";

interface TranscriptMessage {}

// Represents verifier message
contract VerifierMessage is TranscriptMessage {
    uint8 numRepetitions;
    RandomCoeffsSet randomCoefficients;
    FieldElement[] coeffsPi;
    FieldElement[] coeffsChi;
    RawQueries queries;

    TranscriptMessage[] RS_verifier_witness_msg;
    TranscriptMessage[] RS_verifier_composition_msg;
}
