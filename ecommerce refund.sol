// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract EcommerceRefund {

    address public owner ;
    address payable public vendor;
    uint256 public refundPeriod;

    struct Payment {
        uint256 amount;
        uint256 timestamp;
        bool refunded;
    }
    
    mapping(address => Payment) public payments;

    modifier onlyOwner(){
        require(msg.sender == owner,"Only owner can call this function");
        _;
    }

    modifier onlyVendor(){
        require(msg.sender == vendor, "Only Vendor can call this function");
        _;
    }

    constructor(address payable _vendor, uint256 _refundPeriod) {
        owner = msg.sender;
        vendor = _vendor;
        refundPeriod = _refundPeriod;

    }

    function createPayment() external payable {
        require(msg.value > 0, "Amount should be greater than 0");
        require(payments[msg.sender].amount == 0, "Payment already exists");

        payments[msg.sender] = Payment({
            amount: msg.value,
            timestamp: block.timestamp,
            refunded: false
        });

    } 

    function requestRefund() external {
        Payment storage payment = payments[msg.sender];
        require(payment.amount > 0, "Payment not found");
        require(!payment.refunded, "Payment already refunded");
        require(block.timestamp <= payment.timestamp + refundPeriod, "Refund period is expired");
        
        payment.refunded = true;
        payable(msg.sender).transfer(payment.amount);
    }

    function transferToVendor(address _customer) external onlyVendor{
        Payment storage payment = payments[_customer];
        require(payment.amount >0 ,"Payment not found");
        require(!payment.refunded, "Payment already refunded");
        require(block.timestamp <= payment.timestamp + refundPeriod, "Refund period is expired");
        payment.refunded = true;
        vendor.transfer(payment.amount);
     }
    
    function withdraw() external onlyOwner{
    payable(owner).transfer(address(this).balance);
    
    }

    receive() external payable { }
}