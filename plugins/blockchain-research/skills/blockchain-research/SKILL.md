---
name: blockchain-research
description: >
  Multi-chain blockchain protocol research combining local submodule-based
  source analysis with web research. Use when investigating Ethereum protocol,
  EVM, EIPs, hardforks, go-ethereum, reth, revm, prysm; Solana protocol, SVM,
  SIMDs, PoH, Tower BFT, Turbine, Sealevel, agave, SPL programs; or Tempo
  chain, TIP-20, TIP-403, MPP (Machine Payments Protocol), Simplex BFT,
  Payment Lanes, Fee AMM, Tempo Transactions, Zones.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: >
    Comprehensive multi-chain blockchain research skill supporting Ethereum,
    Solana, and Tempo. Provides user-configurable submodule paths per chain,
    setup verification, automatic updates, multi-source research procedures,
    and structured report generation covering protocol-level, code-level, and
    community-level analysis. Ethereum covers go-ethereum, reth, revm, prysm,
    forkcast, and EIPs. Solana covers solana, agave, and solana-program-library.
    Tempo covers tempo core, tempo-go SDK, mpp-go, and mpp-rs.
---

# Blockchain Research

Multi-chain protocol research with local submodule analysis and structured report output.

## When to Apply

Reference these guidelines when:
- Investigating Ethereum protocol, EVM, consensus, EIPs, or hardforks
- Investigating Solana protocol, SVM, PoH, Tower BFT, SIMDs, or SPL programs
- Investigating Tempo chain, TIP-20, MPP, Simplex BFT, Payment Lanes, or Zones
- Exploring client codebases (go-ethereum, reth, revm, prysm, agave, tempo, tempo-go)
- Researching cross-chain comparisons or general blockchain ecosystem topics

## Skill Trigger Flow

1. **Chain Detection** -- determine which chain(s) to research based on the question
2. **Path Resolution** -- ask user for submodule root path or use defaults (see `references/setup-submodules.md`)
3. **Setup Check** -- verify submodules exist at the resolved path
4. **Update** -- run `git submodule update --remote`, report changes
5. **Research** -- combine sources per question type, output structured report

All reference files use `<RESEARCH_ROOT>` as a placeholder for the per-chain submodule root path.

See `references/flow-research.md` for the full research procedure.

## Supported Chains

| Chain | Default Root | Submodules |
|-------|-------------|------------|
| Ethereum | `.ethereum-research` | go-ethereum, reth, revm, prysm, forkcast, EIPs |
| Solana | `.solana-research` | solana, agave, solana-program-library |
| Tempo | `.tempo-research` | tempo, tempo-go, mpp-go, mpp-rs |

## Source Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Setup | CRITICAL | `setup-` |
| 2 | Source Code Navigation | CRITICAL | `src-` |
| 3 | Research Flow | CRITICAL | `flow-` |
| 4 | Report | CRITICAL | `report-` |
| 5 | Web Sources | HIGH | `web-` |

## How to Use

Reference files are organized by chain under `references/`:

| Path | Contents |
|------|----------|
| `setup-submodules.md` | Submodule setup and path config (all chains) |
| `flow-research.md` | Research procedure and source selection (all chains) |
| `report-template.md` | Research report format |
| `ethereum/` | src-go-ethereum, src-reth, src-revm, src-prysm, src-forkcast, src-eips, web-ethresearch, web-ethereum-blog, web-vitalik-blog, web-organmo-blog |
| `solana/` | src-solana, src-agave, src-spl, web-solana-forum, web-solana-blog |
| `tempo/` | src-tempo, src-tempo-go, src-mpp-go, src-mpp-rs, src-tidx, web-tempo-docs, web-mpp |

## References

- https://ethereum.org/en/developers/docs/
- https://github.com/ethereum/go-ethereum
- https://github.com/paradigmxyz/reth
- https://solana.com/docs
- https://github.com/anza-xyz/agave
- https://docs.tempo.xyz
- https://github.com/tempoxyz/tempo
- https://github.com/tempoxyz/tidx
- https://mpp.dev
