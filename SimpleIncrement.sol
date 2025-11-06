// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleIncrement {
    uint256 public counter = 0;
    mapping(address => bool) public hasIncremented;
    
    function increment() public {
        if (!hasIncremented[msg.sender]) {
            hasIncremented[msg.sender] = true;
            counter++;
        }
    }
    
    function getCounter() public view returns (uint256) {
        return counter;
    }
}