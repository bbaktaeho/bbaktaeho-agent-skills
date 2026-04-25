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

Tempo protocol and indexing research with local submodule analysis and a shared MD / HTML report template.

## When to Apply

Reference these guidelines when:
- Investigating Tempo protocol, Simplex BFT consensus, Commonware, Payment Lanes, Fee AMM, or Zones
- Exploring tempo, tempo-go, mpp-go, mpp-rs, or tidx codebases
- Researching Tempo indexing concerns (tidx sync, Tempo-specific tx fields, Fee AMM attribution, ABI decoding, `/query` API)
- Analyzing TIP-20, TIP-403, or Machine Payments Protocol (MPP)

## Skill Trigger Flow

1. **Path Resolution** -- ask user for submodule root or use default `.tempo-research`. See `references/setup-submodules.md`.
2. **Auto-Initialize on First Use** -- if any submodule is missing, run setup commands automatically.
3. **Update** -- run `git submodule update --remote`, report changes.
4. **Research (local-first)** -- prefer `Grep` / `Glob` / `Read` over local `<RESEARCH_ROOT>/{submodule}/`. Use `WebFetch` only for off-repo content (Tempo docs, blogs, MPP spec).
5. **Report** -- fill in `plugins/blockchain-research/templates/report.md` and `report.html` in parallel. Output to `docs/research/tempo/{YYYY-MM-DD}-{slug}.md` and `.html`.

See `references/flow-research.md` for the full procedure.

## Submodules

| Submodule | Default Path |
|-----------|-------------|
| tempo | `<RESEARCH_ROOT>/tempo` |
| tempo-go | `<RESEARCH_ROOT>/tempo-go` |
| mpp-go | `<RESEARCH_ROOT>/mpp-go` |
| mpp-rs | `<RESEARCH_ROOT>/mpp-rs` |
| tidx | `<RESEARCH_ROOT>/tidx` |

Default `<RESEARCH_ROOT>` is `.tempo-research`.

## Source Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Setup | CRITICAL | `setup-` |
| 2 | Research Flow | CRITICAL | `flow-` |
| 3 | Report Template | CRITICAL | `report-` |
| 4 | Protocol Source Code / Web | HIGH | `protocol/src-`, `protocol/web-` |
| 5 | Indexing | HIGH | `indexing/idx-` |

## How to Use

| Path | Contents |
|------|----------|
| `references/setup-submodules.md` | Submodule setup and path config |
| `references/flow-research.md` | Research procedure and source selection |
| `references/report-template.md` | How to use the shared plugin-level templates |
| `references/protocol/src-tempo.md` | tempo core navigation |
| `references/protocol/src-tempo-go.md` | tempo-go SDK navigation |
| `references/protocol/src-mpp-go.md` | mpp-go SDK navigation |
| `references/protocol/src-mpp-rs.md` | mpp-rs SDK navigation |
| `references/protocol/src-tidx.md` | tidx indexer navigation |
| `references/protocol/web-tempo-docs.md` | Tempo docs and blog navigation |
| `references/protocol/web-mpp.md` | MPP protocol docs navigation |
| `references/indexing/idx-*.md` | Indexing lens references (8 files) |

## References

- https://docs.tempo.xyz
- https://github.com/tempoxyz/tempo
- https://github.com/tempoxyz/tempo-go
- https://github.com/tempoxyz/mpp-go
- https://github.com/tempoxyz/mpp-rs
- https://github.com/tempoxyz/tidx
- https://mpp.dev
