// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenizedEarningsPodcast {
    // Token details
    string public name = "Podcast Earnings Token";
    string public symbol = "PDT";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    // Mapping for balances
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events for transactions
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event EarningsReceived(address indexed creator, uint256 value);

    // Contract owner (this can be the creator or admin)
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    // Constructor with a default value
    constructor() {
        uint256 _initialSupply = 1000000; // 1 million tokens as default
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
        
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // Transfer function to send tokens
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balances[msg.sender] >= _value, "Insufficient balance");
        require(_value > 0, "Transfer amount must be greater than zero");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Approve function for delegated transfers
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "Invalid spender address");
        
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Transfer from function for delegated transfers
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0), "Invalid from address");
        require(_to != address(0), "Invalid to address");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(_value > 0, "Transfer amount must be greater than zero");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // Function to receive earnings for a podcast (tokenizing earnings)
    function receiveEarnings(address _creator, uint256 _amount) public onlyOwner returns (bool success) {
        require(_creator != address(0), "Invalid creator address");
        require(_amount > 0, "Amount should be greater than 0");

        balances[_creator] += _amount;
        totalSupply += _amount;
        
        emit Transfer(address(0), _creator, _amount);
        emit EarningsReceived(_creator, _amount);
        return true;
    }

    // Function to check token balance
    function balanceOf(address _account) public view returns (uint256) {
        return balances[_account];
    }
}