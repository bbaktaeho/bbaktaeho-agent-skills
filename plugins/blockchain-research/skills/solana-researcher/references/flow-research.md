---
title: Solana Research Procedure and Source Selection
impact: CRITICAL
impactDescription: Core research procedure and source selection logic for Solana
tags: flow, procedure, research, solana
---

# Solana Research Procedure

This file defines the four-phase research procedure and the source selection logic for Solana research.

All local paths use `<RESEARCH_ROOT>` as a placeholder. Replace it with the user's configured submodule root path. See `references/setup-submodules.md` for path configuration.

## Phase 1 -- Setup Check

### Step 1: Resolve Research Root Path

Ask the user for their submodule root path if not already known. Default: `.solana-research`.

### Step 2: Verify Submodules

```bash
ls <RESEARCH_ROOT>/solana/runtime/ 2>/dev/null && echo "solana: OK" || echo "solana: MISSING"
ls <RESEARCH_ROOT>/agave/core/ 2>/dev/null && echo "agave: OK" || echo "agave: MISSING"
ls <RESEARCH_ROOT>/solana-program-library/token/ 2>/dev/null && echo "solana-program-library: OK" || echo "solana-program-library: MISSING"
```

### Step 3: Auto-Initialize Missing Submodules (First Use)

If any submodule reports MISSING in Step 2, **automatically** run the corresponding `git submodule add` + `git submodule update --init --recursive` commands from `references/setup-submodules.md`. Do not stop to ask for permission -- submodule initialization is a required prerequisite for this skill and is expected to run on first use.

After running the setup commands, re-run the Step 2 verification. If verification still fails (network failure, upstream repo moved, auth issues, etc.), report the specific failure to the user and point them to `references/setup-submodules.md` for manual recovery. Only proceed to Phase 2 when all submodules are present and non-empty.

## Phase 2 -- Update

Update submodules to their latest remote state before researching.

```bash
git submodule update --remote
```

Generate a change summary for each relevant submodule using:

```bash
git -C <RESEARCH_ROOT>/{submodule} log --oneline -10
```

Report update results:

```
Submodule Update Summary
------------------------
{submodule}: <N commits fetched or "already up to date">
  Recent: <first log line>
```

If the update fails due to network issues, proceed with the locally cached version and note the caveat in the final report.

## Phase 3 -- Research

### Source Selection Matrix

| Question Type | Primary Sources | Secondary Sources |
|---------------|----------------|-------------------|
| Runtime or SVM internals | solana `runtime/`, agave `core/` | forum.solana.com, Anza blog |
| PoH (Proof of History) | solana `poh/`, agave `poh/` | SIMDs, Solana blog |
| Tower BFT consensus | solana `core/consensus/`, agave `core/` | SIMDs, forum.solana.com |
| Sealevel parallel execution | solana `runtime/`, agave `svm/` | Solana blog, Anza blog |
| Gulf Stream transaction forwarding | solana `core/banking_stage/`, agave `core/` | forum.solana.com |
| Turbine block propagation | solana `turbine/`, agave `turbine/` | SIMDs |
| SIMD analysis | SIMDs repo (web), forum.solana.com | Solana blog, Anza blog |
| SPL program analysis | solana-program-library | Solana docs |
| Token or Token-2022 | solana-program-library `token/`, `token/program-2022/` | Solana docs |
| General ecosystem | all web sources, relevant repos | forum.solana.com |

### Indexing Source Selection Matrix

When the question involves on-chain data indexing concerns (reorg / finality, asset standards, RPC methods, protocol-level transfers, official indexers, event decoding, transaction envelopes, or state commitment), prefer `indexing/idx-*.md` references in addition to the source matrix above.

