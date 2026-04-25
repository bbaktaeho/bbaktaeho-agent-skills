---
title: Reorg and Finality Semantics (Solana Indexing Lens)
impact: HIGH
impactDescription: Indexer correctness depends on commitment-level choice. Using processed blindly corrupts downstream state when blocks later abandon.
tags: indexing, reorg, finality, commitment, solana
---

# Reorg and Finality (Solana Indexing Lens)

## Concept

Every indexer must answer two questions: (1) has the chain reorganized since I last ingested a block, and (2) at what point can I treat an ingested record as permanent? On Solana, Tower BFT produces gradated commitment levels instead of a single finality moment: `processed` (seen), `confirmed` (supermajority voted), `finalized` (rooted). Below finalized, reorgs are possible; at finalized, they are not.

## Solana

Tower BFT produces gradated commitment levels:

- `processed` -- the bank observed the block; reorgs happen routinely at this level.
- `confirmed` -- a supermajority vote was observed; rare reorg risk remains.
- `finalized` -- the block is rooted; deterministic, cannot reorg.

Indexers select a commitment level per RPC call (`commitment` parameter) or subscribe to commitment changes. Typical observed reorg depth: 0 at `finalized`; up to tens of slots at `processed`. Historical rooted state is often served from a warehouse / Bigtable rather than a live validator, because validators prune aggressively.

Relevant code:

- `<RESEARCH_ROOT>/solana/core/src/consensus/` -- Tower BFT vote tracking and rooted slot derivation.
- `<RESEARCH_ROOT>/agave/core/src/replay_stage.rs` -- replay stage where commitment transitions are observed.
- `<RESEARCH_ROOT>/solana/runtime/src/bank.rs` -- bank state machine that tracks commitment progression.
- `<RESEARCH_ROOT>/agave/geyser-plugin-interface/` -- streams slot / commitment events to external consumers.

## Indexer Design Implications

- Choose a single commitment level per ingestion pipeline and document it explicitly.
- Design a rollback schema only if you ingest below `finalized`. For `finalized`-only pipelines, rollback is unnecessary.
- Prefer Geyser plugins or commitment subscriptions over polling to observe commitment transitions.
- Persist the last finalized slot per run so restarts can detect reorgs relative to prior state.
- Expose a tentative tier with clearly labeled reorg semantics if downstream consumers need lower latency than `finalized`.
- For historical rooted data older than the validator's retention, route queries to a warehouse provider rather than the live node.

## References

- Solana commitment: https://solana.com/docs/rpc#configuring-state-commitment
- Solana Geyser plugin: https://docs.solana.com/validator/geyser
- Related: `idx-state-access.md`
- Related existing refs: `../protocol/src-solana.md`, `../protocol/src-agave.md`
