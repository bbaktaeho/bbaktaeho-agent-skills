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
