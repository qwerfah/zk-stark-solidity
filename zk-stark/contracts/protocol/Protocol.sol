// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "./PartieInterface.sol";
import "./VerifierInterface.sol";

abstract contract Protocol {
    function executeProtocol(PartieInterface prover, VerifierInterface verifier)
        public
        virtual;
}
