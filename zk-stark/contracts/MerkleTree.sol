// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct Node {
    bytes32 leftHash;
    bytes32 rightHash;
}

contract MerkleTree {
    bytes32[][] private _raw;
    mapping(bytes32 => bool) private _hashes;

    uint256 internal constant WORD_SIZE = 32;

    constructor() {
        _raw.push();
    }

    function getRoot() external view returns (bytes32) {
        require(_raw[_raw.length - 1].length == 1, "Empty tree");
        return _raw[_raw.length - 1][0];
    }

    function getAuthPath(bytes32 hash) external view returns (bytes memory) {
        if (!_hashes[hash])
            revert("Value with specified hash doesn't presented in tree");
    }

    // Inserts hash to Merkle tree and returns new tree root hash.
    function addHash(bytes calldata hash) public returns (bytes32) {
        require(_raw.length > 0, "Raw tree representation is not initialized");

        bytes32 prevRoot = _raw[_raw.length - 1].length > 0
            ? _raw[_raw.length - 1][0]
            : bytes32(0x0);

        _raw[0].push();
        _raw[0][_raw[0].length - 1] = keccak256(abi.encodePacked(hash));

        if (_raw[0].length % 2 == 0) {
            recalcHashes(1);
        } else {
            calcHashes(1);
        }

        require(
            _raw[_raw.length - 1].length == 1,
            "Top level can contains only of single node"
        );
        require(
            (prevRoot == bytes32(0x0)) ||
                (_raw[_raw.length - 1][0] != prevRoot),
            "Tree root hash doesn't changes after insertion"
        );

        return _raw[_raw.length - 1][0];
    }

    // Inserts multiple hashes to the Merkle tree and returns new root hash.
    function addHashes(bytes32[] calldata hashes) public returns (bytes32) {}

    // Recalculate tree node hashes after even element insertion
    function recalcHashes(uint256 level) private {
        if (level == _raw.length) return;

        bytes32 hash1 = _raw[level - 1][_raw[level - 1].length - 2];
        bytes32 hash2 = _raw[level - 1][_raw[level - 1].length - 1];
        _raw[level][_raw[level].length - 1] = keccak256(
            concat(abi.encodePacked(hash1), abi.encodePacked(hash2))
        );

        if (_raw[level].length % 2 == 0) {
            recalcHashes(level + 1);
        } else if (_raw[level].length > 1) {
            hash1 = _raw[_raw.length - 2][_raw[_raw.length - 2].length - 1];
            hash2 = _raw[level][_raw[level].length - 1];
            _raw[_raw.length - 1][_raw[_raw.length - 1].length - 1] = keccak256(
                concat(abi.encodePacked(hash1), abi.encodePacked(hash2))
            );
        }
    }

    // Calculate new tree node hashes after odd element insertion
    function calcHashes(uint256 level) private {
        if (level == _raw.length) _raw.push();

        bytes32 hash1;
        bytes32 hash2;

        uint256 prev = level - 1;

        if (_raw[level - 1].length % 2 == 0) {
            hash1 = _raw[prev][_raw[prev].length - 2];
            hash2 = _raw[prev][_raw[prev].length - 1];
        } else {
            hash1 = hash2 = _raw[prev][_raw[prev].length - 1];
        }

        _raw[level].push();
        _raw[level][_raw[level].length - 1] = keccak256(
            concat(abi.encodePacked(hash1), abi.encodePacked(hash2))
        );

        if (_raw[level].length % 2 == 0) {
            calcHashes(level + 1);
        } else if (_raw[level].length > 1) {
            // Taking last hashes of pre-last and current tree levels
            hash1 = _raw[_raw.length - 1][_raw[_raw.length - 1].length - 1];
            hash2 = _raw[level][_raw[level].length - 1];

            _raw.push();
            _raw[_raw.length - 1].push();
            _raw[_raw.length - 1][0] = keccak256(
                concat(abi.encodePacked(hash1), abi.encodePacked(hash2))
            );
        }
    }

    // Get byte array address
    function fromBytes(bytes memory bts)
        private
        pure
        returns (uint256 addr, uint256 len)
    {
        len = bts.length;
        assembly {
            addr := add(
                bts,
                /*BYTES_HEADER_SIZE*/
                32
            )
        }
    }

    // Copy from src to dest specified number if bytes
    function copy(
        uint256 src,
        uint256 dest,
        uint256 len
    ) internal pure {
        // Copy word-length chunks while possible
        for (; len >= WORD_SIZE; len -= WORD_SIZE) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += WORD_SIZE;
            src += WORD_SIZE;
        }

        if (len == 0) return;

        // Copy remaining bytes
        uint256 mask = (1 << ((WORD_SIZE - len) * 8)) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    // Concatenate two byte arrays
    function concat(bytes memory self, bytes memory other)
        private
        pure
        returns (bytes memory)
    {
        bytes memory ret = new bytes(self.length + other.length);

        (uint256 src, uint256 srcLen) = fromBytes(self);
        (uint256 src2, uint256 src2Len) = fromBytes(other);
        (uint256 dest, ) = fromBytes(ret);

        copy(src, dest, srcLen);
        copy(src2, dest + srcLen, src2Len);

        return ret;
    }
}
