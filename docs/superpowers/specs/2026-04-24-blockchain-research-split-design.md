# Blockchain Research Plugin Split -- Design Spec

- Date: 2026-04-24
- Target plugin: `plugins/blockchain-research`
- Author: bbaktaeho

## Purpose

The `blockchain-research` plugin currently ships a single skill `blockchain-research` that covers Ethereum, Solana, and Tempo in one SKILL.md. This spec splits that skill into three chain-specific skills within the same plugin so that Claude loads only the references relevant to the targeted chain and skill triggering becomes more precise.

## Goals

- Replace the single `blockchain-research` skill with three chain-specific skills.
- Each skill owns only its own chain's setup, flow, sources, and indexing references.
- Keep the plugin identity (`blockchain-research`) and the marketplace entry.
- Preserve the existing prefix convention (`setup-`, `flow-`, `report-`, `src-`, `web-`, `idx-`) and `_sections.md` per skill.

## Non-Goals

- No content additions to protocol or indexing references beyond what already exists in the current skill.
- No cross-chain comparison content. Cross-chain questions are handled by the user invoking multiple skills.
- No changes to the submodule upstream repositories, their URLs, or the research procedure phases.
- No rewrite of the `protocol/src-*.md` and `protocol/web-*.md` content. Files move, content stays.

## Target Skills

| Skill | Plugin path | Covers |
|-------|-------------|--------|
| `blockchain-research:ethereum-researcher` | `plugins/blockchain-research/skills/ethereum-researcher/` | Ethereum protocol, EVM, EIPs, hardforks, go-ethereum, reth, revm, prysm, forkcast, plus Ethereum indexing concerns |
| `blockchain-research:solana-researcher` | `plugins/blockchain-research/skills/solana-researcher/` | Solana protocol, SVM, SIMDs, PoH, Tower BFT, Turbine, Sealevel, agave, SPL programs, plus Solana indexing concerns |
| `blockchain-research:tempo-researcher` | `plugins/blockchain-research/skills/tempo-researcher/` | Tempo chain, TIP-20, TIP-403, MPP, Simplex BFT, Payment Lanes, Fee AMM, Zones, tidx, plus Tempo indexing concerns |

## Directory Layout (per skill)

```
plugins/blockchain-research/skills/{chain}-researcher/
  SKILL.md
  references/
    _sections.md
    setup-submodules.md
    flow-research.md
    report-template.md
    protocol/
      src-*.md
      web-*.md
    indexing/
      idx-*.md
```

### Ethereum files

```
protocol/
  src-go-ethereum.md
  src-reth.md
  src-revm.md
  src-prysm.md
  src-eips.md
  src-forkcast.md
  web-ethresearch.md
  web-ethereum-blog.md
  web-vitalik-blog.md
  web-organmo-blog.md
indexing/
  idx-reorg-finality.md
  idx-state-access.md
  idx-rpc-api.md
  idx-tx-envelope.md
  idx-event-decoding.md
  idx-asset-standards.md
  idx-protocol-transfers.md
  idx-official-indexers.md
```

### Solana files

```
protocol/
  src-solana.md
  src-agave.md
  src-spl.md
  web-solana-forum.md
  web-solana-blog.md
indexing/
  idx-reorg-finality.md
  idx-state-access.md
  idx-rpc-api.md
  idx-tx-envelope.md
  idx-event-decoding.md
  idx-asset-standards.md
  idx-protocol-transfers.md
  idx-official-indexers.md
```

### Tempo files

```
protocol/
  src-tempo.md
  src-tempo-go.md
  src-mpp-go.md
  src-mpp-rs.md
  src-tidx.md
  web-tempo-docs.md
  web-mpp.md
indexing/
  idx-reorg-finality.md
  idx-state-access.md
  idx-rpc-api.md
  idx-tx-envelope.md
  idx-event-decoding.md
  idx-asset-standards.md
  idx-protocol-transfers.md
  idx-official-indexers.md
```

## Content Transformation Rules

### SKILL.md (per chain)

Rewrite from scratch using the current blockchain-research SKILL.md as source:

- `name`: `ethereum-researcher` / `solana-researcher` / `tempo-researcher` (must match directory name).
- `description`: chain-specific keywords only. Include indexing keywords as they apply to that chain.
- `metadata.abstract`: describes only the target chain's submodules and reference categories.
- Body: `When to Apply`, `Skill Trigger Flow`, `Source Categories by Priority`, `How to Use`, `References` sections — all filtered to the target chain.
- Reference path in body uses the new `references/protocol/` and `references/indexing/` subpaths.
- Default `<RESEARCH_ROOT>` per chain: `.ethereum-research`, `.solana-research`, `.tempo-research`.

### `setup-submodules.md`

Keep only the target chain's sections:

- Path configuration: single chain row only.
- Prerequisite check: single chain block.
- Setup commands: single chain block.
- Post-setup initialization: keep (chain-agnostic command).
- `.gitignore` recommendation: single chain path.
- Verification commands: single chain block.

Remove all references to the two other chains, including the cross-chain table header.

### `flow-research.md`

Keep only the target chain's sections:

