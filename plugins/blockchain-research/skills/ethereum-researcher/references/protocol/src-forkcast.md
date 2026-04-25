---
title: Forkcast Hardfork Data Navigation
impact: HIGH
impactDescription: Hardfork tracking and schedule data
tags: forkcast, hardfork, upgrade
---

# Forkcast Hardfork Data Navigation

Forkcast (https://forkcast.org) is the official Ethereum upgrade tracker. It aggregates EIP inclusion status, protocol call decisions, devnet progress, and upgrade schedules into a single queryable interface.

Local submodule path: `<RESEARCH_ROOT>/forkcast`

## Repository Overview

Forkcast is a TypeScript/Vite web application. The data relevant for research lives in two locations:

| Location | Purpose |
|----------|---------|
| `src/data/upgrades.ts` | Network upgrade definitions, statuses, activation dates |
| `src/data/eips/` | Per-EIP JSON files with fork inclusion history |
| `src/data/eips.ts` | EIP data loader (references `eips.json`) |
| `src/types/eip.ts` | TypeScript types for EIP and ForkRelationship structures |
| `src/types/timeline.ts` | MacroPhase type for upgrade phases |
| `public/llms.txt` | Machine-readable site overview (good quick reference) |
| `public/artifacts/` | Call transcripts and key decisions per protocol call series |
| `public/eips/` | EIP spec markdown files served at `/eips/{number}.md` |

## Network Upgrade Data (`src/data/upgrades.ts`)

Each `NetworkUpgrade` entry contains:

```
id             -- URL slug (e.g., "pectra", "glamsterdam")
name           -- Human-readable upgrade name
status         -- "Live" | "Upcoming" | "Planning" | "Research"
activationDate -- Activation date string or "TBD"
metaEipLink    -- Link to the meta-EIP thread on Ethereum Magicians
highlights     -- Key headline EIP(s) for the upgrade
```

Upgrade naming convention: Execution Layer name (Devcon city) + Consensus Layer name (star name). Examples: Dencun = Deneb + Cancun, Pectra = Prague + Electra, Glamsterdam = Gloas + Amsterdam.

## EIP Inclusion Data (`src/data/eips/`)

Each file is `{eip-number}.json` with the following key fields:

```
id                -- EIP number
title             -- Full EIP title
status            -- EIP status (Final, Draft, Review, etc.)
type              -- Standards Track | Meta | Informational
category          -- Core | Networking | Interface | ERC (for Standards Track)
forkRelationships -- Array of per-fork inclusion history
  forkName        -- upgrade name (e.g., "pectra")
  statusHistory   -- Ordered list of status changes
    status        -- Proposed | Considered | Scheduled | Declined | Included | Withdrawn
    call          -- Protocol call reference (e.g., "acdc/201")
    date          -- ISO date of the decision
  isHeadliner     -- Whether this EIP was the headliner for that upgrade
```

## Finding Information About a Specific Hardfork

1. Check `src/data/upgrades.ts` for the upgrade entry -- get status, activation date, meta-EIP link.
2. Search `src/data/eips/` for EIPs with `forkRelationships` containing that upgrade name:
   ```bash
   grep -rl '"forkName": "pectra"' src/data/eips/
   ```
3. Filter by `status: "Included"` within those relationships to get the final EIP set.
4. Visit `https://forkcast.org/upgrade/{id}` for the live rendered view.

## Checking Upcoming Hardfork Schedules

1. Open `src/data/upgrades.ts` and look for entries with `status: "Upcoming"` or `status: "Planning"`.
2. Entries with `activationDate: "TBD"` are still in scoping or headliner selection phase.
3. The `macroPhaseOverride` field can indicate the current planning phase (e.g., `"scoping"`).
4. Check `metaEipLink` for the Ethereum Magicians meta-thread with current discussion.

Current known upgrade sequence (as of April 2026):
- Pectra -- Upcoming (EIP-7702 account abstraction, validator improvements, 2x blobs)
- Glamsterdam -- Planning (headliner selection in progress)
- Hegota -- Planning (early scoping)

## Protocol Call Artifacts (`public/artifacts/`)

Call series directories:
- `acdc/` -- All Core Dev Consensus calls
- `acde/` -- All Core Dev Execution calls
- `acdt/` -- All Core Dev Testing calls

Each call directory may contain: `transcript_corrected.vtt`, `tldr.json`, `key_decisions.json`, `config.json`.

Machine-readable API endpoints on the live site:
- `https://forkcast.org/api/eip-stage-changes.json` -- recent EIP status changes

## Relationship to go-ethereum `params/config.go`

Forkcast tracks the *social/governance* layer of hardfork decisions. Once an EIP reaches `Included` status in forkcast, the activation logic appears in go-ethereum:

1. `params/config.go` gains a new timestamp field (e.g., `PectraTime *uint64`)
2. Relevant `core/` code adds `IsX()` guards: `if rules.IsPectra { ... }`
3. The EIP's implementation is merged into the appropriate `core/`, `core/vm/`, or `params/` packages

Cross-reference: forkcast `forkRelationships[].forkName` -> `params.ChainConfig.{ForkName}Time` -> `core/` feature guards.

## References

- https://forkcast.org
- https://github.com/ethereum/forkcast
- https://forkcast.org/api/eip-stage-changes.json
