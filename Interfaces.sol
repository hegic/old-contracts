pragma solidity ^0.6.2;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0-beta.0/contracts/token/ERC20/IERC20.sol";

interface  IUniswapFactory {
    function getExchange(IERC20 token)  external view returns (IUniswapExchange exchange);
}

interface IUniswapExchange {
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
}

interface IPriceProvider {
    function currentAnswer() external view returns (uint);
}

interface ILiquidityPool {
    function token() external view returns(IERC20);
    function totalBalance() external view returns (uint amount);    
    function lock(uint amount) external;
    function unlock(uint amount) external;
    function send(address account, uint amount) external;
}
