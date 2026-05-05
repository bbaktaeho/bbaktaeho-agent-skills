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
