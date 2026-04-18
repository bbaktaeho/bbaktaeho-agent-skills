---
name: blockchain-research
description: >
  Multi-chain blockchain protocol and on-chain data indexing research
  combining local submodule-based source analysis with web research. Use
  when investigating Ethereum protocol, EVM, EIPs, hardforks, go-ethereum,
  reth, revm, prysm; Solana protocol, SVM, SIMDs, PoH, Tower BFT, Turbine,
  Sealevel, agave, SPL programs; or Tempo chain, TIP-20, TIP-403, MPP
  (Machine Payments Protocol), Simplex BFT, Payment Lanes, Fee AMM, Tempo
  Transactions, Zones. Also use when researching on-chain data indexing
  concerns: reorg handling, finality and commitment levels, ABI / IDL
  decoding, asset standards (ERC-20, ERC-721, ERC-1155, SPL Token, TIP-20),
  RPC / gRPC / WebSocket methods, protocol-level value movement (block
  rewards, fee recipients, withdrawals, MEV payments), transaction envelope
  formats, state access and archive / pruning, or official indexer
  implementations (Blockscout, Helius, tidx).
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
- Researching on-chain data indexing concerns (reorg, finality, asset standards, RPC, protocol-level transfers, event decoding, transaction envelopes, state commitment)
- Comparing official indexer implementations across chains
- Researching cross-chain comparisons or general blockchain ecosystem topics

## Skill Trigger Flow

1. **Chain Detection** -- determine which chain(s) to research based on the question
2. **Path Resolution** -- ask user for submodule root path or use defaults (see `references/setup-submodules.md`)
3. **Auto-Initialize on First Use** -- if any submodule is missing, automatically run the setup commands from `references/setup-submodules.md`. Do not ask first; initialization is a required prerequisite for this skill
4. **Update** -- run `git submodule update --remote`, report changes
5. **Research (local-first)** -- prefer `Grep` / `Glob` / `Read` over local `<RESEARCH_ROOT>/{submodule}/` paths. Use `WebFetch` only when the answer is not in the submodule (forum threads, blog posts, PRs, off-repo specs)
6. **Report** -- output structured report per `references/report-template.md`

All reference files use `<RESEARCH_ROOT>` as a placeholder for the per-chain submodule root path.

See `references/flow-research.md` for the full research procedure, including auto-initialization and local-first policy.

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
| 6 | Indexing | HIGH | `idx-` |

## How to Use

Reference files are organized by chain under `references/`:

| Path | Contents |
|------|----------|
| `setup-submodules.md` | Submodule setup and path config (all chains) |
| `flow-research.md` | Research procedure and source selection (all chains) |
| `report-template.md` | Research report format |
| `idx-reorg-finality.md` | Reorg and finality model comparison (all chains) |
| `idx-state-access.md` | Commitment levels, archive, pruning, state sync |
| `idx-rpc-api.md` | RPC / gRPC / subscription method comparison |
| `idx-tx-envelope.md` | Transaction envelope formats and encoding |
| `idx-event-decoding.md` | Log / event / ABI / IDL decoding patterns |
| `idx-asset-standards.md` | Token and asset standards (all chains) |
| `idx-protocol-transfers.md` | Block rewards, fee recipients, withdrawals, MEV |
| `idx-official-indexers.md` | Reference indexer implementations per chain |
| `ethereum/` | Per-source navigation for go-ethereum, reth, revm, prysm, forkcast, EIPs + ethresear.ch, Ethereum/Vitalik/organmo blogs |
| `solana/` | Per-source navigation for solana, agave, solana-program-library + forum.solana.com, Solana/Anza blogs |
| `tempo/` | Per-source navigation for tempo, tempo-go, mpp-go, mpp-rs, tidx + Tempo docs, MPP spec |

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
