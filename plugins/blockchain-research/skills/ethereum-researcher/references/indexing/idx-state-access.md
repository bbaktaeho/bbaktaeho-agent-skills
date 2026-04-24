---
title: State Access, Commitment, and Archive (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Indexer reliability depends on matching block tag to query semantics and handling pruned historical windows correctly.
tags: indexing, state, commitment, archive, pruning, state-sync, ethereum
---

# State Access (Ethereum Indexing Lens)

## Concept

Indexers read chain state in two modes: streaming (live ingestion from the tip) and historical (backfill or point-in-time query). Each mode has requirements around block tag, historical depth, and node type. Archive nodes retain all historical state; full nodes prune after a window.

## Ethereum

Block tags: `earliest`, `safe`, `finalized`, `latest`, `pending`. Archive mode is required for `eth_call` / `debug_*` at arbitrary historical blocks. Default full-node pruning keeps roughly the last 128 blocks of state; snap sync (execution) and checkpoint sync (consensus) bootstrap quickly but produce a non-archive node. EIP-4444 (history expiry) may change long-tail availability over time.

Archive options: `geth --gcmode=archive`, erigon (staged sync + built-in history), reth archive. Each trades off disk footprint against RPC capability. Historical state queries at specific blocks are expensive -- cache aggressively.

Relevant code:

- `<RESEARCH_ROOT>/go-ethereum/core/state/` -- state trie handling, snap sync.
- `<RESEARCH_ROOT>/reth/crates/stages/` -- reth staged sync pipeline.
- `<RESEARCH_ROOT>/go-ethereum/eth/downloader/` -- snap sync implementation.
- `<RESEARCH_ROOT>/prysm/beacon-chain/sync/` -- beacon checkpoint sync.

## Indexer Design Implications

- Document the block tag and node type your indexer assumes.
- For historical queries, decide: run your own archive node, use a managed archive provider, or mirror state in the indexer DB.
- Plan for the pruning window: if the node prunes at 128 blocks, backfill pipelines must race the pruner.
- Track EIP-4444 timelines if you depend on pre-finality history.
- For initial sync, prefer snap sync + checkpoint sync, then switch to block-by-block ingestion at the sync tip.
- Cache `eth_call` / `debug_*` results by (contract, method, block, args) because historical calls do not vary.

## References

- Ethereum JSON-RPC block tags: https://ethereum.org/en/developers/docs/apis/json-rpc
- EIP-4444 history expiry: https://eips.ethereum.org/EIPS/eip-4444
- Erigon: https://github.com/erigontech/erigon
- Related: `idx-reorg-finality.md`, `idx-rpc-api.md`
