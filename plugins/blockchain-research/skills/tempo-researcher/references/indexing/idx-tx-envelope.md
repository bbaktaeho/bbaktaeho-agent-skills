---
title: Transaction Envelope and Encoding (Tempo Indexing Lens)
impact: HIGH
impactDescription: Tempo extends Reth-compatible envelopes with Type 0x76 carrying fee delegation, nonce key, and validity window. Missing these fields breaks fee reconciliation.
tags: indexing, transaction, envelope, rlp, type-0x76, fee-delegation, nonce-key, validity-window, tempo
---

# Transaction Envelope (Tempo Indexing Lens)

## Concept

Tempo is Reth-compatible for legacy Ethereum envelope types (legacy, EIP-2930, 1559, 4844, 7702). On top of that, Tempo defines **Type 0x76**, a Tempo Transaction that adds fee delegation, a nonce key, and a validity window. An indexer must parse both the Ethereum-style types and the Tempo-specific one.

## Tempo

Envelope types:

- **Ethereum-compatible** -- legacy and EIP-2718 typed transactions as on Ethereum.
- **Type 0x76 (Tempo Transaction)** -- adds:
  - **Fee delegator** -- a second signer who pays the fee; reconciliation of fee flows depends on recognizing this.
  - **Nonce key** -- allows parallel nonces per account instead of the single monotonic nonce of Ethereum. Critical for high-throughput senders.
  - **Validity window** -- time-bound validity in addition to `chainId` replay protection.

tidx documents these fields in `<RESEARCH_ROOT>/tidx/src/types.rs` and `<RESEARCH_ROOT>/tidx/db/txs.sql`. The tidx schema separates `from` (sender) and `fee_delegator` so downstream consumers can distinguish them.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/primitives/` -- Tempo envelope primitives.
- `<RESEARCH_ROOT>/tempo-go/tx/builder.go` -- Go SDK transaction builder.
- `<RESEARCH_ROOT>/tidx/src/types.rs` -- indexer record layout for Tempo transactions.
- `<RESEARCH_ROOT>/tidx/db/txs.sql` -- SQL schema for transaction records.

## Indexer Design Implications

- Always branch on envelope type; for Type 0x76, capture sender and fee delegator separately.
- Persist the raw envelope alongside the decoded form for forward compatibility.
- When reconciling fees, attribute the fee debit to the delegator, not the sender.
- Support multiple parallel nonces per account via the nonce key -- a single monotonic nonce assumption will miss valid transactions.
- Enforce validity window checks for pending / mempool records; skipped validity windows can produce phantom records.
- Test fee-delegated flows end-to-end before production.

## References

- Tempo docs: https://docs.tempo.xyz
- tidx: https://github.com/tempoxyz/tidx
- Related: `idx-event-decoding.md`, `idx-rpc-api.md`
