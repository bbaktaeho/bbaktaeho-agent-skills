# blockchain-research: Modes, On-demand Init, Update Cache, Researcher Base — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the three blockchain-research skills (ethereum-researcher, solana-researcher, tempo-researcher) onto a shared researcher base, and add four behavioral changes — quick/full mode branching, disk footprint choice at setup, ask-on-missing submodule init, and 24-hour update cache.

**Architecture:** Create a plugin-level `shared/` directory holding chain-agnostic procedure references (`flow.md`, `setup.md`, `manifest.md`). Add a per-chain `submodules.json` data file describing each repo (URL, default path, verify path, group, source-matrix tags, optional size). Each chain skill's `SKILL.md`, `setup-submodules.md`, and `flow-research.md` shrink to chain-specific deltas (source matrix, output paths, default research root) and delegate to shared references for procedure. Behavioral additions — modes, init policy, cache — live in `shared/flow.md` and read the per-chain manifest as data.

**Tech Stack:** Markdown (SKILL.md, references), JSON (manifest, marketplace.json, plugin.json), Bash (validate-skills.sh, init logic via tool calls in skill execution), Git submodules.

**Spec:** None (agreed conversationally in session 2026-05-01). Captured directly in this plan.

---

## File Structure

### New shared base (chain-agnostic)

| Path | Responsibility |
|------|----------------|
| `plugins/blockchain-research/shared/_README.md` | Authoring notes — what `shared/` is, how chain skills consume it |
| `plugins/blockchain-research/shared/manifest.md` | Schema doc for `submodules.json` |
| `plugins/blockchain-research/shared/setup.md` | Chain-agnostic setup procedure (path resolution, manifest-driven `git submodule add`, `.gitignore`, verification) |
| `plugins/blockchain-research/shared/flow.md` | The 5-phase research procedure with modes, init policy, update cache |

### New per-chain manifests (data)

| Path | Responsibility |
|------|----------------|
| `plugins/blockchain-research/skills/ethereum-researcher/submodules.json` | Ethereum repos manifest |
| `plugins/blockchain-research/skills/solana-researcher/submodules.json` | Solana repos manifest |
| `plugins/blockchain-research/skills/tempo-researcher/submodules.json` | Tempo repos manifest |

### Modified per-chain references (shrunk to chain-specific deltas)

| Path | Change |
|------|--------|
| `plugins/blockchain-research/skills/{chain}-researcher/SKILL.md` | Trigger Flow rewritten to delegate to `shared/flow.md`, mention modes and on-demand init |
| `plugins/blockchain-research/skills/{chain}-researcher/references/setup-submodules.md` | Body shrunk; defers to `shared/setup.md`, keeps only chain-specific defaults & verify commands |
| `plugins/blockchain-research/skills/{chain}-researcher/references/flow-research.md` | Body shrunk; defers to `shared/flow.md`, keeps only the chain-specific Source Selection Matrix |

### Plugin metadata bump

| Path | Change |
|------|--------|
| `plugins/blockchain-research/.claude-plugin/plugin.json` | Bump version `2.0.0` -> `3.0.0`, append behavior summary to description |
| `.claude-plugin/marketplace.json` | Update `blockchain-research` description to mention modes and on-demand init |

### Validation

| Path | Use |
|------|-----|
| `.github/scripts/validate-skills.sh` | Run after every chunk to confirm SKILL.md body <= 100 lines and metadata still valid |

---

## Chunk A: Shared Base + Per-Chain Manifests

This chunk introduces the shared base and the manifest data files. No skill behavior changes yet — the per-chain skills still point at their existing references. We finish this chunk with everything green so later chunks can rewire one chain at a time.

### Task A1: Create `shared/` directory and authoring notes

**Files:**
- Create: `plugins/blockchain-research/shared/_README.md`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p plugins/blockchain-research/shared
```

- [ ] **Step 2: Write `_README.md`**

Create `plugins/blockchain-research/shared/_README.md`:

```markdown
---
title: Blockchain Research Shared Base
impact: CRITICAL
impactDescription: Shared procedure references consumed by every chain-specific researcher skill
tags: shared, base, authoring, blockchain-research
---

# Blockchain Research Shared Base

This directory holds chain-agnostic procedure references shared by all chain-specific researcher skills under `plugins/blockchain-research/skills/`.

## Files

| File | Role |
|------|------|
| `manifest.md` | JSON schema doc for the per-chain `submodules.json` data file |
| `setup.md` | Path resolution, manifest-driven submodule install, verification |
| `flow.md` | The 5-phase research procedure: setup, init policy, update cache, research, report (mode-dependent) |

## Consumption Pattern

Each chain skill keeps only chain-specific deltas in its own `references/`:

- `references/setup-submodules.md` -- chain default research root, verify-commands list, deferral pointer
- `references/flow-research.md` -- chain Source Selection Matrix, deferral pointer
- `submodules.json` -- chain repos data (URL, default path, verify path, group, tags)

The bulk of the procedure lives in `shared/flow.md` and `shared/setup.md`. When updating procedure, edit shared files; when updating chain-specific routing, edit per-chain files.

## Adding a New Chain

1. Create `plugins/blockchain-research/skills/{chain}-researcher/`.
2. Add `submodules.json` per `manifest.md` schema.
3. Author SKILL.md with chain description + Trigger Flow that defers to `shared/flow.md`.
4. Author `references/flow-research.md` with the chain Source Selection Matrix only.
5. Author `references/setup-submodules.md` with chain default root + verify commands only.
6. Run `bash .github/scripts/validate-skills.sh`.

## Authoring Constraints

- Keep SKILL.md body <= 100 lines (validator enforces).
- No emoji anywhere (project rule from CLAUDE.md).
- All code examples belong in references, not in SKILL.md.
```

- [ ] **Step 3: Commit**

```bash
git add plugins/blockchain-research/shared/_README.md
git commit -m "docs(blockchain-research): add shared base authoring notes"
```

---

### Task A2: Define `shared/manifest.md` (JSON schema)

**Files:**
- Create: `plugins/blockchain-research/shared/manifest.md`

- [ ] **Step 1: Write the schema doc**

Create `plugins/blockchain-research/shared/manifest.md`:

```markdown
---
title: Submodule Manifest Schema
impact: CRITICAL
impactDescription: Defines the per-chain submodules.json shape consumed by shared setup and flow procedures
tags: manifest, schema, submodules, json, blockchain-research
---

# Submodule Manifest Schema

Each chain-specific researcher skill ships one `submodules.json` file at `plugins/blockchain-research/skills/{chain}-researcher/submodules.json`. The shared `setup.md` and `flow.md` procedures read this file as the single source of truth for which repos to clone, where to put them, how to verify a healthy clone, and which question types route to each repo.

