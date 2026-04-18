---
title: State Access, Commitment, and Archive (Indexing Lens)
impact: HIGH
impactDescription: Indexer reliability depends on matching commitment level to query semantics and handling pruned historical windows correctly.
tags: indexing, state, commitment, archive, pruning, state-sync, ethereum, solana, tempo
---

# State Access (Indexing Lens)

## Concept

Indexers read chain state in two modes: streaming (live ingestion from the tip) and historical (backfill or point-in-time query). Each mode has requirements around commitment level, historical depth, and node type. Archive nodes retain all historical state; full nodes prune after a window. Some indexers embed state in their own store; others query the node per request.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Commitment / block tags | earliest / safe / finalized / latest / pending | processed / confirmed / finalized / rooted | committed (single level) |
| Archive node | geth `--gcmode=archive`, erigon, reth archive | No traditional archive; Bigtable / warehouse for history | tidx own store; per Tempo docs |
| Default pruning | Full node prunes state after ~128 blocks | Validator prunes aggressively; history via warehouse | Per node operator config |
| State sync | Snap sync (execution), checkpoint sync (consensus) | Snapshot download | Tempo-specific sync; tidx replay |
| Historical state query | `eth_call` at block, `debug_*` at block | `getAccountInfo` at slot via archive provider | tidx `/query` + on-chain |

## Ethereum

Block tags: `earliest`, `safe`, `finalized`, `latest`, `pending`. Archive mode is required for `eth_call` at arbitrary historical blocks. EIP-4444 (history expiry) may change long-tail availability. Snap sync (execution) and checkpoint sync (consensus) bootstrap quickly but yield a non-archive node.

Relevant code: `<RESEARCH_ROOT>/go-ethereum/core/state/`, `<RESEARCH_ROOT>/reth/crates/stages/`. Phase 2 file: `ethereum/idx-state-access.md`.

## Solana

Commitment levels are set per RPC call via the `commitment` parameter. Archive is external to the validator (Bigtable, warehouse, or per-provider storage). Geyser plugins pipe state changes in real time to external sinks. Historical account state at an old slot requires an archive provider.

Relevant code: `<RESEARCH_ROOT>/solana/runtime/src/bank.rs`, `<RESEARCH_ROOT>/agave/geyser-plugin-interface/`. Phase 2 file: `solana/idx-state-access.md`.

## Tempo

Simplex BFT finalization removes commitment-level complexity: a block is either committed or not. tidx maintains its own database (`<RESEARCH_ROOT>/tidx/db/`) for indexed state and exposes a `/query` API. Archive retention is determined by tidx configuration.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/`, `<RESEARCH_ROOT>/tidx/src/sync/engine.rs`. Phase 2 file: `tempo/idx-state-access.md`.

## Indexer Design Implications

- Document the commitment level and node type your indexer assumes.
- For historical queries, decide: use a chain-provided archive, run your own archive node, or mirror state in the indexer DB.
- Plan for pruning windows: if the node prunes at 128 blocks, backfill pipelines must race the pruner.
- On Solana, architect around Geyser plugins or a warehouse provider for historical coverage.
- On Ethereum, track EIP-4444 (history expiry) timelines if you depend on pre-finality history.
- For initial sync, prefer the chain's native fast-sync mechanism, then switch to block-by-block ingestion at the sync tip.
- State queries at specific blocks (`eth_call`, `getAccountInfo` at slot) are expensive; cache aggressively.

## References

- Ethereum JSON-RPC block tags: https://ethereum.org/en/developers/docs/apis/json-rpc
- Solana commitment: https://solana.com/docs/rpc
- Solana Geyser plugin: https://docs.solana.com/validator/geyser
- EIP-4444 history expiry: https://eips.ethereum.org/EIPS/eip-4444
- Related: `idx-reorg-finality.md`, `idx-rpc-api.md`
