---
title: Reorg and Finality Semantics (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Indexer correctness depends on reorg detection and finality model. Missing rollback logic corrupts downstream state.
tags: indexing, reorg, finality, commitment, ethereum
---

# Reorg and Finality (Ethereum Indexing Lens)

## Concept

Every indexer must answer two questions: (1) has the chain reorganized since I last ingested a block, and (2) at what point can I treat an ingested record as permanent? On Ethereum, the answer depends on the post-Merge PoS finality model: head blocks are probabilistic and can reorg by a few blocks before finalization; once a block is finalized via Casper FFG (two epochs lag), it is deterministic. Indexers must therefore maintain rollback capability for the pre-finalization window.

## Ethereum

Post-Merge (PoS), finality is two-epoch lagging via Casper FFG. Between head and finalized, reorgs of a few blocks can occur. The indexer selects an ingestion tag:

- `latest` -- fast but reorg-prone.
- `safe` -- justified checkpoint, rarely reorgs.
- `finalized` -- two-epoch lag, deterministic.

Typical observed reorg depth: 1-2 blocks pre-finalization. Reorg signal arrives via the canonical head chain tip changing (observable on the `newHeads` subscription).

Relevant code:

- `<RESEARCH_ROOT>/prysm/beacon-chain/forkchoice/` -- fork choice implementation and head determination.
- `<RESEARCH_ROOT>/go-ethereum/eth/catalyst/` -- Engine API handling from the consensus client.
- `<RESEARCH_ROOT>/go-ethereum/core/blockchain.go` -- canonical chain reorganization and rewinding.
- `<RESEARCH_ROOT>/reth/crates/blockchain-tree/` -- tree-based reorg handling in reth.

## Indexer Design Implications

- Choose a single commitment tag per ingestion pipeline and document it explicitly.
- Design a rollback schema for the pre-finalization window. Track the last finalized block hash per run so restarts can detect reorgs relative to prior state.
- Prefer subscribing to finality events (subscribe to `finalized` head updates) over polling.
- Expose a tentative tier with clearly labeled reorg semantics if downstream consumers need lower latency.
- Decide early whether to track justified / safe or only finalized -- the two-epoch lag may be unacceptable for some use cases.
- On reorg detection, replay from the common ancestor rather than dropping arbitrary blocks.

## References

- Ethereum finality (Casper FFG): https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/#finality
- Ethereum block tags (earliest, safe, finalized, latest, pending): https://ethereum.org/en/developers/docs/apis/json-rpc
- Related: `idx-state-access.md`
- Related existing refs: `../protocol/src-prysm.md`, `../protocol/src-go-ethereum.md`, `../protocol/src-reth.md`
