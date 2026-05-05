---
title: Submodule Manifest Schema
impact: CRITICAL
impactDescription: Defines the per-chain submodules.json shape consumed by shared setup and flow procedures
tags: manifest, schema, submodules, json, blockchain-research
---

# Submodule Manifest Schema

Each chain-specific researcher skill ships one `submodules.json` file at `plugins/blockchain-research/skills/{chain}-researcher/submodules.json`. The shared `setup.md` and `flow.md` procedures read this file as the single source of truth for which repos to clone, where to put them, how to verify a healthy clone, and which question types route to each repo.

## Top-Level Shape

```json
{
  "defaultRoot": "<string>",
  "submodules": [ <Submodule> ]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `defaultRoot` | string | yes | Default research root path. Example: `.ethereum-research`. The user may override at first setup. |
| `submodules` | array | yes | One entry per repo. Order is irrelevant; tags drive routing. |

## `Submodule` Object

```json
{
  "name": "<string>",
  "url": "<string>",
  "verifyPath": "<string>",
  "group": "<string>",
  "tags": ["<string>"],
  "sizeApprox": "<string>"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Directory name under the research root. Must match the leaf in the `git submodule add` target path. |
| `url` | string | yes | Git URL passed to `git submodule add`. |
| `verifyPath` | string | yes | Relative path inside the cloned repo whose existence indicates a healthy clone. Example: `core/` for go-ethereum. Used by `shared/setup.md` verification step. |
| `group` | string | yes | Coarse grouping label used in user-facing prompts (for example `execution`, `consensus`, `spl`, `mpp`). Drives the bundle picker fallback offered at first setup. |
| `tags` | array of strings | yes | Source-matrix routing tags. Used by `shared/flow.md` Phase 2 to decide which submodules a question needs. Examples: `evm`, `rpc`, `consensus`, `decoding`. |
| `sizeApprox` | string | no | Human-readable size estimate (for example `~1.2 GB`). Shown in the on-demand install prompt. Omit for repos whose size is unknown. |

## Example

The Ethereum manifest is the reference shape:

```json
{
  "defaultRoot": ".ethereum-research",
  "submodules": [
    {
      "name": "go-ethereum",
      "url": "https://github.com/ethereum/go-ethereum",
      "verifyPath": "core/",
      "group": "execution",
      "tags": ["execution", "evm", "rpc", "tx-envelope"],
      "sizeApprox": "~1.2 GB"
    }
  ]
}
```

## Routing

`shared/flow.md` consumes the manifest in two places:

1. **Phase 1 / setup** -- iterate `submodules[]` to render `git submodule add` commands and verification `ls` checks.
2. **Phase 2 / on-demand init** -- when the chain Source Selection Matrix routes a question to a tag, look up which submodules carry that tag and ask the user about installing only those.

## Validation

`submodules.json` is data, not a Claude-readable reference. The pre-commit hook does not parse it today; correctness is the author's responsibility. When adding a new manifest, sanity-check with:

```bash
jq . plugins/blockchain-research/skills/{chain}-researcher/submodules.json
```
