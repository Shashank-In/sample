// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./AaveV2Strategy.sol";

//solhint-disable no-empty-blocks
contract AaveV2StrategyLINK is AaveV2Strategy {
    string public constant NAME = "Strategy-AaveV2-LINK";
    string public constant VERSION = "2.0.3";

    constructor(address _controller, address _pool)
        public
        AaveV2Strategy(_controller, _pool, 0x514910771AF9Ca656af840dff83E8264EcF986CA)
    {}
}
