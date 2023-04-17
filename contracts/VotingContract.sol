// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IERC20Token.sol";

contract VotingContract {
    IERC20Token private _token;

    constructor(address token) {
        _token = IERC20Token(token);
    }
}
