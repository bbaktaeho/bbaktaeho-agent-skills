---
title: solana-program-library Source Code Navigation
impact: HIGH
impactDescription: Primary source for SPL on-chain program implementation analysis
tags: spl, token, token-2022, associated-token, program-library
---

# solana-program-library Source Code Navigation

solana-program-library (SPL) is the collection of official on-chain programs maintained by Solana Labs. It includes the Token program, Token-2022 (token extensions), Associated Token Account program, governance programs, and various other utility programs. These programs are deployed on Solana mainnet and are the foundation for most DeFi and NFT protocols on Solana.

Local submodule path: `<RESEARCH_ROOT>/solana-program-library`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `token/program/` | Token program (spl-token) -- fungible and NFT token standard |
| `token/program/src/processor.rs` | Token instruction processor -- all token operations |
| `token/program-2022/` | Token-2022 (spl-token-2022) -- token extensions (transfer fees, interest bearing, etc.) |
| `token/program-2022/src/extension/` | Extension implementations (confidential transfers, metadata, etc.) |
| `associated-token-account/program/` | ATA program -- deterministic token account addresses |
| `token-upgrade/` | Token upgrade program -- spl-token to spl-token-2022 migration |
| `memo/program/` | Memo program -- on-chain memo strings |
| `name-service/` | Name service program -- .sol domain name registration |
| `governance/` | SPL Governance -- DAO and on-chain proposal voting |
| `governance/program/src/` | Governance instruction processor |
| `stake-pool/` | Stake pool program -- liquid staking protocol |
| `stake-pool/program/src/` | Stake pool instruction processor |
| `account-compression/` | Account compression -- Merkle tree-based compressed accounts |
| `account-compression/programs/account-compression/src/` | Compression program implementation |
| `single-pool/` | Single-validator stake pool |
| `shared-memory/` | Shared memory program for on-chain CPIs |
| `token-lending/` | Token lending protocol |
| `binary-oracle-pair/` | Binary oracle pair program |
| `clients/` | Generated TypeScript and Rust client SDKs |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/solana-program-library`:

```bash
# Find a specific Token instruction handler
grep -rn "fn process_initialize_mint\|fn process_transfer\|fn process_mint_to" token/program/src/processor.rs

# Find Token-2022 extension implementations
grep -rn "impl Extension\|ExtensionType::" token/program-2022/src/extension/

# Find where transfer fees are calculated
grep -rn "TransferFee\|calculate_fee\|withheld_amount" token/program-2022/src/extension/transfer_fee/

# Find ATA derivation logic
grep -rn "get_associated_token_address\|create_associated_token_account" associated-token-account/

# Find governance proposal processing
grep -rn "process_create_proposal\|process_cast_vote\|GovernanceInstruction" governance/program/src/

# Find stake pool deposit/withdraw
grep -rn "process_deposit_sol\|process_withdraw_stake\|StakePoolInstruction" stake-pool/program/src/

# Find confidential transfer extension
grep -rn "ConfidentialTransfer\|ElGamal\|ZkProof" token/program-2022/src/extension/confidential_transfer/
```

## Common Investigation Paths

**"How does the Token program handle transfers?"**
- `token/program/src/processor.rs` -- `process_transfer` and `process_transfer_checked`
- `token/program/src/state.rs` -- `Account` and `Mint` state structs
- `token/program/src/instruction.rs` -- all instruction types

**"How does Token-2022 differ from Token?"**
- `token/program-2022/src/extension/mod.rs` -- extension registry and type list
- Each extension under `token/program-2022/src/extension/{extension-name}/`
- `token/program-2022/src/processor.rs` -- extension-aware instruction routing

**"How do token extensions work?"**
- `token/program-2022/src/extension/transfer_fee/` -- transfer fee extension
- `token/program-2022/src/extension/interest_bearing_mint/` -- interest-bearing token
- `token/program-2022/src/extension/metadata/` -- on-chain metadata extension
- `token/program-2022/src/extension/confidential_transfer/` -- confidential transfers (ZK)
- `token/program-2022/src/extension/permanent_delegate/` -- permanent delegate

**"How does the ATA program work?"**
- `associated-token-account/program/src/processor.rs` -- `process_create` and idempotent create
- ATA derivation: PDA from `[wallet, token_program_id, mint]`

**"How does compressed account storage work?"**
- `account-compression/programs/account-compression/src/lib.rs` -- program entry point
- `account-compression/programs/account-compression/src/state/` -- Merkle tree state
- Used by Metaplex Bubblegum for compressed NFTs

**"How does the stake pool work?"**
- `stake-pool/program/src/processor.rs` -- all stake pool instructions
- `stake-pool/program/src/state.rs` -- `StakePool` and `ValidatorList` state
- Liquid staking: users deposit SOL, receive pool tokens representing their stake

## Key Files

| File | Purpose |
|------|---------|
| `token/program/src/processor.rs` | Token program instruction processor |
| `token/program/src/state.rs` | Token Account and Mint state definitions |
| `token/program/src/instruction.rs` | Token instruction enum |
| `token/program-2022/src/processor.rs` | Token-2022 instruction processor |
| `token/program-2022/src/extension/mod.rs` | Extension registry |
| `token/program-2022/src/extension/transfer_fee/mod.rs` | Transfer fee extension |
| `token/program-2022/src/extension/confidential_transfer/mod.rs` | Confidential transfer extension |
| `associated-token-account/program/src/processor.rs` | ATA program processor |
| `stake-pool/program/src/processor.rs` | Stake pool instruction processor |
| `governance/program/src/processor.rs` | Governance program processor |
| `account-compression/programs/account-compression/src/lib.rs` | Compression program |

## References

- https://github.com/solana-labs/solana-program-library
- https://spl.solana.com/
- https://solana.com/docs/core/tokens
