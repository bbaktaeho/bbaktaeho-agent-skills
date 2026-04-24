---
title: Asset and Token Standards (Tempo Indexing Lens)
impact: HIGH
impactDescription: TIP-20 defines Tempo's fungible token standard. EVM-compatible contracts may also implement ERC-20 / 721 / 1155 directly.
tags: indexing, tip-20, tip-403, erc-20, erc-721, erc-1155, token, nft, tempo
---

# Asset Standards (Tempo Indexing Lens)

## Concept

Asset indexing on Tempo follows EVM conventions with a Tempo-specific overlay. TIP-20 is the Tempo fungible token standard and is shape-compatible with ERC-20. Tempo also supports standard EVM NFT and multi-token standards by virtue of Reth execution compatibility. TIP-403 defines a policy registry that can gate transfers.

## Tempo

- **TIP-20** -- Tempo fungible token, shape-compatible with ERC-20. Integrates with Payment Lanes and Fee AMM accounting.
- **TIP-403** -- Policy registry used to enforce transfer policies (allow lists, rate limits, compliance gates) above the token contract layer.
- **ERC-20 / ERC-721 / ERC-1155** -- EVM-compatible contracts deployed on Tempo can implement these directly. Detection follows Ethereum patterns (EIP-165, event shape).

Native Tempo asset is not a token; track it via account state diffs and protocol-level transfers.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/contracts/` -- TIP-20 and TIP-403 reference contracts.
- Tempo docs describe the full TIP catalog.

## Indexer Design Implications

- Detect TIP-20 tokens alongside ERC-20 tokens; they share the same event signatures and the same balance derivation rules.
- For TIP-403 policy-gated transfers, record the policy decision alongside the transfer event; failed transfers under a policy have distinct semantics from plain reverts.
- Native Tempo asset requires protocol-level tracking (see `idx-protocol-transfers.md`).
- Use tidx's schema as a reference for canonical balance representation on Tempo -- it already distinguishes TIP-20 from ERC-20 where they differ.
- For NFTs, follow the Ethereum playbook (metadata caching, mutable URIs).
- Reconcile mint / burn events against total supply per token and compare with tidx to catch drift.

## References

- Tempo TIP catalog: https://docs.tempo.xyz
- ERC-20 (baseline): https://eips.ethereum.org/EIPS/eip-20
- ERC-721 (baseline): https://eips.ethereum.org/EIPS/eip-721
- ERC-1155 (baseline): https://eips.ethereum.org/EIPS/eip-1155
- Related: `idx-event-decoding.md`, `idx-protocol-transfers.md`
