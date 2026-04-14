---
name: solana-research
description: >
  Solana protocol research combining local submodule-based source analysis
  with web research. Use when investigating Solana protocol, SVM internals,
  SIMDs, PoH, Tower BFT, Turbine, Sealevel, solana-labs/solana codebase,
  agave validator client, SPL programs, or Solana ecosystem discussions.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: >
    Comprehensive Solana research skill with user-configurable submodule
    paths (solana, agave, solana-program-library) and web-based research
    across forum.solana.com, solana.com/news, anza.xyz/blog, and SIMD
    documents. Covers the validator runtime (solana, agave), SPL programs,
    PoH, Tower BFT, Sealevel parallel execution, and Gulf Stream transaction
    forwarding. Provides path configuration, setup verification, automatic
    submodule updates, multi-source research procedures, and structured
    report generation covering protocol-level, code-level, and
    community-level analysis.
---

# Solana Research

Multi-source Solana protocol research with local submodule analysis and structured report output.

## When to Apply

Reference these guidelines when:
- Investigating Solana protocol, SVM, PoH, or consensus mechanisms (Tower BFT)
- Analyzing SIMDs (Solana Improvement Documents)
- Exploring solana, agave, or solana-program-library codebase for implementation details
- Understanding Sealevel parallel execution, Gulf Stream, or Turbine block propagation
- Researching Solana ecosystem topics (forum, Anza blog, Solana blog)

## Skill Trigger Flow

1. **Path Resolution** -- ask user for submodule root path or use default `.solana-research` (see `references/setup-submodules.md`)
2. **Setup Check** -- verify submodules exist at the resolved path
3. **Update** -- run `git submodule update --remote`, report changes
4. **Research** -- combine sources per question type, output structured report

All reference files use `<RESEARCH_ROOT>` as a placeholder for the submodule root path. Replace with the user's configured path.

See `references/flow-research.md` for the full research procedure.

## Source Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Setup | CRITICAL | `setup-` |
| 2 | Source Code Navigation | CRITICAL | `src-` |
| 3 | Research Flow | CRITICAL | `flow-` |
| 4 | Report | CRITICAL | `report-` |
| 5 | Web Sources | HIGH | `web-` |

## How to Use

Read reference files for navigation guides and procedures:

```
references/setup-submodules.md      -- submodule setup and path configuration
references/src-solana.md            -- solana-labs/solana runtime code navigation
references/src-agave.md             -- anza-xyz/agave validator client code navigation
references/src-spl.md               -- solana-program-library SPL programs navigation
references/web-solana-forum.md      -- forum.solana.com search guide
references/web-solana-blog.md       -- Solana and Anza blog access
references/report-template.md       -- research report format
references/flow-research.md         -- research procedure and source selection
```

## Quick Reference

| Source | Location | Purpose |
|--------|----------|---------|
| solana | `<RESEARCH_ROOT>/solana` | Validator runtime, SVM, PoH (Rust) |
| agave | `<RESEARCH_ROOT>/agave` | Agave validator client -- active fork of solana (Rust) |
| solana-program-library | `<RESEARCH_ROOT>/solana-program-library` | SPL programs (Token, Token-2022, etc.) |
| forum.solana.com | https://forum.solana.com/ | Protocol and developer discussions |
| Solana Blog | https://solana.com/news | Official announcements |
| Anza Blog | https://www.anza.xyz/blog | Agave client engineering posts |
| SIMDs | https://github.com/solana-foundation/solana-improvement-documents | Improvement proposals |

## References

- https://solana.com/docs
- https://github.com/solana-labs/solana
- https://github.com/anza-xyz/agave
- https://github.com/solana-labs/solana-program-library
- https://github.com/solana-foundation/solana-improvement-documents
- https://docs.anza.xyz/
- https://forum.solana.com/
