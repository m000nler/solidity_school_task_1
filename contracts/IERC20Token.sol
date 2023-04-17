// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20Token {
    event Transfer(address from, address to, uint256 value);

    event Approval(address owner, address spender, uint256 value);

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
        address spender,
        address to,
        uint256 amount
    ) external returns (bool);
}
