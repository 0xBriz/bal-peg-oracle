// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./interfaces/IOracleWeightedPool.sol";

import "./Epoch.sol";

// Oracle is Epoch is Operator
contract BalancerPegOracle is Epoch {
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

    IOracleWeightedPool public pool;

    constructor(
        address _pool,
        uint256 _period,
        uint256 _startTime
    ) Epoch(_period, _startTime, 0) {}

    /// @dev do we need the checkEpoch modifier?
    function update() external checkEpoch {
        // "Updates 1-day EMA price from Uniswap."
        // our oracle pools do this on their own
        // still need to provide the interface to treasuries though
    }

    // should return the current price
    function consult(address _token, uint256 _amountIn) external view returns (uint144) {
        // tomb forks seem to just pass 1e18 for amount in which makes sense
    }

    // twap for what length of time?
    // tomb contracts use uniswap twap function but need to specify a time
    function twap(address _token, uint256 _amountIn) external view returns (uint144) {
        // tomb forks seem to just pass 1e18 for amount in which makes sense
        // just return the last 24 hours?
    }
}
