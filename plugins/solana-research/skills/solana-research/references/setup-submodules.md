---
title: Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup, path
---

# Submodule Setup Guide

This file explains how to configure the git submodules required for local Solana source analysis.

## Path Configuration

The submodule root path is user-configurable. Ask the user where they want to place the research submodules.

Default path: `.solana-research`

If the user specifies a custom path, use that path throughout all subsequent commands and references. All other reference files in this skill use `<RESEARCH_ROOT>` as a placeholder -- replace it with the user's chosen path.

Examples of valid custom paths:

```
.solana-research            (default)
research/solana
libs/solana-sources
~/solana-research            (absolute path outside project)
../shared-solana-research    (relative path outside project)
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
cat .gitmodules 2>/dev/null | grep -E "solana|agave|solana-program-library"
```

If both of the following are true, skip to the Verification section:
- `<RESEARCH_ROOT>/` exists and contains non-empty subdirectories
- `.gitmodules` contains entries for `solana`, `agave`, and `solana-program-library` under `<RESEARCH_ROOT>/`

## Setup Commands

Run these commands from the user project root. Each command adds one submodule. Replace `<RESEARCH_ROOT>` with the user's chosen path.

Add solana (solana-labs/solana -- original validator runtime and SVM):

```
git submodule add https://github.com/solana-labs/solana.git <RESEARCH_ROOT>/solana
```

Add agave (anza-xyz/agave -- active validator client fork maintained by Anza):

```
git submodule add https://github.com/anza-xyz/agave.git <RESEARCH_ROOT>/agave
```

Add solana-program-library (SPL programs -- Token, Token-2022, ATA, etc.):

```
git submodule add https://github.com/solana-labs/solana-program-library.git <RESEARCH_ROOT>/solana-program-library
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

Verify solana contains runtime source:

```
ls <RESEARCH_ROOT>/solana/runtime/
```

Verify agave contains validator source:

```
ls <RESEARCH_ROOT>/agave/core/
```

Verify solana-program-library contains SPL programs:

```
ls <RESEARCH_ROOT>/solana-program-library/token/
```

If any directory is empty, re-run:

```
git submodule update --init --recursive
```
