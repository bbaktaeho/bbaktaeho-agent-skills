---
title: RPC, gRPC, and Subscription APIs (Indexing Lens)
impact: HIGH
impactDescription: Ingestion throughput and correctness depend on choosing the right transport and method per data type.
tags: indexing, rpc, grpc, websocket, subscription, api, ethereum, solana, tempo
---

# RPC and API (Indexing Lens)

## Concept

Indexers fetch blockchain data through chain-specific APIs: JSON-RPC, gRPC, WebSocket subscriptions, or custom protocols. Method choice affects latency, throughput, and resource usage. Subscribe-style APIs reduce polling load; request-response suits backfill. Some chains expose specialized indexer plugins (Solana Geyser, Tempo tidx).

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Primary transport | JSON-RPC over HTTP / WebSocket | JSON-RPC over HTTP, WebSocket, gRPC (Yellowstone) | JSON-RPC (Reth-compatible) + tidx `/query` API |
| Block fetch | `eth_getBlockByNumber` | `getBlock` | `eth_getBlockByNumber` |
| Log / event fetch | `eth_getLogs` with block range | `getSignaturesForAddress` + `getTransaction` | `eth_getLogs` + tidx ABI-decoded query |
| Subscription | `eth_subscribe` (newHeads, logs) | `logsSubscribe`, `accountSubscribe`, `slotSubscribe` | `eth_subscribe` + gRPC via Commonware |
| Trace / internal tx | `debug_traceTransaction`, `trace_block` | Inner instructions in `getTransaction` response | `debug_traceTransaction` |
| Indexer-specific plugin | reth ExEx, Erigon hooks | Geyser plugin interface | tidx as protocol-native |

## Ethereum

Namespaces: `eth_*` (standard), `engine_*` (consensus <-> execution), `debug_*`, `trace_*` (Parity / OpenEthereum style). WebSocket subscription is the standard head tracker; `eth_getLogs` with a block range is the backfill workhorse but is subject to per-provider range limits. Batch RPC reduces round-trip overhead.

Relevant code: `<RESEARCH_ROOT>/go-ethereum/internal/ethapi/`, `<RESEARCH_ROOT>/reth/crates/rpc/`. Phase 2 file: `ethereum/idx-rpc-api.md`.

## Solana

Core JSON-RPC: `getBlock`, `getTransaction`, `getSignaturesForAddress`, `getProgramAccounts`, `getAccountInfo`. WebSocket: `logsSubscribe`, `slotSubscribe`, `accountSubscribe`. gRPC via Yellowstone (Triton) or a custom Geyser plugin. Geyser plugins run inside the validator and stream account / slot / transaction events with near-zero overhead compared to polling.

Relevant code: `<RESEARCH_ROOT>/solana/rpc/`, `<RESEARCH_ROOT>/agave/geyser-plugin-interface/`. Phase 2 file: `solana/idx-rpc-api.md`.

## Tempo

Reth-compatible JSON-RPC (`eth_*`), augmented with Tempo-specific endpoints for Simplex consensus and Payment Lanes. tidx (`<RESEARCH_ROOT>/tidx/`) offers a `/query` API for indexed data with SQL-style filtering over decoded events and transactions.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/rpc/`, `<RESEARCH_ROOT>/tidx/src/service/`. Phase 2 file: `tempo/idx-rpc-api.md`.

## Indexer Design Implications

- Split ingestion into three channels: head subscription, range backfill, state queries.
- Respect per-provider rate and range limits; batch where possible and pre-partition backfill by block range.
- On Solana, prefer Geyser plugins over RPC polling for production-scale indexers.
- On Tempo, use tidx `/query` for ABI-decoded queries; fall back to JSON-RPC for raw state.
- For cross-chain indexers, abstract the transport behind a per-chain driver so consumers share a unified record shape.
- Verify data integrity across transport (for example, confirm block hash matches the head subscription when reading block body via a separate call).

## References

- Ethereum JSON-RPC: https://ethereum.org/en/developers/docs/apis/json-rpc
- Solana RPC: https://solana.com/docs/rpc
- Solana Geyser: https://docs.solana.com/validator/geyser
- Yellowstone gRPC: https://github.com/rpcpool/yellowstone-grpc
- Tempo RPC: https://docs.tempo.xyz
- tidx: https://github.com/tempoxyz/tidx
- Related: `idx-tx-envelope.md`, `idx-event-decoding.md`
