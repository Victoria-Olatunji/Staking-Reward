// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract staking is ERC20 {
    mapping(address => uint) public staked;
    mapping(address => uint) private stakedFromTS;

    constructor() ERC20("VikJ Token", "VKJ") {
        _mint(msg.sender, 10**18);
    }

    function stake(uint amount) public {
        require(amount > 0, "amount <= 0");
        require(balanceOf(msg.sender) >= amount, "You do not have up to that amount");
        _transfer(msg.sender, address(this), amount);
        /*function transfer(address payable _to) public payable {
        _to.transfer(msg.value);
        }*/
        if(staked[msg.sender] > 0) {
            claim();
        }
 
        stakedFromTS[msg.sender] = block.timestamp;
        staked[msg.sender] = staked[msg.sender] + amount;
    }
 
    function unstake(uint amount) public {
        require(amount >0, "amount <=0");
        require(staked[msg.sender] > 0, "You did not stake with us");
        _transfer(address(this), msg.sender, amount);
        stakedFromTS[msg.sender] = block.timestamp;
        staked[msg.sender] = staked[msg.sender] - amount;
    }

    function claim() public {
        require(staked[msg.sender] > 0, "staked is <= 0");
        uint secondsStaked = block.timestamp - stakedFromTS[msg.sender];
        uint rewards = staked[msg.sender] * secondsStaked/3.154e7;
        _mint(msg.sender, rewards);
        stakedFromTS[msg.sender] = block.timestamp;
    }  
}