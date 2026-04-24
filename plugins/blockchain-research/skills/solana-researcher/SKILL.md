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

Solana protocol and indexing research with local submodule analysis and a shared MD / HTML report template.

## When to Apply

Reference these guidelines when:
- Investigating Solana protocol, SVM, PoH, Tower BFT, Sealevel, Gulf Stream, Turbine, or SIMDs
- Exploring solana, agave, or solana-program-library codebases
- Researching Solana indexing concerns (commitment levels, Geyser, RPC / gRPC, SPL standards, program log decoding, versioned tx / ALT, inner instructions, epoch rewards)
- Comparing Solana reference indexers (Helius, Yellowstone / Triton, Shyft, Solscan)

## Skill Trigger Flow

1. **Path Resolution** -- ask user for submodule root or use default `.solana-research`. See `references/setup-submodules.md`.
2. **Auto-Initialize on First Use** -- if any submodule is missing, run setup commands automatically.
3. **Update** -- run `git submodule update --remote`, report changes.
4. **Research (local-first)** -- prefer `Grep` / `Glob` / `Read` over local `<RESEARCH_ROOT>/{submodule}/`. Use `WebFetch` only for off-repo content (forum threads, blogs, PRs, SIMDs).
5. **Report** -- fill in `plugins/blockchain-research/templates/report.md` and `report.html` in parallel. Output to `docs/research/solana/{YYYY-MM-DD}-{slug}.md` and `.html`.

See `references/flow-research.md` for the full procedure.

## Submodules

| Submodule | Default Path |
|-----------|-------------|
| solana | `<RESEARCH_ROOT>/solana` |
| agave | `<RESEARCH_ROOT>/agave` |
| solana-program-library | `<RESEARCH_ROOT>/solana-program-library` |

Default `<RESEARCH_ROOT>` is `.solana-research`.

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
| `references/protocol/src-solana.md` | solana (runtime, core, poh, turbine) navigation |
| `references/protocol/src-agave.md` | agave (validator, svm, geyser) navigation |
| `references/protocol/src-spl.md` | solana-program-library navigation |
| `references/protocol/web-solana-forum.md` | forum.solana.com navigation |
| `references/protocol/web-solana-blog.md` | Solana and Anza blog navigation |
| `references/indexing/idx-*.md` | Indexing lens references (8 files) |

## References

- https://solana.com/docs
- https://github.com/solana-labs/solana
- https://github.com/anza-xyz/agave
- https://github.com/solana-labs/solana-program-library
- https://github.com/solana-foundation/solana-improvement-documents
- https://forum.solana.com/
