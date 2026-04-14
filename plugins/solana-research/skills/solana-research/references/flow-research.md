---
title: Research Procedure and Source Selection
impact: CRITICAL
impactDescription: Core research procedure and source selection logic
tags: flow, procedure, research
---

# Research Procedure and Source Selection

This file defines the three-phase research procedure and the source selection logic for each question type.

All local paths below use `<RESEARCH_ROOT>` as a placeholder. Replace it with the user's configured submodule root path (default: `.solana-research`). See `references/setup-submodules.md` for path configuration details.

## Phase 1 -- Setup Check

### Step 1: Resolve Research Root Path

Ask the user for their submodule root path if not already known. If the user has not specified one, use the default `.solana-research`.

Check common locations in order:

```
ls -d .solana-research 2>/dev/null && echo "Found: .solana-research"
```

If not found at the default path, ask the user to specify where they placed (or want to place) the submodules. Once resolved, use that path as `<RESEARCH_ROOT>` for the remainder of the session.

### Step 2: Verify Submodules

```
ls <RESEARCH_ROOT>/solana/runtime/ 2>/dev/null && echo "solana: OK" || echo "solana: MISSING"
ls <RESEARCH_ROOT>/agave/core/ 2>/dev/null && echo "agave: OK" || echo "agave: MISSING"
ls <RESEARCH_ROOT>/solana-program-library/token/ 2>/dev/null && echo "solana-program-library: OK" || echo "solana-program-library: MISSING"
```

If any submodule is missing, stop and instruct the user to complete setup. Refer them to `references/setup-submodules.md` for the full setup procedure. Do not proceed with research until all three submodules are present and non-empty.

If all three are present, continue to Phase 2.

## Phase 2 -- Update

Update all submodules to their latest remote state before researching.

Run from the user project root:

```
git submodule update --remote
```

After updating, generate a change summary for each submodule.

solana recent changes:

```
git -C <RESEARCH_ROOT>/solana log --oneline -10
```

agave recent changes:

```
git -C <RESEARCH_ROOT>/agave log --oneline -10
```

solana-program-library recent changes:

```
git -C <RESEARCH_ROOT>/solana-program-library log --oneline -10
```

Report update results in this format:

```
Submodule Update Summary
------------------------
solana: <N commits fetched or "already up to date">
  Recent: <first log line>
agave: <N commits fetched or "already up to date">
  Recent: <first log line>
solana-program-library: <N commits fetched or "already up to date">
  Recent: <first log line>
```

If the update fails due to network issues, proceed with the locally cached version and note the caveat in the final report.

## Phase 3 -- Research

### Source Selection Matrix

Select sources based on the question type. Use multiple sources when the question spans categories.

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

### Source Navigation

For each selected source, use the corresponding reference file for navigation instructions:

- solana runtime: see `references/src-solana.md`
- agave validator: see `references/src-agave.md`
- solana-program-library: see `references/src-spl.md`
- forum.solana.com: see `references/web-solana-forum.md`
- Solana and Anza blogs: see `references/web-solana-blog.md`

### Report Assembly

After gathering information from all relevant sources, assemble the final report using the template defined in `references/report-template.md`.

## Multi-Level Analysis Requirement

Every research report must cover all three levels of analysis. No level may be omitted.

| Level | Description |
|-------|-------------|
| Protocol level | SIMD specifications, consensus rules, design rationale, PoH/Tower BFT mechanics |
| Code level | solana, agave, and solana-program-library packages, implementation details, file and line references |
| Community level | forum.solana.com threads, Solana blog posts, Anza engineering posts, open discussions |

If a level cannot be covered due to missing sources or irrelevance, explicitly note why in the report rather than silently skipping it.
