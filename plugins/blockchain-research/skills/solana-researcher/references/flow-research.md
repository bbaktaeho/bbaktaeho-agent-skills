---
title: Solana Source Selection -- Chain Delta
impact: CRITICAL
impactDescription: Solana-specific question-to-tag routing; full procedure delegated to shared base
tags: flow, source-matrix, routing, solana
---

# Solana Source Selection

The chain-agnostic 5-phase procedure lives in `plugins/blockchain-research/shared/flow.md`. Read that first.

This file documents Solana-specific routing only. The shared procedure intersects the tags routed here against `submodules.json` to compute the `NEEDED` submodule set.

## Output Paths

Full-mode reports are emitted to:

```
docs/research/solana/{YYYY-MM-DD}-{slug}.md
docs/research/solana/{YYYY-MM-DD}-{slug}.html
```

`{slug}` is kebab-case from the report title.

## Source Selection Matrix

| Question Type | Routed Tags | Notes |
|---------------|-------------|-------|
| SVM internals or runtime | `svm` | Primary: solana, agave runtime. |
| Consensus (Tower BFT, PoH, leader schedule) | `consensus` | Primary: solana, agave. |
| RPC / WebSocket / Geyser | `rpc`, `geyser` | Primary: agave, solana. Secondary: web (Helius docs). |
| SPL token, Token-2022, Metaplex | `spl`, `token`, `asset-standards` | Primary: solana-program-library. |
| SIMDs / proposals | (web only) | Solana forum / blog. |
| Anchor, IDL, Borsh decoding | `spl`, `decoding` | Primary: solana-program-library. Secondary: web (Anchor docs). |
| Compute units, cost model, ALT, versioned tx | `tx-envelope`, `svm` | Primary: agave, solana. |
| Stake accounts, epoch rewards, ATAs | `consensus`, `spl` | Primary: solana, solana-program-library. |

## Indexing Source Selection Matrix

| Indexing Question | Routed Tags | Indexing Lens |
|-------------------|-------------|---------------|
| Commitment levels (processed / confirmed / finalized / rooted) | `consensus`, `rpc` | `indexing/idx-commitment-levels.md` (if present) |
| Geyser plugins, Yellowstone gRPC | `geyser`, `rpc` | `indexing/idx-geyser-grpc.md` (if present) |
| Inner instructions, program logs, Anchor emit! events | `decoding`, `spl` | `indexing/idx-event-decoding.md` (if present) |
| Versioned tx / Address Lookup Tables | `tx-envelope`, `svm` | `indexing/idx-tx-envelope.md` (if present) |
| ATAs, SPL token / Token-2022 standards | `spl`, `token`, `asset-standards` | `indexing/idx-asset-standards.md` (if present) |

If any indexing lens file referenced above does not exist in `references/indexing/`, fall back to the source matrix and the relevant repo navigation file.

## Repo-Level Navigation Pointers

- solana: `references/protocol/src-solana.md` (if present)
- agave: `references/protocol/src-agave.md` (if present)
- solana-program-library: `references/protocol/src-spl.md` (if present)

Web sources:

- forum.solana.com: `references/protocol/web-solana-forum.md` (if present)
- Solana blog: `references/protocol/web-solana-blog.md` (if present)
- Anza engineering blog: `references/protocol/web-anza-blog.md` (if present)
