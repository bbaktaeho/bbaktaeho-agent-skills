---
title: Ethereum Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup, path, ethereum
---

# Ethereum Submodule Setup Guide

This file explains how to configure the git submodules required for local Ethereum source analysis.

## Path Configuration

Ask the user where they want to place Ethereum research submodules. Default path: `.ethereum-research`.

If the user specifies a custom path, use that path throughout all subsequent commands and references. All other reference files in this skill use `<RESEARCH_ROOT>` as a placeholder -- replace it with the user's chosen path.

Examples of valid custom paths:

```
.ethereum-research          (default)
research/ethereum
libs/blockchain-sources/ethereum
~/ethereum-research          (absolute path outside project)
```

Store the resolved path and use it consistently for all submodule operations and source navigation.

## Prerequisite Check

Before running any setup commands, verify whether submodules are already configured:

```bash
ls -la <RESEARCH_ROOT>/
cat .gitmodules 2>/dev/null | grep -E "go-ethereum|reth|revm|forkcast|EIPs|prysm"
```

If submodule directories exist and are non-empty, and `.gitmodules` contains the relevant entries, skip to the Verification section.

## Setup Commands

Run these commands from the user project root. Replace `<RESEARCH_ROOT>` with the user's chosen path.

```bash
git submodule add https://github.com/ethereum/go-ethereum <RESEARCH_ROOT>/go-ethereum
git submodule add https://github.com/ethereum/forkcast <RESEARCH_ROOT>/forkcast
git submodule add https://github.com/ethereum/EIPs <RESEARCH_ROOT>/EIPs
git submodule add https://github.com/paradigmxyz/reth <RESEARCH_ROOT>/reth
git submodule add https://github.com/bluealloy/revm <RESEARCH_ROOT>/revm
git submodule add https://github.com/offchainlabs/prysm <RESEARCH_ROOT>/prysm
```

## Post-Setup Initialization

After adding all submodules, run:

```bash
git submodule update --init --recursive
```

## .gitignore Recommendation

If the user does not want to track the submodule state in their project (optional), add the chosen path to `.gitignore`:

```
.ethereum-research/
```

## Verification Commands

```bash
git submodule status
ls <RESEARCH_ROOT>/go-ethereum/core/
ls <RESEARCH_ROOT>/forkcast/
ls <RESEARCH_ROOT>/EIPs/EIPS/ | head -10
ls <RESEARCH_ROOT>/reth/crates/
ls <RESEARCH_ROOT>/revm/crates/interpreter/
ls <RESEARCH_ROOT>/prysm/beacon-chain/
```

If any directory is empty, re-run:

```bash
git submodule update --init --recursive
```
