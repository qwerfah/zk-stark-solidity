// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "./PartieInterface.sol";
import "./VerifierInterface.sol";

contract Protocol {
    function executeProtocol(PartieInterface prover, VerifierInterface verifier) public;
}