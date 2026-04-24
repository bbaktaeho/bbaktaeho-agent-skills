---
title: Transaction Envelope and Encoding (Solana Indexing Lens)
impact: HIGH
impactDescription: Misparsing transaction envelopes loses or misattributes data; Solana has two envelope shapes (legacy, versioned v0) and ALT-loaded accounts.
tags: indexing, transaction, envelope, compact-u16, bincode, versioned-transactions, alt, solana
---

# Transaction Envelope (Solana Indexing Lens)

## Concept

Solana transactions come in two shapes: legacy and versioned (v0). Versioned transactions support Address Lookup Tables (ALT), enabling up to 256 accounts per transaction vs 64 in legacy. An indexer must handle both shapes and reconstruct the effective account list when ALT is used. Encoding is compact-u16 length prefix plus bincode bodies.

## Solana

Transaction structure:

- Header: `numRequiredSignatures`, `numReadonlySignedAccounts`, `numReadonlyUnsignedAccounts`.
- Static `accountKeys` array.
- `recentBlockhash`.
- `instructions`: each has `programIdIndex`, `accounts` (indices), `data`.
- For v0: `addressTableLookups` (list of `{accountKey, writableIndexes, readonlyIndexes}`).

On decode, the indexer builds `effective_keys = accountKeys + loadedAddresses.writable + loadedAddresses.readonly`. The same index space is shared by `instructions`, `innerInstructions`, `preBalances` / `postBalances`, and `preTokenBalances` / `postTokenBalances`. Header fields partition effective_keys into four role quadrants (writable signer, readonly signer, writable non-signer, readonly non-signer).

Fee payer is always `accountKeys[0]`. Base fee is `5000 * numRequiredSignatures` lamports; priority fee is added via ComputeBudget instructions. Signatures are Ed25519.

Relevant code:

- `<RESEARCH_ROOT>/solana/sdk/program/src/message/` -- message encoding.
- `<RESEARCH_ROOT>/solana/sdk/src/transaction/` -- transaction builder and signing.
- `<RESEARCH_ROOT>/solana/programs/address-lookup-table/` -- ALT program.

## Indexer Design Implications

- Always branch on `version` (`legacy` vs `0`). On v0, compute effective_keys before doing anything else.
- Persist ALT snapshots separately -- if an ALT is later modified or closed, you still need to decode historical transactions that referenced it.
- Normalize legacy and versioned transactions to a common record shape but preserve ALT metadata (source ALT pubkey, writable vs readonly section).
- Parse the header-derived role quadrants once and attach them to every downstream record (per-ix role, per-balance-diff role).
- Test with ALT-heavy transactions (Jupiter, DEX aggregators) before production.
- Confirm `Σ preBalance - Σ postBalance == meta.fee` as a parsing invariant.

## References

- Solana versioned transactions: https://solana.com/docs/advanced/versioned-transactions
- Address Lookup Tables: https://solana.com/docs/advanced/lookup-tables
- Solana RPC `getTransaction`: https://solana.com/docs/rpc/http/gettransaction
- Related: `idx-event-decoding.md`, `idx-rpc-api.md`
