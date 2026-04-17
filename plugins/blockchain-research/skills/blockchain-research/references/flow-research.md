---
title: Research Procedure and Source Selection
impact: CRITICAL
impactDescription: Core research procedure and source selection logic for all chains
tags: flow, procedure, research, ethereum, solana, tempo
---

# Research Procedure and Source Selection

This file defines the four-phase research procedure and the source selection logic for each chain and question type.

All local paths below use `<RESEARCH_ROOT>` as a placeholder. Replace it with the user's configured submodule root path for the relevant chain. See `references/setup-submodules.md` for path configuration details.

## Phase 0 -- Chain Detection

Determine which chain(s) are relevant to the user's question:

| Keywords / Context | Chain |
|-------------------|-------|
| EVM, EIP, go-ethereum, geth, reth, revm, prysm, beacon chain, PoS, Merge, hardfork, Ethereum | Ethereum |
| SVM, SIMD, PoH, Tower BFT, Turbine, Sealevel, Gulf Stream, agave, SPL, Solana | Solana |
| TIP-20, TIP-403, MPP, Machine Payments, Payment Lanes, Fee AMM, Simplex BFT, Commonware, Zones, Tempo | Tempo |

If the question spans multiple chains (e.g., cross-chain comparison), run the research procedure for each relevant chain and combine results in a single report.

## Phase 1 -- Setup Check

### Step 1: Resolve Research Root Path

Ask the user for their submodule root path for the detected chain if not already known. Use chain defaults if unspecified:

- Ethereum: `.ethereum-research`
- Solana: `.solana-research`
- Tempo: `.tempo-research`

### Step 2: Verify Submodules

#### Ethereum

```bash
ls <RESEARCH_ROOT>/go-ethereum/core/ 2>/dev/null && echo "go-ethereum: OK" || echo "go-ethereum: MISSING"
ls <RESEARCH_ROOT>/reth/crates/ 2>/dev/null && echo "reth: OK" || echo "reth: MISSING"
ls <RESEARCH_ROOT>/revm/crates/interpreter/ 2>/dev/null && echo "revm: OK" || echo "revm: MISSING"
ls <RESEARCH_ROOT>/prysm/beacon-chain/ 2>/dev/null && echo "prysm: OK" || echo "prysm: MISSING"
ls <RESEARCH_ROOT>/forkcast/ 2>/dev/null && echo "forkcast: OK" || echo "forkcast: MISSING"
ls <RESEARCH_ROOT>/EIPs/EIPS/ 2>/dev/null && echo "EIPs: OK" || echo "EIPs: MISSING"
```

#### Solana

```bash
ls <RESEARCH_ROOT>/solana/runtime/ 2>/dev/null && echo "solana: OK" || echo "solana: MISSING"
ls <RESEARCH_ROOT>/agave/core/ 2>/dev/null && echo "agave: OK" || echo "agave: MISSING"
ls <RESEARCH_ROOT>/solana-program-library/token/ 2>/dev/null && echo "solana-program-library: OK" || echo "solana-program-library: MISSING"
```

#### Tempo

```bash
ls <RESEARCH_ROOT>/tempo/crates/ 2>/dev/null && echo "tempo: OK" || echo "tempo: MISSING"
ls <RESEARCH_ROOT>/tempo-go/ 2>/dev/null && echo "tempo-go: OK" || echo "tempo-go: MISSING"
ls <RESEARCH_ROOT>/mpp-go/ 2>/dev/null && echo "mpp-go: OK" || echo "mpp-go: MISSING"
ls <RESEARCH_ROOT>/mpp-rs/crates/ 2>/dev/null && echo "mpp-rs: OK" || echo "mpp-rs: MISSING"
ls <RESEARCH_ROOT>/tidx/src/ 2>/dev/null && echo "tidx: OK" || echo "tidx: MISSING"
```

If any submodule is missing, stop and instruct the user to complete setup. Refer them to `references/setup-submodules.md`. Do not proceed with research until all submodules for the target chain are present and non-empty.

## Phase 2 -- Update

Update submodules to their latest remote state before researching.

```bash
git submodule update --remote
```

Generate a change summary for each relevant submodule using:

```bash
git -C <RESEARCH_ROOT>/{submodule} log --oneline -10
```

Report update results:

```
Submodule Update Summary
------------------------
{submodule}: <N commits fetched or "already up to date">
  Recent: <first log line>
```

If the update fails due to network issues, proceed with the locally cached version and note the caveat in the final report.

## Phase 3 -- Research

### Ethereum Source Selection Matrix

| Question Type | Primary Sources | Secondary Sources |
|---------------|----------------|-------------------|
| Protocol or EVM internals | go-ethereum code, revm, EIPs | reth, ethresear.ch, organmo blog |
| EVM opcode-level analysis | revm, go-ethereum `core/vm/` | reth `crates/evm/` |
| PoS consensus or beacon chain | prysm code, EIPs | ethresear.ch, Vitalik blog |
| EIP analysis | EIPs repo, ethresear.ch | Vitalik blog, organmo blog |
| Hardfork tracking | forkcast, go-ethereum, reth, prysm | Ethereum blog |
| Validator operations | prysm code, EIPs | ethresear.ch |
| Multi-client comparison | go-ethereum, reth, revm | prysm |
| General ecosystem | all web sources, relevant repos | organmo blog |

