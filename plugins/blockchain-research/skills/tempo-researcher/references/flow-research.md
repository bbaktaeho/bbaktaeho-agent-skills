---
title: Tempo Source Selection -- Chain Delta
impact: CRITICAL
impactDescription: Tempo-specific question-to-tag routing; full procedure delegated to shared base
tags: flow, source-matrix, routing, tempo
---

# Tempo Source Selection

The chain-agnostic 5-phase procedure lives in `plugins/blockchain-research/shared/flow.md`. Read that first.

This file documents Tempo-specific routing only.

## Output Paths

Full-mode reports are emitted to:

```
docs/research/tempo/{YYYY-MM-DD}-{slug}.md
docs/research/tempo/{YYYY-MM-DD}-{slug}.html
```

`{slug}` is kebab-case from the report title.

## Source Selection Matrix

| Question Type | Routed Tags | Notes |
|---------------|-------------|-------|
| Tempo protocol or Simplex BFT | `protocol`, `consensus` | Primary: tempo. Secondary: web (Tempo docs, Paradigm blog). |
| TIP-20 / TIP-403 | `protocol` | Primary: tempo. Secondary: web (Tempo docs, MPP spec). |
| Tempo Transactions (Type 0x76), fee delegation, validity window | `tx-envelope`, `protocol` | Primary: tempo, tempo-go. |
| MPP (Machine Payments Protocol) | `mpp`, `payments` | Primary: mpp-go, mpp-rs. Secondary: web (MPP spec). |
| Indexing pipeline (tidx) | `indexer`, `decoding` | Primary: tidx. |
| RPC / `/query` API | `rpc`, `indexer` | Primary: tempo, tidx, tempo-go. |
| SDK usage | `sdk` | Primary: tempo-go. |

## Indexing Source Selection Matrix

| Indexing Question | Routed Tags | Indexing Lens |
|-------------------|-------------|---------------|
| tidx sync pipeline and reorg handling | `indexer` | `indexing/idx-tidx-sync.md` (if present) |
| Reth-compatible JSON-RPC plus Commonware gRPC | `rpc`, `indexer` | `indexing/idx-rpc-grpc.md` (if present) |
| ABI decoding via tidx registry | `decoding`, `indexer` | `indexing/idx-abi-decoding.md` (if present) |
| Tempo-specific transaction fields | `tx-envelope`, `protocol` | `indexing/idx-tempo-tx.md` (if present) |
| Fee AMM attribution, Payment Lane settlements | `payments`, `mpp` | `indexing/idx-fee-amm.md` (if present) |

If any indexing lens file referenced above does not exist in `references/indexing/`, fall back to the source matrix and the relevant repo navigation file.

## Repo-Level Navigation Pointers

- tempo: `references/protocol/src-tempo.md` (if present)
- tempo-go: `references/protocol/src-tempo-go.md` (if present)
- mpp-go: `references/protocol/src-mpp-go.md` (if present)
- mpp-rs: `references/protocol/src-mpp-rs.md` (if present)
- tidx: `references/protocol/src-tidx.md` (if present)

Web sources:

- Tempo docs: `references/protocol/web-tempo-docs.md` (if present)
- Tempo blog: `references/protocol/web-tempo-blog.md` (if present)
- MPP spec: `references/protocol/web-mpp-spec.md` (if present)
- Paradigm blog: `references/protocol/web-paradigm-blog.md` (if present)
