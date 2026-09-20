# Session 04

**Name:** Yeshwanth R

**Enrolment ID:** AU24UG-028

**Date submitted:** 20/09/2026

## 1. What this contract does

This contract is a simple Ether vault that lets any address deposit and withdraw Ether, while tracking each depositor's balance separately from the contract's total pooled funds. It rejects zero-value deposits and emits events for both deposits and withdrawals so off-chain apps can track activity.

## 2. Design decisions

I used `call` instead of `transfer` or `send` to move Ether out, since `call` forwards all available gas and is the currently preferred method — but this means I had to manually check its return value with `require(success, ...)`, since `call` doesn't automatically revert on failure like `transfer` does.

The most important decision was ordering inside `withdraw()`: I clear `balances[recepient] = 0` _before_ making the external `call`, following the Checks-Effects-Interactions pattern. I considered the more "natural-looking" order — send first, then clear the balance — but rejected it, since that's exactly the reentrancy vulnerability covered in the session: a malicious contract's `receive()` function could call `withdraw()` again before the balance was cleared, draining the vault repeatedly on one transaction.

I kept `balances` as a separate mapping rather than relying only on `address(this).balance`, since the contract balance is a shared pool across all depositors — I need a per-address record to know how much each individual is owed.

## 3. Deployment

- Network: Remix VM
- Contract address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
- Transaction hash: 0x1b3b4ec8603e2e35e9363549d9568e6a9aef0a3c8b37a1986c3d99122e18dc36
- Block explorer link: N/A (Remix VM is a local simulated chain, not viewable on a public explorer)

## 4. How to test it

1. `deposit()` with 0 ETH from Account A → reverts with "Zero Amount"
2. `deposit()` with 1 ETH from Account A → succeeds, `Deposited` event logged
3. `getBalance()` from Account A → returns 1 ETH (in wei)
4. `deposit()` with 2 ETH from Account B → succeeds
5. `getContractBalance()` → returns 3 ETH (combined pool)
6. `withdraw()` from Account A → succeeds, `Withdrawn` event logged, A's wallet balance increases by 1 ETH
7. `getBalance()` from Account A → returns 0
8. `withdraw()` again from Account A → reverts with "Nothing to Withdraw"
9. `withdraw()` from Account B → succeeds, B receives 2 ETH
10. `getContractBalance()` → returns 0

## 5. What I found difficult

Understanding exactly why the order of balance-clearing vs sending Ether matters, since both versions look almost identical" and faced a 'TxRunner internal runner not initialized' Remix error similar to previous session's runtime error that had nothing to do with my code — took a browser refresh to fix it.

## 6. Acknowledgements

Used Claude (Anthropic) to understand Solidity concepts (payable functions, msg.value, the call method, reentrancy, and the Checks-Effects-Interactions pattern) and to debug a Remix deployment error. Wrote and tested the final contract myself in Remix.
