---
title: Asset and Token Standards (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Indexers must recognize each standard to surface fungible, non-fungible, and composite balances correctly.
tags: indexing, erc-20, erc-721, erc-1155, erc-4626, eip-2612, eip-165, token, nft, ethereum
---

# Asset Standards (Ethereum Indexing Lens)

## Concept

Asset indexing requires knowing which standard a contract implements: the standard dictates event semantics, balance computation rules, metadata location, and transfer mechanics. Standards also layer (EIP-2612 Permit atop ERC-20, ERC-4626 vaults atop ERC-20) -- indexers must detect and compose them.

## Ethereum

- **ERC-20** -- `Transfer(address from, address to, uint256 value)`, `Approval(...)`. Balances derivable from Transfer history. Decimals set at contract deployment.
- **ERC-721** -- `Transfer(address from, address to, uint256 tokenId)` with indexed `tokenId`. `tokenURI(uint256)` returns metadata URI.
- **ERC-1155** -- `TransferSingle`, `TransferBatch`, `ApprovalForAll`. Multi-token per contract; useful for game assets.
- **ERC-4626** -- vault standard atop ERC-20. Adds `Deposit`, `Withdraw` events and pps / pricePerShare conventions.
- **EIP-2612 Permit** -- ERC-20 extension. Indexers do not need to track Permit separately for balance computation; it just replaces `approve` + `transferFrom`.
- **EIP-165** -- interface detection via `supportsInterface(bytes4)`. The preferred way to detect ERC-721 / ERC-1155 vs ERC-20.

Native ETH is not a token. Track it via account state diffs, transaction value, and protocol-level transfers (see `idx-protocol-transfers.md`).

Relevant code:

- `<RESEARCH_ROOT>/EIPs/EIPS/eip-20.md`, `eip-721.md`, `eip-1155.md`, `eip-4626.md`, `eip-2612.md`, `eip-165.md` -- spec text.
- OpenZeppelin contracts are the off-repo reference implementations.

## Indexer Design Implications

- Detect standards via EIP-165 where possible rather than inferring from event shape alone.
- Track decimals per token (required for display; set at mint time).
- For NFTs, cache metadata JSON separately; plan for unreachable URIs and mutable metadata (owners can return different JSON later).
- Reconcile mint / burn events against total supply to catch gaps.
- For ERC-4626, record the underlying asset and the share token separately; pps derivation is common downstream.
- Native ETH requires protocol-level tracking; do not treat it as just another ERC-20.

## References

- ERC-20: https://eips.ethereum.org/EIPS/eip-20
- ERC-721: https://eips.ethereum.org/EIPS/eip-721
- ERC-1155: https://eips.ethereum.org/EIPS/eip-1155
- ERC-4626: https://eips.ethereum.org/EIPS/eip-4626
- EIP-2612 Permit: https://eips.ethereum.org/EIPS/eip-2612
- EIP-165 interface detection: https://eips.ethereum.org/EIPS/eip-165
- Related: `idx-event-decoding.md`, `idx-protocol-transfers.md`
