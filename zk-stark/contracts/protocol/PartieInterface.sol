// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

interface PartieInterface {
    struct TranscriptMessage {
        string data;
    }

    function receiveMessage(TranscriptMessage calldata message) external;

    function sendMessage() external returns (TranscriptMessage memory);
}
