// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "../VerifierInterface.sol";
import "../../../bair/BairInstance.sol";

enum ProtocolPhase {
    START_PROTOCOL,
    UNIVARIATE_COMMITMENTS,
    VERIFIER_RANDOMNESS,
    RS_PROXIMITY,
    QUERY,
    RESULTS,
    DONE
}

contract AliVerifier is VerifierInterface {
    BairInstance private _bairInstance;
    uint32[] private _combSoundness;
    FieldElement[][] private _coeffsPi;
    FieldElement[][] private _coeffsChi;
    AcspInstance[] private _instance;
    RandomCoeffsSet private _randCoeffs;
    ProtocolPhase private _phase;

    constructor(
        BairInstance bairInstance,
        function(FieldElement[] calldata, int16, int16, bool)
            external
            returns (IoppVerifierInterface) factory,
        uint16 securityParameter
    ) {
        _bairInstance = bairInstance;
    }

    function receiveMessage(TranscriptMessage message) external override {}

    function sendMessage() external override returns (TranscriptMessage) {}

    function doneInteracting() external view override returns (bool) {}

    function verify() external view override returns (bool) {}

    function expectedCommitedProofBytes()
        external
        view
        override
        returns (uint64)
    {}

    function expectedSentProofBytes() external view override returns (uint64) {}

    function expectedQueriedDataBytes()
        external
        view
        override
        returns (uint64)
    {}

    function fillResultsAndCommitmentRandomly() external override {}
}
