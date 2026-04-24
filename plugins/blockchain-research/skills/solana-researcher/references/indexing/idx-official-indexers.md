---
title: Official and Reference Indexer Implementations (Solana Indexing Lens)
impact: MEDIUM-HIGH
impactDescription: Solana's indexers define the conveniences users expect (NFT parsing, Anchor IDL auto-decoding) and showcase Geyser-based architectures.
tags: indexing, reference-indexers, helius, yellowstone, triton, shyft, solscan, geyser, solana
---

# Official Indexers (Solana Indexing Lens)

## Concept

Solana has no protocol-native indexer; the ecosystem has produced several reference implementations, mostly Geyser-plugin-based. Studying them reveals Solana-specific conveniences (NFT parsing, Anchor IDL auto-decoding, transaction-level enhancement) and real-time ingestion patterns.

## Solana

- **Helius** -- enhanced RPC with NFT parsing, transaction enrichment, and developer-oriented conveniences. Widely used reference for Solana-specific response shapes.
- **Triton One (Yellowstone)** -- gRPC streaming via Geyser, low-latency reference implementation for real-time ingestion. Server-side filtering reduces network cost.
- **Solscan** -- public block explorer with a public API worth studying for UI-oriented data shapes.
- **Solana FM** -- another public explorer; partial open source.
- **Shyft** -- managed indexer with Anchor IDL auto-decoding; study their pipeline for IDL-first decoding patterns.
- **Geyser plugins (general framework)** -- the foundation for any real-time Solana indexer. Reference plugin interface: `<RESEARCH_ROOT>/agave/geyser-plugin-interface/`.

## Indexer Design Implications

- Prefer Geyser-plugin-based ingestion over RPC polling in production; study existing plugins before building a new one.
- Inherit API response shapes from Helius or Solscan to reduce friction for users migrating.
- For IDL-first decoding, study Shyft's approach.
- For cross-region low-latency indexers, Yellowstone gRPC with regional peers is the current reference architecture.
- Solscan-style per-address history APIs are a common integration target; plan at least a compatibility layer.

## References

- Helius: https://docs.helius.dev
- Triton Yellowstone: https://github.com/rpcpool/yellowstone-grpc
- Solscan: https://solscan.io
- Solana FM: https://solana.fm
- Shyft: https://shyft.to
- Solana Geyser docs: https://docs.solana.com/validator/geyser
- Related: `idx-rpc-api.md`, `idx-event-decoding.md`
