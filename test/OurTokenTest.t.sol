// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000 ether;

        // Bob allows Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500 ether;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    /* function testAllowanceCanBeUpdated() public {
        vm.prank(bob);
        ourToken.approve(alice, 200 ether);

        vm.prank(bob);
        ourToken.approve(alice, 500 ether);

        assertEq(ourToken.allowance(bob, alice), 500 ether);
    }

    function testTransferFromExactAllowance() public {
        vm.prank(bob);
        ourToken.approve(alice, 300 ether);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, 300 ether);

        assertEq(ourToken.allowance(bob, alice), 0);
    }

    function testTransferEmitsEvent() public {
        vm.prank(bob);
        ourToken.approve(alice, 123 ether);

        vm.expectEmit(true, true, false, true);
        emit Transfer(bob, alice, 123 ether);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, 123 ether);
    }

    function testApprovalEmitsEvent() public {
        vm.expectEmit(true, true, false, true);
        emit Approval(bob, alice, 456 ether);

        vm.prank(bob);
        ourToken.approve(alice, 456 ether);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    */
}
