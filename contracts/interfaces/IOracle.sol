// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IOracleWeightedPool {
    function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut);

    function twap(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);
}
