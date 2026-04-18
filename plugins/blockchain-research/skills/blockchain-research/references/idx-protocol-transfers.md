---
title: Protocol-Level Value Movement (Indexing Lens)
impact: HIGH
impactDescription: Value movement outside user transactions (rewards, fees, withdrawals, MEV) must be tracked or balance reconciliation breaks.
tags: indexing, block-rewards, fees, withdrawals, mev, mint, burn, ethereum, solana, tempo
---

# Protocol-Level Transfers (Indexing Lens)

## Concept

Not all value movement is expressed as a user-signed transfer. Consensus systems mint rewards, burn fees, distribute fees to block producers, credit withdrawals, and settle MEV payments -- all outside the normal transaction log. An indexer that tracks only transactions will under-count balances and miss economic activity.

## Cross-Chain Comparison

| Aspect | Ethereum | Solana | Tempo |
|--------|----------|--------|-------|
| Block proposer reward | Beacon block reward + attestation / sync committee rewards | Transaction fee share (50%) + inflation | Per Simplex model + Fee AMM share |
| Fee burn | EIP-1559 base fee burned | 50% of transaction fee burned | Per Fee AMM model |
| Fee recipient | Priority fee to block builder's fee recipient (coinbase) | Leader (50% of tx fee) | Per Fee AMM distribution |
| Withdrawals | EIP-4895 beacon withdrawals (credited on execution layer) | Stake account redelegation / withdrawal | Validator redelegation |
| MEV payments | MEV-Boost builder -> proposer payment via coinbase or direct bribe | Searcher tip via transaction ordering | Per Tempo model |
| Mint / burn | Consensus reward mint on beacon layer | Inflation mint per epoch | Per Tempo tokenomics |

## Ethereum

- **Beacon block rewards**: credited on the consensus layer, realized on the execution layer via the withdrawal queue (EIP-4895). The indexer must ingest the beacon API to see the full reward detail.
- **Attestation / sync committee rewards**: accrued per epoch on the beacon layer.
- **Fee burn (EIP-1559)**: `baseFeePerGas * gasUsed` burned; never credited to any account.
- **Priority fee**: sent to `block.coinbase` (block builder's fee recipient).
- **Withdrawals (EIP-4895)**: each block body contains a withdrawals list; the execution layer credits balances atomically.
- **MEV-Boost**: a builder delivers a signed block with payment to the proposer baked in, typically as the last transaction (coinbase transfer) or via a direct bribe.

Relevant code: `<RESEARCH_ROOT>/prysm/beacon-chain/`, `<RESEARCH_ROOT>/go-ethereum/consensus/`. Relevant EIPs: 1559, 4895. Phase 2 file: `ethereum/idx-protocol-transfers.md`.

## Solana

- **Transaction fee split**: 50% burned, 50% to current leader.
- **Inflation rewards**: minted per epoch, distributed to stake accounts proportional to stake.
- **Vote transaction costs**: separate fee-like cost paid by validators.
- **Stake account accounting**: stake, deactivating, inactive states; rewards land on the stake account.

Relevant code: `<RESEARCH_ROOT>/solana/runtime/src/bank.rs`, `<RESEARCH_ROOT>/solana/programs/stake/`. Phase 2 file: `solana/idx-protocol-transfers.md`.

## Tempo

- **Fee AMM**: distributes fees per a protocol-defined AMM curve rather than a fixed split. The indexer must replicate or read the AMM state to attribute fees correctly.
- **Validator rewards**: per the Simplex BFT participant model.
- **Payment Lanes / MPP settlements**: cross-entity value movements through dedicated transaction types.

Relevant code: `<RESEARCH_ROOT>/tempo/crates/`, `<RESEARCH_ROOT>/tidx/src/sync/`, Tempo docs for Fee AMM. Phase 2 file: `tempo/idx-protocol-transfers.md`.

## Indexer Design Implications

- Maintain a separate "protocol ledger" for non-transaction value movement; join it with the transaction ledger for full balance reconciliation.
- On Ethereum, ingest the beacon layer as well as the execution layer; otherwise rewards and withdrawals are invisible.
- Track MEV-Boost payloads via relays or block inspection; naive transaction-only ingestion misses the off-chain builder-to-proposer flow.
- On Solana, ingest stake program state and epoch rewards; transaction logs alone miss inflation.
- On Tempo, read Fee AMM state at each block to attribute fee distribution.
- Reconcile total supply at regular intervals against mint / burn / reward sums -- divergence signals a missed protocol event.

## References

- EIP-1559: https://eips.ethereum.org/EIPS/eip-1559
- EIP-4895: https://eips.ethereum.org/EIPS/eip-4895
- MEV-Boost: https://docs.flashbots.net/flashbots-mev-boost/introduction
- Solana economics: https://solana.com/docs/economics
- Tempo Fee AMM: https://docs.tempo.xyz
- Related: `idx-reorg-finality.md`, `idx-asset-standards.md`
