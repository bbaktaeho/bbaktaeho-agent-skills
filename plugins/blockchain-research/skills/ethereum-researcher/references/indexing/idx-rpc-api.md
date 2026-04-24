---
title: RPC and WebSocket APIs (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Ingestion throughput and correctness depend on choosing the right JSON-RPC method and subscription channel per data type.
tags: indexing, rpc, jsonrpc, websocket, subscription, ethereum
---

# RPC and API (Ethereum Indexing Lens)

## Concept

Indexers fetch Ethereum data via JSON-RPC over HTTP or WebSocket. Method choice affects latency, throughput, and resource usage. Subscribe-style APIs reduce polling load; request-response suits backfill. Specialized indexer plugins (reth ExEx, Erigon hooks) embed inside the node for maximum efficiency.

## Ethereum

Namespaces:

- `eth_*` -- standard (blocks, transactions, receipts, logs, calls, storage).
- `engine_*` -- consensus-to-execution communication; generally not for indexers.
- `debug_*` -- trace-oriented (`debug_traceTransaction`, `debug_traceCall`, `debug_traceBlockByHash`).
- `trace_*` -- Parity / OpenEthereum style traces; supported by Erigon and some proxies.

Key methods:

- Block fetch: `eth_getBlockByNumber`, `eth_getBlockReceipts` (combined tx + receipt in one call).
- Log / event fetch: `eth_getLogs` with `{fromBlock, toBlock, address?, topics?}`. Subject to per-provider range limits.
- Subscription: `eth_subscribe` with `newHeads`, `logs`, `newPendingTransactions`.
- Trace / internal tx: `debug_traceTransaction`, `trace_block` -- expensive; used selectively.

Batch RPC reduces round-trip overhead for backfill. Relevant code:

- `<RESEARCH_ROOT>/go-ethereum/internal/ethapi/` -- standard RPC handler implementations.
- `<RESEARCH_ROOT>/reth/crates/rpc/` -- reth's RPC server.
- `<RESEARCH_ROOT>/reth/crates/exex/` -- reth execution extensions (ExEx) for embedded indexers.

## Indexer Design Implications

- Split ingestion into three channels: head subscription, range backfill, state queries.
- Respect per-provider rate and range limits; batch where possible and pre-partition backfill by block range.
- Use WebSocket subscription for the head and HTTP range queries for backfill; mixing both concerns on a single transport adds latency.
- Consider reth ExEx or Erigon staged sync hooks when embedding the indexer next to the node.
- Cache `debug_*` / `trace_*` outputs by (tx hash, block hash) -- they are deterministic and expensive.
- Verify data integrity across transports (for example, confirm block hash matches the head subscription when reading block body via a separate call).

## References

- Ethereum JSON-RPC: https://ethereum.org/en/developers/docs/apis/json-rpc
- Erigon: https://github.com/erigontech/erigon
- reth ExEx: https://github.com/paradigmxyz/reth
- Related: `idx-tx-envelope.md`, `idx-event-decoding.md`
