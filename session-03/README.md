# Session 03

Make the student registry contract better with access controls, events and interface.

**Name:** Yeshwanth R

**Enrolment ID:** AU24UG-028

**Date submitted:** 18/09/2026

## Contract

- `contracts/StudentRegistry_v2.sol`

## 1. What this contract does

This contract extends the Session 2 student registry by adding events, access control, and an interface. Only the contract owner can register students, every state change (registration and status update) emits an event for off-chain tracking, and the read functionality is exposed through a separate interface so other contracts can interact with it without knowing its internal code.

## 2. Design decisions

I added a hand-written `onlyOwner` modifier instead of using OpenZeppelin's `Ownable`, since the task only asked for a modifier restricting registration and the base contract from Session 2 didn't already import OpenZeppelin — this kept the change minimal rather than pulling in a new dependency.

I used `indexed` on the `student` address in both events, since that's the field most likely to be filtered/searched by an off-chain app (e.g. "show all events for this address"), matching the pattern from the session material.

I declared `IsStudentRegistry` as a separate `interface` rather than an `abstract contract`, since it only needed to expose a read function's signature with no shared logic to inherit — an interface is the stricter, more appropriate fit here.

## 3. Deployment

- Network: Remix VM
- Contract address: 0xd9145CCE52D386f254917e481eB44e9943F39138
- Transaction hash: 0xef28bf733d51bce20a822c607d051e9c6b3adb473500510ba75c7f4c0fd10d14
- Block hash: 0x4653abbe634aac2bfdd9e54d9e985e2852a141057af49a78f453907242207103

## 4. How to test it

1. `owner()` → returns the deploying account's address
2. `registerStudent("Yeshwanth", 1)` from the owner account → succeeds, `StudentRegistered` event logged
3. `registerStudent("Anurag", 102)` from a non-owner account → reverts with "Not the owner"
4. `getStudent(owner address)` → returns `("Yeshwanth", 1, 0)`
5. `registerStudent(...)` again from the owner → reverts with "Student already registered"
6. `getStudent(non-owner address)` → reverts with "Student not registered"
7. `updateStatus(2)` from the owner → succeeds, `StatusUpdated` event logged
8. `getStudent(owner address)` → returns `("Yeshwanth", 1, 2)`

## 5. What I found difficult

Understanding why the interface needed both `is IsStudentRegistry` and `override` on the function to actually compile against it and had a hard time figuring out how to debug 'Cannot read properties of undefined' deploy error that turned out to be a Remix environment glitch, not a code issue.

## 6. Acknowledgements

Used Claude (Anthropic) to understand Solidity concepts (events, modifiers, interfaces, access control) and to debug a Remix deployment error. Wrote and tested the final contract myself in Remix.
