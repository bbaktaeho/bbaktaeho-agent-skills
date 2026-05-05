---
name: ethereum-researcher
description: >
  Ethereum protocol and on-chain indexing research, combining local
  submodule-based source analysis (go-ethereum, reth, revm, prysm, forkcast,
  EIPs) with web research (ethresear.ch, Ethereum blog, Vitalik blog, organmo
  blog). Use this skill whenever the user is investigating EVM internals,
  EIPs, hardforks, PoS consensus, beacon chain, execution clients, or
  Ethereum indexing concerns - reorg and finality, ERC-20 / ERC-721 /
  ERC-1155 asset standards, JSON-RPC and WebSocket methods, protocol-level
  value movement (block rewards, base fee burn, priority fee, EIP-4895
  withdrawals, MEV-Boost), transaction envelopes (legacy, EIP-2718, 2930,
  1559, 4844, 7702), state access and archive / pruning (snap sync,
  checkpoint sync, EIP-4444), event / log / ABI decoding, Blockscout /
  Erigon / reth ExEx reference indexers - even if they just ask "how does X
  work" or "why does Y behave this way" without the word "research".
license: MIT
metadata:
  author: bbaktaeho
  version: "2.0.0"
  date: April 2026
  abstract: >
    Ethereum-specific research skill covering protocol analysis and on-chain
    data indexing. Submodule-based local source navigation for go-ethereum,
    reth, revm, prysm, forkcast, and the EIPs repository. Web research
    across ethresear.ch, Ethereum blog, Vitalik blog, and organmo blog.
    Produces structured reports from the plugin-level shared template
    (plugins/blockchain-research/templates/report.md and report.html) with
    required Mermaid / SVG visualizations, covering protocol-level,
    code-level, and community-level analysis.
---

# Ethereum Researcher

Ethereum protocol and indexing research. Procedure delegated to `plugins/blockchain-research/shared/`. Chain-specific source matrix and submodule manifest live in this skill.

## When to Apply

Reference these guidelines when:
- Investigating Ethereum protocol, EVM, consensus, EIPs, or hardforks
- Exploring go-ethereum, reth, revm, or prysm codebases
- Researching Ethereum indexing concerns (reorg / finality, ERC standards, JSON-RPC, protocol-level transfers, event decoding, tx envelopes, state access)
- Comparing Ethereum reference indexers (Blockscout, Erigon, reth ExEx, The Graph)

## Trigger Flow

1. **Resolution & Mode** -- see `plugins/blockchain-research/shared/flow.md` Phase 1. Mode auto-detected from message; explicit `quick:` / `full:` prefix overrides.
2. **Source Routing** -- read this skill's `references/flow-research.md` Source Selection Matrix; intersect routed tags against `submodules.json`.
3. **Init Policy** -- shared Phase 2: skip-if-present, ask-on-missing.
4. **Update Cache** -- shared Phase 3: 24-hour TTL per submodule, force-refresh on user request.
5. **Research** -- shared Phase 4: local-first, `WebFetch` only for off-repo content.
6. **Output** -- shared Phase 5: quick = inline; full = emit MD + HTML to `docs/research/ethereum/{YYYY-MM-DD}-{slug}.{md,html}`.

Setup procedure: see `plugins/blockchain-research/shared/setup.md`. Manifest schema: see `plugins/blockchain-research/shared/manifest.md`. Ethereum manifest: see `submodules.json` next to this file.

## Submodule Manifest

See `submodules.json` (this skill's directory). Default research root: `.ethereum-research`. Submodules: go-ethereum, reth, revm, prysm, forkcast, EIPs.

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
| `references/flow-research.md` | Ethereum Source Selection Matrix and chain output paths |
| `references/setup-submodules.md` | Ethereum-specific setup deltas (verify commands, default root) |
| `references/report-template.md` | How to use the shared plugin-level templates |
| `references/protocol/src-*.md` | Per-repo navigation (go-ethereum, reth, revm, prysm, forkcast, EIPs) |
| `references/protocol/web-*.md` | Per-source navigation (ethresear.ch, Ethereum blog, Vitalik blog, organmo blog) |
| `references/indexing/idx-*.md` | Indexing lens references |

## References

- https://ethereum.org/en/developers/docs/
- https://github.com/ethereum/go-ethereum
- https://github.com/paradigmxyz/reth
- https://github.com/bluealloy/revm
- https://github.com/offchainlabs/prysm
- https://github.com/ethereum/EIPs
- https://github.com/ethereum/forkcast
