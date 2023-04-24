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

    function addPriceVotingAdmin(address newAdmin) external;

    function changeTokenPrice(uint256 newPrice) external;

    function getTokenPrice() external view returns (uint256);

    function mint(uint256 amount, address to) external returns (bool);

    function burn(uint256 amount, address owner) external returns (bool);

    function deposit() external payable;

    function withdraw() external payable;
}
