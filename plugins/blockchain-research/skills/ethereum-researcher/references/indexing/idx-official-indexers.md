---
title: Official and Reference Indexer Implementations (Ethereum Indexing Lens)
impact: MEDIUM-HIGH
impactDescription: Ethereum's reference indexers define API conventions users expect and reveal chain-specific design patterns worth borrowing.
tags: indexing, reference-indexers, blockscout, etherscan, erigon, reth-exex, the-graph, ethereum
---

# Official Indexers (Ethereum Indexing Lens)

## Concept

Ethereum has no protocol-native indexer; the ecosystem has produced several open-source and commercial reference implementations. Studying them yields three benefits: (1) API shape conventions users expect, (2) data model patterns refined over years of production use, (3) coverage gaps that open opportunities for a new indexer.

## Ethereum

- **Etherscan** -- de facto public API shape (contract verification, logs, internal txs, token transfers). Closed source; many indexers mimic its response format.
- **Blockscout** -- open-source block explorer with a full indexer. Its Ecto-based PostgreSQL schema is a strong reference.
- **Erigon** -- archive node with built-in indexed RPC (`trace_*`, `ots_*` for Otterscan). Efficient storage via staged sync; a strong base for an embedded indexer.
- **reth + ExEx (execution extensions)** -- hook into reth's pipeline to build custom indexers co-located with the node. Lowest ingestion overhead available.
- **The Graph** -- subgraph-based contract-specific indexers. Good reference for per-contract index design and a well-documented GraphQL API shape.
- **Subsquid** -- managed and self-hosted indexer platform with a batch-processor programming model.
- **Goldsky** -- managed indexer; study their mirror and pipeline abstractions.
- **Dune** -- SQL-based analytics built on top of custom-ingested data; useful to study for query shapes even if its ingestion is not open source.

## Indexer Design Implications

- Inherit API response shapes from Etherscan or Blockscout to reduce friction for users migrating.
- For embedded / low-overhead ingestion, evaluate reth ExEx or Erigon hooks before building a separate polling pipeline.
- For per-contract indexers with mutable schemas, study The Graph's subgraph design.
- Borrow data models: Blockscout's PostgreSQL schema offers a ready-made starting point.
- Etherscan-compatible endpoints are a common integration target; plan at least a compatibility layer even if your primary API differs.

## References

- Etherscan API: https://docs.etherscan.io
- Blockscout: https://github.com/blockscout/blockscout
- Erigon: https://github.com/erigontech/erigon
- reth ExEx: https://github.com/paradigmxyz/reth
- The Graph: https://thegraph.com/docs/
- Subsquid: https://docs.subsquid.io
- Related: `idx-rpc-api.md`, `idx-event-decoding.md`
