// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MultiSend {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this function");
        _;
    }

    function multisend(address[] calldata recipients, uint256[] calldata amounts) external payable {
        require(recipients.length == amounts.length,"Recipients and amounts length mismatch");
        uint256 totalAmount = 0;
        
        for (uint256 i=0;i< amounts.length; i++){
            totalAmount += amounts[i];
        }
        require(msg.value == totalAmount,"Amount is not equal to total amount");

        for (uint i = 0; i < recipients.length; i++) 
        {
         payable(recipients[i]).transfer(amounts[i]);   
        }
    }

    receive() external payable { }

}
