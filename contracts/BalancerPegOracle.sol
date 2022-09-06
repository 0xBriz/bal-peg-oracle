// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./interfaces/IOracleWeightedPool.sol";
import "./interfaces/IVault.sol";
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

    IVault public immutable vault;

    IOracleWeightedPool public immutable pool;

    address public immutable trackedToken;

    constructor(
        address _vault,
        address _pool,
        address _token,
        uint256 _period,
        uint256 _startTime
    ) Epoch(_period, _startTime, 0) {
        require(_vault != address(0), "Vault not provided");
        require(_pool != address(0), "Pool not provided");
        require(_token != address(0), "Token not provided");

        // could require token is in pool but just assume for now
        // check that pool is an oracle enabled pool
        // etc

        vault = IVault(_vault);
        pool = IOracleWeightedPool(_pool);
        trackedToken = _token;
    }

    /// @dev do we need the checkEpoch modifier?
    function update() external checkEpoch {
        // "Updates 1-day EMA price from Uniswap."
        // our oracle pools do this on their own
        // still need to provide the interface to treasuries though
    }

    /// @dev Should return the current price of the tracked token.
    /// @dev Parameters are ignored and just provide compatible interface.
    /**
     * Spot price is calculated by:
     *      (tokenInPoolBalance / tokenInWeight) / (tokenOutPoolBalance / tokenOutWeight)
     *
     *  Where tokenInPoolBalance = token being sold into the pool
     */
    function consult(address _token, uint256 _amountIn) external view returns (uint144 spotPrice) {
        (IERC20[] memory tokens, uint256[] memory balances, uint256 lastChangeBlock) = vault
            .getPoolTokens(pool.getpoolid());

        uint256[] memory weights = pool.getNormalizedWeights();

        for (uint256 i = 0; i < tokens.length; i++) {
            if (address(tokens[i]) == trackedToken) {
                // Get this tokens price in terms of the other tokens balance
                // Or, how many of the other token can you get for our tracked token?

                // We have a reference to our tracked token now, so we know the "other" index is the other token
                uint256 ourTokenIndex = i;
                uint256 otherTokensIndex = ourTokenIndex == 0 ? 1 : 0;
                uint256 numerator = balances[otherTokensIndex] / weights[otherTokensIndex];
                uint256 denominator = balances[ourTokenIndex] / weights[ourTokenIndex];

                spotPrice = uint144(numerator / denominator);
            }
        }
    }

    /// @dev Parameters are simply to provide the correct interface
    function twap(address _token, uint256 _amountIn) external view returns (uint144) {
        // twap for what length of time?
        // tomb contracts use uniswap twap function but do not need to specify a time
        // guess the 1 day EMA is the twap?
        // tomb forks seem to just pass 1e18 for amount in which makes sense
        // just return the last 24 hours?
        // Get twap for the last day, but how to get the single tokens twap?
        // can get the records and loop across and calc for just the one I guess
    }
}
