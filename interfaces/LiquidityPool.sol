pragma solidity ^0.6.2;
import "../oz/token/ERC20/IERC20.sol";

interface LiquidityPool {
    function token() external view returns(IERC20);
    function totalBalance() external view returns (uint amount);
    
    function lock(uint amount) external;
    function unlock(uint amount) external;
    function send(address account, uint amount) external;
}
