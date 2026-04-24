---
title: Protocol-Level Value Movement (Tempo Indexing Lens)
impact: HIGH
impactDescription: Fee AMM distributions, validator rewards under Simplex BFT, and Payment Lane / MPP settlements live outside user-visible transfers; missing them breaks reconciliation.
tags: indexing, fee-amm, payment-lanes, mpp, simplex-bft, rewards, tempo
---

# Protocol-Level Transfers (Tempo Indexing Lens)

## Concept

Not all value movement is expressed as a user-signed transfer. Tempo distributes fees via the Fee AMM curve, credits validator rewards under the Simplex BFT participant model, and settles cross-entity flows via Payment Lanes and MPP. An indexer that tracks only transaction events will miss each of these channels.

## Tempo

- **Fee AMM** -- distributes fees per a protocol-defined AMM curve rather than a fixed split. The indexer must replicate or read the AMM state to attribute fees correctly.
- **Validator rewards** -- follow the Simplex BFT participant model, distributed per consensus round rather than per epoch.
- **Payment Lanes** -- dedicated channels for high-throughput settlements; tidx exposes decoded Payment Lane events in its schema.
- **MPP (Machine Payments Protocol) settlements** -- cross-entity value movements through dedicated transaction types; tidx surfaces charge intent and session intent events.
- **Fee delegation** -- a Type 0x76 transaction may be paid by a delegator rather than the sender. Reconciliation of fee flows depends on this distinction.

Relevant code:

- `<RESEARCH_ROOT>/tempo/crates/` -- Fee AMM, Payment Lanes, Simplex BFT implementation.
- `<RESEARCH_ROOT>/tidx/src/sync/` -- sync engine that extracts protocol-level events.
- `<RESEARCH_ROOT>/mpp-go/`, `<RESEARCH_ROOT>/mpp-rs/` -- MPP charge intent and session intent handling.

## Indexer Design Implications

- Maintain a separate "protocol ledger" for non-transaction value movement; join it with the transaction ledger for full balance reconciliation.
- Read Fee AMM state at each block to attribute fee distribution correctly. Static percentage assumptions will be wrong.
- Record the fee delegator separately from the sender on every Type 0x76 transaction.
- Track Payment Lane settlements by extracting tidx's decoded Payment Lane rows; they appear on the protocol ledger, not the raw tx ledger.
- MPP settlements: capture charge intent creation, session intent progression, and the final settlement. tidx and `mpp-go` / `mpp-rs` together define the full state machine.
- Reconcile total supply at regular intervals against mint / burn / reward sums.

## References

- Tempo Fee AMM: https://docs.tempo.xyz
- MPP spec: https://mpp.dev
- Paymentauth: https://paymentauth.org
- Related: `idx-reorg-finality.md`, `idx-asset-standards.md`
