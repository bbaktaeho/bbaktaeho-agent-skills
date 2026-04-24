---
title: Ethereum Research Procedure and Source Selection
impact: CRITICAL
impactDescription: Core research procedure and source selection logic for Ethereum
tags: flow, procedure, research, ethereum
---

# Ethereum Research Procedure

This file defines the four-phase research procedure and the source selection logic for Ethereum research.

All local paths use `<RESEARCH_ROOT>` as a placeholder. Replace it with the user's configured submodule root path. See `references/setup-submodules.md` for path configuration.

## Phase 1 -- Setup Check

### Step 1: Resolve Research Root Path

Ask the user for their submodule root path if not already known. Default: `.ethereum-research`.

### Step 2: Verify Submodules

```bash
ls <RESEARCH_ROOT>/go-ethereum/core/ 2>/dev/null && echo "go-ethereum: OK" || echo "go-ethereum: MISSING"
ls <RESEARCH_ROOT>/reth/crates/ 2>/dev/null && echo "reth: OK" || echo "reth: MISSING"
ls <RESEARCH_ROOT>/revm/crates/interpreter/ 2>/dev/null && echo "revm: OK" || echo "revm: MISSING"
ls <RESEARCH_ROOT>/prysm/beacon-chain/ 2>/dev/null && echo "prysm: OK" || echo "prysm: MISSING"
ls <RESEARCH_ROOT>/forkcast/ 2>/dev/null && echo "forkcast: OK" || echo "forkcast: MISSING"
ls <RESEARCH_ROOT>/EIPs/EIPS/ 2>/dev/null && echo "EIPs: OK" || echo "EIPs: MISSING"
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
| Protocol or EVM internals | go-ethereum code, revm, EIPs | reth, ethresear.ch, organmo blog |
| EVM opcode-level analysis | revm, go-ethereum `core/vm/` | reth `crates/evm/` |
| PoS consensus or beacon chain | prysm code, EIPs | ethresear.ch, Vitalik blog |
| EIP analysis | EIPs repo, ethresear.ch | Vitalik blog, organmo blog |
| Hardfork tracking | forkcast, go-ethereum, reth, prysm | Ethereum blog |
| Validator operations | prysm code, EIPs | ethresear.ch |
| Multi-client comparison | go-ethereum, reth, revm | prysm |
| General ecosystem | all web sources, relevant repos | organmo blog |

### Indexing Source Selection Matrix

When the question involves on-chain data indexing concerns (reorg / finality, asset standards, RPC methods, protocol-level transfers, official indexers, event decoding, transaction envelopes, or state commitment), prefer `indexing/idx-*.md` references in addition to the source matrix above.

| Indexing Question | Primary Sources | Secondary Sources |
|-------------------|-----------------|-------------------|
| Reorg handling and finality | `indexing/idx-reorg-finality.md` + `protocol/src-prysm.md`, `protocol/src-go-ethereum.md` | `indexing/idx-state-access.md` |
| Asset standards (ERC-20 / 721 / 1155) | `indexing/idx-asset-standards.md` + `protocol/src-eips.md` | Ethereum docs |
| RPC / API / subscription methods | `indexing/idx-rpc-api.md` + `protocol/src-go-ethereum.md`, `protocol/src-reth.md` | Ethereum docs |
| Protocol-level value movement | `indexing/idx-protocol-transfers.md` + `protocol/src-prysm.md`, `protocol/src-go-ethereum.md` | EIPs (1559, 4895) |
| Official indexer implementations | `indexing/idx-official-indexers.md` | Ethereum blogs |
| Event / log / ABI decoding | `indexing/idx-event-decoding.md` + `protocol/src-revm.md`, `protocol/src-go-ethereum.md` | Ethereum docs |
| Transaction envelope / encoding | `indexing/idx-tx-envelope.md` + `protocol/src-go-ethereum.md`, `protocol/src-reth.md` | EIPs (2718, 2930, 1559, 4844, 7702) |
| Commitment / archive / pruning / state sync | `indexing/idx-state-access.md` + `protocol/src-go-ethereum.md`, `protocol/src-reth.md` | EIP-4444 |

### Source Navigation

For each selected source, use the corresponding reference file for navigation instructions:

- go-ethereum: `references/protocol/src-go-ethereum.md`
- reth: `references/protocol/src-reth.md`
- revm: `references/protocol/src-revm.md`
- prysm: `references/protocol/src-prysm.md`
- forkcast: `references/protocol/src-forkcast.md`
- EIPs: `references/protocol/src-eips.md`
- ethresear.ch: `references/protocol/web-ethresearch.md`
- Ethereum blog: `references/protocol/web-ethereum-blog.md`
- Vitalik blog: `references/protocol/web-vitalik-blog.md`
- organmo blog: `references/protocol/web-organmo-blog.md`

### Local-First Research Policy

Once submodules are initialized, **always prefer local file access over web fetches** for code-level questions. The submodules are the authoritative snapshot, they are already on disk, and local search is both faster and less restricted than `WebFetch`.

Preferred tool order:

1. `Grep` with `path` pointed at `<RESEARCH_ROOT>/{submodule}/` -- keyword or regex search across a codebase.
2. `Glob` with `path` pointed at `<RESEARCH_ROOT>/{submodule}/` -- locate files by name pattern.
3. `Read` with an absolute local path -- read specific files and line ranges.
4. `WebFetch` against github.com or upstream docs -- only when the information is not in the submodule.

Use local for:

- "How does geth verify a block header?" -- Grep / Read in `<RESEARCH_ROOT>/go-ethereum/consensus/`.
- "Where is the EIP-1559 base fee logic in reth?" -- Grep in `<RESEARCH_ROOT>/reth/crates/`.
- "What does prysm do during fork choice?" -- Grep in `<RESEARCH_ROOT>/prysm/beacon-chain/forkchoice/`.
- "Show me the revm opcode implementation for CALL" -- Read `<RESEARCH_ROOT>/revm/crates/interpreter/src/instructions/`.

Use web for:

- Forum or research threads (ethresear.ch).
- Official blog posts (ethereum.org, Vitalik, organmo).
- Open pull requests, issues, or release notes on GitHub.
- Off-repo specifications (Yellow Paper).
- Community discussion that the submodule itself does not contain.

If you find yourself reaching for `WebFetch` on a code-level question, stop and check the local submodule first. Cite files with the `<RESEARCH_ROOT>/{repo}/{path}:{line}` format defined in `references/report-template.md`.

### Report Assembly

After gathering information from all relevant sources, assemble the final report using the shared template referenced from `references/report-template.md`. Emit both the Markdown and HTML versions into `docs/research/ethereum/{YYYY-MM-DD}-{slug}.md` and `.html`.

## Multi-Level Analysis Requirement

Every research report must cover all three levels of analysis. No level may be omitted.

| Level | Description |
|-------|-------------|
| Protocol level | Specifications, EIPs, consensus rules, design rationale |
| Code level | Client implementations, packages, file and line references, cross-client comparison |
| Community level | Forum threads, blog posts, official announcements, open discussions |

If a level cannot be covered due to missing sources or irrelevance, explicitly note why in the report rather than silently skipping it.
