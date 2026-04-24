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

Ethereum protocol and indexing research with local submodule analysis and a shared MD / HTML report template.

## When to Apply

Reference these guidelines when:
- Investigating Ethereum protocol, EVM, consensus, EIPs, or hardforks
- Exploring go-ethereum, reth, revm, or prysm codebases
- Researching Ethereum indexing concerns (reorg / finality, ERC standards, JSON-RPC, protocol-level transfers, event decoding, tx envelopes, state access)
- Comparing Ethereum reference indexers (Blockscout, Erigon, reth ExEx, The Graph)

## Skill Trigger Flow

1. **Path Resolution** -- ask user for submodule root or use default `.ethereum-research`. See `references/setup-submodules.md`.
2. **Auto-Initialize on First Use** -- if any submodule is missing, run setup commands automatically.
3. **Update** -- run `git submodule update --remote`, report changes.
4. **Research (local-first)** -- prefer `Grep` / `Glob` / `Read` over local `<RESEARCH_ROOT>/{submodule}/`. Use `WebFetch` only for off-repo content (threads, blogs, PRs).
5. **Report** -- fill in `plugins/blockchain-research/templates/report.md` and `report.html` in parallel. Output to `docs/research/ethereum/{YYYY-MM-DD}-{slug}.md` and `.html`.

See `references/flow-research.md` for the full procedure.

## Submodules

| Submodule | Default Path |
|-----------|-------------|
| go-ethereum | `<RESEARCH_ROOT>/go-ethereum` |
| reth | `<RESEARCH_ROOT>/reth` |
| revm | `<RESEARCH_ROOT>/revm` |
| prysm | `<RESEARCH_ROOT>/prysm` |
| forkcast | `<RESEARCH_ROOT>/forkcast` |
| EIPs | `<RESEARCH_ROOT>/EIPs` |

Default `<RESEARCH_ROOT>` is `.ethereum-research`.

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
| `references/protocol/src-go-ethereum.md` | go-ethereum navigation |
| `references/protocol/src-reth.md` | reth navigation |
| `references/protocol/src-revm.md` | revm navigation |
| `references/protocol/src-prysm.md` | prysm navigation |
| `references/protocol/src-forkcast.md` | forkcast navigation |
| `references/protocol/src-eips.md` | EIPs repo navigation |
| `references/protocol/web-ethresearch.md` | ethresear.ch navigation |
| `references/protocol/web-ethereum-blog.md` | Ethereum blog navigation |
| `references/protocol/web-vitalik-blog.md` | Vitalik blog navigation |
| `references/protocol/web-organmo-blog.md` | organmo blog navigation |
| `references/indexing/idx-*.md` | Indexing lens references (8 files) |

## References

- https://ethereum.org/en/developers/docs/
- https://github.com/ethereum/go-ethereum
- https://github.com/paradigmxyz/reth
- https://github.com/bluealloy/revm
- https://github.com/offchainlabs/prysm
- https://github.com/ethereum/EIPs
- https://github.com/ethereum/forkcast
