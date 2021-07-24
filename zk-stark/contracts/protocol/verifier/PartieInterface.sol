// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

pragma experimental ABIEncoderV2;

import "../message/TranscriptMessage.sol";

interface PartieInterface {
    function receiveMessage(TranscriptMessage message) external;

    function sendMessage() external returns (TranscriptMessage);
}
