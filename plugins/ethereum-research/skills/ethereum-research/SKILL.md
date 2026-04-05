---
name: ethereum-research
description: >
  Ethereum protocol research combining local submodule-based source analysis
  with web research. Use when investigating Ethereum protocol, EVM internals,
  EIPs, hardforks, go-ethereum codebase, or Ethereum ecosystem discussions.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: >
    Comprehensive Ethereum research skill with user-configurable submodule
    paths (go-ethereum, reth, revm, prysm, forkcast, EIPs) and web-based
    research across ethresear.ch, blog.ethereum.org, vitalik.eth.limo, and
    medium.com/@organmo. Covers execution layer (go-ethereum, reth/revm) and
    consensus layer (prysm) with multi-client comparison support. Provides
    path configuration, setup verification, automatic submodule updates,
    multi-source research procedures, and structured report generation covering
    protocol-level, code-level, and community-level analysis.
---

# Ethereum Research

Multi-source Ethereum protocol research with local submodule analysis and structured report output.

## When to Apply

Reference these guidelines when:
- Investigating Ethereum protocol, EVM, or consensus mechanisms
- Analyzing EIPs (status, content, implementation)
- Exploring go-ethereum, reth, revm (EL) or prysm (CL) codebase for implementation details
- Tracking hardfork history or upcoming network upgrades
- Researching Ethereum ecosystem topics (ethresear.ch, Vitalik blog, Ethereum blog)

## Skill Trigger Flow

1. **Path Resolution** -- ask user for submodule root path or use default `.ethereum-research` (see `references/setup-submodules.md`)
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
references/setup-submodules.md    -- submodule setup and path configuration
references/src-go-ethereum.md     -- go-ethereum (EL, Go) code navigation
references/src-reth.md            -- reth (EL, Rust) code navigation
references/src-revm.md            -- revm (EVM, Rust) code navigation
references/src-prysm.md           -- prysm (CL, Go) beacon chain code navigation
references/src-forkcast.md        -- hardfork data navigation
references/src-eips.md            -- EIP repository navigation
references/web-ethresearch.md     -- ethresear.ch search guide
references/web-ethereum-blog.md   -- Ethereum blog access
references/web-vitalik-blog.md    -- Vitalik blog access
references/web-organmo-blog.md    -- organmo researcher blog access
references/report-template.md     -- research report format
references/flow-research.md       -- research procedure and source selection
```

## Quick Reference

| Source | Location | Purpose |
|--------|----------|---------|
| go-ethereum | `<RESEARCH_ROOT>/go-ethereum` | Execution layer (Go) |
| reth | `<RESEARCH_ROOT>/reth` | Execution layer (Rust) |
| revm | `<RESEARCH_ROOT>/revm` | EVM implementation (Rust, used by reth) |
| prysm | `<RESEARCH_ROOT>/prysm` | Consensus layer (beacon chain) |
| forkcast | `<RESEARCH_ROOT>/forkcast` | Hardfork tracking |
| EIPs | `<RESEARCH_ROOT>/EIPs` | EIP documents |
| ethresear.ch | https://ethresear.ch/ | Research discussions |
| Ethereum Blog | https://blog.ethereum.org/ | Official announcements |
| Vitalik Blog | https://vitalik.eth.limo/ | Protocol philosophy |
| organmo Blog | https://medium.com/@organmo | Researcher analysis |

## References

- https://ethereum.org/en/developers/docs/
- https://github.com/ethereum/go-ethereum
- https://github.com/ethereum/EIPs
- https://github.com/ethereum/forkcast
- https://eips.ethereum.org/
- https://github.com/paradigmxyz/reth
- https://github.com/bluealloy/revm
- https://github.com/offchainlabs/prysm
- https://medium.com/@organmo
