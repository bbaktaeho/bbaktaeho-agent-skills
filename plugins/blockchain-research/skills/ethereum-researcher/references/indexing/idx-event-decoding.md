---
title: Event, Log, and Trace Decoding (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Decoded event records are the backbone of most indexer downstream consumers; decoding correctness is load-bearing.
tags: indexing, events, logs, abi, decoding, traces, ethereum
---

# Event Decoding (Ethereum Indexing Lens)

## Concept

Raw chain data must be decoded into structured records before it is useful. Ethereum uses ABI-based events emitted as logs, with up to 4 topics and a data blob. Internal calls (from `CALL`, `STATICCALL`, `DELEGATECALL`, `CREATE`, `CREATE2`) are not emitted as logs -- the indexer must run traces (`debug_traceTransaction`, `trace_block`) to see them.

## Ethereum

Logs carry:

- Up to 4 topics (32 bytes each). Topic 0 is `keccak256(event signature)` for standard events; anonymous events omit this.
- A data blob containing ABI-encoded non-indexed parameters.

Indexed parameters occupy additional topics. Block and receipt level bloom filters accelerate address and topic lookup. For unknown contracts, the indexer stores raw logs and can decode them later once ABI is available.

Internal calls require traces. Options:

- `debug_traceTransaction` with a prestate or callTracer.
- `trace_*` (Parity-style) if the node supports it (Erigon, some proxies).
- Structured traces are expensive; trace selectively (contract-creating txs, on-demand, or only for specialized indexers).

Relevant code:

- `<RESEARCH_ROOT>/go-ethereum/core/types/log.go` -- log type definition.
- `<RESEARCH_ROOT>/revm/crates/interpreter/src/instructions/host.rs` -- revm's LOG opcode handling.
- `<RESEARCH_ROOT>/go-ethereum/eth/tracers/` -- tracing framework.

## Indexer Design Implications

- Maintain a per-contract ABI registry keyed by address. Populate via source-verified providers (Etherscan, Sourcify), user upload, or on-chain metadata.
- For unknown contracts, fall back to raw-topic storage; add full decoding later when ABI becomes available.
- Decide trace policy early -- tracing every tx is expensive.
- Normalize event records across envelope versions: the same `Transfer` event is emitted by contracts spanning years of EVM evolution.
- Never drop undecodable events silently; log and store raw for later analysis.
- For EIP-165 interface detection, call `supportsInterface(bytes4)` before assuming a token standard based on event shape alone.

## References

- Ethereum event ABI spec: https://docs.soliditylang.org/en/latest/abi-spec.html
- Ethereum logs and bloom: https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_getlogs
- Related: `idx-asset-standards.md`, `idx-tx-envelope.md`