### Solana Source Selection Matrix

| Question Type | Primary Sources | Secondary Sources |
|---------------|----------------|-------------------|
| Runtime or SVM internals | solana `runtime/`, agave `core/` | forum.solana.com, Anza blog |
| PoH (Proof of History) | solana `poh/`, agave `poh/` | SIMDs, Solana blog |
| Tower BFT consensus | solana `core/consensus/`, agave `core/` | SIMDs, forum.solana.com |
| Sealevel parallel execution | solana `runtime/`, agave `svm/` | Solana blog, Anza blog |
| Gulf Stream transaction forwarding | solana `core/banking_stage/`, agave `core/` | forum.solana.com |
| Turbine block propagation | solana `turbine/`, agave `turbine/` | SIMDs |
| SIMD analysis | SIMDs repo (web), forum.solana.com | Solana blog, Anza blog |
| SPL program analysis | solana-program-library | Solana docs |
| Token or Token-2022 | solana-program-library `token/`, `token/program-2022/` | Solana docs |
| General ecosystem | all web sources, relevant repos | forum.solana.com |

### Tempo Source Selection Matrix

| Question Type | Primary Sources | Secondary Sources |
|---------------|----------------|-------------------|
| Simplex BFT consensus | tempo core code | Tempo docs, Paradigm blog |
| EVM execution (Reth SDK) | tempo core code, reth reference | Tempo docs |
| TIP-20 token standard | tempo core `contracts/` | Tempo docs, tempo-std |
| TIP-403 policy registry | tempo core `contracts/` | Tempo docs |
| Payment Lanes | tempo core code | Tempo docs |
| Fee AMM mechanism | tempo core code | Tempo docs |
| Tempo Transactions (Type 0x76) | tempo core, tempo-go | Tempo docs |
| MPP protocol (Machine Payments) | mpp-go, mpp-rs, mpp-specs (web) | mpp.dev, paymentauth.org |
| MPP charge intent | mpp-go, mpp-rs | mpp-specs |
| MPP session intent | mpp-go, mpp-rs | mpp-specs |
| Go SDK / client integration | tempo-go | Tempo docs |
| Zones (privacy layer) | tempo core, Tempo docs | Tempo blog |
| On-chain data analysis (raw) | tidx `db/` schema, `src/types.rs` | Tempo docs |
| Indexed data queries (SQL) | tidx `/query` API, `db/functions.sql` | tidx README |
| Tempo-specific tx fields (fee delegation, nonce key, validity) | tidx `db/txs.sql`, `src/types.rs` | tempo core |
| ABI event decoding | tidx `src/service/mod.rs`, `db/functions.sql` | tidx API |
| Sync pipeline / reorg handling | tidx `src/sync/engine.rs` | -- |
| General Tempo ecosystem | all Tempo web sources, relevant repos | Tempo blog |

### Source Navigation

For each selected source, use the corresponding reference file for navigation instructions:

**Ethereum:**
- go-ethereum: see `references/ethereum/src-go-ethereum.md`
- reth: see `references/ethereum/src-reth.md`
- revm: see `references/ethereum/src-revm.md`
- prysm: see `references/ethereum/src-prysm.md`
- forkcast: see `references/ethereum/src-forkcast.md`
- EIPs: see `references/ethereum/src-eips.md`
- ethresear.ch: see `references/ethereum/web-ethresearch.md`
- Ethereum blog: see `references/ethereum/web-ethereum-blog.md`
- Vitalik blog: see `references/ethereum/web-vitalik-blog.md`
- organmo blog: see `references/ethereum/web-organmo-blog.md`

**Solana:**
- solana runtime: see `references/solana/src-solana.md`
- agave validator: see `references/solana/src-agave.md`
- solana-program-library: see `references/solana/src-spl.md`
- forum.solana.com: see `references/solana/web-solana-forum.md`
- Solana and Anza blogs: see `references/solana/web-solana-blog.md`

**Tempo:**
- tempo core: see `references/tempo/src-tempo.md`
- tempo-go SDK: see `references/tempo/src-tempo-go.md`
- mpp-go SDK: see `references/tempo/src-mpp-go.md`
- mpp-rs SDK: see `references/tempo/src-mpp-rs.md`
- tidx indexer: see `references/tempo/src-tidx.md`
- Tempo docs and blog: see `references/tempo/web-tempo-docs.md`
- MPP protocol docs: see `references/tempo/web-mpp.md`

### Report Assembly

After gathering information from all relevant sources, assemble the final report using the template defined in `references/report-template.md`.

## Multi-Level Analysis Requirement

Every research report must cover all three levels of analysis. No level may be omitted.

| Level | Description |
|-------|-------------|
| Protocol level | Specifications, improvement proposals (EIPs/SIMDs/TIPs), consensus rules, design rationale |
| Code level | Client implementations, packages, file and line references, cross-client comparison |
| Community level | Forum threads, blog posts, official announcements, open discussions |

If a level cannot be covered due to missing sources or irrelevance, explicitly note why in the report rather than silently skipping it.
