---
title: Transaction Envelope and Encoding (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Misparsing transaction envelopes loses or misattributes data; Ethereum has six distinct envelope types that all coexist on mainnet.
tags: indexing, transaction, envelope, rlp, eip-2718, eip-2930, eip-1559, eip-4844, eip-7702, ethereum
---

# Transaction Envelope (Ethereum Indexing Lens)

## Concept

Transactions have evolved as Ethereum adds features: fee market changes (EIP-1559), access lists (EIP-2930), blob data (EIP-4844), account abstraction (EIP-7702). An indexer must handle every envelope version the chain has ever produced and extract the version-specific fields. Encoding is RLP across all types.

## Ethereum

Envelope types:

- **Legacy** -- raw RLP list `[nonce, gasPrice, gasLimit, to, value, data, v, r, s]`. EIP-155 chainId is baked into the signature.
- **EIP-2718 typed** -- first byte is the type, followed by type-specific RLP payload.
- **Type 0x01 (EIP-2930)** -- adds `accessList`.
- **Type 0x02 (EIP-1559)** -- adds `maxFeePerGas`, `maxPriorityFeePerGas`.
- **Type 0x03 (EIP-4844)** -- adds `blobVersionedHashes`, `maxFeePerBlobGas`. Blobs themselves travel separately over the beacon network.
- **Type 0x04 (EIP-7702)** -- adds `authorizationList` for delegated account abstraction.

Signature recovery requires the correct pre-image per type. Chain ID lives in the signature for legacy (EIP-155) and in the payload for typed envelopes.

Relevant code:

- `<RESEARCH_ROOT>/go-ethereum/core/types/` -- envelope definitions and RLP decoders.
- `<RESEARCH_ROOT>/reth/crates/primitives/src/transaction/` -- reth's envelope types.
- `<RESEARCH_ROOT>/EIPs/EIPS/eip-2718.md`, `eip-2930.md`, `eip-1559.md`, `eip-4844.md`, `eip-7702.md` -- spec text.

## Indexer Design Implications

- Branch on envelope type early; extract fields per type using a fully typed deserializer.
- Persist the raw envelope alongside the decoded form -- if a new type appears later, you can re-decode historical data.
- Track which EIPs have activated on the target network so you know which types to expect per block range.
- For EIP-4844, record the blob versioned hashes but do not require the blob bodies unless your indexer specifically needs them.
- For EIP-7702, capture the authorization list entries; they affect authorization-bound balance changes.
- Test with malformed and edge-case envelopes before production.

## References

- EIP-2718 typed envelope: https://eips.ethereum.org/EIPS/eip-2718
- EIP-2930 access list: https://eips.ethereum.org/EIPS/eip-2930
- EIP-1559 fee market: https://eips.ethereum.org/EIPS/eip-1559
- EIP-4844 blob tx: https://eips.ethereum.org/EIPS/eip-4844
- EIP-7702 authorization list: https://eips.ethereum.org/EIPS/eip-7702
- Related: `idx-event-decoding.md`, `idx-rpc-api.md`
