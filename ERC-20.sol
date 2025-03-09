// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable{
    constructor(uint256 initialSupply,address _owner)  Ownable(_owner) ERC20("Coin","C"){
        _mint(msg.sender, initialSupply);
    }

    // Mint new tokens (only owner can call this)
    function mint(address to, uint256 amount) public  {
        _mint(to, amount);
    }

    // Burn tokens from the caller's balance
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function getTotalSupply() public view returns (uint256) 
    {
        return totalSupply();  // OpenZeppelin ERC20 already has totalSupply()
    }

    // Transfer function (already available in ERC20)
    function transferTokens(address recipient, uint256 amount) public returns (bool) 
    {
        return transfer(recipient, amount);
    }
}
