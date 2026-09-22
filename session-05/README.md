# Session 05

Create an ERC-20 token using OpenZeppelin with an initial supply and owner-only minting.

**Name:** Yeshwanth R

**Enrolment ID:** AU24UG-028

**Date submitted:** 21/09/2026

## Contract

- `ERC20_Token.sol`

## 1. What this contract does

This contract creates a fungible ERC-20 token called `MyToken` with the symbol `MTK`. The constructor mints the initial supply to the account that deploys the contract. The deploying account is stored as the owner, and only that owner can mint additional tokens to a specified address.

## 2. Design decisions

I inherited from OpenZeppelin's `ERC20` implementation instead of writing the token standard from scratch. This provides the standard ERC-20 functions and accounting logic while keeping the custom contract focused on the token name, symbol, initial supply, and minting permission.

I mint the initial supply to `msg.sender`, because the deployer is the account creating the token and should receive the starting balance. I store the deployer in `owner` and check `msg.sender` in `mint()` so that other accounts cannot create tokens arbitrarily.

The `initialSupply` and `amount` values are passed directly to `_mint()`, so they use the token's smallest unit, as with standard ERC-20 tokens. OpenZeppelin's default decimal value is 18, meaning a displayed amount of 1 token is represented internally as `10^18` units.

## 3. Deployment

- Network: Metamask
- Contract address: 0xdb9B1e94B5b69Df7e401DDbedE43491141047dB3

## 4. How to test it

1. Deploy `MyToken` with an initial supply, for example `1000 * 10^18`
2. `name()` → returns `MyToken`
3. `symbol()` → returns `MTK`
4. `decimals()` → returns `18`
5. `totalSupply()` → returns the initial supply
6. `balanceOf(deployer)` → returns the complete initial supply
7. Call `mint(accountB, amount)` from the owner account → succeeds and increases the total supply
8. `balanceOf(accountB)` → returns the newly minted amount
9. Call `mint(accountB, amount)` from a non-owner account → reverts with `Only the owner can mint tokens`

## 5. What I found difficult

Understanding the difference between a token's displayed amount and its smallest internal units was the main challenge, especially when choosing the value for `initialSupply`. I also had to understand how inheriting from OpenZeppelin's `ERC20` provides the standard balance, transfer, allowance, and supply functionality automatically.

## 6. Acknowledgements

Used Claude (Anthropic) and docs to understand ERC-20 token standards, OpenZeppelin inheritance, token decimals, and access control for minting. Wrote and tested the final contract myself.
