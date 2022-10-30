pragma solidity 0.8.13;
// SPDX-License-Identifier: UNLICENSED.

import "openzeppelin-contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {

    struct Payment {
        uint256 amount;
        address to;
    }

    mapping(address => Payment[]) payments;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;

    event TotalSupplyChanged(uint256 newSupply);
    event TokenTransfer(uint256 amount, address from, address to);

    constructor() {
        totalSupply = 10000;
        balances[owner()] = totalSupply;
    }

    function increaseSupply() onlyOwner() public {
        totalSupply += 1000;
    }

    // We can get the sender address from msg.sender, having a variable 'from' where 
    // you can pass the address from we want to withdraw tokens would allow the users to withdraw from other users,
    // unless we have extra checks in place.
    function transfer(uint256 amount, address to) public {
        require(balances[msg.sender] >= amount, "user has not enough tokens");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        recordPayment(msg.sender, to, amount);

        emit TokenTransfer(amount, msg.sender, to);
    }

    function getPaymentsFrom(address from) public view returns(Payment[] memory) {
        return payments[from];
    }

    function recordPayment(address from, address to, uint256 amount) internal {
        Payment memory newPayment = Payment(amount, to);

        Payment[] storage senderPayments = payments[from];
        senderPayments.push(newPayment);
    }
}