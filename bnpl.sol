// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BNPL {
    address public owner;

    struct Purchase {
        address buyer;
        uint256 amount;
        bool repaid;
    }

    mapping(uint256 => Purchase) public purchases;
    uint256 public purchaseCounter;

    constructor() {
        owner = msg.sender;
    }

    // Record a new BNPL purchase
    function createPurchase(address _buyer, uint256 _amount) external {
        require(msg.sender == owner, "Only owner can create a purchase");
        purchases[purchaseCounter] = Purchase(_buyer, _amount, false);
        purchaseCounter++;
    }

    // Repay the BNPL amount
    function repay(uint256 _purchaseId) external payable {
        Purchase storage p = purchases[_purchaseId];
        require(msg.sender == p.buyer, "Only buyer can repay");
        require(!p.repaid, "Already repaid");
        require(msg.value == p.amount, "Incorrect repayment amount");

        p.repaid = true;
        payable(owner).transfer(msg.value);
    }
}
