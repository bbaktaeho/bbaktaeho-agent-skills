---
title: Research Procedure and Source Selection
impact: CRITICAL
impactDescription: Core research procedure and source selection logic
tags: flow, procedure, research
---

# Research Procedure and Source Selection

This file defines the three-phase research procedure and the source selection logic for each question type.

All local paths below use `<RESEARCH_ROOT>` as a placeholder. Replace it with the user's configured submodule root path (default: `.ethereum-research`). See `references/setup-submodules.md` for path configuration details.

## Phase 1 -- Setup Check

### Step 1: Resolve Research Root Path

Ask the user for their submodule root path if not already known. If the user has not specified one, use the default `.ethereum-research`.

Check common locations in order:

```
ls -d .ethereum-research 2>/dev/null && echo "Found: .ethereum-research"
```

If not found at the default path, ask the user to specify where they placed (or want to place) the submodules. Once resolved, use that path as `<RESEARCH_ROOT>` for the remainder of the session.

### Step 2: Verify Submodules

```
ls <RESEARCH_ROOT>/go-ethereum/core/ 2>/dev/null && echo "go-ethereum: OK" || echo "go-ethereum: MISSING"
ls <RESEARCH_ROOT>/reth/crates/ 2>/dev/null && echo "reth: OK" || echo "reth: MISSING"
ls <RESEARCH_ROOT>/revm/crates/interpreter/ 2>/dev/null && echo "revm: OK" || echo "revm: MISSING"
ls <RESEARCH_ROOT>/prysm/beacon-chain/ 2>/dev/null && echo "prysm: OK" || echo "prysm: MISSING"
ls <RESEARCH_ROOT>/forkcast/ 2>/dev/null && echo "forkcast: OK" || echo "forkcast: MISSING"
ls <RESEARCH_ROOT>/EIPs/EIPS/ 2>/dev/null && echo "EIPs: OK" || echo "EIPs: MISSING"
```

If any submodule is missing, stop and instruct the user to complete setup. Refer them to `references/setup-submodules.md` for the full setup procedure. Do not proceed with research until all six submodules are present and non-empty.

If all three are present, continue to Phase 2.

## Phase 2 -- Update

Update all submodules to their latest remote state before researching.

Run from the user project root:

```
git submodule update --remote
```

After updating, generate a change summary for each submodule.

go-ethereum recent changes:

```
git -C <RESEARCH_ROOT>/go-ethereum log --oneline -10
```

reth recent changes:

```
git -C <RESEARCH_ROOT>/reth log --oneline -10
```

revm recent changes:

```
git -C <RESEARCH_ROOT>/revm log --oneline -10
```

prysm recent changes:

```
git -C <RESEARCH_ROOT>/prysm log --oneline -10
```

forkcast recent changes:

```
git -C <RESEARCH_ROOT>/forkcast log --oneline -10
```

EIPs recent changes:

```
git -C <RESEARCH_ROOT>/EIPs log --oneline -10
```

Report update results in this format:

```
Submodule Update Summary
------------------------
go-ethereum: <N commits fetched or "already up to date">
  Recent: <first log line>
reth: <N commits fetched or "already up to date">
  Recent: <first log line>
revm: <N commits fetched or "already up to date">
  Recent: <first log line>
prysm: <N commits fetched or "already up to date">
  Recent: <first log line>
forkcast: <N commits fetched or "already up to date">
  Recent: <first log line>
EIPs: <N commits fetched or "already up to date">
  Recent: <first log line>
```

If the update fails due to network issues, proceed with the locally cached version and note the caveat in the final report.

## Phase 3 -- Research

### Source Selection Matrix

Select sources based on the question type. Use multiple sources when the question spans categories.

| Question Type | Primary Sources | Secondary Sources |
|---------------|----------------|-------------------|
| Protocol or EVM internals | go-ethereum code, revm, EIPs | reth, ethresear.ch, organmo blog |
| EVM opcode-level analysis | revm, go-ethereum `core/vm/` | reth `crates/evm/` |
| PoS consensus or beacon chain | prysm code, EIPs | ethresear.ch, Vitalik blog |
| EIP analysis | EIPs repo, ethresear.ch | Vitalik blog, organmo blog |
| Hardfork tracking | forkcast, go-ethereum, reth, prysm | Ethereum blog |
| Validator operations | prysm code, EIPs | ethresear.ch |
| Multi-client comparison | go-ethereum, reth, revm | prysm |
| General ecosystem | all web sources, relevant repos | organmo blog |

### Source Navigation

For each selected source, use the corresponding reference file for navigation instructions:

- go-ethereum code: see `references/src-go-ethereum.md`
- reth code: see `references/src-reth.md`
- revm EVM: see `references/src-revm.md`
- prysm beacon chain: see `references/src-prysm.md`
- forkcast data: see `references/src-forkcast.md`
- EIPs repository: see `references/src-eips.md`
- ethresear.ch: see `references/web-ethresearch.md`
- Ethereum blog: see `references/web-ethereum-blog.md`
- Vitalik blog: see `references/web-vitalik-blog.md`
- organmo blog: see `references/web-organmo-blog.md`

### Report Assembly

After gathering information from all relevant sources, assemble the final report using the template defined in `references/report-template.md`.

## Multi-Level Analysis Requirement

Every research report must cover all three levels of analysis. No level may be omitted.

| Level | Description |
|-------|-------------|
| Protocol level | Specification, EIPs, consensus rules, design rationale |
| Code level | go-ethereum, reth, revm, and prysm packages, implementation details, file and line references |
| Community level | ethresear.ch threads, blog posts, Vitalik writings, organmo writings, open discussions |

If a level cannot be covered due to missing sources or irrelevance, explicitly note why in the report rather than silently skipping it.