- Phase 0 Chain Detection: remove the cross-chain keyword table; the skill is already chain-specific.
- Phase 1 Setup Check: keep only the target chain's verification block and auto-initialize step.
- Phase 2 Update: keep as-is.
- Phase 3 Research:
  - Keep only the target chain's Source Selection Matrix.
  - Keep the Indexing Source Selection Matrix but replace cross-chain references with target-chain-only pointers (e.g., "chain src-*" becomes explicit like "src-go-ethereum.md, src-reth.md").
  - Update Source Navigation list to list only the target chain's references with new `protocol/` paths.
  - Local-First Research Policy examples: keep only the target chain's examples.
- Multi-Level Analysis Requirement: keep as-is (chain-agnostic).

All path references update to `references/protocol/src-*.md`, `references/protocol/web-*.md`, `references/indexing/idx-*.md`.

### `report-template.md`

Copy as-is to each skill. Template is chain-agnostic.

### `protocol/src-*.md` and `protocol/web-*.md`

Move existing files from `references/ethereum/`, `references/solana/`, `references/tempo/` into the corresponding skill's `references/protocol/` directory. Content is preserved verbatim.

### `indexing/idx-*.md`

Transform each idx file into three chain-specific versions. For each file:

1. Drop the "Cross-Chain Comparison" table.
2. Keep only the target chain's dedicated section; delete the other two chains' sections.
3. Keep "Concept" section (chain-agnostic background), "Indexer Design Implications" (filtered to the target chain's implications), and "References" (filtered to links relevant to the target chain).
4. Update any `<RESEARCH_ROOT>/{chain}/...` path that referenced a different chain's repo — remove it.
5. Update cross-reference mentions of "Phase 2 file" to point to the new in-skill location if still applicable, otherwise remove.
6. Update the `tags:` frontmatter to mention only the target chain.

If the target chain has no dedicated section in a given idx file (unlikely, but possible), mark it explicitly: add a short note that the topic does not apply to this chain, rather than creating an empty file.

### `_sections.md`

Keep existing section definitions. No change needed — same six prefixes (`setup`, `src`, `web`, `report`, `flow`, `indexing`) apply per skill.

## Removal

Delete `plugins/blockchain-research/skills/blockchain-research/` entirely after the three new skills are in place. Do not keep a router skill.

## Marketplace Entry

Update `.claude-plugin/marketplace.json` entry for `blockchain-research`:

- `name`: unchanged (`blockchain-research`).
- `source`: unchanged (`./plugins/blockchain-research`).
- `category`: unchanged (`development`).
- `description`: update to mention the three sub-skills explicitly so the marketplace entry reflects the new shape. Example wording: "Multi-chain blockchain research plugin providing three chain-specific skills: ethereum-researcher, solana-researcher, tempo-researcher. Each covers protocol analysis and on-chain indexing concerns for the target chain."

## Plugin Manifest

`plugins/blockchain-research/.claude-plugin/plugin.json`: description may be updated to mirror the marketplace description. Version bumped to `2.0.0` because the skill shape changes break prior `blockchain-research` skill invocations.

## Trigger Accuracy Considerations

Each new skill's description is the single largest factor for correct triggering.

- Ethereum skill: must include EVM, EIP, go-ethereum, geth, reth, revm, prysm, beacon chain, PoS, Merge, hardfork, Ethereum, plus indexing terms relevant to Ethereum (ERC-20/721/1155, Blockscout, reorg, finality, gwei, JSON-RPC).
- Solana skill: must include SVM, SIMD, PoH, Tower BFT, Turbine, Sealevel, Gulf Stream, agave, SPL, Solana, plus Helius, commitment levels, geyser.
- Tempo skill: must include TIP-20, TIP-403, MPP, Machine Payments, Payment Lanes, Fee AMM, Simplex BFT, Commonware, Zones, Tempo, plus tidx, Fee AMM, Tempo Transactions (Type 0x76).

Each description should still contain the phrase "even if they just ask 'how does X work' or 'why does Y behave this way' without the word 'research'" to preserve the existing trigger behavior.

## Acceptance Criteria

- `plugins/blockchain-research/skills/` contains exactly three subdirectories: `ethereum-researcher`, `solana-researcher`, `tempo-researcher`.
- Each skill directory contains `SKILL.md`, `references/_sections.md`, `references/setup-submodules.md`, `references/flow-research.md`, `references/report-template.md`, a non-empty `references/protocol/`, and a non-empty `references/indexing/`.
- No reference file in any skill contains sections, tables, code paths, or implications tied to the other two chains. Chain-agnostic background (e.g., the "Concept" introduction in each `idx-*.md`) may remain unchanged.
- `_sections.md` in each skill lists the same six sections as today.
- Running a grep across each new skill for the two non-target chain names returns only incidental mentions (e.g., "unlike {other chain}") that have been explicitly kept for clarity, or no hits at all.
- `.claude-plugin/marketplace.json` blockchain-research description is updated.
- `plugins/blockchain-research/.claude-plugin/plugin.json` version bumped to `2.0.0`, description updated.
- `plugins/blockchain-research/skills/blockchain-research/` no longer exists.

## Out-of-Scope Follow-Ups

- Adding a cross-chain comparison skill: explicitly deferred; the user will invoke two skills as needed.
- Expanding indexing references beyond the current eight `idx-*.md` files.
- Automated tests for skill triggering accuracy.
