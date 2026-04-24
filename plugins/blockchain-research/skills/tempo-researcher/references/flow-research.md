---
title: Tempo Research Procedure and Source Selection
impact: CRITICAL
impactDescription: Core research procedure and source selection logic for Tempo
tags: flow, procedure, research, tempo
---

# Tempo Research Procedure

This file defines the four-phase research procedure and the source selection logic for Tempo research.

All local paths use `<RESEARCH_ROOT>` as a placeholder. Replace it with the user's configured submodule root path. See `references/setup-submodules.md` for path configuration.

## Phase 1 -- Setup Check

### Step 1: Resolve Research Root Path

Ask the user for their submodule root path if not already known. Default: `.tempo-research`.

### Step 2: Verify Submodules

```bash
ls <RESEARCH_ROOT>/tempo/crates/ 2>/dev/null && echo "tempo: OK" || echo "tempo: MISSING"
ls <RESEARCH_ROOT>/tempo-go/ 2>/dev/null && echo "tempo-go: OK" || echo "tempo-go: MISSING"
ls <RESEARCH_ROOT>/mpp-go/ 2>/dev/null && echo "mpp-go: OK" || echo "mpp-go: MISSING"
ls <RESEARCH_ROOT>/mpp-rs/crates/ 2>/dev/null && echo "mpp-rs: OK" || echo "mpp-rs: MISSING"
ls <RESEARCH_ROOT>/tidx/src/ 2>/dev/null && echo "tidx: OK" || echo "tidx: MISSING"
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
| Simplex BFT consensus | tempo core code | Tempo docs, Paradigm blog |
| EVM execution (Reth SDK) | tempo core code | Tempo docs |
| TIP-20 token standard | tempo core `contracts/` | Tempo docs, tempo-std |
| TIP-403 policy registry | tempo core `contracts/` | Tempo docs |
| Payment Lanes | tempo core code | Tempo docs |
| Fee AMM mechanism | tempo core code | Tempo docs |
| Tempo Transactions (Type 0x76) | tempo core, tempo-go | Tempo docs |
| MPP protocol (Machine Payments) | mpp-go, mpp-rs, mpp-specs (web) | mpp.dev, paymentauth.org |
| MPP charge intent | mpp-go, mpp-rs | mpp-specs |
| MPP session intent | mpp-go, mpp-rs | mpp-specs |
| Go SDK / client integration | tempo-go | Tempo docs |
| Zones (privacy layer) | tempo core, Tempo docs | Tempo blog |
| On-chain data analysis (raw) | tidx `db/` schema, `src/types.rs` | Tempo docs |
| Indexed data queries (SQL) | tidx `/query` API, `db/functions.sql` | tidx README |
| Tempo-specific tx fields (fee delegation, nonce key, validity) | tidx `db/txs.sql`, `src/types.rs` | tempo core |
| ABI event decoding | tidx `src/service/mod.rs`, `db/functions.sql` | tidx API |
| Sync pipeline / reorg handling | tidx `src/sync/engine.rs` | -- |
| General Tempo ecosystem | all Tempo web sources, relevant repos | Tempo blog |

### Indexing Source Selection Matrix

When the question involves on-chain data indexing concerns, prefer `indexing/idx-*.md` references in addition to the source matrix above.

| Indexing Question | Primary Sources | Secondary Sources |
|-------------------|-----------------|-------------------|
| Reorg handling and finality | `indexing/idx-reorg-finality.md` + `protocol/src-tempo.md`, `protocol/src-tidx.md` | Tempo docs |
| Asset standards (TIP-20, ERC-721) | `indexing/idx-asset-standards.md` + `protocol/src-tempo.md` | Tempo docs |
| RPC / `/query` API / subscription methods | `indexing/idx-rpc-api.md` + `protocol/src-tempo.md`, `protocol/src-tidx.md` | tidx README |
| Protocol-level value movement (Fee AMM, Payment Lanes) | `indexing/idx-protocol-transfers.md` + `protocol/src-tempo.md` | Tempo docs |
| Official indexer (tidx) | `indexing/idx-official-indexers.md` + `protocol/src-tidx.md` | tidx README |
| Event / log / ABI decoding | `indexing/idx-event-decoding.md` + `protocol/src-tidx.md`, `protocol/src-tempo.md` | tidx ABI registry |
| Transaction envelope (legacy + Type 0x76) | `indexing/idx-tx-envelope.md` + `protocol/src-tempo.md`, `protocol/src-tempo-go.md`, `protocol/src-tidx.md` | Tempo docs |
| State access / commitment / archive | `indexing/idx-state-access.md` + `protocol/src-tempo.md`, `protocol/src-tidx.md` | Tempo docs |

### Source Navigation

For each selected source, use the corresponding reference file for navigation instructions:

- tempo: `references/protocol/src-tempo.md`
- tempo-go: `references/protocol/src-tempo-go.md`
- mpp-go: `references/protocol/src-mpp-go.md`
- mpp-rs: `references/protocol/src-mpp-rs.md`
- tidx: `references/protocol/src-tidx.md`
- Tempo docs / blog: `references/protocol/web-tempo-docs.md`
- MPP protocol docs: `references/protocol/web-mpp.md`

### Local-First Research Policy

Once submodules are initialized, **always prefer local file access over web fetches** for code-level questions. The submodules are the authoritative snapshot, they are already on disk, and local search is both faster and less restricted than `WebFetch`.

Preferred tool order:

1. `Grep` with `path` pointed at `<RESEARCH_ROOT>/{submodule}/` -- keyword or regex search across a codebase.
2. `Glob` with `path` pointed at `<RESEARCH_ROOT>/{submodule}/` -- locate files by name pattern.
3. `Read` with an absolute local path -- read specific files and line ranges.
4. `WebFetch` against github.com or upstream docs -- only when the information is not in the submodule.

Use local for:

- "What does tidx index about Tempo fee delegation?" -- Read `<RESEARCH_ROOT>/tidx/src/types.rs`.
- "Where is the Simplex BFT consensus code?" -- Grep `<RESEARCH_ROOT>/tempo/crates/`.
- "How does tidx handle reorgs?" -- Read `<RESEARCH_ROOT>/tidx/src/sync/engine.rs`.
- "Show me the MPP charge intent handler" -- Grep `<RESEARCH_ROOT>/mpp-go/` or `<RESEARCH_ROOT>/mpp-rs/`.

Use web for:

- Tempo docs pages and blog posts.
- MPP specification (mpp.dev, paymentauth.org).
- Paradigm blog posts on Simplex / Commonware.
- Open pull requests, issues, or release notes on GitHub.
- Community discussion that the submodule itself does not contain.

If you find yourself reaching for `WebFetch` on a code-level question, stop and check the local submodule first. Cite files with the `<RESEARCH_ROOT>/{repo}/{path}:{line}` format defined in `references/report-template.md`.

### Report Assembly

After gathering information from all relevant sources, assemble the final report using the shared template referenced from `references/report-template.md`. Emit both the Markdown and HTML versions into `docs/research/tempo/{YYYY-MM-DD}-{slug}.md` and `.html`.

## Multi-Level Analysis Requirement

Every research report must cover all three levels of analysis. No level may be omitted.

| Level | Description |
|-------|-------------|
| Protocol level | Specifications, TIPs, consensus rules, design rationale |
| Code level | Client implementations, packages, file and line references |
| Community level | Tempo docs, blog posts, MPP spec, Paradigm blog |

If a level cannot be covered due to missing sources or irrelevance, explicitly note why in the report rather than silently skipping it.
