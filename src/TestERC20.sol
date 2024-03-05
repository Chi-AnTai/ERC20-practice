// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract TestERC20 {
    string public tokenName;
    string public tokenSymbol;
    uint256 public _totalSupply;
    // address => A 允許
    // address => B
    // uint256 => 動用的錢
    mapping(address => mapping(address => uint256)) public _allowance;
    mapping(address => uint256) public _balance;

    constructor(string memory _name, string memory _symbol) {
        tokenName = _name;
        tokenSymbol = _symbol;
    }

    function mint(address to, uint256 amount) public {
        require(to != address(0));
        _balance[to] += amount;
        _totalSupply += amount;
    }

    function burn(address from, uint256 amount) public {
        require(from != address(0));
        _balance[from] -= amount;
        _totalSupply -= amount;
    }

    function name() public returns (string memory) {
        return tokenName;
    }

    function symbol() public returns (string memory) {
        return tokenSymbol;
    }

    function totalSupply() external view returns (uint256) {
      return _totalSupply;
    }

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256) {
      return _balance[account];
    }

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool) {
        require(_balance[msg.sender] >= value);
        require(to != address(0));
        _balance[msg.sender] -= value;
        _balance[to] += value;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool) {
        require(spender != address(0));
        require(msg.sender != address(0));
        _allowance[msg.sender][spender] = value;
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(_allowance[from][msg.sender] >= value);
        require(_balance[from] >= value);
        _allowance[from][msg.sender] -= value;
        _balance[from] -= value;
        _balance[to] += value;
        return true;
    }
}