## Top-Level Shape

```json
{
  "defaultRoot": "<string>",
  "submodules": [ <Submodule> ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `defaultRoot` | string | yes | Default research root path. Example: `.ethereum-research`. The user may override at first setup. |
| `submodules` | array | yes | One entry per repo. Order is irrelevant; tags drive routing. |

## `Submodule` Object

```json
{
  "name": "<string>",
  "url": "<string>",
  "verifyPath": "<string>",
  "group": "<string>",
  "tags": ["<string>"],
  "sizeApprox": "<string>"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Directory name under the research root. Must match the leaf in the `git submodule add` target path. |
| `url` | string | yes | Git URL passed to `git submodule add`. |
| `verifyPath` | string | yes | Relative path inside the cloned repo whose existence indicates a healthy clone. Example: `core/` for go-ethereum. Used by `shared/setup.md` verification step. |
| `group` | string | yes | Coarse grouping label used in user-facing prompts (for example `execution`, `consensus`, `spl`, `mpp`). Drives the bundle picker fallback offered at first setup. |
| `tags` | array of strings | yes | Source-matrix routing tags. Used by `shared/flow.md` Phase 2 to decide which submodules a question needs. Examples: `evm`, `rpc`, `consensus`, `decoding`. |
| `sizeApprox` | string | no | Human-readable size estimate (for example `~1.2 GB`). Shown in the on-demand install prompt. Omit for repos whose size is unknown. |

## Example

The Ethereum manifest is the reference shape:

```json
{
  "defaultRoot": ".ethereum-research",
  "submodules": [
    {
      "name": "go-ethereum",
      "url": "https://github.com/ethereum/go-ethereum",
      "verifyPath": "core/",
      "group": "execution",
      "tags": ["execution", "evm", "rpc", "tx-envelope"],
      "sizeApprox": "~1.2 GB"
    }
  ]
}
```

## Routing

`shared/flow.md` consumes the manifest in two places:

1. **Phase 1 / setup** -- iterate `submodules[]` to render `git submodule add` commands and verification `ls` checks.
2. **Phase 2 / on-demand init** -- when the chain Source Selection Matrix routes a question to a tag, look up which submodules carry that tag and ask the user about installing only those.

## Validation

`submodules.json` is data, not a Claude-readable reference. The pre-commit hook does not parse it today; correctness is the author's responsibility. When adding a new manifest, sanity-check with:

```bash
jq . plugins/blockchain-research/skills/{chain}-researcher/submodules.json
```
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/shared/manifest.md
git commit -m "docs(blockchain-research): add submodule manifest schema"
```

---

### Task A3: Create `submodules.json` for each chain

**Files:**
- Create: `plugins/blockchain-research/skills/ethereum-researcher/submodules.json`
- Create: `plugins/blockchain-research/skills/solana-researcher/submodules.json`
- Create: `plugins/blockchain-research/skills/tempo-researcher/submodules.json`

- [ ] **Step 1: Write the Ethereum manifest**

Create `plugins/blockchain-research/skills/ethereum-researcher/submodules.json`:

```json
{
  "defaultRoot": ".ethereum-research",
  "submodules": [
    {
      "name": "go-ethereum",
      "url": "https://github.com/ethereum/go-ethereum",
      "verifyPath": "core/",
      "group": "execution",
      "tags": ["execution", "evm", "rpc", "tx-envelope", "state-access", "event-decoding"],
      "sizeApprox": "~1.2 GB"
    },
    {
      "name": "reth",
      "url": "https://github.com/paradigmxyz/reth",
      "verifyPath": "crates/",
      "group": "execution",
      "tags": ["execution", "evm", "rpc", "tx-envelope", "state-access"],
      "sizeApprox": "~500 MB"
    },
    {
      "name": "revm",
      "url": "https://github.com/bluealloy/revm",
      "verifyPath": "crates/interpreter/",
      "group": "execution",
      "tags": ["evm", "event-decoding"],
      "sizeApprox": "~150 MB"
    },
    {
      "name": "prysm",
      "url": "https://github.com/offchainlabs/prysm",
      "verifyPath": "beacon-chain/",
      "group": "consensus",
      "tags": ["consensus", "reorg-finality", "protocol-transfers"],
      "sizeApprox": "~600 MB"
    },
    {
      "name": "forkcast",
      "url": "https://github.com/ethereum/forkcast",
      "verifyPath": ".",
      "group": "spec",
      "tags": ["hardfork", "spec"],
      "sizeApprox": "~50 MB"
    },
    {
      "name": "EIPs",
      "url": "https://github.com/ethereum/EIPs",
      "verifyPath": "EIPS/",
      "group": "spec",
      "tags": ["spec", "asset-standards", "tx-envelope"],
      "sizeApprox": "~80 MB"
    }
  ]
}
```

- [ ] **Step 2: Write the Solana manifest**

Create `plugins/blockchain-research/skills/solana-researcher/submodules.json`:

```json
{
  "defaultRoot": ".solana-research",
  "submodules": [
    {
      "name": "solana",
      "url": "https://github.com/solana-labs/solana.git",
      "verifyPath": "runtime/",
      "group": "client",
      "tags": ["svm", "consensus", "rpc", "tx-envelope"],
      "sizeApprox": "~800 MB"
    },
    {
      "name": "agave",
      "url": "https://github.com/anza-xyz/agave.git",
      "verifyPath": "core/",
      "group": "client",
      "tags": ["svm", "consensus", "rpc", "geyser"],
      "sizeApprox": "~700 MB"
    },
    {
      "name": "solana-program-library",
      "url": "https://github.com/solana-labs/solana-program-library.git",
      "verifyPath": "token/",
      "group": "spl",
      "tags": ["spl", "token", "asset-standards"],
      "sizeApprox": "~250 MB"
    }
  ]
}
```

- [ ] **Step 3: Write the Tempo manifest**

Create `plugins/blockchain-research/skills/tempo-researcher/submodules.json`:

```json
{
  "defaultRoot": ".tempo-research",
  "submodules": [
    {
      "name": "tempo",
      "url": "https://github.com/tempoxyz/tempo.git",
      "verifyPath": "crates/",
      "group": "core",
      "tags": ["protocol", "consensus", "tx-envelope", "rpc"]
    },
    {
      "name": "tempo-go",
      "url": "https://github.com/tempoxyz/tempo-go.git",
      "verifyPath": ".",
      "group": "sdk",
      "tags": ["sdk", "rpc"]
    },
    {
      "name": "mpp-go",
      "url": "https://github.com/tempoxyz/mpp-go.git",
      "verifyPath": ".",
      "group": "mpp",
      "tags": ["mpp", "payments"]
    },
    {
      "name": "mpp-rs",
      "url": "https://github.com/tempoxyz/mpp-rs.git",
      "verifyPath": "crates/",
      "group": "mpp",
      "tags": ["mpp", "payments"]
    },
    {
      "name": "tidx",
      "url": "https://github.com/tempoxyz/tidx.git",
      "verifyPath": "src/",
      "group": "indexer",
      "tags": ["indexer", "rpc", "decoding"]
    }
  ]
}
```

- [ ] **Step 4: Validate JSON**

Run:

```bash
jq . plugins/blockchain-research/skills/ethereum-researcher/submodules.json
jq . plugins/blockchain-research/skills/solana-researcher/submodules.json
jq . plugins/blockchain-research/skills/tempo-researcher/submodules.json
```

Expected: each command echoes pretty-printed JSON with no errors.

- [ ] **Step 5: Commit**

```bash
git add plugins/blockchain-research/skills/ethereum-researcher/submodules.json \
        plugins/blockchain-research/skills/solana-researcher/submodules.json \
        plugins/blockchain-research/skills/tempo-researcher/submodules.json
git commit -m "feat(blockchain-research): add per-chain submodule manifests"
```

---

### Task A4: Create `shared/setup.md`

**Files:**
- Create: `plugins/blockchain-research/shared/setup.md`

- [ ] **Step 1: Write the setup procedure**

Create `plugins/blockchain-research/shared/setup.md`:

```markdown
---
title: Submodule Setup Procedure (chain-agnostic)
impact: CRITICAL
impactDescription: Single source of truth for path resolution, manifest-driven submodule install, and verification across all chain skills
tags: setup, submodule, manifest, install, verify, blockchain-research
---

# Submodule Setup Procedure

This file is the chain-agnostic procedure for installing the git submodules that a chain-specific researcher skill needs. It reads the per-chain `submodules.json` manifest (see `shared/manifest.md`) as the source of truth.

All paths use `<RESEARCH_ROOT>` as a placeholder. Replace with the user's resolved root.
All chain-specific data uses `<MANIFEST>` as a placeholder for the path `plugins/blockchain-research/skills/{chain}-researcher/submodules.json`.

## Step 1 -- Resolve `<RESEARCH_ROOT>`

Read `defaultRoot` from `<MANIFEST>`. Ask the user where to place the chain's research submodules; offer the manifest default. Examples of valid custom paths:

```
.ethereum-research          (manifest default for ethereum)
research/{chain}
libs/blockchain-sources/{chain}
~/{chain}-research          (absolute path outside project)
```

Store the resolved path. Use it consistently for all subsequent commands and reference lookups.

## Step 2 -- Decide Disk Strategy (first setup only)

Ask the user **once**, at the first setup of this chain in this project, which install strategy to use:

- **Bulk install (all submodules now)** -- clones every entry in `submodules[]`. Faster later, slower now, larger disk footprint.
- **On-demand install (clone only when a question needs it)** -- starts empty. Each future question that routes to a missing submodule triggers a per-submodule install prompt. See `shared/flow.md` Phase 2.

Store the chosen strategy in `<RESEARCH_ROOT>/.cache/strategy` as a single line `bulk` or `on-demand`. If the file already exists on subsequent invocations, do not ask again. The user can change strategy later by editing or deleting this marker file.

If the user has no preference, default to **on-demand**.

## Step 3 -- Prerequisite Check

Before running any `git submodule add`, verify whether submodules are already configured:

```bash
ls -la <RESEARCH_ROOT>/ 2>/dev/null
cat .gitmodules 2>/dev/null | grep -E "<comma-separated submodule names from manifest>"
```

For each entry in `submodules[]`, check whether `<RESEARCH_ROOT>/<name>/<verifyPath>` exists and is non-empty. Mark each as `OK` or `MISSING`. If all are `OK`, skip directly to Step 6 (Verification).

## Step 4 -- Install (manifest-driven)

For each `MISSING` entry that the chosen strategy says to install now (bulk: all; on-demand: none at setup time, deferred to flow Phase 2):

```bash
git submodule add <url> <RESEARCH_ROOT>/<name>
```

Render one line per submodule, in manifest order.

## Step 5 -- Post-Install Initialization

After all `git submodule add` commands succeed:

```bash
git submodule update --init --recursive
```

If the user prefers not to track submodule state in their project, recommend adding `<RESEARCH_ROOT>/` to `.gitignore`.

## Step 6 -- Verification

For each entry in `submodules[]` that should be installed (bulk strategy: all; on-demand strategy: only those already present):

```bash
ls <RESEARCH_ROOT>/<name>/<verifyPath>
```

If any expected directory is empty or missing, re-run:

```bash
git submodule update --init --recursive
```

If verification still fails (network failure, upstream repo moved, auth issues), report the specific failure to the user and stop. Do not silently proceed.

## Step 7 -- Initialize the Update Cache Directory

Ensure `<RESEARCH_ROOT>/.cache/` exists. The update cache (see `shared/flow.md` Phase 3) writes per-submodule timestamps here.

```bash
mkdir -p <RESEARCH_ROOT>/.cache
```
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/shared/setup.md
git commit -m "feat(blockchain-research): add shared setup procedure"
```

---

### Task A5: Create `shared/flow.md`

**Files:**
- Create: `plugins/blockchain-research/shared/flow.md`

- [ ] **Step 1: Write the procedure**

Create `plugins/blockchain-research/shared/flow.md`:

```markdown
---
title: Research Procedure (chain-agnostic)
impact: CRITICAL
impactDescription: Single source of truth for the 5-phase research procedure with mode branching, on-demand init, and 24-hour update cache
tags: flow, procedure, modes, init-policy, cache, blockchain-research
---

# Research Procedure

This file is the chain-agnostic procedure for executing a research request against a chain-specific researcher skill. Each chain skill defers to this file for procedure and supplies only its Source Selection Matrix and chain-specific output paths.

All paths use `<RESEARCH_ROOT>` as a placeholder.
All chain-specific data uses `<MANIFEST>` as a placeholder for the path `plugins/blockchain-research/skills/{chain}-researcher/submodules.json`.
The chain Source Selection Matrix lives at `references/flow-research.md` of the calling skill.

## Phase 1 -- Resolution & Mode

### Step 1: Resolve research root and strategy

Look up `<RESEARCH_ROOT>` (resolved at first setup, see `shared/setup.md`). If not yet resolved for this chain, run `shared/setup.md` Steps 1 and 2 first.

Read disk strategy from `<RESEARCH_ROOT>/.cache/strategy`. Default `on-demand` if missing.

### Step 2: Determine mode (quick vs full)

Two modes:

| Mode | Behavior |
|------|----------|
| `quick` | Inline answer with `<RESEARCH_ROOT>/{repo}/{path}:{line}` citations. Skip update cache check unless stale beyond TTL. Skip MD/HTML report. Multi-level analysis not enforced. |
| `full` | Run all five phases. Emit MD + HTML report to chain-specific output path. Multi-level analysis enforced. |

Auto-detection heuristics, evaluated in order:

1. **Explicit prefix** -- if the user message starts with `quick:` or `full:`, use that mode.
2. **Strong full signals** -- if the message contains any of: `research`, `compare`, `investigate`, `report`, `deep dive`, `리서치`, `리포트`, `비교`, treat as `full`.
3. **Default** -- treat as `quick`.

After choosing `quick`, if the question turns out to be deep (>= 3 distinct submodule references gathered, or the user follows up asking for "the report"), offer once: "Promote to full mode and emit a report?". Do not nag.

### Step 3: Source routing

Read the chain Source Selection Matrix from `references/flow-research.md` of the calling skill. The matrix maps question types to manifest tags (see `shared/manifest.md`). Compute the set of submodules whose `tags` intersect the routed tags. Call this set `NEEDED`.

## Phase 2 -- Init Policy (skip-if-present, ask-on-missing)

For each submodule in `NEEDED`:

1. **Skip-if-present**: if `<RESEARCH_ROOT>/<name>/<verifyPath>` exists and is non-empty, do nothing. Continue silently.
2. **Ask-on-missing**: otherwise, ask the user once with this template:

   ```
   Submodule `<name>` (<sizeApprox if present>) is needed for this question
   (matched tags: <intersected tags>).

   Install now? (y / n / skip-and-fall-back-to-web)
   ```

   - `y`: run `git submodule add <url> <RESEARCH_ROOT>/<name>` then `git submodule update --init --recursive`.
   - `n`: stop the research request. Tell the user the question cannot be answered without this submodule and suggest changing scope.
   - `skip-and-fall-back-to-web`: drop this submodule from `NEEDED`, continue with what remains, and note the caveat in the final answer / report.

3. **Verify after install**: re-check `<verifyPath>` non-empty. If still empty, surface the failure with the submodule name and `git submodule status` output.

Never auto-install without asking. The previous "auto-initialize on first use without permission" rule is removed.

## Phase 3 -- Update with 24-hour Cache

For each submodule in `NEEDED`:

1. Read `<RESEARCH_ROOT>/.cache/last-update-<name>` if it exists. Parse it as a Unix timestamp.
2. If the timestamp is less than 24 hours old (86400 seconds), skip the update for this submodule.
3. Otherwise run:

   ```bash
   git -C <RESEARCH_ROOT>/<name> fetch --quiet
   git submodule update --remote -- <RESEARCH_ROOT>/<name>
   ```

   Then write the current timestamp:

   ```bash
   date +%s > <RESEARCH_ROOT>/.cache/last-update-<name>
   ```

4. Generate a per-submodule change summary only when an update actually ran:

   ```bash
   git -C <RESEARCH_ROOT>/<name> log --oneline -10
   ```

Force refresh: if the user's message contains `refresh`, `pull latest`, `최신화`, `업데이트` followed by `submodule`, ignore the cache and update everything in `NEEDED`.

If a network failure occurs, proceed with the locally cached version and note the caveat in the final answer / report.

## Phase 4 -- Research (local-first)

Once `NEEDED` is initialized and (where applicable) updated, prefer local file access over web fetches.

Preferred tool order:

1. `Grep` with `path` pointed at `<RESEARCH_ROOT>/<name>/` -- keyword or regex search.
2. `Glob` with `path` pointed at `<RESEARCH_ROOT>/<name>/` -- locate files by name pattern.
3. `Read` with an absolute local path -- read specific files and line ranges.
4. `WebFetch` against upstream docs / forum / blog -- only for content the submodule does not contain.

Use local for code-level questions. Use web only for forum threads, blog posts, open PRs / issues, off-repo specs, and community discussion.

Cite files with `<RESEARCH_ROOT>/<name>/<path>:<line>`.

## Phase 5 -- Output (mode-dependent)

### Quick mode

- Reply inline.
- Cite at least one local source (file:line) for every code-level claim.
- For web claims, include the URL inline.
- Do not emit a report file.
- Multi-level analysis (protocol / code / community) is **not** enforced. Cover whichever levels the question actually needs.

### Full mode

- Emit both Markdown and HTML using the shared templates at `plugins/blockchain-research/templates/report.md` and `report.html`.
- Output paths come from the calling skill's `references/flow-research.md` (chain-specific). Default convention: `docs/research/{chain}/{YYYY-MM-DD}-{slug}.md` and `.html`.
- Fill MD and HTML in lockstep. They must carry identical section ids, identical Mermaid sources, identical inline SVG sources, and identical table rows.
- Multi-level analysis (protocol / code / community) **is** enforced. If a level is irrelevant, state the reason in the report rather than omitting the section.
- Replace every `{{PLACEHOLDER}}` and `<!-- TODO: ... -->` marker before considering the report done.

## Caveats Section

Whenever Phase 2 dropped a submodule (`skip-and-fall-back-to-web`), Phase 3 hit a network failure, or the update cache was used (skip > 24h), record this in:

- Quick mode: a short bullet list at the end of the inline answer.
- Full mode: a "Caveats" subsection inside the Overview section of the report.
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/shared/flow.md
git commit -m "feat(blockchain-research): add shared 5-phase flow with modes, init policy, cache"
```

- [ ] **Step 3: Run validator (smoke test)**

```bash
bash .github/scripts/validate-skills.sh
```

Expected: PASS for all existing skills (we have not modified any SKILL.md yet, so validator should still be green).

---

## Chunk B: Rewire Ethereum Researcher

This chunk rewires the ethereum-researcher skill onto the shared base. SKILL.md trigger flow is rewritten; per-chain references shrink to chain-specific deltas.

### Task B1: Rewrite ethereum SKILL.md trigger flow

**Files:**
- Modify: `plugins/blockchain-research/skills/ethereum-researcher/SKILL.md`

- [ ] **Step 1: Read the current file**

```bash
cat plugins/blockchain-research/skills/ethereum-researcher/SKILL.md
```

Confirm version is `2.0.0`.

- [ ] **Step 2: Replace the body (everything after the second `---`)**

Replace the body of `plugins/blockchain-research/skills/ethereum-researcher/SKILL.md` with:

```markdown
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
```

Keep the existing frontmatter unchanged (description, license, metadata). The `metadata.version` field bumps in Task E1, not here.

- [ ] **Step 3: Verify body length**

Run:

```bash
bash .github/scripts/validate-skills.sh 2>&1 | grep -E "ethereum-researcher.*body"
```

Expected: `[PASS] plugins/blockchain-research: SKILL.md body N lines (max 100)` where `N <= 100`.

- [ ] **Step 4: Commit**

```bash
git add plugins/blockchain-research/skills/ethereum-researcher/SKILL.md
git commit -m "refactor(ethereum-researcher): delegate trigger flow to shared base"
```

---

### Task B2: Shrink ethereum `setup-submodules.md` to chain delta

**Files:**
- Modify: `plugins/blockchain-research/skills/ethereum-researcher/references/setup-submodules.md`

- [ ] **Step 1: Replace the file with a chain delta**

Overwrite `plugins/blockchain-research/skills/ethereum-researcher/references/setup-submodules.md`:

```markdown
---
title: Ethereum Submodule Setup -- Chain Delta
impact: CRITICAL
impactDescription: Ethereum-specific defaults and verify commands; full procedure delegated to shared base
tags: submodule, git, setup, path, ethereum
---

# Ethereum Submodule Setup

The chain-agnostic setup procedure lives in `plugins/blockchain-research/shared/setup.md`. Read that first.

This file documents Ethereum-specific deltas only.

## Default Research Root

`.ethereum-research`

Source: `submodules.json` -> `defaultRoot`.

## Submodule List

Source: `submodules.json` (this skill). Six entries: go-ethereum, reth, revm, prysm, forkcast, EIPs.

## Verify Commands

Run after install to confirm a healthy clone:

```bash
git submodule status
ls <RESEARCH_ROOT>/go-ethereum/core/
ls <RESEARCH_ROOT>/reth/crates/
ls <RESEARCH_ROOT>/revm/crates/interpreter/
ls <RESEARCH_ROOT>/prysm/beacon-chain/
ls <RESEARCH_ROOT>/forkcast/
ls <RESEARCH_ROOT>/EIPs/EIPS/ | head -10
```

If any directory is empty, re-run `git submodule update --init --recursive`.

## .gitignore

If the user prefers not to track submodule state, recommend adding to `.gitignore`:

```
.ethereum-research/
```
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/skills/ethereum-researcher/references/setup-submodules.md
git commit -m "refactor(ethereum-researcher): shrink setup-submodules to chain delta"
```

---

### Task B3: Shrink ethereum `flow-research.md` to source matrix only

**Files:**
- Modify: `plugins/blockchain-research/skills/ethereum-researcher/references/flow-research.md`

- [ ] **Step 1: Replace the file**

Overwrite `plugins/blockchain-research/skills/ethereum-researcher/references/flow-research.md`:

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/skills/ethereum-researcher/references/flow-research.md
git commit -m "refactor(ethereum-researcher): shrink flow-research to chain-specific source matrix"
```

- [ ] **Step 3: Run full validator**

```bash
bash .github/scripts/validate-skills.sh
```

Expected: all PASS.

---

## Chunk C: Rewire Solana Researcher

Mirror Chunk B for solana-researcher.

### Task C1: Rewrite solana SKILL.md trigger flow

**Files:**
- Modify: `plugins/blockchain-research/skills/solana-researcher/SKILL.md`

- [ ] **Step 1: Replace the body (everything after second `---`)**

Replace the body of `plugins/blockchain-research/skills/solana-researcher/SKILL.md` with:

```markdown
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
```

Keep frontmatter unchanged.

- [ ] **Step 2: Validate body length**

```bash
bash .github/scripts/validate-skills.sh 2>&1 | grep -E "solana-researcher|body"
```

Expected: PASS, body <= 100 lines.

- [ ] **Step 3: Commit**

```bash
git add plugins/blockchain-research/skills/solana-researcher/SKILL.md
git commit -m "refactor(solana-researcher): delegate trigger flow to shared base"
```

---

### Task C2: Shrink solana `setup-submodules.md` to chain delta

**Files:**
- Modify: `plugins/blockchain-research/skills/solana-researcher/references/setup-submodules.md`

- [ ] **Step 1: Replace the file**

Overwrite `plugins/blockchain-research/skills/solana-researcher/references/setup-submodules.md`:

```markdown
---
title: Solana Submodule Setup -- Chain Delta
impact: CRITICAL
impactDescription: Solana-specific defaults and verify commands; full procedure delegated to shared base
tags: submodule, git, setup, path, solana
---

# Solana Submodule Setup

The chain-agnostic setup procedure lives in `plugins/blockchain-research/shared/setup.md`. Read that first.

This file documents Solana-specific deltas only.

## Default Research Root

`.solana-research`

Source: `submodules.json` -> `defaultRoot`.

## Submodule List

Source: `submodules.json` (this skill). Three entries: solana, agave, solana-program-library.

## Verify Commands

```bash
git submodule status
ls <RESEARCH_ROOT>/solana/runtime/
ls <RESEARCH_ROOT>/agave/core/
ls <RESEARCH_ROOT>/solana-program-library/token/
```

If any directory is empty, re-run `git submodule update --init --recursive`.

## .gitignore

If the user prefers not to track submodule state, recommend adding to `.gitignore`:

```
.solana-research/
```
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/skills/solana-researcher/references/setup-submodules.md
git commit -m "refactor(solana-researcher): shrink setup-submodules to chain delta"
```

---

### Task C3: Shrink solana `flow-research.md` to source matrix only

**Files:**
- Modify: `plugins/blockchain-research/skills/solana-researcher/references/flow-research.md`

- [ ] **Step 1: Read the current source matrix**

```bash
sed -n '/Source Selection Matrix/,/Source Navigation/p' plugins/blockchain-research/skills/solana-researcher/references/flow-research.md
```

Capture the existing question-type rows; they are chain-specific knowledge that must survive the shrink.

- [ ] **Step 2: Replace the file**

Overwrite `plugins/blockchain-research/skills/solana-researcher/references/flow-research.md`:

```markdown
---
title: Solana Source Selection -- Chain Delta
impact: CRITICAL
impactDescription: Solana-specific question-to-tag routing; full procedure delegated to shared base
tags: flow, source-matrix, routing, solana
---

# Solana Source Selection

The chain-agnostic 5-phase procedure lives in `plugins/blockchain-research/shared/flow.md`. Read that first.

This file documents Solana-specific routing only. The shared procedure intersects the tags routed here against `submodules.json` to compute the `NEEDED` submodule set.

## Output Paths

Full-mode reports are emitted to:

```
docs/research/solana/{YYYY-MM-DD}-{slug}.md
docs/research/solana/{YYYY-MM-DD}-{slug}.html
```

`{slug}` is kebab-case from the report title.

## Source Selection Matrix

| Question Type | Routed Tags | Notes |
|---------------|-------------|-------|
| SVM internals or runtime | `svm` | Primary: solana, agave runtime. |
| Consensus (Tower BFT, PoH, leader schedule) | `consensus` | Primary: solana, agave. |
| RPC / WebSocket / Geyser | `rpc`, `geyser` | Primary: agave, solana. Secondary: web (Helius docs). |
| SPL token, Token-2022, Metaplex | `spl`, `token`, `asset-standards` | Primary: solana-program-library. |
| SIMDs / proposals | (web only) | Solana forum / blog. |
| Anchor, IDL, Borsh decoding | `spl`, `decoding` | Primary: solana-program-library. Secondary: web (Anchor docs). |
| Compute units, cost model, ALT, versioned tx | `tx-envelope`, `svm` | Primary: agave, solana. |
| Stake accounts, epoch rewards, ATAs | `consensus`, `spl` | Primary: solana, solana-program-library. |

## Indexing Source Selection Matrix

| Indexing Question | Routed Tags | Indexing Lens |
|-------------------|-------------|---------------|
| Commitment levels (processed / confirmed / finalized / rooted) | `consensus`, `rpc` | `indexing/idx-commitment-levels.md` (if present) |
| Geyser plugins, Yellowstone gRPC | `geyser`, `rpc` | `indexing/idx-geyser-grpc.md` (if present) |
| Inner instructions, program logs, Anchor emit! events | `decoding`, `spl` | `indexing/idx-event-decoding.md` (if present) |
| Versioned tx / Address Lookup Tables | `tx-envelope`, `svm` | `indexing/idx-tx-envelope.md` (if present) |
| ATAs, SPL token / Token-2022 standards | `spl`, `token`, `asset-standards` | `indexing/idx-asset-standards.md` (if present) |

If any indexing lens file referenced above does not exist in `references/indexing/`, fall back to the source matrix and the relevant repo navigation file.

## Repo-Level Navigation Pointers

- solana: `references/protocol/src-solana.md` (if present)
- agave: `references/protocol/src-agave.md` (if present)
- solana-program-library: `references/protocol/src-spl.md` (if present)

Web sources:

- forum.solana.com: `references/protocol/web-solana-forum.md` (if present)
- Solana blog: `references/protocol/web-solana-blog.md` (if present)
- Anza engineering blog: `references/protocol/web-anza-blog.md` (if present)
```

The "(if present)" hedges keep this file consistent with the actual on-disk navigation files. The shrink is allowed to outrun the existing per-repo navigation footprint; existing files keep working, missing ones fall back to the source matrix.

- [ ] **Step 3: Commit**

```bash
git add plugins/blockchain-research/skills/solana-researcher/references/flow-research.md
git commit -m "refactor(solana-researcher): shrink flow-research to chain-specific source matrix"
```

- [ ] **Step 4: Run validator**

```bash
bash .github/scripts/validate-skills.sh
```

Expected: all PASS.

---

## Chunk D: Rewire Tempo Researcher

Mirror Chunks B and C for tempo-researcher.

### Task D1: Rewrite tempo SKILL.md trigger flow

**Files:**
- Modify: `plugins/blockchain-research/skills/tempo-researcher/SKILL.md`

- [ ] **Step 1: Replace the body (everything after second `---`)**

Replace the body of `plugins/blockchain-research/skills/tempo-researcher/SKILL.md` with:

```markdown
# Tempo Researcher

Tempo protocol and indexing research. Procedure delegated to `plugins/blockchain-research/shared/`. Chain-specific source matrix and submodule manifest live in this skill.

## When to Apply

Reference these guidelines when:
- Investigating Tempo protocol, Simplex BFT consensus, Commonware, Payment Lanes, Fee AMM, or Zones
- Exploring tempo, tempo-go, mpp-go, mpp-rs, or tidx codebases
- Researching Tempo indexing concerns (tidx sync, Tempo-specific tx fields, Fee AMM attribution, ABI decoding, `/query` API)
- Analyzing TIP-20, TIP-403, or Machine Payments Protocol (MPP)

## Trigger Flow

1. **Resolution & Mode** -- see `plugins/blockchain-research/shared/flow.md` Phase 1. Mode auto-detected from message; explicit `quick:` / `full:` prefix overrides.
2. **Source Routing** -- read this skill's `references/flow-research.md` Source Selection Matrix; intersect routed tags against `submodules.json`.
3. **Init Policy** -- shared Phase 2: skip-if-present, ask-on-missing.
4. **Update Cache** -- shared Phase 3: 24-hour TTL per submodule, force-refresh on user request.
5. **Research** -- shared Phase 4: local-first, `WebFetch` only for off-repo content.
6. **Output** -- shared Phase 5: quick = inline; full = emit MD + HTML to `docs/research/tempo/{YYYY-MM-DD}-{slug}.{md,html}`.

Setup procedure: see `plugins/blockchain-research/shared/setup.md`. Manifest schema: see `plugins/blockchain-research/shared/manifest.md`. Tempo manifest: see `submodules.json` next to this file.

## Submodule Manifest

See `submodules.json` (this skill's directory). Default research root: `.tempo-research`. Submodules: tempo, tempo-go, mpp-go, mpp-rs, tidx.

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
| `references/flow-research.md` | Tempo Source Selection Matrix and chain output paths |
| `references/setup-submodules.md` | Tempo-specific setup deltas (verify commands, default root) |
| `references/report-template.md` | How to use the shared plugin-level templates |
| `references/protocol/src-*.md` | Per-repo navigation |
| `references/protocol/web-*.md` | Per-source navigation |
| `references/indexing/idx-*.md` | Indexing lens references |

## References

- Tempo docs (per spec)
- https://github.com/tempoxyz/tempo
- https://github.com/tempoxyz/tempo-go
- https://github.com/tempoxyz/mpp-go
- https://github.com/tempoxyz/mpp-rs
- https://github.com/tempoxyz/tidx
```

Keep frontmatter unchanged.

- [ ] **Step 2: Validate body length**

```bash
bash .github/scripts/validate-skills.sh 2>&1 | grep -E "tempo-researcher|body"
```

Expected: PASS, body <= 100 lines.

- [ ] **Step 3: Commit**

```bash
git add plugins/blockchain-research/skills/tempo-researcher/SKILL.md
git commit -m "refactor(tempo-researcher): delegate trigger flow to shared base"
```

---

### Task D2: Shrink tempo `setup-submodules.md` to chain delta

**Files:**
- Modify: `plugins/blockchain-research/skills/tempo-researcher/references/setup-submodules.md`

- [ ] **Step 1: Replace the file**

Overwrite `plugins/blockchain-research/skills/tempo-researcher/references/setup-submodules.md`:

```markdown
---
title: Tempo Submodule Setup -- Chain Delta
impact: CRITICAL
impactDescription: Tempo-specific defaults and verify commands; full procedure delegated to shared base
tags: submodule, git, setup, path, tempo
---

# Tempo Submodule Setup

The chain-agnostic setup procedure lives in `plugins/blockchain-research/shared/setup.md`. Read that first.

This file documents Tempo-specific deltas only.

## Default Research Root

`.tempo-research`

Source: `submodules.json` -> `defaultRoot`.

## Submodule List

Source: `submodules.json` (this skill). Five entries: tempo, tempo-go, mpp-go, mpp-rs, tidx.

## Verify Commands

```bash
git submodule status
ls <RESEARCH_ROOT>/tempo/crates/
ls <RESEARCH_ROOT>/tempo-go/
ls <RESEARCH_ROOT>/mpp-go/
ls <RESEARCH_ROOT>/mpp-rs/crates/
ls <RESEARCH_ROOT>/tidx/src/
```

If any directory is empty, re-run `git submodule update --init --recursive`.

## .gitignore

If the user prefers not to track submodule state, recommend adding to `.gitignore`:

```
.tempo-research/
```
```

- [ ] **Step 2: Commit**

```bash
git add plugins/blockchain-research/skills/tempo-researcher/references/setup-submodules.md
git commit -m "refactor(tempo-researcher): shrink setup-submodules to chain delta"
```

---

### Task D3: Shrink tempo `flow-research.md` to source matrix only

**Files:**
- Modify: `plugins/blockchain-research/skills/tempo-researcher/references/flow-research.md`

- [ ] **Step 1: Read the current source matrix**

```bash
sed -n '/Source Selection Matrix/,/Source Navigation/p' plugins/blockchain-research/skills/tempo-researcher/references/flow-research.md
```

Capture chain-specific question types.

- [ ] **Step 2: Replace the file**

Overwrite `plugins/blockchain-research/skills/tempo-researcher/references/flow-research.md`:

```markdown
---
title: Tempo Source Selection -- Chain Delta
impact: CRITICAL
impactDescription: Tempo-specific question-to-tag routing; full procedure delegated to shared base
tags: flow, source-matrix, routing, tempo
---

# Tempo Source Selection

The chain-agnostic 5-phase procedure lives in `plugins/blockchain-research/shared/flow.md`. Read that first.

This file documents Tempo-specific routing only.

## Output Paths

Full-mode reports are emitted to:

```
docs/research/tempo/{YYYY-MM-DD}-{slug}.md
docs/research/tempo/{YYYY-MM-DD}-{slug}.html
```

`{slug}` is kebab-case from the report title.

## Source Selection Matrix

| Question Type | Routed Tags | Notes |
|---------------|-------------|-------|
| Tempo protocol or Simplex BFT | `protocol`, `consensus` | Primary: tempo. Secondary: web (Tempo docs, Paradigm blog). |
| TIP-20 / TIP-403 | `protocol` | Primary: tempo. Secondary: web (Tempo docs, MPP spec). |
| Tempo Transactions (Type 0x76), fee delegation, validity window | `tx-envelope`, `protocol` | Primary: tempo, tempo-go. |
| MPP (Machine Payments Protocol) | `mpp`, `payments` | Primary: mpp-go, mpp-rs. Secondary: web (MPP spec). |
| Indexing pipeline (tidx) | `indexer`, `decoding` | Primary: tidx. |
| RPC / `/query` API | `rpc`, `indexer` | Primary: tempo, tidx, tempo-go. |
| SDK usage | `sdk` | Primary: tempo-go. |

## Indexing Source Selection Matrix

| Indexing Question | Routed Tags | Indexing Lens |
|-------------------|-------------|---------------|
| tidx sync pipeline and reorg handling | `indexer` | `indexing/idx-tidx-sync.md` (if present) |
| Reth-compatible JSON-RPC plus Commonware gRPC | `rpc`, `indexer` | `indexing/idx-rpc-grpc.md` (if present) |
| ABI decoding via tidx registry | `decoding`, `indexer` | `indexing/idx-abi-decoding.md` (if present) |
| Tempo-specific transaction fields | `tx-envelope`, `protocol` | `indexing/idx-tempo-tx.md` (if present) |
| Fee AMM attribution, Payment Lane settlements | `payments`, `mpp` | `indexing/idx-fee-amm.md` (if present) |

If any indexing lens file referenced above does not exist in `references/indexing/`, fall back to the source matrix and the relevant repo navigation file.

## Repo-Level Navigation Pointers

- tempo: `references/protocol/src-tempo.md` (if present)
- tempo-go: `references/protocol/src-tempo-go.md` (if present)
- mpp-go: `references/protocol/src-mpp-go.md` (if present)
- mpp-rs: `references/protocol/src-mpp-rs.md` (if present)
- tidx: `references/protocol/src-tidx.md` (if present)

Web sources:

- Tempo docs: `references/protocol/web-tempo-docs.md` (if present)
- Tempo blog: `references/protocol/web-tempo-blog.md` (if present)
- MPP spec: `references/protocol/web-mpp-spec.md` (if present)
- Paradigm blog: `references/protocol/web-paradigm-blog.md` (if present)
```

- [ ] **Step 3: Commit**

```bash
git add plugins/blockchain-research/skills/tempo-researcher/references/flow-research.md
git commit -m "refactor(tempo-researcher): shrink flow-research to chain-specific source matrix"
```

- [ ] **Step 4: Run validator**

```bash
bash .github/scripts/validate-skills.sh
```

Expected: all PASS.

---

## Chunk E: Metadata, Validation, PR

### Task E1: Bump plugin version + update plugin description

**Files:**
- Modify: `plugins/blockchain-research/.claude-plugin/plugin.json`

- [ ] **Step 1: Read current**

```bash
cat plugins/blockchain-research/.claude-plugin/plugin.json
```

Confirm current version is `2.0.0`.

- [ ] **Step 2: Replace**

Overwrite `plugins/blockchain-research/.claude-plugin/plugin.json`:

```json
{
  "name": "blockchain-research",
  "description": "Multi-chain blockchain protocol and on-chain indexing research. Ships three chain-specific skills: blockchain-research:ethereum-researcher (go-ethereum, reth, revm, prysm, forkcast, EIPs), blockchain-research:solana-researcher (solana, agave, SPL, Anchor, Geyser), blockchain-research:tempo-researcher (tempo, tempo-go, mpp-go, mpp-rs, tidx, TIP-20, MPP, Simplex BFT). All skills share a chain-agnostic procedure base (mode branching, on-demand submodule init, 24-hour update cache) and a manifest-driven setup. Use the relevant chain skill whenever the user is investigating that chain, even if they just ask 'how does X work' without the word 'research'.",
  "author": {
    "name": "bbaktaeho"
  },
  "version": "3.0.0"
}
```

- [ ] **Step 3: Commit**

```bash
git add plugins/blockchain-research/.claude-plugin/plugin.json
git commit -m "chore(blockchain-research): bump to 3.0.0; describe shared base"
```

---

### Task E2: Update marketplace description

**Files:**
- Modify: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Read current `blockchain-research` entry**

```bash
jq '.plugins[] | select(.name=="blockchain-research")' .claude-plugin/marketplace.json
```

- [ ] **Step 2: Patch the description in place**

Use `Edit` to change the existing `blockchain-research` description in `.claude-plugin/marketplace.json`. The new description string is:

```
Multi-chain blockchain protocol and on-chain indexing research plugin. Ships three chain-specific skills: blockchain-research:ethereum-researcher (EVM, EIPs, go-ethereum, reth, revm, prysm), blockchain-research:solana-researcher (SVM, SIMDs, PoH, agave, SPL, Anchor), blockchain-research:tempo-researcher (TIP-20, TIP-403, MPP, Simplex BFT, Payment Lanes, Fee AMM, tidx). All skills share a chain-agnostic procedure base (quick / full mode branching, on-demand submodule install, 24-hour update cache, manifest-driven setup). Each skill produces reports via the plugin-level shared MD / HTML templates with Mermaid and inline SVG. Use the relevant chain skill whenever the user is investigating that chain, even without the word 'research'.
```

Replace only the description string for `blockchain-research`. Do not touch other plugin entries.

- [ ] **Step 3: Validate JSON**

```bash
jq . .claude-plugin/marketplace.json > /dev/null && echo OK
```

Expected: `OK`.

- [ ] **Step 4: Commit**

```bash
git add .claude-plugin/marketplace.json
git commit -m "chore(marketplace): update blockchain-research description"
```

---

### Task E3: Final full validation

**Files:** none modified.

- [ ] **Step 1: Run full validator**

```bash
bash .github/scripts/validate-skills.sh
```

Expected: all checks PASS, exit 0.

- [ ] **Step 2: Sanity-check shared files exist**

```bash
ls plugins/blockchain-research/shared/
ls plugins/blockchain-research/skills/*/submodules.json
```

Expected:
- `shared/` contains `_README.md`, `manifest.md`, `setup.md`, `flow.md`.
- Three `submodules.json` files exist.

- [ ] **Step 3: Sanity-check JSON parses**

```bash
for f in plugins/blockchain-research/skills/*/submodules.json; do
  jq . "$f" > /dev/null && echo "OK $f" || echo "FAIL $f"
done
```

Expected: three `OK` lines.

- [ ] **Step 4: Sanity-check no orphan references**

For each chain, every `(if present)` reference mentioned in the new `flow-research.md` should either exist or be flagged as missing. List missing files for visibility:

```bash
for chain in ethereum solana tempo; do
  echo "=== $chain ==="
  grep -oE 'references/[a-z/_-]+\.md' plugins/blockchain-research/skills/${chain}-researcher/references/flow-research.md \
  | sort -u \
  | while read ref; do
      full="plugins/blockchain-research/skills/${chain}-researcher/$ref"
      if [[ -f "$full" ]]; then
        echo "OK $ref"
      else
        echo "MISSING $ref"
      fi
    done
done
```

Capture the output. `MISSING` is acceptable for `(if present)` hedged references; the report will still produce them as fallback to source matrix. If any non-hedged reference is `MISSING`, fix the path before continuing.

---

### Task E4: Push and open PR

**Files:** none.

- [ ] **Step 1: Confirm branch**

```bash
git branch --show-current
```

Expected: a dedicated branch for this work, branched off `main`. If still on `feat/agents-meta-dir-and-meta-validator` or another unrelated branch, stop and ask the user how to proceed (the user's stated workflow is "sync main first, branch off, then auto commit/push/PR on changes").

- [ ] **Step 2: Push**

```bash
git push -u origin <branch-name>
```

- [ ] **Step 3: Open PR**

Use `gh pr create` with title `refactor(blockchain-research): modes, on-demand init, update cache, shared base` and a body summarizing:

- New `shared/` base (`_README.md`, `manifest.md`, `setup.md`, `flow.md`).
- Per-chain `submodules.json` manifests.
- Mode branching (`quick` / `full`) with auto-detection.
- Skip-if-present + ask-on-missing init policy (replaces auto-init-without-permission).
- Disk strategy choice at first setup (`bulk` / `on-demand`), persisted in `<RESEARCH_ROOT>/.cache/strategy`.
- 24-hour update cache, persisted in `<RESEARCH_ROOT>/.cache/last-update-<name>`.
- Plugin bumped to `3.0.0`.

Include a "Test plan" checklist:

- [ ] `bash .github/scripts/validate-skills.sh` passes.
- [ ] Each chain SKILL.md body <= 100 lines.
- [ ] Each `submodules.json` parses with `jq`.
- [ ] Manual smoke test: dispatch each chain skill against a sample question and confirm shared/flow.md is read.

---

## Self-Review Checklist (run after writing the plan)

- [x] Spec coverage: every item from the agreed direction is addressed.
  - Mode branching: Task A5 (definition), Tasks B1/C1/D1 (skill consumption).
  - Disk footprint choice: Task A4 Step 2 (strategy prompt), Task A3 (manifest enables on-demand).
  - Skip-if-present + ask-on-missing: Task A5 Phase 2.
  - Update cache 24h: Task A5 Phase 3.
  - Researcher base extraction: Task A1, A4, A5 + per-chain rewires B/C/D.
  - Submodule manifest separation: Task A2 (schema), A3 (data), consumed in A4/A5.
- [x] Placeholder scan: no "TBD" / "TODO" / "fill in" / "similar to" left in the plan content. The strings `<MANIFEST>` and `<RESEARCH_ROOT>` are documented placeholders inside generated reference files, not gaps in the plan.
- [x] Type consistency: manifest field names (`defaultRoot`, `submodules`, `name`, `url`, `verifyPath`, `group`, `tags`, `sizeApprox`) are identical across `manifest.md`, the three `submodules.json` files, `setup.md`, and `flow.md`.
- [x] Cross-chain consistency: each chain's SKILL.md, `setup-submodules.md`, and `flow-research.md` follow the same structure and the same pointers into shared base.
