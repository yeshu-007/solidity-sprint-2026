# Session 06

Create an ERC-721 NFT collection using OpenZeppelin with token URI storage and owner-only minting.

**Name:** Yeshwanth R

**Enrolment ID:** AU24UG-028

**Date submitted:** 22/09/2026

## Contract

- `NFT_Contract.sol`

## 1. What this contract does

This contract creates an ERC-721 NFT collection called `RY Collection` with the symbol `RYC`. The contract owner can mint NFTs to the owner's wallet by supplying a token URI, which can point to metadata describing the NFT. Each newly minted NFT receives the next sequential token ID, and `totalMinted()` reports the current number of minted tokens.

## 2. Design decisions

I inherited from OpenZeppelin's `ERC721URIStorage` so the contract can use the standard ERC-721 ownership and transfer behavior while also storing a separate metadata URI for each token. I also inherited from `Ownable` to use its established owner tracking and `onlyOwner` access-control modifier.

The constructor passes `msg.sender` to `Ownable`, making the deploying account the initial owner. The `mint()` function uses `onlyOwner` and mints to `msg.sender`, so only the collection owner can create NFTs and the newly minted NFT is assigned to that owner.

I increment `tokenId` before calling `_safeMint()`, so the first NFT has ID 1 and every later NFT receives a unique sequential ID. `_safeMint()` is used instead of `_mint()` because it checks that a contract recipient can receive ERC-721 tokens safely.

## 3. Deployment

- Network: Metamask
- Contract address: 0xA38ABbF25C8B12D3cFAaD99Ffd7d51d3F6566199

## 4. How to test it

1. Deploy `RYNFT` → the deploying account becomes the owner
2. `name()` → returns `RY Collection`
3. `symbol()` → returns `RYC`
4. `totalMinted()` → returns `0`
5. Call `mint("ipfs://example-metadata-1")` from the owner account → succeeds and returns token ID `1`
6. `ownerOf(1)` → returns the owner's address
7. `tokenURI(1)` → returns `ipfs://example-metadata-1`
8. Call `mint("ipfs://example-metadata-2")` again from the owner → creates token ID `2`
9. `totalMinted()` → returns `2`
10. Call `mint(...)` from a non-owner account → reverts because of `onlyOwner`

## 5. What I found difficult

Understanding how ERC-721 ownership differs from fungible ERC-20 balances was the main challenge. I also had to understand why `ERC721URIStorage` is needed for per-token metadata and why the OpenZeppelin `Ownable` constructor must receive the deployer's address in the current version.

## 6. Acknowledgements

Used Claude (Anthropic) to understand ERC-721 tokens, token metadata URIs, OpenZeppelin extensions, safe minting, and ownership-based access control. Wrote and tested the final contract myself.
