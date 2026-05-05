---
name: tempo-researcher
description: >
  Tempo chain protocol and on-chain indexing research, combining local
  submodule-based source analysis (tempo, tempo-go, mpp-go, mpp-rs, tidx)
  with web research (Tempo docs, Tempo blog, MPP specification, Paradigm
  blog). Use this skill whenever the user is investigating Tempo protocol,
  Simplex BFT consensus, Commonware framework, Payment Lanes, Fee AMM,
  Zones privacy layer, TIP-20 token standard, TIP-403 policy registry,
  Tempo Transactions (Type 0x76), fee delegation, nonce key, validity
  window, MPP (Machine Payments Protocol), charge intent, session intent,
  or Tempo indexing concerns - tidx sync pipeline and reorg handling,
  Reth-compatible JSON-RPC plus Commonware gRPC, ABI decoding via tidx
  registry, Tempo-specific transaction fields (fee delegator, nonce key,
  validity window), Fee AMM attribution, Payment Lane settlements, or the
  `/query` API - even if they just ask "how does X work" or "why does Y
  behave this way" without the word "research".
license: MIT
metadata:
  author: bbaktaeho
  version: "2.0.0"
  date: April 2026
  abstract: >
    Tempo-specific research skill covering protocol analysis and on-chain
    data indexing. Submodule-based local source navigation for tempo core,
    tempo-go SDK, mpp-go, mpp-rs, and tidx. Web research across Tempo docs,
    Tempo blog, and MPP specification. Produces structured reports from the
    plugin-level shared template (plugins/blockchain-research/templates/
    report.md and report.html) with required Mermaid / SVG visualizations,
    covering protocol-level, code-level, and community-level analysis.
---

# Tempo Researcher

Tempo protocol and indexing research. Procedure delegated to `plugins/blockchain-research/shared/`. Chain-specific source matrix and submodule manifest live in this skill.

## When to Apply

Reference these guidelines when:
- Investigating Tempo protocol, Simplex BFT consensus, Commonware, Payment Lanes, Fee AMM, or Zones
- Exploring tempo, tempo-go, mpp-go, mpp-rs, or tidx codebases
- Researching Tempo indexing concerns (tidx sync, Tempo-specific tx fields, Fee AMM attribution, ABI decoding, `/query` API)
- Analyzing TIP-20, TIP-403, or Machine Payments Protocol (MPP)

## Trigger Flow

1. **Resolution & Mode** -- see `plugins/blockchain-research/shared/flow.md` Phase 1. Mode auto-detected from message; explicit `quick:` / `full:` prefix overrides.
2. **Source Routing** -- read this skill's `references/flow-research.md` Source Selection Matrix; intersect routed tags against `submodules.json`.
3. **Init Policy** -- shared Phase 2: skip-if-present, ask-on-missing.
4. **Update Cache** -- shared Phase 3: 24-hour TTL per submodule, force-refresh on user request.
5. **Research** -- shared Phase 4: local-first, `WebFetch` only for off-repo content.
6. **Output** -- shared Phase 5: quick = inline; full = emit MD + HTML to `docs/research/tempo/{YYYY-MM-DD}-{slug}.{md,html}`.

Setup procedure: see `plugins/blockchain-research/shared/setup.md`. Manifest schema: see `plugins/blockchain-research/shared/manifest.md`. Tempo manifest: see `submodules.json` next to this file.

## Submodule Manifest

See `submodules.json` (this skill's directory). Default research root: `.tempo-research`. Submodules: tempo, tempo-go, mpp-go, mpp-rs, tidx.

## Source Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Research Flow (chain-specific source matrix) | CRITICAL | `flow-` |
| 2 | Report Template | CRITICAL | `report-` |
| 3 | Protocol Source Code / Web | HIGH | `protocol/src-`, `protocol/web-` |
| 4 | Indexing | HIGH | `indexing/idx-` |

## How to Use

| Path | Contents |
|------|----------|
| `references/flow-research.md` | Tempo Source Selection Matrix and chain output paths |
| `references/setup-submodules.md` | Tempo-specific setup deltas (verify commands, default root) |
| `references/report-template.md` | How to use the shared plugin-level templates |
| `references/protocol/src-*.md` | Per-repo navigation |
| `references/protocol/web-*.md` | Per-source navigation |
| `references/indexing/idx-*.md` | Indexing lens references |

## References

- Tempo docs (per spec)
- https://github.com/tempoxyz/tempo
- https://github.com/tempoxyz/tempo-go
- https://github.com/tempoxyz/mpp-go
- https://github.com/tempoxyz/mpp-rs
- https://github.com/tempoxyz/tidx
