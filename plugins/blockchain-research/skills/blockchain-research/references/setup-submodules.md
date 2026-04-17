---
title: Multi-Chain Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup, path, ethereum, solana, tempo
---

# Multi-Chain Submodule Setup Guide

This file explains how to configure the git submodules required for local blockchain source analysis. Each chain has its own submodule root path.

## Path Configuration

Each chain has an independent, user-configurable submodule root path. Ask the user where they want to place each chain's research submodules.

Default paths:

| Chain | Default Path |
|-------|-------------|
| Ethereum | `.ethereum-research` |
| Solana | `.solana-research` |
| Tempo | `.tempo-research` |

If the user specifies custom paths, use those paths throughout all subsequent commands and references. All other reference files in this skill use `<RESEARCH_ROOT>` as a placeholder -- replace it with the user's chosen path for the relevant chain.

Examples of valid custom paths:

```
.ethereum-research          (default)
research/ethereum
libs/blockchain-sources/ethereum
~/ethereum-research          (absolute path outside project)
```

Store the resolved paths and use them consistently for all submodule operations and source navigation.

## Prerequisite Check

Before running any setup commands, verify whether submodules are already configured for the target chain.

### Ethereum

```bash
ls -la <RESEARCH_ROOT>/
cat .gitmodules 2>/dev/null | grep -E "go-ethereum|reth|revm|forkcast|EIPs|prysm"
```

### Solana

```bash
ls -la <RESEARCH_ROOT>/
cat .gitmodules 2>/dev/null | grep -E "solana|agave|solana-program-library"
```

### Tempo

```bash
ls -la <RESEARCH_ROOT>/
cat .gitmodules 2>/dev/null | grep -E "tempo|tempo-go|mpp-go|mpp-rs"
```

If submodule directories exist and are non-empty, and `.gitmodules` contains the relevant entries, skip to the Verification section for that chain.

## Setup Commands -- Ethereum

Run these commands from the user project root. Replace `<RESEARCH_ROOT>` with the user's chosen Ethereum path.

```bash
git submodule add https://github.com/ethereum/go-ethereum <RESEARCH_ROOT>/go-ethereum
git submodule add https://github.com/ethereum/forkcast <RESEARCH_ROOT>/forkcast
git submodule add https://github.com/ethereum/EIPs <RESEARCH_ROOT>/EIPs
git submodule add https://github.com/paradigmxyz/reth <RESEARCH_ROOT>/reth
git submodule add https://github.com/bluealloy/revm <RESEARCH_ROOT>/revm
git submodule add https://github.com/offchainlabs/prysm <RESEARCH_ROOT>/prysm
```

## Setup Commands -- Solana

Replace `<RESEARCH_ROOT>` with the user's chosen Solana path.

```bash
git submodule add https://github.com/solana-labs/solana.git <RESEARCH_ROOT>/solana
git submodule add https://github.com/anza-xyz/agave.git <RESEARCH_ROOT>/agave
git submodule add https://github.com/solana-labs/solana-program-library.git <RESEARCH_ROOT>/solana-program-library
```

## Setup Commands -- Tempo

Replace `<RESEARCH_ROOT>` with the user's chosen Tempo path.

```bash
git submodule add https://github.com/tempoxyz/tempo.git <RESEARCH_ROOT>/tempo
git submodule add https://github.com/tempoxyz/tempo-go.git <RESEARCH_ROOT>/tempo-go
git submodule add https://github.com/tempoxyz/mpp-go.git <RESEARCH_ROOT>/mpp-go
git submodule add https://github.com/tempoxyz/mpp-rs.git <RESEARCH_ROOT>/mpp-rs
```

## Post-Setup Initialization

After adding all submodules for the desired chain(s), run:

```bash
git submodule update --init --recursive
```

## .gitignore Recommendation

If the user does not want to track the submodule state in their project (optional), add the chosen paths to `.gitignore`:

```
.ethereum-research/
.solana-research/
.tempo-research/
```

## Verification Commands

### Ethereum

```bash
git submodule status
ls <RESEARCH_ROOT>/go-ethereum/core/
ls <RESEARCH_ROOT>/forkcast/
ls <RESEARCH_ROOT>/EIPs/EIPS/ | head -10
ls <RESEARCH_ROOT>/reth/crates/
ls <RESEARCH_ROOT>/revm/crates/interpreter/
ls <RESEARCH_ROOT>/prysm/beacon-chain/
```

### Solana

```bash
git submodule status
ls <RESEARCH_ROOT>/solana/runtime/
ls <RESEARCH_ROOT>/agave/core/
ls <RESEARCH_ROOT>/solana-program-library/token/
```

### Tempo

```bash
git submodule status
ls <RESEARCH_ROOT>/tempo/crates/
ls <RESEARCH_ROOT>/tempo-go/
ls <RESEARCH_ROOT>/mpp-go/
ls <RESEARCH_ROOT>/mpp-rs/crates/
```

If any directory is empty, re-run:

```bash
git submodule update --init --recursive
```
