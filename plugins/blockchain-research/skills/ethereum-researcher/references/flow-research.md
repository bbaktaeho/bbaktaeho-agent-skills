---
title: Ethereum Source Selection -- Chain Delta
impact: CRITICAL
impactDescription: Ethereum-specific question-to-tag routing; full procedure delegated to shared base
tags: flow, source-matrix, routing, ethereum
---

# Ethereum Source Selection

The chain-agnostic 5-phase procedure lives in `plugins/blockchain-research/shared/flow.md`. Read that first.

This file documents Ethereum-specific routing only. The shared procedure intersects the tags routed here against `submodules.json` to compute the `NEEDED` submodule set.

## Output Paths

Full-mode reports are emitted to:

```
docs/research/ethereum/{YYYY-MM-DD}-{slug}.md
docs/research/ethereum/{YYYY-MM-DD}-{slug}.html
```

`{slug}` is kebab-case from the report title (for example `eip-4844-blob-gas`).

## Source Selection Matrix

| Question Type | Routed Tags | Notes |
|---------------|-------------|-------|
| Protocol or EVM internals | `evm`, `execution`, `spec` | Primary: go-ethereum, revm, EIPs. Secondary: reth, ethresear.ch, organmo blog. |
| EVM opcode-level analysis | `evm` | Primary: revm, go-ethereum `core/vm/`. Secondary: reth `crates/evm/`. |
| PoS consensus or beacon chain | `consensus`, `spec` | Primary: prysm, EIPs. Secondary: ethresear.ch, Vitalik blog. |
| EIP analysis | `spec` | Primary: EIPs, ethresear.ch. Secondary: Vitalik blog, organmo blog. |
| Hardfork tracking | `hardfork`, `execution`, `consensus` | Primary: forkcast, go-ethereum, reth, prysm. Secondary: Ethereum blog. |
| Validator operations | `consensus`, `spec` | Primary: prysm, EIPs. Secondary: ethresear.ch. |
| Multi-client comparison | `execution`, `evm` | go-ethereum vs reth vs revm. |
| General ecosystem | (web only) | All web sources, relevant repos. |

## Indexing Source Selection Matrix

When the question involves on-chain indexing concerns, prefer `indexing/idx-*.md` references in addition to the source matrix above.

| Indexing Question | Routed Tags | Indexing Lens |
|-------------------|-------------|---------------|
| Reorg handling and finality | `reorg-finality`, `consensus`, `execution` | `indexing/idx-reorg-finality.md` |
| Asset standards (ERC-20 / 721 / 1155) | `asset-standards`, `spec` | `indexing/idx-asset-standards.md` |
| RPC / API / subscription methods | `rpc`, `execution` | `indexing/idx-rpc-api.md` |
| Protocol-level value movement | `protocol-transfers`, `consensus`, `execution` | `indexing/idx-protocol-transfers.md` |
| Official indexer implementations | (web only) | `indexing/idx-official-indexers.md` |
| Event / log / ABI decoding | `event-decoding`, `evm`, `execution` | `indexing/idx-event-decoding.md` |
| Transaction envelope / encoding | `tx-envelope`, `execution`, `spec` | `indexing/idx-tx-envelope.md` |
| Commitment / archive / pruning / state sync | `state-access`, `execution` | `indexing/idx-state-access.md` |

## Repo-Level Navigation Pointers

For each repo identified by routing, consult the matching navigation file:

- go-ethereum: `references/protocol/src-go-ethereum.md`
- reth: `references/protocol/src-reth.md`
- revm: `references/protocol/src-revm.md`
- prysm: `references/protocol/src-prysm.md`
- forkcast: `references/protocol/src-forkcast.md`
- EIPs: `references/protocol/src-eips.md`

Web sources:

- ethresear.ch: `references/protocol/web-ethresearch.md`
- Ethereum blog: `references/protocol/web-ethereum-blog.md`
- Vitalik blog: `references/protocol/web-vitalik-blog.md`
- organmo blog: `references/protocol/web-organmo-blog.md`
