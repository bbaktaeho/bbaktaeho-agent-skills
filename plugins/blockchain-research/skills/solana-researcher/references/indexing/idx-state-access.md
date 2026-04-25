---
title: State Access, Commitment, and Archive (Solana Indexing Lens)
impact: HIGH
impactDescription: Indexer reliability depends on matching commitment level to query semantics and handling the absence of traditional archive nodes.
tags: indexing, state, commitment, archive, geyser, pruning, solana
---

# State Access (Solana Indexing Lens)

## Concept

Indexers read chain state in two modes: streaming (live ingestion from the tip) and historical (backfill or point-in-time query). Each mode has requirements around commitment level, historical depth, and node type. Solana does not have a traditional archive node; historical state is served via external warehouse / Bigtable providers.

## Solana

Commitment levels are set per RPC call via the `commitment` parameter (`processed` / `confirmed` / `finalized`). Validators prune aggressively; `finalized` state older than the retention window is unavailable from a live validator. Archive is external -- providers run historical warehouses (Bigtable, custom stores) that serve `getAccountInfo` and `getBlock` at old slots.

Geyser plugins pipe state changes in real time to external sinks (Kafka, Postgres, custom stores). This is the preferred ingestion path for production indexers because it avoids polling and costs less than RPC.

Relevant code:

- `<RESEARCH_ROOT>/solana/runtime/src/bank.rs` -- bank state and commitment tracking.
- `<RESEARCH_ROOT>/agave/geyser-plugin-interface/` -- Geyser plugin interface for streaming state.
- `<RESEARCH_ROOT>/solana/runtime/src/snapshot_bank_utils.rs` -- snapshot-based fast sync.

## Indexer Design Implications

- Document the commitment level and node type your indexer assumes.
- Architect around Geyser plugins or a warehouse provider for historical coverage.
- For initial sync, prefer snapshot download, then switch to block-by-block ingestion at the sync tip.
- `getAccountInfo` at old slots requires an archive provider; cache aggressively and never assume a live validator can serve it.
- Track stake account state changes via Geyser; epoch rewards land there and are easy to miss.
- Plan for validator pruning windows in your backfill: if the validator you connect to retains only a few days, backfill pipelines must source from a warehouse provider instead.

## References

- Solana commitment: https://solana.com/docs/rpc
- Solana Geyser plugin: https://docs.solana.com/validator/geyser
- Triton Yellowstone (gRPC Geyser): https://github.com/rpcpool/yellowstone-grpc
- Related: `idx-reorg-finality.md`, `idx-rpc-api.md`
