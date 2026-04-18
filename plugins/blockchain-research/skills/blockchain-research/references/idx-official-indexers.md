---
title: Official and Reference Indexer Implementations (Indexing Lens)
impact: MEDIUM-HIGH
impactDescription: Reference indexers define API conventions users expect and reveal chain-specific design patterns worth borrowing.
tags: indexing, reference-indexers, blockscout, helius, tidx, etherscan, ethereum, solana, tempo
---

# Official Indexers (Indexing Lens)

## Concept

Every chain ecosystem has one or more reference indexer implementations. Studying them yields three benefits: (1) API shape conventions users expect, (2) data model patterns refined over years of production use, (3) coverage gaps that open opportunities for a new indexer. This file catalogs the major reference indexers per chain.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Protocol-native indexer | None (ecosystem-provided) | None (ecosystem-provided) | tidx (official) |
| Dominant block explorer | Etherscan (closed source, public API) | Solscan, Solana FM | Tempo Explorer (per docs) |
| Open source explorer | Blockscout | Solana FM / Explorer (partial) | tidx |
| Archive node w/ indexer | Erigon, reth-indexer | No direct analog | tidx |
| Analytics platform | The Graph, Subsquid, Goldsky, Dune (shared) | Helius, Triton One, Shyft, Dune (shared) | tidx |
| Real-time plugin model | reth ExEx, Erigon hooks | Geyser plugin interface | tidx + Commonware stream |

## Ethereum

- **Etherscan**: de facto public API shape (contract verification, logs, internal txs). Closed source; many indexers mimic its response format.
- **Blockscout**: open-source block explorer with full indexer. The Ecto-based PostgreSQL schema is a strong reference.
- **Erigon**: archive node with built-in indexed RPC (`trace_*`, `ots_*`). Efficient storage via staged sync.
- **reth + ExEx (execution extensions)**: hook into reth's pipeline to build custom indexers co-located with the node.
- **The Graph**: subgraph-based contract-specific indexers; good reference for per-contract index design.
- **Subsquid / Goldsky**: managed indexer platforms; study data models and query APIs.

Phase 2 file: `ethereum/idx-official-indexers.md`.

## Solana

- **Helius**: enhanced RPC with NFT / transaction parsing; widely used reference for Solana-specific conveniences.
- **Triton One (Yellowstone)**: gRPC streaming, Geyser-based, low-latency reference.
- **Solscan / Solana FM**: public explorers with public APIs worth studying for UI-oriented data shapes.
- **Shyft**: managed indexer with Anchor IDL auto-decoding.
- **Geyser plugins (general)**: framework for any real-time Solana indexer. Study `<RESEARCH_ROOT>/agave/geyser-plugin-interface/`.

Phase 2 file: `solana/idx-official-indexers.md`.

## Tempo

- **tidx**: the protocol-native Tempo indexer. Submodule at `<RESEARCH_ROOT>/tidx/`. Reference implementation for Tempo-specific transaction fields, Fee AMM attribution, Simplex BFT sync, and ABI-decoded event queries via the `/query` API.
- External analytics: listed in Tempo docs as they emerge.

Phase 2 file: `tempo/idx-official-indexers.md`.

## Indexer Design Implications

- Inherit API response shapes from dominant explorers (Etherscan, Solscan, tidx) to reduce friction for users migrating.
- For Solana, prefer Geyser-plugin-based ingestion over RPC polling in production; study existing plugins.
- For Ethereum, consider reth ExEx or Erigon staged sync hooks if embedding the indexer next to the node.
- For Tempo, start by reading tidx -- most Tempo-specific indexing concerns are already solved there.
- Borrow data models: Blockscout's PostgreSQL schema and tidx's SQL functions offer a ready-made starting point.

## References

- Etherscan API: https://docs.etherscan.io
- Blockscout: https://github.com/blockscout/blockscout
- Erigon: https://github.com/erigontech/erigon
- reth ExEx: https://github.com/paradigmxyz/reth
- The Graph: https://thegraph.com/docs/
- Helius: https://docs.helius.dev
- Triton Yellowstone: https://github.com/rpcpool/yellowstone-grpc
- tidx: https://github.com/tempoxyz/tidx
- Related: `idx-rpc-api.md`, `idx-event-decoding.md`
