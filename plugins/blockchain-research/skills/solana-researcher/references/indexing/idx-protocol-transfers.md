---
title: Protocol-Level Value Movement (Solana Indexing Lens)
impact: HIGH
impactDescription: Transaction fee split, inflation, stake rewards, and vote costs live outside user instructions; tracking only tx data under-counts supply and balances.
tags: indexing, leader-reward, fee-burn, inflation, stake, epoch-rewards, solana
---

# Protocol-Level Transfers (Solana Indexing Lens)

## Concept

Not all value movement is expressed as a user-signed instruction. Solana mints inflation per epoch, distributes stake rewards, splits transaction fees between the leader and a burn bucket, and charges validators for vote transactions -- all outside the normal instruction log. An indexer that tracks only instructions will under-count balances.

## Solana

- **Transaction fee split** -- 50% burned, 50% to the current leader.
- **Inflation rewards** -- minted per epoch, distributed to stake accounts proportional to stake.
- **Vote transaction costs** -- validators pay a fee-like cost for vote transactions; visible as balance deltas on vote accounts.
- **Stake account accounting** -- stake accounts move through `stake` / `deactivating` / `inactive` states. Rewards land on the stake account, not on a user wallet.
- **Rent** -- persistent accounts must maintain a rent-exempt minimum. `CloseAccount` sweeps reclaimed lamports to a destination.

Epoch boundaries are the most important moment for protocol-level accounting: many reward and inflation events happen there simultaneously.

Relevant code:

- `<RESEARCH_ROOT>/solana/runtime/src/bank.rs` -- fee split and reward distribution logic.
- `<RESEARCH_ROOT>/solana/programs/stake/` -- stake program and reward computation.
- `<RESEARCH_ROOT>/agave/core/src/replay_stage.rs` -- epoch boundary handling.

## Indexer Design Implications

- Maintain a separate "protocol ledger" for non-instruction value movement; join with the instruction ledger for full balance reconciliation.
- Ingest stake program state and epoch rewards; transaction logs alone miss inflation.
- Record per-tx base fee, priority fee, and burn share separately -- downstream analytics always want this breakdown.
- On epoch boundaries, re-read stake account balances to capture reward credits that do not produce a per-tx record.
- For rent reclaim via `CloseAccount`, record the destination account; that lamport flow is not a Transfer and will be missed otherwise.
- Reconcile total supply at regular intervals against mint / burn / reward sums.

## References

- Solana economics: https://solana.com/docs/economics
- Solana validator economics: https://docs.solana.com/implemented-proposals/ed_overview
- Related: `idx-reorg-finality.md`, `idx-asset-standards.md`
