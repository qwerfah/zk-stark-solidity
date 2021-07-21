// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Hash map element
struct HashMapElement {
    // True if element with specified hash is presented in map
    bool isSet;
    // Index of hash in array tree representation
    uint32 index;
}

enum ChildPos { Left, Right }

struct AuthPathElement {
    ChildPos pos;
    bytes32 hash;
}

// Represents binary tree which leafs are hashes of tree element values
// and nodes are hashes of concatination of all its children
contract MerkleTree {
    // Two-dimensional array representation of hash tree
    bytes32[][] private _raw;
    // Maps tree node hashes to its indices in array tree representation
    mapping(bytes32 => HashMapElement) private _hashes;

    uint256 private constant WORD_SIZE = 32;

    constructor() {
        _raw.push();
    }

    // Get current tree root
    function getRoot() external view returns (bytes32) {
        require(_raw[_raw.length - 1].length == 1, "Empty tree");
        return _raw[_raw.length - 1][0];
    }

    // Get authentication path for specified tree leaf hash
    // Reverts if hash is not presented in tree
    function getAuthPath(bytes32 hash)
        external
        view
        returns (AuthPathElement[] memory)
    {
        HashMapElement storage element = _hashes[hash];
        if (!element.isSet) {
            revert("Value with specified hash doesn't presented in tree");
        }

        uint32 level = 0;
        uint32 index = element.index;
        AuthPathElement[] memory path = new AuthPathElement[](_raw.length);

        for (;level != _raw.length; level++) {
            path[level] = getNeighbour(level, index);
        }

        return path;
    }

    // Get neighbour of tree node with specified index on given level
    function getNeighbour(uint32 level, uint32 index)
        private
        view
        returns (AuthPathElement memory)
    {
        require(level >= 0 && level < _raw.length, "Level is out of range");
        require(index >= 0 && index < _raw[level].length, "Index is out of range");
        
        if (level == 0) {
            if (index % 2 == 1) {
                return AuthPathElement(ChildPos.Left, _raw[0][index - 1]);
            } else {
                if (index + 1 < _raw[0].length) {
                    return AuthPathElement(ChildPos.Right, _raw[0][index + 1]);
                } else {
                    return AuthPathElement(ChildPos.Right, _raw[0][index]);
                }
            }
        } else {
            if (index % 2 == 1) {
                return AuthPathElement(ChildPos.Left, _raw[level][index - 1]);
            } else {
                return getUnbalancedNeighbour(level + 1);
            }
        }
    }
    
    // Get neighbour of tree node with unbalanced parent 
    // (left and right subtree depths are not equal) 
    function getUnbalancedNeighbour(uint32 level) 
        private 
        view 
        returns (AuthPathElement memory) 
    {
        require(level > 0 && level < _raw.length, "Level is out of range");
        
        for (; level < _raw.length; level++) {
            
        }
    }

    // Inserts hash to Merkle tree and returns new tree root hash.
    function addHash(bytes calldata data) public returns (bytes32, bytes32) {
        require(_raw.length > 0, "Raw tree representation is not initialized");

        bytes32 prevRoot = _raw[_raw.length - 1].length > 0
            ? _raw[_raw.length - 1][0]
            : bytes32(0x0);

        _raw[0].push();
        bytes32 hash = keccak256(abi.encodePacked(data));
        _raw[0][_raw[0].length - 1] = hash;
        _hashes[hash] = HashMapElement(true, uint32(_raw[0].length - 1));

        if (_raw[0].length % 2 == 0) {
            if (_raw[0][_raw[0].length - 1] == _raw[0][_raw[0].length - 2]) {
                return (hash, _raw[_raw.length - 1][0]);
            }

            recalcHashes(1);
        } else {
            calcHashes(1);
        }

        require(
            _raw[_raw.length - 1].length == 1,
            "Top level can consists only of single node"
        );
        require(
            (prevRoot == bytes32(0x0)) ||
                (_raw[_raw.length - 1][0] != prevRoot),
            "Tree root hash didn't change after insertion"
        );

        return (hash, _raw[_raw.length - 1][0]);
    }

    // Inserts multiple hashes to the Merkle tree and returns new root hash.
    function addHashes(bytes32[] calldata hashes) public returns (bytes32) {}

    // Recalculate tree node hashes after even element insertion
    function recalcHashes(uint256 level) private {
        if (level == _raw.length) return;

        uint256 prev = level - 1;
        bytes32 hash1 = _raw[prev][_raw[prev].length - 2];
        bytes32 hash2 = _raw[prev][_raw[prev].length - 1];

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

        if (_raw[prev].length % 2 == 0) {
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
