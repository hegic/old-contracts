pragma solidity ^0.6.2;

import "./interfaces/Uniswap.sol";
import "./interfaces/LiquidityPool.sol";
import "./interfaces/PriceProvider.sol";
import "./oz/token/ERC20/IERC20.sol";
import "./oz/ownership/Ownable.sol";
import "./oz/token/ERC20/ERC20.sol";
import "./Pool.sol";

struct Hedge {
    BasicHedgeContract.State state;
    address holder;
    uint strike;
    uint amount;
    uint expiration;
}

contract BasicHedgeContract is Ownable {
    enum State{ Undefined, Active, Released }
    
    Hedge[] public hedges;
    uint nextHedgeID;
    uint priceDecimals = 1e8;
    
    LiquidityPool public pool;
    PriceProvider public priceProvider;
    IUniswapFactory public exchanges;
    
    event HedgeCreated(address indexed account, uint id);
    
    constructor(LiquidityPool lp, PriceProvider pp, IUniswapFactory ex) public {
        pool = lp;
        priceProvider = pp;
        exchanges = ex;
    }
    
    function createHedge(uint period, uint amount) public payable returns (uint hedgeID) {
        require(period <= 8 weeks,"Period is too large");
        (uint strike, uint premium, uint fee) = fees(period, amount);
        require(msg.value >= fee + premium, "Value is too low");
        if(msg.value > fee + premium)
            msg.sender.transfer(msg.value - fee - premium);
        
        exchanges.getExchange(pool.token())
            .ethToTokenTransferInput.value(premium)(1, now + 1 minutes, address(pool));
        
        payable( owner() ).transfer(fee);
        
        pool.lock(strike);
        hedgeID = hedges.length;
        hedges.push(
            Hedge(State.Active, msg.sender, strike, amount, now + period)
        );
        emit HedgeCreated(msg.sender, hedgeID);
    }
    
    function release(uint hedgeID) public payable {
        Hedge storage hedge = hedges[hedgeID];
        require(hedge.expiration >= now, 'Hedge has expired');
        require(hedge.holder == msg.sender);
        require(hedge.state == State.Active);
        require(hedge.amount == msg.value);
        
        exchanges.getExchange(pool.token())
            .ethToTokenTransferInput.value(msg.value)(1, now + 1 minutes, address(pool));
            
        pool.send(hedge.holder, hedge.strike);
        
        hedge.state = State.Released;
    }
    
    function fees(uint period, uint amount) public view returns (uint strike, uint premium, uint fee) {
        uint price = priceProvider.currentAnswer();
        strike = amount * price / priceDecimals;
        premium = amount * period / 7 days * 2/100; // 2% weekly
        fee = amount / 100; // 1%
    }
    
    function unlock(uint hedgeID) public {
        Hedge storage hedge = hedges[hedgeID];
        require(hedge.expiration < now);
        require(hedge.state == State.Active);
        pool.unlock(hedge.strike);
        hedge.state = State.Released;
    }    
}

contract HedgeContract is BasicHedgeContract {
    constructor(IERC20 token, PriceProvider pp, IUniswapFactory ex) BasicHedgeContract(new Pool(token), pp, ex) public {}
}