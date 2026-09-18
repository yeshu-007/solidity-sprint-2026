# Session 01

Build a simple notice board contract.

**Name:** Yeshwanth R
**Enrolment ID:** AU24UG-028
**Date submitted:** 15/09/2026

## Contract

- `contracts/NoticeBoard.sol`

## 1. What this contract does

This contract stores a single message as text and keeps track of the address of whoever last changed it. Anyone can update the message, and the contract automatically records who made that update.

## 2. Design decisions

I used two separate state variables — `message` (a `string`) and `lastEditor` (an `address`) — instead of bundling them into a struct, since this is a single global record rather than a per-user one; a struct wasn't needed for just two related fields at this scale.

I made both variables `public` so Solidity auto-generates read functions for them, instead of writing my own `getMessage()`/`getLastEditor()` functions manually — less code, same result.

To record the last editor, I used the built-in `msg.sender` global inside `updateMessage()` rather than asking the caller to pass their own address as a parameter — this is safer, since a caller could otherwise pass a fake address.

## 3. Deployment

- Network: Remix VM
- Contract address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
- Transaction hash: 0x863dc65a4eacebdf9783c83559ae3a9f16fc7a343f641ae467be237420712a57
- Block explorer link: 0xfd71ccc01e165165ff268a538fef9bab1de99a4defbce7c9fe93a35314637289

## 4. How to test it

1. `message()` → returns `""` (empty, nothing stored yet)
2. `updateMessage("hello")` from Account A → succeeds
3. `message()` → returns `"hello"`
4. `lastEditor()` → returns Account A's address
5. `updateMessage("hi again")` from Account B → succeeds
6. `lastEditor()` → returns Account B's address (proves it updates per caller)

## 5. What I found difficult

Understanding why msg.sender is filled automatically by the network rather than passed as a parameter

## 6. Acknowledgements

Used Claude (Anthropic) to understand Solidity concepts (state variables, `public` getters, `msg.sender`) and to review the contract logic. Wrote and tested the final contract myself in Remix.
