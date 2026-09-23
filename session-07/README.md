# Session 07

Create and deploy an ERC-20 token using OpenZeppelin, Hardhat, TypeScript tests, and Hardhat Ignition.

**Name:** Yeshwanth R

**Enrolment ID:** AU24UG-028

**Date submitted:** 23/09/2026

## Contract

- `hardhat-my-token/contracts/My_Token.sol`

## 1. What this contract does

This project creates a fungible ERC-20 token called `MyToken` with the symbol `MTK`. The constructor mints an initial supply to the account that deploys the contract. The deploying account is stored as the owner, and only that owner can mint additional tokens to a specified address.

The project uses Hardhat 3 with ethers.js for contract interaction, Mocha and Chai for TypeScript tests, and Hardhat Ignition for deployment.

## 2. Design decisions

I inherited from OpenZeppelin's `ERC20` implementation instead of writing the token standard from scratch. This provides the standard balance, transfer, allowance, and supply functionality while keeping the custom contract focused on the token name, symbol, initial supply, and minting permission.

The constructor mints `initialSupply` to `msg.sender`, because the deploying account should receive the starting balance. It also stores the deployer in `owner`. The `mint()` function checks that the caller is the owner before creating new tokens.

Token amounts use the token's smallest unit. Since OpenZeppelin's default is 18 decimals, the tests use `ethers.parseUnits("1000", 18)` for an initial supply of 1,000 displayed tokens.

## 3. Deployment

- Network: Sepolia
- Contract address: `0x3eeA1283Ae69c00e26cbAA224874eCEA999Ab648`
- Deployment module: `ignition/modules/My_Token.ts`

The Sepolia deployment uses the `SEPOLIA_RPC_URL` and `SEPOLIA_PRIVATE_KEY` configuration variables. These values should be supplied through the Hardhat keystore or environment configuration and should not be committed to the repository.

## 4. How to test it

From the `session-07/hardhat-my-token` directory:

1. Run `npx hardhat test` → all TypeScript tests should pass
2. Deploy `MyToken` with an initial supply of `1000 * 10^18`
3. `name()` → returns `MyToken`
4. `symbol()` → returns `MTK`
5. `decimals()` → returns `18`
6. `balanceOf(deployer)` → returns the complete initial supply
7. Call `transfer(accountA, amount)` from the deployer → succeeds and increases account A's balance
8. Attempt a transfer from an account with insufficient balance → reverts
9. Call `mint(accountA, amount)` from the owner account → succeeds and increases the total supply
10. Call `mint(accountB, amount)` from a non-owner account → reverts with `Only the owner can mint tokens`

To deploy with Hardhat Ignition to Sepolia:

```shell
npx hardhat ignition deploy ignition/modules/My_Token.ts --network sepolia
```

## 5. What I found difficult

Understanding how Hardhat 3 connects Solidity contracts with TypeScript tests was the main challenge. I also had to understand the difference between displayed token amounts and their smallest internal units, how ethers.js represents those values, and how configuration variables are used for a Sepolia deployment.

## 6. Acknowledgements

Used Claude (Anthropic) and documentation to understand ERC-20 tokens, OpenZeppelin inheritance, Hardhat 3, ethers.js, TypeScript testing, Hardhat Ignition, and Sepolia deployment. Wrote and tested the final contract myself.
