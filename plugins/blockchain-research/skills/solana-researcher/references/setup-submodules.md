---
title: Solana Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup, path, solana
---

# Solana Submodule Setup Guide

This file explains how to configure the git submodules required for local Solana source analysis.

## Path Configuration

Ask the user where they want to place Solana research submodules. Default path: `.solana-research`.

If the user specifies a custom path, use that path throughout all subsequent commands and references. All other reference files in this skill use `<RESEARCH_ROOT>` as a placeholder -- replace it with the user's chosen path.

Examples of valid custom paths:

```
.solana-research          (default)
research/solana
libs/blockchain-sources/solana
~/solana-research          (absolute path outside project)
```

Store the resolved path and use it consistently for all submodule operations and source navigation.

## Prerequisite Check

Before running any setup commands, verify whether submodules are already configured:

```bash
ls -la <RESEARCH_ROOT>/
cat .gitmodules 2>/dev/null | grep -E "solana|agave|solana-program-library"
```

If submodule directories exist and are non-empty, and `.gitmodules` contains the relevant entries, skip to the Verification section.

## Setup Commands

Run these commands from the user project root. Replace `<RESEARCH_ROOT>` with the user's chosen path.

```bash
git submodule add https://github.com/solana-labs/solana.git <RESEARCH_ROOT>/solana
git submodule add https://github.com/anza-xyz/agave.git <RESEARCH_ROOT>/agave
git submodule add https://github.com/solana-labs/solana-program-library.git <RESEARCH_ROOT>/solana-program-library
```

## Post-Setup Initialization

After adding all submodules, run:

```bash
git submodule update --init --recursive
```

## .gitignore Recommendation

If the user does not want to track the submodule state in their project (optional), add the chosen path to `.gitignore`:

```
.solana-research/
```

## Verification Commands

```bash
git submodule status
ls <RESEARCH_ROOT>/solana/runtime/
ls <RESEARCH_ROOT>/agave/core/
ls <RESEARCH_ROOT>/solana-program-library/token/
```

If any directory is empty, re-run:

```bash
git submodule update --init --recursive
```
