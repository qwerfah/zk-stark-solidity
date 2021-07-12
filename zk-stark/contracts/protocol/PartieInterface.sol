// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

interface PartieInterface {
    struct TranscriptMessage {
        string data;
    }

    function receiveMessage(TranscriptMessage calldata msg) external;

    function sendMessage() external returns (TranscriptMessage calldata);
}
