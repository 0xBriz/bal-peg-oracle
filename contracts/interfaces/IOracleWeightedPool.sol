// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IOracleWeightedPool {
    enum Variable {
        PAIR_PRICE,
        BPT_PRICE,
        INVARIANT
    }

    struct OracleAverageQuery {
        Variable variable;
        uint256 secs;
        uint256 ago;
    }

    struct OracleAccumulatorQuery {
        Variable variable;
        uint256 ago;
    }

    function getpoolid() external view returns (bytes32);

    function getNormalizedWeights() external view returns (uint256[] memory);

    function getTimeWeightedAverage(OracleAverageQuery[] memory queries)
        external
        view
        returns (uint256[] memory results);

    function getPastAccumulators(OracleAccumulatorQuery[] memory queries)
        external
        view
        returns (int256[] memory results);
}
