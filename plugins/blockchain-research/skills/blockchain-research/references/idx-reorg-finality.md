---
title: Reorg and Finality Semantics (Indexing Lens)
impact: HIGH
impactDescription: Indexer correctness depends on reorg detection and finality model per chain. Missing rollback logic corrupts downstream state.
tags: indexing, reorg, finality, commitment, ethereum, solana, tempo
---

# Reorg and Finality (Indexing Lens)

## Concept

Every indexer must answer two questions: (1) has the chain reorganized since I last ingested a block, and (2) at what point can I treat an ingested record as permanent? The answers depend on the chain's finality model. Probabilistic finality (work-based or early-confirmation consensus) means the indexer must maintain rollback capability. Deterministic finality (BFT-based, single-round commitment) means once data is finalized, it cannot change -- the indexer can prune tentative state.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Finality type | Probabilistic pre-finalization, deterministic at finalized checkpoint | Gradated commitment (processed / confirmed / finalized) with rooted terminal | Deterministic (Simplex BFT, single round) |
| Typical reorg depth | 1-2 blocks pre-finalization | 0 at finalized; up to tens of slots at processed | 0 after commit |
| Recommended confirmation | `finalized` block tag (~2 epochs, 12.8 min) | `finalized` commitment | Committed block (no wait) |
| Reorg signal | Canonical head chain tip changes; newHeads subscription | Bank rooted event; commitment subscriptions | Not applicable after commit |
| Late-finality data | Permanent after finalization | Warehouse / Bigtable for historical rooted state | On-chain, always |

## Ethereum

Post-Merge (PoS), finality is two-epoch lagging via Casper FFG. Between head and finalized, reorgs of a few blocks can occur. The indexer selects an ingestion tag:
- `latest` -- fast but reorg-prone.
- `safe` -- justified checkpoint, rarely reorgs.
- `finalized` -- two-epoch lag, deterministic.

Relevant code: `<RESEARCH_ROOT>/prysm/beacon-chain/forkchoice/`, `<RESEARCH_ROOT>/go-ethereum/eth/catalyst/`. Phase 2 file: `ethereum/idx-reorg-finality.md`.

## Solana

Tower BFT produces gradated commitment levels: `processed` (broadcast), `confirmed` (supermajority vote observed), `finalized` (rooted). `finalized` is safe; `confirmed` has rare reorg risk; `processed` reorgs routinely. Indexers subscribe to commitment changes or send each request with a `commitment` parameter.

Relevant code: `<RESEARCH_ROOT>/solana/core/src/consensus/`, `<RESEARCH_ROOT>/agave/core/src/replay_stage.rs`. Phase 2 file: `solana/idx-reorg-finality.md`.

## Tempo

Simplex BFT finalizes a block in a single consensus round. Once committed, the block cannot be reorganized. The indexer treats each committed block as terminal. Tempo's tidx encodes this assumption in its sync pipeline.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/node/` consensus module, `<RESEARCH_ROOT>/tidx/src/sync/engine.rs`. Phase 2 file: `tempo/idx-reorg-finality.md`.

## Indexer Design Implications

- Choose a single commitment level per ingestion pipeline and document it explicitly.
- Design rollback schema only for chains whose model requires it (Ethereum pre-finalization, Solana below finalized). Tempo does not require rollback.
- Prefer subscribing to finality events (Ethereum `finalized` tag, Solana commitment subscription) over polling.
- Expose a tentative tier with clearly labeled reorg semantics if downstream consumers need lower latency.
- On Ethereum, decide early whether to track justified / safe or only finalized -- the two-epoch lag may be unacceptable for some use cases.
- Persist the last finalized block hash per run so restarts can detect reorgs relative to prior state.

## References

- Ethereum finality (Casper FFG): https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/#finality
- Solana commitment: https://solana.com/docs/rpc#configuring-state-commitment
- Simplex BFT (Tempo): https://docs.tempo.xyz
- Related: `idx-state-access.md`
- Related existing refs: `ethereum/src-prysm.md`, `solana/src-agave.md`, `tempo/src-tidx.md`
