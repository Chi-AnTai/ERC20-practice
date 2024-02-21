// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";     
// import "forge-std/console.sol";       // use like hardhat console.log
import "../src/TestERC20.sol";

contract ContractTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    TestERC20 token;

    address alice = vm.addr(0x1);
    address bob = vm.addr(0x2);

    // hardhat beforeEach -> setUp
    function setUp() public {
        token = new TestERC20("AppWorks School","AWS");
    }

    function testName() external {
        assertEq("AppWorks School",token.name());
    }

    function testSymbol() external {
        assertEq("AWS", token.symbol());
    }

    function testMint() public {
        token.mint(alice, 2e18);
        assertEq(token.totalSupply(), token.balanceOf(alice));
    }

    function testBurn() public {
        token.mint(alice, 10e18);
        assertEq(token.balanceOf(alice),10e18);
        
        token.burn(alice, 8e18);

        assertEq(token.totalSupply(), 2e18);
        assertEq(token.balanceOf(alice),2e18);
    }

    function testApprove() public {
        assertTrue(token.approve(alice, 1e18));
        assertEq(token.allowance(address(this),alice), 1e18);
    }

    function testTransfer() external {
        testMint();
        vm.prank(alice);
        token.transfer(bob, 0.5e18);
        assertEq(token.balanceOf(bob), 0.5e18);
        assertEq(token.balanceOf(alice), 1.5e18);
    }

    function testTransferFrom() external {
        testMint();
        vm.prank(alice);
        token.approve(address(this), 1e18);
        assertTrue(token.transferFrom(alice, bob, 0.7e18));
        assertEq(token.allowance(alice, address(this)), 1e18 - 0.7e18);
        assertEq(token.balanceOf(alice), 2e18 - 0.7e18);
        assertEq(token.balanceOf(bob), 0.7e18);
    }

    function testFailMintToZero() external {
        token.mint(address(0), 1e18);
    }

    function testFailBurnFromZero() external {
        token.burn(address(0) , 1e18);
    }

    function testFailBurnInsufficientBalance() external {
        testMint();
        vm.prank(alice);
        token.burn(alice, 3e18);
    }

    function testFailApproveToZeroAddress() external {
        token.approve(address(0), 1e18);
    }

    function testFailApproveFromZeroAddress() external {
        vm.prank(address(0));
        token.approve(alice, 1e18);
    }

    function testFailTransferToZeroAddress() external {
        testMint();
        vm.prank(alice);
        token.transfer(address(0), 1e18);
    }

    function testFailTransferFromZeroAddress() external {
        testBurn();
        vm.prank(address(0));
        token.transfer(alice , 1e18);
    }

    function testFailTransferInsufficientBalance() external {
        testMint();
        vm.prank(alice);
        token.transfer(bob , 3e18);
    }

    function testFailTransferFromInsufficientApprove() external {
        testMint();
        vm.prank(alice);
        token.approve(address(this), 1e18);
        token.transferFrom(alice, bob, 2e18);
    }

    function testFailTransferFromInsufficientBalance() external {
        testMint();
        vm.prank(alice);
        token.approve(address(this), type(uint).max);

        token.transferFrom(alice, bob, 3e18);
    }

    // events

    // function testMintEvent() public {
    //     vm.expectEmit(true, true, true, true);
    //     emit Transfer(address(0), alice, 2e18);
    //     token.mint(alice, 2e18);
    //     assertEq(token.totalSupply(), token.balanceOf(alice));
    // } 

    // function testBurnEvent() public {
    //     token.mint(alice, 10e18);
    //     assertEq(token.balanceOf(alice),10e18);
        
    //     vm.expectEmit(true, true, true, true);
    //     emit Transfer(alice, address(0), 8e18);
    //     token.burn(alice, 8e18);

    //     assertEq(token.totalSupply(), 2e18);
    //     assertEq(token.balanceOf(alice),2e18);
    // }

    // function testTransferEvent() external {
    //     testMint();
    //     vm.prank(alice);
    //     vm.expectEmit(true, true, true, true);
    //     emit Transfer(alice, bob, 0.5e18);
    //     token.transfer(bob, 0.5e18);
    //     assertEq(token.balanceOf(bob), 0.5e18);
    //     assertEq(token.balanceOf(alice), 1.5e18);
    // }
}   