---
name: solana-researcher
description: >
  Solana protocol and on-chain indexing research, combining local
  submodule-based source analysis (solana, agave, solana-program-library)
  with web research (forum.solana.com, Solana blog, Anza engineering blog).
  Use this skill whenever the user is investigating SVM internals, SIMDs,
  PoH (Proof of History), Tower BFT, Turbine, Sealevel parallel execution,
  Gulf Stream, leader schedule, SPL Token / Token-2022 / Metaplex, Anchor
  programs, or Solana indexing concerns - commitment levels (processed /
  confirmed / finalized / rooted), Geyser plugins, Yellowstone gRPC,
  Helius, JSON-RPC and WebSocket methods (getBlock, getTransaction,
  getSignaturesForAddress, logsSubscribe, accountSubscribe), inner
  instructions, program logs, Anchor emit! events, IDL / Borsh decoding,
  compute units and cost model, versioned transactions and Address Lookup
  Tables, stake accounts, epoch rewards, Associated Token Accounts - even
  if they just ask "how does X work" or "why does Y behave this way"
  without the word "research".
license: MIT
metadata:
  author: bbaktaeho
  version: "2.0.0"
  date: April 2026
  abstract: >
    Solana-specific research skill covering protocol analysis and on-chain
    data indexing. Submodule-based local source navigation for solana,
    agave, and solana-program-library. Web research across forum.solana.com,
    Solana blog, and Anza engineering blog. Produces structured reports
    from the plugin-level shared template (plugins/blockchain-research/
    templates/report.md and report.html) with required Mermaid / SVG
    visualizations, covering protocol-level, code-level, and
    community-level analysis.
---

# Solana Researcher

Solana protocol and indexing research. Procedure delegated to `plugins/blockchain-research/shared/`. Chain-specific source matrix and submodule manifest live in this skill.

## When to Apply

Reference these guidelines when:
- Investigating Solana protocol, SVM, PoH, Tower BFT, Sealevel, Gulf Stream, Turbine, or SIMDs
- Exploring solana, agave, or solana-program-library codebases
- Researching Solana indexing concerns (commitment levels, Geyser, RPC / gRPC, SPL standards, program log decoding, versioned tx / ALT, inner instructions, epoch rewards)
- Comparing Solana reference indexers (Helius, Yellowstone / Triton, Shyft, Solscan)

## Trigger Flow

1. **Resolution & Mode** -- see `plugins/blockchain-research/shared/flow.md` Phase 1. Mode auto-detected from message; explicit `quick:` / `full:` prefix overrides.
2. **Source Routing** -- read this skill's `references/flow-research.md` Source Selection Matrix; intersect routed tags against `submodules.json`.
3. **Init Policy** -- shared Phase 2: skip-if-present, ask-on-missing.
4. **Update Cache** -- shared Phase 3: 24-hour TTL per submodule, force-refresh on user request.
5. **Research** -- shared Phase 4: local-first, `WebFetch` only for off-repo content.
6. **Output** -- shared Phase 5: quick = inline; full = emit MD + HTML to `docs/research/solana/{YYYY-MM-DD}-{slug}.{md,html}`.

Setup procedure: see `plugins/blockchain-research/shared/setup.md`. Manifest schema: see `plugins/blockchain-research/shared/manifest.md`. Solana manifest: see `submodules.json` next to this file.

## Submodule Manifest

See `submodules.json` (this skill's directory). Default research root: `.solana-research`. Submodules: solana, agave, solana-program-library.

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
| `references/flow-research.md` | Solana Source Selection Matrix and chain output paths |
| `references/setup-submodules.md` | Solana-specific setup deltas (verify commands, default root) |
| `references/report-template.md` | How to use the shared plugin-level templates |
| `references/protocol/src-*.md` | Per-repo navigation |
| `references/protocol/web-*.md` | Per-source navigation |
| `references/indexing/idx-*.md` | Indexing lens references |

## References

- https://docs.solana.com/
- https://github.com/solana-labs/solana
- https://github.com/anza-xyz/agave
- https://github.com/solana-labs/solana-program-library
- https://forum.solana.com/
