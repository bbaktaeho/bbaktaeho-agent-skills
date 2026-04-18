---
title: Transaction Envelope and Encoding (Indexing Lens)
impact: HIGH
impactDescription: Misparsing transaction envelopes loses or misattributes data; each chain has distinct version schemes.
tags: indexing, transaction, envelope, rlp, borsh, bincode, versioning, ethereum, solana, tempo
---

# Transaction Envelope (Indexing Lens)

## Concept

Transactions have evolved as chains add features: fee market changes, account abstraction, blob data, address lookup tables, fee delegation. An indexer must handle every envelope version the chain has ever produced and extract the version-specific fields. Encoding format (RLP, bincode, Borsh) determines the parser.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Envelope versioning | EIP-2718 typed tx (0x01 / 0x02 / 0x03 / 0x04) + legacy | Legacy + Versioned (v0) | Reth legacy types + Tempo Type 0x76 |
| Encoding | RLP | Compact-u16 + bincode | RLP + Tempo-specific fields |
| Signature scheme | ECDSA over keccak256 digest | Ed25519 per signer | ECDSA + optional fee delegation signature |
| Account model | Externally owned + contract accounts | Lamport accounts (any program owner) | Ethereum-compatible balance + contract accounts |
| Replay protection | EIP-155 chainId in signature | recent_blockhash + signer uniqueness | chainId + validity window |
| Chain-specific fields | access list (2930), priority fee (1559), blob (4844), authorization list (7702) | Versioned message, ALT | Fee delegator, nonce key, validity window |

## Ethereum

Envelope types:
- Legacy: raw RLP list `[nonce, gasPrice, gasLimit, to, value, data, v, r, s]`.
- EIP-2718 typed: first byte is type, followed by type-specific RLP payload.
- Type 0x01 (EIP-2930): adds access list.
- Type 0x02 (EIP-1559): adds `maxFeePerGas`, `maxPriorityFeePerGas`.
- Type 0x03 (EIP-4844): adds `blobVersionedHashes`, `maxFeePerBlobGas`.
- Type 0x04 (EIP-7702): adds `authorizationList` for delegated account abstraction.

Signature recovery requires the correct pre-image per type. Chain ID lives in the signature for legacy (EIP-155) and in the payload for typed envelopes.

Relevant code: `<RESEARCH_ROOT>/go-ethereum/core/types/`, `<RESEARCH_ROOT>/reth/crates/primitives/src/transaction/`. Relevant EIPs: 2718, 2930, 1559, 4844, 7702. Phase 2 file: `ethereum/idx-tx-envelope.md`.

## Solana

Two main shapes: legacy and versioned. Versioned transactions (v0) support address lookup tables (ALT), enabling up to 256 accounts per transaction vs 64 in legacy. Message header encodes signature count and account layout. Instructions reference accounts by index; the program is itself an account. Encoding: compact-u16 length prefix + bincode bodies.

Relevant code: `<RESEARCH_ROOT>/solana/sdk/program/src/message/`, `<RESEARCH_ROOT>/solana/sdk/src/transaction/`. Phase 2 file: `solana/idx-tx-envelope.md`.

## Tempo

Reth-compatible for legacy Ethereum types. Tempo Type 0x76 adds fee delegation (a second signer pays fees), a nonce key (allows parallel nonces per account), and a validity window. tidx documents these fields in `<RESEARCH_ROOT>/tidx/src/types.rs` and `<RESEARCH_ROOT>/tidx/db/txs.sql`.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/primitives/`, `<RESEARCH_ROOT>/tempo-go/tx/builder.go`, `<RESEARCH_ROOT>/tidx/src/types.rs`. Phase 2 file: `tempo/idx-tx-envelope.md`.

## Indexer Design Implications

- Branch on envelope type early; extract fields per type using a fully typed deserializer.
- Persist the raw envelope alongside the decoded form -- if a new type appears later, you can re-decode historical data.
- For Ethereum, track which EIPs have activated on the target network so you know which types to expect per block range.
- For Solana, normalize legacy and versioned transactions to a common record shape but preserve ALT metadata.
- For Tempo, capture the fee delegator separately from the sender of record; reconciliation of fee flows depends on it.
- Test with malformed and edge-case envelopes before production.

## References

- EIP-2718 typed envelope: https://eips.ethereum.org/EIPS/eip-2718
- EIP-4844 blob tx: https://eips.ethereum.org/EIPS/eip-4844
- EIP-7702 authorization list: https://eips.ethereum.org/EIPS/eip-7702
- Solana versioned transactions: https://docs.solana.com/developing/versioned-transactions
- Tempo docs: https://docs.tempo.xyz
- Related: `idx-event-decoding.md`, `idx-rpc-api.md`
