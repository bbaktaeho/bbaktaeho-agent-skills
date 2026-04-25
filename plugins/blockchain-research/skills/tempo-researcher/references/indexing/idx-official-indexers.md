---
title: Official and Reference Indexer Implementations (Tempo Indexing Lens)
impact: MEDIUM-HIGH
impactDescription: tidx is Tempo's protocol-native indexer. It defines the ABI registry, the /query API, and the sync pipeline that external tools should interoperate with.
tags: indexing, reference-indexers, tidx, query-api, commonware, tempo
---

# Official Indexers (Tempo Indexing Lens)

## Concept

Unlike Ethereum and Solana, Tempo ships with a protocol-native indexer: **tidx**. Studying tidx yields three benefits: (1) the canonical data model for Tempo, (2) the ABI registry and decoded-event schema, (3) reference patterns for Tempo-specific fields (fee delegation, nonce key, validity window) and Simplex BFT sync.

## Tempo

- **tidx** -- the protocol-native Tempo indexer. Submodule at `<RESEARCH_ROOT>/tidx/`. Reference implementation for:
  - Tempo-specific transaction fields (fee delegator, nonce key, validity window).
  - Fee AMM attribution.
  - Simplex BFT sync pipeline with single-round-finality assumption.
  - ABI-decoded event queries via the `/query` API and SQL functions in `<RESEARCH_ROOT>/tidx/db/functions.sql`.
  - Postgres-backed storage for raw + decoded records.
- **Tempo Explorer** -- official explorer on the Tempo docs; API surface is a consumer of tidx for most views.
- External analytics and block explorers: listed in Tempo docs as they emerge.

## Indexer Design Implications

- Start by reading tidx -- most Tempo-specific indexing concerns are already solved there.
- Inherit tidx's schema and `/query` conventions for any downstream tool; migrating away from tidx has a high cost.
- For new indexer projects on Tempo, extend tidx rather than rebuilding. New ABIs, new decoded rows, and new query patterns all fit naturally.
- For analytics pipelines, route ingestion through tidx's Postgres store rather than the base node.
- Watch for updates to tidx's sync engine: any change to its reorg assumptions or fee attribution is load-bearing for downstream consumers.

## References

- tidx: https://github.com/tempoxyz/tidx
- Tempo docs: https://docs.tempo.xyz
- Related: `idx-rpc-api.md`, `idx-event-decoding.md`
