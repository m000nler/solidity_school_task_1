// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC20Token.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is IERC20Token, Ownable {
    using SafeMath for uint256;

    string private _name;
    mapping(address => bool) private _votingAdmins;
    uint256 private _tokenPrice = 1 ether;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);

    constructor(string memory name) {
        _name = name;
    }

    function mint(uint256 amount, address to) public onlyOwner returns (bool) {
        require(amount >= 0, "Cannot mint zero tokens");

        _balances[to] += amount;
        _totalSupply += amount;
        emit Transfer(address(this), to, amount);

        return true;
    }

    function burn(uint256 amount, address owner)
        public
        onlyOwner
        returns (bool)
    {
        require(amount > 0, "Cannot burn zero tokens");
        require(
            _balances[owner] >= amount,
            "Owner doesn't have this amount of tokens"
        );

        _balances[owner] -= amount;
        _totalSupply -= amount;
        emit Transfer(address(this), owner, amount);

        return true;
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
        emit Transfer(msg.sender, to, amount);

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
        emit Approval(msg.sender, spender, amount);

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

        emit Transfer(owner, to, amount);

        return true;
    }

    function decimals() external pure returns (uint256) {
        return 18;
    }

    function addPriceVotingAdmin(address newAdmin) public onlyOwner {
        _votingAdmins[newAdmin] = true;
    }

    function changeTokenPrice(uint256 newPrice) public {
        require(
            _votingAdmins[msg.sender],
            "Only price voting admin can change price"
        );
        _tokenPrice = newPrice;
    }

    function getTokenPrice() external view returns (uint256) {
        return _tokenPrice;
    }
}
