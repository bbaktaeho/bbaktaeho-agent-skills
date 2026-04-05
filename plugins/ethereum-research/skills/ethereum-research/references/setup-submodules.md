---
title: Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup, path
---

# Submodule Setup Guide

This file explains how to configure the git submodules required for local Ethereum source analysis.

## Path Configuration

The submodule root path is user-configurable. Ask the user where they want to place the research submodules.

Default path: `.ethereum-research`

If the user specifies a custom path, use that path throughout all subsequent commands and references. All other reference files in this skill use `<RESEARCH_ROOT>` as a placeholder -- replace it with the user's chosen path.

Examples of valid custom paths:

```
.ethereum-research          (default)
research/ethereum
libs/ethereum-sources
~/ethereum-research          (absolute path outside project)
../shared-ethereum-research  (relative path outside project)
```

Store the resolved path and use it consistently for all submodule operations and source navigation.

## Prerequisite Check

Before running any setup commands, verify whether submodules are already configured.

Check for the `<RESEARCH_ROOT>/` directory:

```
ls -la <RESEARCH_ROOT>/
```

Check for existing `.gitmodules` entries:

```
cat .gitmodules 2>/dev/null | grep -E "go-ethereum|forkcast|EIPs|prysm"
```

If both of the following are true, skip to the Verification section:
- `<RESEARCH_ROOT>/` exists and contains non-empty subdirectories
- `.gitmodules` contains entries for `go-ethereum`, `forkcast`, `EIPs`, and `prysm` under `<RESEARCH_ROOT>/`

## Setup Commands

Run these commands from the user project root. Each command adds one submodule. Replace `<RESEARCH_ROOT>` with the user's chosen path.

Add go-ethereum:

```
git submodule add https://github.com/ethereum/go-ethereum <RESEARCH_ROOT>/go-ethereum
```

Add forkcast:

```
git submodule add https://github.com/ethereum/forkcast <RESEARCH_ROOT>/forkcast
```

Add EIPs:

```
git submodule add https://github.com/ethereum/EIPs <RESEARCH_ROOT>/EIPs
```

Add prysm (beacon chain consensus client):

```
git submodule add https://github.com/offchainlabs/prysm <RESEARCH_ROOT>/prysm
```

## Post-Setup Initialization

After adding all submodules, run the following to initialize and populate them:

```
git submodule update --init --recursive
```

This ensures all nested submodules within each repository are also initialized.

## .gitignore Recommendation

If the user does not want to track the submodule state in their project (optional), add the chosen path to `.gitignore`:

```
<RESEARCH_ROOT>/
```

Note: adding this to `.gitignore` means the submodule configuration in `.gitmodules` will still exist, but the directory contents will be ignored by git status. This is appropriate for projects that treat the research directories as purely local tooling.

## Verification Commands

After setup, confirm each submodule is correctly initialized and contains files.

Check submodule status:

```
git submodule status
```

Expected output: each submodule line begins with a space (initialized) rather than `-` (not initialized) or `+` (modified HEAD).

Verify go-ethereum contains source files:

```
ls <RESEARCH_ROOT>/go-ethereum/core/
```

Verify forkcast contains data:

```
ls <RESEARCH_ROOT>/forkcast/
```

Verify EIPs contains EIP documents:

```
ls <RESEARCH_ROOT>/EIPs/EIPS/ | head -10
```

Verify prysm contains beacon chain source:

```
ls <RESEARCH_ROOT>/prysm/beacon-chain/
```

If any directory is empty, re-run:

```
git submodule update --init --recursive
```
