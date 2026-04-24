---
title: Protocol-Level Value Movement (Ethereum Indexing Lens)
impact: HIGH
impactDescription: Beacon rewards, base fee burn, priority fee, EIP-4895 withdrawals, and MEV-Boost payments live outside user transactions; tracking only tx data under-counts balances.
tags: indexing, block-rewards, base-fee-burn, priority-fee, eip-1559, eip-4895, mev-boost, ethereum
---

# Protocol-Level Transfers (Ethereum Indexing Lens)

## Concept

Not all value movement is expressed as a user-signed transfer. Consensus systems mint rewards, burn fees, credit withdrawals, and settle MEV payments -- all outside the normal transaction log. An indexer that tracks only transactions will under-count balances and miss economic activity.

## Ethereum

- **Beacon block rewards** -- credited on the consensus layer, realized on the execution layer via the withdrawal queue (EIP-4895). The indexer must ingest the beacon API to see the full reward detail.
- **Attestation / sync committee rewards** -- accrued per epoch on the beacon layer.
- **Fee burn (EIP-1559)** -- `baseFeePerGas * gasUsed` burned; never credited to any account.
- **Priority fee** -- sent to `block.coinbase` (block builder's fee recipient).
- **Withdrawals (EIP-4895)** -- each block body contains a `withdrawals` list; the execution layer credits balances atomically. Visible via `eth_getBlockByNumber` response.
- **MEV-Boost** -- a builder delivers a signed block with payment to the proposer baked in, typically as the last transaction (coinbase transfer) or via a direct bribe.

Relevant code:

- `<RESEARCH_ROOT>/prysm/beacon-chain/` -- beacon reward accounting.
- `<RESEARCH_ROOT>/go-ethereum/consensus/` -- reward / burn logic on the execution side.
- `<RESEARCH_ROOT>/EIPs/EIPS/eip-1559.md`, `eip-4895.md` -- spec text.

## Indexer Design Implications

- Maintain a separate "protocol ledger" for non-transaction value movement; join it with the transaction ledger for full balance reconciliation.
- Ingest the beacon layer as well as the execution layer; otherwise rewards and withdrawals are invisible.
- Track MEV-Boost payloads via relay APIs or block inspection; naive transaction-only ingestion misses the off-chain builder-to-proposer flow.
- Reconcile total supply at regular intervals against mint / burn / reward sums -- divergence signals a missed protocol event.
- Record per-block base fee and base-fee-burned amount even when no one queries them; downstream analytics always want them.
- For withdrawals, preserve the full index (amount, validator index, address) -- historical queries often filter by validator.

## References

- EIP-1559 fee market and base fee burn: https://eips.ethereum.org/EIPS/eip-1559
- EIP-4895 beacon withdrawals: https://eips.ethereum.org/EIPS/eip-4895
- MEV-Boost: https://docs.flashbots.net/flashbots-mev-boost/introduction
- Related: `idx-reorg-finality.md`, `idx-asset-standards.md`
