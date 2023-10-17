// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ComplexSmartContract {
    address public owner;
    mapping(address => uint) public balances;
    uint public totalBalance;
    uint public maxDepositLimit = 9999;
    uint public maxWithdrawLimit = 5000;

    event DepositMade(address indexed account, uint amount);
    event WithdrawalMade(address indexed account, uint amount);
    event DepositLimitChanged(uint newLimit);
    event WithdrawalLimitChanged(uint newLimit);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit value must be greater than zero");
        require(msg.value <= maxDepositLimit, "Deposit amount exceeds maximum limit");

        assert(totalBalance + msg.value >= totalBalance);

        totalBalance += msg.value;
        balances[msg.sender] += msg.value;

        emit DepositMade(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(amount > 0 && amount <= balances[msg.sender], "Invalid withdrawal amount");
        require(amount <= maxWithdrawLimit, "Withdrawal amount exceeds maximum limit");

        assert(balances[msg.sender] - amount >= 0);

        balances[msg.sender] -= amount;
        totalBalance -= amount;
        payable(msg.sender).transfer(amount);

        emit WithdrawalMade(msg.sender, amount);
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function getTotalBalance() public view returns (uint) {
        return totalBalance;
    }

    function setDepositLimit(uint newLimit) public onlyOwner {
        maxDepositLimit = newLimit;
        emit DepositLimitChanged(newLimit);
    }

    function setWithdrawalLimit(uint newLimit) public onlyOwner {
        maxWithdrawLimit = newLimit;
        emit WithdrawalLimitChanged(newLimit);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
