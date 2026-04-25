---
title: RPC and Indexed Query APIs (Tempo Indexing Lens)
impact: HIGH
impactDescription: Tempo indexers consume two API surfaces: Reth-compatible JSON-RPC for raw state and tidx /query for ABI-decoded indexed records.
tags: indexing, rpc, jsonrpc, grpc, tidx, query, tempo
---

# RPC and API (Tempo Indexing Lens)

## Concept

Indexers fetch Tempo data via two complementary APIs: Reth-compatible JSON-RPC (`eth_*`) for raw blocks, transactions, and state, and tidx's `/query` endpoint for ABI-decoded records. Tempo also exposes Commonware-backed gRPC for consensus-adjacent streams.

## Tempo

Reth-compatible JSON-RPC covers:

- `eth_getBlockByNumber` / `eth_getBlockReceipts` -- standard block + receipts.
- `eth_getLogs` -- log queries with block range and topic filters.
- `eth_call` / `eth_getStorageAt` -- state queries at a historical tag.
- `eth_subscribe` -- WebSocket subscriptions for newHeads and logs.
- `debug_traceTransaction` -- trace-level analysis for Tempo-specific tx types.

Tempo-specific endpoints extend the standard set for Simplex consensus observation and Payment Lane state. Check Tempo docs and the node's RPC schema for the exact names.

tidx (`<RESEARCH_ROOT>/tidx/`) offers a `/query` API for ABI-decoded and Tempo-specific tx fields, with SQL-style filtering. Typical queries hit the tidx Postgres store directly rather than replaying RPC for each request.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/rpc/` -- Tempo's RPC surface.
- `<RESEARCH_ROOT>/tidx/src/service/` -- tidx query service.
- `<RESEARCH_ROOT>/tidx/db/functions.sql` -- SQL functions backing decoded queries.

## Indexer Design Implications

- Decide per query: raw state from JSON-RPC, or decoded records from tidx `/query`. Mixing the two naively leads to double-counting.
- For decoded events and Tempo-specific tx fields (fee delegator, nonce key, validity window), use tidx. It already parses them correctly.
- For raw storage reads or historical `eth_call`, use JSON-RPC against a Tempo node with adequate retention.
- tidx's `/query` API can be the primary interface for most indexer consumers; treat it as a first-class dependency.
- For low-latency consensus events, consider the gRPC / Commonware streams rather than polling JSON-RPC.

## References

- Tempo RPC: https://docs.tempo.xyz
- tidx: https://github.com/tempoxyz/tidx
- Related: `idx-tx-envelope.md`, `idx-event-decoding.md`
