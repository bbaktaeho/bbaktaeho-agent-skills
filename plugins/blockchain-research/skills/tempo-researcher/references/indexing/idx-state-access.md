---
title: State Access, Commitment, and Archive (Tempo Indexing Lens)
impact: HIGH
impactDescription: Tempo's deterministic commit simplifies commitment handling. tidx owns historical indexed state; archive retention is a tidx configuration concern.
tags: indexing, state, commitment, archive, pruning, tidx, tempo
---

# State Access (Tempo Indexing Lens)

## Concept

Indexers read chain state in two modes: streaming (live ingestion from the tip) and historical (backfill or point-in-time query). Each mode has requirements around commitment level, historical depth, and node type.

## Tempo

Simplex BFT finalization removes commitment-level complexity: a block is either committed or not. There is no equivalent of Ethereum's multi-tag model or Solana's gradated commitments -- Tempo has a single effective commitment level.

tidx maintains its own database (`<RESEARCH_ROOT>/tidx/db/`) for indexed state and exposes a `/query` API for SQL-style access to decoded records. Archive retention is determined by tidx configuration rather than by the base node. For raw historical state (pre-decoded), tidx can be paired with a Tempo full node that retains the requested window, or queries can be served from tidx's own decoded tables.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/` -- Tempo node state handling.
- `<RESEARCH_ROOT>/tidx/src/sync/engine.rs` -- tidx sync pipeline reading finalized blocks.
- `<RESEARCH_ROOT>/tidx/db/` -- tidx Postgres schema for indexed state.

## Indexer Design Implications

- No rollback schema is required because commitments do not revert.
- Decide whether to mirror Tempo state into tidx or serve queries directly from the base node.
- Plan tidx retention explicitly -- once tidx prunes an old block window, backfill becomes expensive.
- For raw state queries at a specific block, use Reth-compatible JSON-RPC (`eth_call`, `eth_getStorageAt`) with a historical tag; for decoded indexed queries, use tidx `/query`.
- tidx's sync engine is the reference implementation; extend it rather than building from scratch when you need Tempo-specific indexing.

## References

- Tempo docs: https://docs.tempo.xyz
- tidx: https://github.com/tempoxyz/tidx
- Related: `idx-reorg-finality.md`, `idx-rpc-api.md`
