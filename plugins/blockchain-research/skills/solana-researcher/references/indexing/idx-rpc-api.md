---
title: RPC, gRPC, and WebSocket APIs (Solana Indexing Lens)
impact: HIGH
impactDescription: Ingestion throughput and correctness depend on choosing the right transport (JSON-RPC / WebSocket / gRPC / Geyser) per data type.
tags: indexing, rpc, jsonrpc, grpc, websocket, geyser, subscription, solana
---

# RPC and API (Solana Indexing Lens)

## Concept

Indexers fetch Solana data via JSON-RPC (HTTP and WebSocket) or gRPC. Method choice affects latency, throughput, and resource usage. For production-scale indexers, Geyser plugins or Yellowstone gRPC dramatically reduce cost and latency compared to polling.

## Solana

Core JSON-RPC methods:

- Block fetch: `getBlock` (slot-keyed), `getSlotLeaders`.
- Transaction fetch: `getTransaction` (signature-keyed), `getSignaturesForAddress` (per-account listing).
- Account / program state: `getAccountInfo`, `getMultipleAccounts`, `getProgramAccounts` (with filters).
- Supply / fees: `getSupply`, `getFeeForMessage`.

WebSocket subscriptions:

- `slotSubscribe` -- slot progression with commitment changes.
- `logsSubscribe` -- program log streams (filter by account or program).
- `accountSubscribe` -- per-account change stream.
- `signatureSubscribe` -- confirmation progression for a specific signature.

gRPC via Yellowstone (Triton) provides low-latency Geyser-backed streaming of accounts, slots, and transactions with server-side filtering. For in-validator ingestion, write a Geyser plugin against the stable plugin interface.

Relevant code:

- `<RESEARCH_ROOT>/solana/rpc/` -- standard JSON-RPC handlers.
- `<RESEARCH_ROOT>/agave/geyser-plugin-interface/` -- Geyser plugin trait and lifecycle.
- `<RESEARCH_ROOT>/agave/rpc/` -- agave's RPC server implementation.

## Indexer Design Implications

- Split ingestion into three channels: commitment subscription, slot backfill, account / program-account queries.
- Prefer Geyser plugins or Yellowstone gRPC over RPC polling in production.
- For `getProgramAccounts`, pre-partition by filter to stay within per-provider limits.
- Never assume `getTransaction` returns `innerInstructions` or `logMessages`; both can be skipped via `OptionSerializer::Skip`. Account for that in the parser.
- Cache `getBlock` responses by slot -- they are immutable once finalized.
- For cross-region indexers, run a Geyser plugin in each region rather than sending every event over WAN.

## References

- Solana RPC: https://solana.com/docs/rpc
- Solana Geyser: https://docs.solana.com/validator/geyser
- Yellowstone gRPC: https://github.com/rpcpool/yellowstone-grpc
- Related: `idx-tx-envelope.md`, `idx-event-decoding.md`
