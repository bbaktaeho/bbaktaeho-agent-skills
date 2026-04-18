---
title: Event, Log, and Instruction Decoding (Indexing Lens)
impact: HIGH
impactDescription: Decoded event records are the backbone of most indexer downstream consumers; decoding correctness is load-bearing.
tags: indexing, events, logs, abi, idl, decoding, cpi, traces, ethereum, solana, tempo
---

# Event Decoding (Indexing Lens)

## Concept

Raw chain data must be decoded into structured records before it is useful. Each chain uses a different artifact format (ABI, IDL), different event emission semantics (log, program log, emit), and different mechanisms for surfacing internal calls (traces, inner instructions). An indexer needs a decoding pipeline: registry of decoding artifacts, per-event parser, fallback for unknown contracts, and a policy for trace data.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Decoding artifact | ABI (JSON schema) | IDL (Anchor) or manual Borsh | ABI (EVM-compatible) + Tempo extensions |
| Event format | Log with up to 4 topics + data blob | Program log strings; Anchor `emit!` produces structured log | Log (Ethereum-style) |
| Topic indexing | Bloom filter on topics + addresses | N/A (log scan by signature) | Bloom filter + tidx ABI registry |
| Internal calls | Trace via `debug_traceTransaction` / `trace_*` | Inner instructions in tx meta | Trace via `debug_traceTransaction` |
| Event signature | keccak256(event signature) as first topic | Anchor discriminator (first 8 bytes) or prefix in log | keccak256(event signature) |
| Anonymous / raw | Supported (no signature topic) | Any program log string is valid | Supported |

## Ethereum

Logs carry up to 4 topics (32 bytes each) plus a data blob. The first topic is the event signature hash (`keccak256(event(type1,type2,...))`). Indexed parameters occupy additional topics; non-indexed parameters are ABI-encoded into the data blob. Bloom filter at block and receipt level allows efficient address / topic search. Internal calls (`CALL`, `STATICCALL`, `DELEGATECALL`, `CREATE`, `CREATE2`) are not emitted as logs -- the indexer must run traces to see them.

Relevant code: `<RESEARCH_ROOT>/go-ethereum/core/types/log.go`, `<RESEARCH_ROOT>/revm/crates/interpreter/src/instructions/host.rs`. Phase 2 file: `ethereum/idx-event-decoding.md`.

## Solana

Program logs are unstructured strings prefixed with `Program log:`, `Program data:`, and `Program <id> invoke [n]` / `Program <id> success`. Anchor programs emit typed events via `emit!`, which writes a base64-encoded Borsh payload with an 8-byte discriminator. Non-Anchor programs use ad-hoc log strings. Inner instructions (cross-program invocations) appear in transaction metadata under `innerInstructions` -- the indexer reads them directly without a separate trace call.

Relevant code: `<RESEARCH_ROOT>/solana/runtime/src/message_processor.rs`, `<RESEARCH_ROOT>/solana-program-library/`. Phase 2 file: `solana/idx-event-decoding.md`.

## Tempo

EVM-compatible log structure (same topics + data model as Ethereum). tidx implements an ABI registry and decodes events at ingest time via functions in `<RESEARCH_ROOT>/tidx/db/functions.sql` -- callers can query decoded event fields directly from the indexer. Tempo-specific transaction fields may need custom decoders that operate on the envelope rather than on logs.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/evm/`, `<RESEARCH_ROOT>/tidx/src/service/mod.rs`, `<RESEARCH_ROOT>/tidx/db/functions.sql`. Phase 2 file: `tempo/idx-event-decoding.md`.

## Indexer Design Implications

- Maintain a per-contract ABI / IDL registry keyed by address. Populate via source-verified providers, user upload, or on-chain metadata.
- For unknown contracts, fall back to raw-topic storage; add full decoding later when ABI becomes available.
- Decide trace policy early -- tracing every tx is expensive. Common patterns: trace only contract-creating txs, trace on-demand, trace everything only for specialized indexers.
- On Solana, always read inner instructions alongside logs; logs alone miss program semantics.
- For Anchor programs, extract discriminators and decode Borsh via the IDL; for non-Anchor programs, write custom parsers.
- Normalize event records across envelope versions: the same Transfer event may be emitted by contracts spanning years of EVM evolution.
- Never drop undecodable events silently; log and store raw for later analysis.

## References

- Ethereum event ABI spec: https://docs.soliditylang.org/en/latest/abi-spec.html
- Ethereum logs and bloom: https://ethereum.org/en/developers/docs/apis/json-rpc/#eth_getlogs
- Anchor events / IDL: https://book.anchor-lang.com/anchor_bts/events.html
- Solana inner instructions: https://solana.com/docs/rpc/http/gettransaction
- tidx ABI decoding: https://github.com/tempoxyz/tidx
- Related: `idx-asset-standards.md`, `idx-tx-envelope.md`
