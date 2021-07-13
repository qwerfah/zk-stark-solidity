// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "./PartieInterface.sol";

interface VerifierInterface is PartieInterface {
    function doneInteracting() external view returns (bool);

    function verify() external view returns (bool);

    function expectedCommitedProofBytes() external view returns (uint256);

    function expectedSentProofBytes() external view returns (uint256);

    function expectedQueriedDataBytes() external view returns (uint256);

    function fillResultsAndCommitmentRandomly() external;
}

interface IoppVerifierInterface is VerifierInterface {
    function queriesToInput() external view;
}
