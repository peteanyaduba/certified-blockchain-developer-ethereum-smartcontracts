/*SPDX-License-Identifier: GPL-3.0*/
pragma solidity >=0.4.0 < 0.9.0;

contract Money{
    uint money;

    function Deposit(uint _money) public {
        money = _money;
    }

    function Withdraw() public view returns(uint){
        return money * 2;
    }
}