| Indexing Question | Primary Sources | Secondary Sources |
|-------------------|-----------------|-------------------|
| Commitment levels / finality | `indexing/idx-reorg-finality.md` + `protocol/src-solana.md`, `protocol/src-agave.md` | `indexing/idx-state-access.md` |
| Asset standards (SPL Token, Token-2022, Metaplex) | `indexing/idx-asset-standards.md` + `protocol/src-spl.md` | Solana docs |
| RPC / gRPC / subscription methods | `indexing/idx-rpc-api.md` + `protocol/src-solana.md`, `protocol/src-agave.md` | Solana docs, Yellowstone docs |
| Protocol-level value movement | `indexing/idx-protocol-transfers.md` + `protocol/src-solana.md` | SIMDs, Solana economics |
| Official indexer implementations | `indexing/idx-official-indexers.md` | Solana / Anza blogs |
| Event / log / IDL / inner instruction decoding | `indexing/idx-event-decoding.md` + `protocol/src-solana.md`, `protocol/src-spl.md` | Anchor docs |
| Transaction envelope / versioned tx / ALT | `indexing/idx-tx-envelope.md` + `protocol/src-solana.md` | Solana docs (versioned transactions) |
| Commitment / archive / pruning / Geyser | `indexing/idx-state-access.md` + `protocol/src-solana.md`, `protocol/src-agave.md` | Solana Geyser docs |

### Source Navigation

For each selected source, use the corresponding reference file for navigation instructions:

- solana: `references/protocol/src-solana.md`
- agave: `references/protocol/src-agave.md`
- solana-program-library: `references/protocol/src-spl.md`
- forum.solana.com: `references/protocol/web-solana-forum.md`
- Solana and Anza blogs: `references/protocol/web-solana-blog.md`

### Local-First Research Policy

Once submodules are initialized, **always prefer local file access over web fetches** for code-level questions. The submodules are the authoritative snapshot, they are already on disk, and local search is both faster and less restricted than `WebFetch`.

Preferred tool order:

1. `Grep` with `path` pointed at `<RESEARCH_ROOT>/{submodule}/` -- keyword or regex search across a codebase.
2. `Glob` with `path` pointed at `<RESEARCH_ROOT>/{submodule}/` -- locate files by name pattern.
3. `Read` with an absolute local path -- read specific files and line ranges.
4. `WebFetch` against github.com or upstream docs -- only when the information is not in the submodule.

Use local for:

- "How does agave implement Tower BFT?" -- Grep / Read in `<RESEARCH_ROOT>/agave/core/`.
- "Where is the PoH verifier?" -- Grep in `<RESEARCH_ROOT>/solana/poh/`.
- "Which SPL Token instructions exist?" -- Grep in `<RESEARCH_ROOT>/solana-program-library/token/program/`.
- "Show me the Geyser plugin interface" -- Read `<RESEARCH_ROOT>/agave/geyser-plugin-interface/`.

Use web for:

- Forum or research threads (forum.solana.com).
- Official blog posts (solana.com, Anza).
- Open pull requests, issues, or release notes on GitHub.
- Off-repo specifications (SIMDs, Yellowstone gRPC).
- Community discussion that the submodule itself does not contain.

If you find yourself reaching for `WebFetch` on a code-level question, stop and check the local submodule first. Cite files with the `<RESEARCH_ROOT>/{repo}/{path}:{line}` format defined in `references/report-template.md`.

### Report Assembly

After gathering information from all relevant sources, assemble the final report using the shared template referenced from `references/report-template.md`. Emit both the Markdown and HTML versions into `docs/research/solana/{YYYY-MM-DD}-{slug}.md` and `.html`.

## Multi-Level Analysis Requirement

Every research report must cover all three levels of analysis. No level may be omitted.

| Level | Description |
|-------|-------------|
| Protocol level | Specifications, SIMDs, consensus rules, design rationale |
| Code level | Client implementations, packages, file and line references |
| Community level | Forum threads, blog posts, official announcements, open discussions |

If a level cannot be covered due to missing sources or irrelevance, explicitly note why in the report rather than silently skipping it.
