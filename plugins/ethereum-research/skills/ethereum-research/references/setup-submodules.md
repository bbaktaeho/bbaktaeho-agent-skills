---
title: Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup
---

# Submodule Setup Guide

This file explains how to configure the git submodules required for local Ethereum source analysis.

## Prerequisite Check

Before running any setup commands, verify whether submodules are already configured.

Check for the `.ethereum-research/` directory in the user's project root:

```
ls -la .ethereum-research/
```

Check for existing `.gitmodules` entries:

```
cat .gitmodules 2>/dev/null | grep ethereum-research
```

If both of the following are true, skip to the Verification section:
- `.ethereum-research/` exists and contains non-empty subdirectories
- `.gitmodules` contains entries for `go-ethereum`, `forkcast`, and `EIPs` under `.ethereum-research/`

## Setup Commands

Run these commands from the user project root. Each command adds one submodule.

Add go-ethereum:

```
git submodule add https://github.com/ethereum/go-ethereum .ethereum-research/go-ethereum
```

Add forkcast:

```
git submodule add https://github.com/ethereum/forkcast .ethereum-research/forkcast
```

Add EIPs:

```
git submodule add https://github.com/ethereum/EIPs .ethereum-research/EIPs
```

## Post-Setup Initialization

After adding all submodules, run the following to initialize and populate them:

```
git submodule update --init --recursive
```

This ensures all nested submodules within each repository are also initialized.

## .gitignore Recommendation

If the user does not want to track the submodule state in their project (optional), add the following to `.gitignore`:

```
.ethereum-research/
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
ls .ethereum-research/go-ethereum/core/
```

Verify forkcast contains data:

```
ls .ethereum-research/forkcast/
```

Verify EIPs contains EIP documents:

```
ls .ethereum-research/EIPs/EIPS/ | head -10
```

If any directory is empty, re-run:

```
git submodule update --init --recursive
```
