# Providing Liquidity on Hegic - Tutorial

## Information about Writing Put Options

Writing (selling) a Put Hedge Contract consists of providing Dai to the `writeDai` liquidity pool contract. The incentive for writers to
provide liquidity is to earn the premiums paid by buyers of Hegic put options. The rates paid by put option buyers (and thus earned by option writers) depends on the hedge contract period and strike price, which are selected by each individual buyer. 

On a deposit of DAI to the liquity pool, the writer receives writeDAI (ERC20) tokens in return. When the writer wishes to receive their DAI back, they can send writeDAI tokens to the liquidity pool contract and use the `burn` function. DAI will be automatically sent to the writer’s ETH-address.

Example: for a put hedge contract of 1 ETH with a period of 2 weeks, the buyer chooses a $200 strike price (at-the-money; market price of ETH is $200). The price of such a put hedge contract is $10. In this example, the buyer chooses to pay $10 in ETH and sends a **0.05 ETH premium** to activate the hedge contract. The premium will be automatically swapped to DAI using Uniswap. The premium in DAI will be added to the liquidity pool after the successful swap. Liquidity providers receive this premium in advance so that they can withdraw it at any given moment. 

Once the premium is received, the liquidity in DAI will be locked for a period of a hedge contract that the put option buyer has paid for. Some portion of the liquidity will always be unlocked to let the liquidity providers claim the DAI that they have provided to the liquidity pool. Initial implementations of Hegic will allow 80% of the total amount of DAI in the pool to be locked in active hedge contracts. The other 20% are always unlocked and can be used by those who would like to withdraw the liquidity from the pool. 

If the amount of unlocked DAI in the liquidity pool is not enough for the writer to swap their writeDAI to DAI, they will have to wait for the active hedge contracts’ expiration. If the writer wishes to withdraw the liquidity from the pool, but the amount of unlocked DAI is not enough, they send a request to swap their writeDAI to DAI as soon as the liquidity will be unlocked. Their requests are aggregated in queues. 

Both returns (premiums paid by option buyers) and potential losses (profit made by put option buyers) are denominated in DAI and split pro rata between liquidity providers, based on the proportions of DAI that they have allocated in the liquidity pool. 

## How to provide liquidity to the writeDAI contract

### Step 1: Approve an amount of DAI on the DAI Token Contract

- Go to the [Dai Token Contract (writeContract) link](https://etherscan.io/token/0x6b175474e89094c44da98b954eedeac495271d0f#writeContract)
- click on "Connect to Web3"
- Under 'approve', enter the Hegic writeDai contract (0x009c216b7e86e5c38af14fcd8c07aab3a2e7888e) as the 'usr(address)' 
- Enter the amount of Dai you would live to approve under 'wad (uint256)'. For example, to approve 100 DAI:
```100 DAI + 000000000000000000 (18 zero's) -> 100000000000000000000```

![alt text](https://imgur.com/ap2qnbn.png) 

### Step 2: Prove an amount of DAI to the writeDAI liquidity pool contract

- Go to the [Hegic writeDAI Contract (writeContract) link](https://etherscan.io/token/0x009c216b7e86e5c38af14fcd8c07aab3a2e7888e#writeContract)
- Under 'provide', enter the amount of DAI you would like to provide to the liquidity pool. For example, to provide 100 DAI:
```100 DAI + 000000000000000000 (18 zero's) -> 100000000000000000000```

![alt text](https://imgur.com/ytoFTN4.png)

You will now receive writeDAI ERC20 in return for provided DAI. Starting from the next hedge contract that is activated by a put option buyer, you will start receiving portions of all premiums paid by hedge contract buyers. You can enable the writeDAI token address (0x009c216b7e86e5c38af14fcd8c07aab3a2e7888e) in Metamask in order to view your balance of writeDAI.

### Check the amount of DAI available for withdrawal (liquidity + premiums received) from the liqudiity pool

- Go to the [Hedic writeDAI Contract (readContract) link](https://etherscan.io/token/0x009c216b7e86e5c38af14fcd8c07aab3a2e7888e#readContract)
- Under 'shareOf', enter your ethereum address as the 'user (address)'

![shareOf](https://imgur.com/261PnQL.png)

(Share in picture is ~5112 DAI)

### Withdraw DAI from liquidity pool

- Go to the [Hegic writeDAI Contract (writeContract) link](https://etherscan.io/token/0x009c216b7e86e5c38af14fcd8c07aab3a2e7888e#writeContract)
- Under 'withdraw', enter the amount of DAI you would like to withdraw from the liquidity pool. For example, to withdraw 100 DAI:
```100 DAI + 000000000000000000 (18 zero's) -> 100000000000000000000```

After withdrawal, your writeDAI will be burned and DAI will be sent to your ethereum address

![withdraw](https://imgur.com/lXBv1Us.png)

