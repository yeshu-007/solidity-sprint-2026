// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address owner;
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
        owner = msg.sender;
    }

    function mint(address _to, uint256 amount) external {
        require(msg.sender == owner, "Only the owner can mint tokens");
        _mint(_to, amount);
    }
}