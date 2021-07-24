// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "../message/TranscriptMessage.sol";

interface VerifierInterface {
    function receiveMessage(TranscriptMessage message) external;

    function sendMessage() external returns (TranscriptMessage);

    function doneInteracting() external view returns (bool);

    function verify() external view returns (bool);

    function expectedCommitedProofBytes() external view returns (uint64);

    function expectedSentProofBytes() external view returns (uint64);

    function expectedQueriedDataBytes() external view returns (uint64);

    function fillResultsAndCommitmentRandomly() external;
}

interface IoppVerifierInterface is VerifierInterface {
    function queriesToInput() external view;
}
