---
title: Reorg and Finality Semantics (Tempo Indexing Lens)
impact: HIGH
impactDescription: Tempo's Simplex BFT gives deterministic single-round finality. Indexer design simplifies accordingly; no rollback schema is needed.
tags: indexing, reorg, finality, simplex-bft, commitment, tempo
---

# Reorg and Finality (Tempo Indexing Lens)

## Concept

Every indexer must answer two questions: (1) has the chain reorganized since I last ingested a block, and (2) at what point can I treat an ingested record as permanent? On Tempo, Simplex BFT finalizes a block in a single consensus round. Once committed, a block cannot be reorganized. The indexer therefore treats each committed block as terminal and does not need rollback capability.

## Tempo

Simplex BFT finalizes a block in a single consensus round. Once committed, the block cannot be reorganized. Recommended confirmation: the committed block itself, no wait. Reorg signal: not applicable after commit. tidx encodes this assumption in its sync pipeline -- the sync engine reads committed blocks and writes them directly without a rollback tier.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/node/` -- consensus module implementing Simplex BFT.
- `<RESEARCH_ROOT>/tidx/src/sync/engine.rs` -- sync pipeline that relies on single-round finality.

## Indexer Design Implications

- No rollback schema is required. Committed blocks are terminal.
- Persist the last committed block hash per run for idempotency checks on restart, not for rollback.
- tidx is the reference implementation for Tempo indexing; prefer extending or mirroring its patterns rather than inventing a new reorg model.
- Latency optimization can focus on time-to-commit rather than finality lag, because there is no gap between commit and finality.
- Any caller exposing "confirmation depth" should document that Tempo's is effectively 0.

## References

- Simplex BFT (Tempo): https://docs.tempo.xyz
- tidx: https://github.com/tempoxyz/tidx
- Related: `idx-state-access.md`
- Related existing refs: `../protocol/src-tempo.md`, `../protocol/src-tidx.md`
