// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/VolcanoCoin.sol";

interface CheatCodes {
    // Sets the *next* call's msg.sender to be the input address,
    // and the tx.origin to be the second input
    function prank(address, address) external;
}

contract VolcanoCoinTest is Test {
    VolcanoCoin volcanoCoin;
    CheatCodes cheatCodes;

    function setUp() public {
        volcanoCoin = new VolcanoCoin();
        cheatCodes = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    }

    function testInitialSupply() public {
        uint256 currentSupply = volcanoCoin.totalSupply();
        assertEq(currentSupply, 10000);
    }

    function testIncrementSteps() public {
        assertEq(volcanoCoin.totalSupply(), 10000);
        volcanoCoin.increaseSupply();
        assertEq(volcanoCoin.totalSupply(), 10000 + 1000);
    }
    
    function testFailOnlyOwnerIncrements() public {
        cheatCodes.prank(address(1337), address(1337));
        volcanoCoin.increaseSupply();
    }
}
