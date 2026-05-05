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
