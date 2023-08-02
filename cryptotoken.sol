// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoToken {
    string public token_name;
    string public token_symbol;
    uint8 public decimals;
    uint256 public totalSupplyoftoken;
    address public owner;
    bool public paused;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed to, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Pause();
    event Unpause();
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TransferFrom(address indexed from, address indexed to, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "this function can only be operated by owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "transferring of token is paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "transferring of token is not paused");
        _;
    }

    constructor(string memory _tokenname, string memory _token_symbol, uint8 _decimals, uint256 _initialSupply) {
        token_name =_tokenname ;
        token_symbol =_token_symbol;
        decimals = _decimals;
        totalSupplyoftoken = _initialSupply * (10**uint256(decimals));
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupplyoftoken;
        paused = false;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
        require(_to != address(0), " recipient address is invalid");
        require(_value > 0, "Value must be greater than 0");
        require(balanceOf[msg.sender] >= _value, " balance is insufficient");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function burn(uint256 _value) public whenNotPaused returns (bool success) {
        require(_value > 0, "Value must be greater than 0");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        totalSupplyoftoken -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }

    function mint(address _to, uint256 _value) public onlyOwner whenNotPaused returns (bool success) {
        require(_to != address(0), "recipient address is invalid");
        require(_value > 0, "Value must be greater than 0");

        balanceOf[_to] += _value;
        totalSupplyoftoken += _value;
        emit Mint(_to, _value);
        return true;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), " new owner address is invalid");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    function pauseTransfers() public onlyOwner whenNotPaused {
        paused = true;
        emit Pause();
    }

    function unpauseTransfers() public onlyOwner whenPaused {
        paused = false;
        emit Unpause();
    }

    function isPaused() public view returns (bool) {
        return paused;
    }

    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
        require(_spender != address(0), " spender address is invalid");

        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    

    function getBalance(address _user) public view returns (uint256) {
        return balanceOf[_user];
    }

    function getAllowance(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }
}
