// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is Ownable {
    // Token details
    string public name = "Coin";
    string public symbol = "C#";
    uint public totalSupply;
    uint public maxSupply; // Added maximum supply cap

    // Mapping to store balances
    mapping(address => uint) public balances;

    // Events for logging transactions
    event Mint(address indexed to, uint amount);
    event Burn(address indexed from, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

    // Constructor to set the maximum supply and owner
    constructor(uint _maxSupply) Ownable(msg.sender) {
        maxSupply = _maxSupply;
    }

    // Mint function (only owner can mint)
    function mint(address _to, uint _value) public onlyOwner {
        require(totalSupply + _value <= maxSupply, "Exceeds max supply");
        totalSupply += _value;
        balances[_to] += _value;
        emit Mint(_to, _value);
    }

    // Burn function (only sender can burn their tokens)
    function burn(uint _value) public {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        totalSupply -= _value;
        balances[msg.sender] -= _value;
        emit Burn(msg.sender, _value);
    }

    // Transfer function
    function transfer(address _to, uint _value) public {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid recipient address");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    // Function to check max supply
    function getMaxSupply() public view returns (uint) {
        return maxSupply;
    }

    function TotalSupply() public  view returns (uint) {
        return totalSupply;
    }
}
