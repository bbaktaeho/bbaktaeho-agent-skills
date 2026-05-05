---
title: Blockchain Research Shared Base
impact: CRITICAL
impactDescription: Shared procedure references consumed by every chain-specific researcher skill
tags: shared, base, authoring, blockchain-research
---

# Blockchain Research Shared Base

This directory holds chain-agnostic procedure references shared by all chain-specific researcher skills under `plugins/blockchain-research/skills/`.

## Files

| File | Role |
|------|------|
| `manifest.md` | JSON schema doc for the per-chain `submodules.json` data file |
| `setup.md` | Path resolution, manifest-driven submodule install, verification |
| `flow.md` | The 5-phase research procedure: setup, init policy, update cache, research, report (mode-dependent) |

## Consumption Pattern

Each chain skill keeps only chain-specific deltas in its own `references/`:

- `references/setup-submodules.md` -- chain default research root, verify-commands list, deferral pointer
- `references/flow-research.md` -- chain Source Selection Matrix, deferral pointer
- `submodules.json` -- chain repos data (URL, default path, verify path, group, tags)

The bulk of the procedure lives in `shared/flow.md` and `shared/setup.md`. When updating procedure, edit shared files; when updating chain-specific routing, edit per-chain files.

## Adding a New Chain

1. Create `plugins/blockchain-research/skills/{chain}-researcher/`.
2. Add `submodules.json` per `manifest.md` schema.
3. Author SKILL.md with chain description + Trigger Flow that defers to `shared/flow.md`.
4. Author `references/flow-research.md` with the chain Source Selection Matrix only.
5. Author `references/setup-submodules.md` with chain default root + verify commands only.
6. Run `bash .github/scripts/validate-skills.sh`.

## Authoring Constraints

- Keep SKILL.md body <= 100 lines (validator enforces).
- No emoji anywhere (project rule from CLAUDE.md).
- All code examples belong in references, not in SKILL.md.
