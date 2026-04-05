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
    Comprehensive Ethereum research skill that manages local git submodules
    (go-ethereum, forkcast, EIPs) and guides web-based research across
    ethresear.ch, blog.ethereum.org, and vitalik.eth.limo. Provides setup
    verification, automatic submodule updates, multi-source research
    procedures, and structured report generation covering protocol-level,
    code-level, and community-level analysis.
---

# Ethereum Research

Multi-source Ethereum protocol research with local submodule analysis and structured report output.

## When to Apply

Reference these guidelines when:
- Investigating Ethereum protocol, EVM, or consensus mechanisms
- Analyzing EIPs (status, content, implementation)
- Exploring go-ethereum codebase for implementation details
- Tracking hardfork history or upcoming network upgrades
- Researching Ethereum ecosystem topics (ethresear.ch, Vitalik blog, Ethereum blog)

## Skill Trigger Flow

1. **Setup Check** -- verify submodules exist in user project (see `references/setup-submodules.md`)
2. **Update** -- run `git submodule update --remote`, report changes
3. **Research** -- combine sources per question type, output structured report

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
references/setup-submodules.md    -- submodule setup commands
references/src-go-ethereum.md     -- go-ethereum code navigation
references/src-forkcast.md        -- hardfork data navigation
references/src-eips.md            -- EIP repository navigation
references/web-ethresearch.md     -- ethresear.ch search guide
references/web-ethereum-blog.md   -- Ethereum blog access
references/web-vitalik-blog.md    -- Vitalik blog access
references/report-template.md     -- research report format
references/flow-research.md       -- research procedure and source selection
```

## Quick Reference

| Source | Location | Purpose |
|--------|----------|---------|
| go-ethereum | `.ethereum-research/go-ethereum` | Protocol implementation |
| forkcast | `.ethereum-research/forkcast` | Hardfork tracking |
| EIPs | `.ethereum-research/EIPs` | EIP documents |
| ethresear.ch | https://ethresear.ch/ | Research discussions |
| Ethereum Blog | https://blog.ethereum.org/ | Official announcements |
| Vitalik Blog | https://vitalik.eth.limo/ | Protocol philosophy |

## References

- https://ethereum.org/en/developers/docs/
- https://github.com/ethereum/go-ethereum
- https://github.com/ethereum/EIPs
- https://github.com/ethereum/forkcast
- https://eips.ethereum.org/
