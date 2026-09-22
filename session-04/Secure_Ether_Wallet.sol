// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Vault is ReentrancyGuard {
    mapping(address => uint256) balances;
    event Deposited(address userAddress, uint256 amount, uint256 depositedAt);
    event Withdrawn(address userAddress, uint256 amount, uint256 withdrawnAt);

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    function getBalance() external view returns (uint256) {
        return balances[msg.sender];
    }
    function deposit() external payable {
        require(msg.value > 0, "Zero Amount");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value, block.timestamp);
    }
    function withdraw() external nonReentrant {
        address recepient = msg.sender;
        uint256 amount = balances[recepient];
        require(amount > 0, "Nothing to Withdraw");
        balances[recepient] = 0;

        (bool success, ) = recepient.call{value: amount}("");
        require(success, "Transfer failed");
        emit Withdrawn(recepient, amount, block.timestamp);
    }
}