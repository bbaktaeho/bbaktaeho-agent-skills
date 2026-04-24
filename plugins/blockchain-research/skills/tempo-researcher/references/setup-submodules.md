---
title: Tempo Submodule Setup Guide
impact: CRITICAL
impactDescription: Skill cannot function without submodule setup
tags: submodule, git, setup, path, tempo
---

# Tempo Submodule Setup Guide

This file explains how to configure the git submodules required for local Tempo source analysis.

## Path Configuration

Ask the user where they want to place Tempo research submodules. Default path: `.tempo-research`.

If the user specifies a custom path, use that path throughout all subsequent commands and references. All other reference files in this skill use `<RESEARCH_ROOT>` as a placeholder -- replace it with the user's chosen path.

Examples of valid custom paths:

```
.tempo-research          (default)
research/tempo
libs/blockchain-sources/tempo
~/tempo-research          (absolute path outside project)
```

Store the resolved path and use it consistently for all submodule operations and source navigation.

## Prerequisite Check

Before running any setup commands, verify whether submodules are already configured:

```bash
ls -la <RESEARCH_ROOT>/
cat .gitmodules 2>/dev/null | grep -E "tempo|tempo-go|mpp-go|mpp-rs|tidx"
```

If submodule directories exist and are non-empty, and `.gitmodules` contains the relevant entries, skip to the Verification section.

## Setup Commands

Run these commands from the user project root. Replace `<RESEARCH_ROOT>` with the user's chosen path.

```bash
git submodule add https://github.com/tempoxyz/tempo.git <RESEARCH_ROOT>/tempo
git submodule add https://github.com/tempoxyz/tempo-go.git <RESEARCH_ROOT>/tempo-go
git submodule add https://github.com/tempoxyz/mpp-go.git <RESEARCH_ROOT>/mpp-go
git submodule add https://github.com/tempoxyz/mpp-rs.git <RESEARCH_ROOT>/mpp-rs
git submodule add https://github.com/tempoxyz/tidx.git <RESEARCH_ROOT>/tidx
```

## Post-Setup Initialization

After adding all submodules, run:

```bash
git submodule update --init --recursive
```

## .gitignore Recommendation

If the user does not want to track the submodule state in their project (optional), add the chosen path to `.gitignore`:

```
.tempo-research/
```

## Verification Commands

```bash
git submodule status
ls <RESEARCH_ROOT>/tempo/crates/
ls <RESEARCH_ROOT>/tempo-go/
ls <RESEARCH_ROOT>/mpp-go/
ls <RESEARCH_ROOT>/mpp-rs/crates/
ls <RESEARCH_ROOT>/tidx/src/
```

If any directory is empty, re-run:

```bash
git submodule update --init --recursive
```
