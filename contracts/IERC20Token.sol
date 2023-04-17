// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20Token {
    function totalSupply() external view returns (uint256);

    function balanceOf(address user) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address owner,
        address to,
        uint256 amount
    ) external returns (bool);
}
