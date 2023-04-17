// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC20Token.sol";

contract ERC20Token is IERC20Token {
    string private _name;
    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory name) {
        _name = name;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address user) public view returns (uint256) {
        require(user != address(0), "User address cannot be zero");

        return _balances[user];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Receiver address cannot be zero");
        require(amount > 0, "Amount cannot be zero");
        require(_balances[msg.sender] >= amount, "Insufficient amount");

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        require(owner != address(0), "Owner address cannot be zero");
        require(spender != address(0), "Spender address cannot be zero");

        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "Spender address cannot be zero");
        require(amount > 0, "Amount cannot be zero");
        require(_balances[msg.sender] >= amount, "Insufficient amount");

        _allowances[msg.sender][spender] = amount;

        return true;
    }

    function transferFrom(
        address owner,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(owner != address(0), "Owner address cannot be zero");
        require(to != address(0), "Receiver address cannot be zero");
        require(amount > 0, "Amount cannot be zero");
        require(allowance(owner, msg.sender) >= amount, "Insufficient amount");

        _allowances[owner][msg.sender] -= amount;
        _balances[owner] -= amount;
        _balances[to] += amount;

        return true;
    }

    function decimals() external returns (uint256) {
        return 18;
    }
}
