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
