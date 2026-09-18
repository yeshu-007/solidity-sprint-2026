# Session 02

Build a simple, minimal student registry contract.


**Name:** Yeshwanth R
**Enrolment ID:** AU24UG-028
**Date submitted:** 16/09/2026

## Contract

- `contracts/StudentRegistry.sol`

## 1. What this contract does

This contract lets a wallet register itself as a student by storing a name, enrolment ID, and status. Once registered, the wallet can update its own status (Active, Inactive, Graduated) and anyone can look up a student's record by address.

## 2. Design decisions

I used a `struct` to bundle name, enrolment ID, and status together since they always belong to one student. I used `enum Status` instead of a plain `uint` for status so invalid values (like `5`) can't be stored — Solidity restricts it to the three defined states.

For lookups I used `mapping(address => Student)` so each wallet maps directly to its own record — no need to loop through a list to find a student.

I added a second mapping, `isRegistered`, purely to check for duplicates. I considered checking `students[x].enrolmentId == 0` instead, but rejected it — `0` could be a real enrolment ID, so that check would incorrectly treat a real student as "not registered." A separate `bool` mapping avoids that ambiguity.

## 3. Deployment

- Network: Remix VM
- Contract address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
- Transaction hash: 0x01a7fbade8d3224458da3af4664195f65e418186834cd6fca9275d609f103d62
- Block explorer link: 0x87fc16fda5ede888ef1917db522318d9514347f83c079a162de4ac7286177ad6

## 4. How to test it

1. `registerStudent("Yeshwanth", 1)` from Account A → succeeds
2. `registerStudent("Yeshwanth", 1)` from Account A again → reverts with "Student already registered"
3. `getStudent(Account A address)` → returns `("Yeshwanth", 1, 0)`
4. `getStudent(Account B address)` (never registered) → reverts with "Student not registered"
5. `updateStatus(2)` from Account A → succeeds
6. `getStudent(Account A address)` → returns `("Yeshwanth", 1, 2)`

## 5. What I found difficult

Understanding when to use storage vs memory took a few tries
The access control and update changes were not secure and had inconsistencies

## 6. Acknowledgements

Used Claude (Anthropic) to understand Solidity concepts (structs, enums, mappings, storage vs memory) and to review/explain the contract logic. Wrote and tested the final contract myself in Remix.