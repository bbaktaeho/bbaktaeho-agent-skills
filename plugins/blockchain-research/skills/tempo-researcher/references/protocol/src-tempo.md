---
title: Tempo Core Blockchain Source Code Navigation
impact: CRITICAL
impactDescription: Primary source for Tempo chain protocol, consensus, and payment infrastructure analysis
tags: tempo, simplex-bft, payment-lanes, tip-20, tip-403, fee-amm, zones
---

# Tempo Core Blockchain Source Code Navigation

Tempo is a Layer 1 blockchain purpose-built for stablecoin payments at scale, incubated by Paradigm and Stripe. The core repository contains the blockchain node implementation in Rust, smart contracts in Solidity, and protocol-level infrastructure including Simplex BFT consensus (via Commonware), Payment Lanes, TIP-20 token standard, TIP-403 policy registry, Fee AMM, and Tempo Transactions (Type 0x76). EVM-compatible targeting the Osaka hardfork, built on Paradigm's Reth SDK.

Local submodule path: `<RESEARCH_ROOT>/tempo`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `crates/` | Core Rust crates for the Tempo node |
| `crates/node/` | Node builder and configuration (Reth SDK-based) |
| `crates/consensus/` | Simplex BFT consensus implementation (Commonware) |
| `crates/evm/` | EVM execution layer customizations on top of Reth |
| `crates/payload/` | Payload builder for block production |
| `crates/rpc/` | Custom JSON-RPC endpoints |
| `crates/primitives/` | Core types: Tempo transactions, TIP-20, headers |
| `crates/pool/` | Transaction pool with Payment Lane awareness |
| `crates/net/` | P2P networking layer |
| `crates/engine/` | Engine integration for consensus-execution communication |
| `crates/chainspec/` | Chain specification and hardfork configuration (T2, T3) |
| `contracts/` | Solidity smart contracts |
| `contracts/src/` | Core protocol contracts (FeeManager, DEX, TIP-403, precompiles) |
| `contracts/src/tip20/` | TIP-20 token standard implementation |
| `contracts/src/tip403/` | TIP-403 policy registry |
| `contracts/src/fee/` | Fee AMM and FeeManager singleton |
| `contracts/src/dex/` | Enshrined DEX (price-time priority orderbook) |
| `contracts/src/precompiles/` | Custom precompile interfaces |
| `contracts/lib/` | Foundry dependencies (forge-std, tempo-std) |
| `bin/` | Binary entry points |
| `tests/` | Integration tests |

## How to Search

```bash
# Find Simplex BFT consensus logic
grep -rn "simplex\|SimplexBft\|consensus\|Proposal\|Vote" crates/consensus/

# Find Payment Lane implementation
grep -rn "PaymentLane\|payment_lane\|lane\|reserved_blockspace" crates/pool/ crates/payload/

# Find TIP-20 token logic
grep -rn "TIP20\|Tip20\|tip20\|transfer_memo\|currency_id" contracts/src/tip20/

# Find TIP-403 policy registry
grep -rn "TIP403\|Policy\|PolicyRegistry\|ISSUER_ROLE\|PAUSE_ROLE" contracts/src/tip403/

# Find Fee AMM mechanism
grep -rn "FeeAMM\|FeeManager\|fee_swap\|rebalancing" contracts/src/fee/ crates/

# Find Tempo Transaction type (0x76)
grep -rn "0x76\|TempoTransaction\|TxType\|fee_sponsor\|batch_call\|nonce_key\|passkey\|access_key" crates/primitives/

# Find 2D nonce implementation
grep -rn "nonce_key\|NonceKey\|2d_nonce\|concurrent_nonce" crates/primitives/ crates/pool/

# Find passkey / P-256 authentication
grep -rn "P256\|secp256r1\|WebAuthn\|passkey\|Passkey" crates/primitives/ crates/

# Find scheduled transaction logic
grep -rn "scheduled\|time_window\|expiring_nonce\|valid_until" crates/primitives/ crates/pool/

# Find Zones (privacy layer) references
grep -rn "Zone\|zone\|confidential\|encrypted_deposit" crates/

# Find hardfork configuration (T2, T3)
grep -rn "T2\|T3\|hardfork\|HardFork\|is_t2\|is_t3" crates/chainspec/

# Find enshrined DEX logic
grep -rn "Orderbook\|FlipOrder\|multi_hop\|price_time" contracts/src/dex/

# Find Reth SDK integration points
grep -rn "RethNode\|NodeBuilder\|reth_node" crates/node/
```

## Common Investigation Paths

**"How does Simplex BFT consensus work?"**
- Start at `crates/consensus/` for the consensus implementation
- Simplex achieves finality in 2 rounds (vs traditional 3)
- Uses BLS signature aggregation with buffered verification
- Deterministic ~0.6 second finality, no chain reorgs
- Built on Commonware modular primitives

**"How do Payment Lanes work?"**
- `crates/pool/` for transaction pool with lane awareness
- `crates/payload/` for payload builder reserving blockspace for TIP-20 transfers
- Payment transactions get dedicated, reserved blockspace at the protocol level
- Eliminates the "noisy neighbor problem" for payment transactions

**"How does the TIP-20 token standard work?"**
- `contracts/src/tip20/` for the Solidity implementation
- Extends ERC-20 with: transfer memos (32-byte), currency identifiers (ISO 4217), rewards distribution, role-based access
- All stablecoins on Tempo are TIP-20 tokens

**"How does TIP-403 policy registry work?"**
- `contracts/src/tip403/` for the policy registry
- Issuers define "who can send what to whom under which conditions"
- Multiple tokens can share a single policy; updates propagate automatically
- Applied uniformly across DEX, reward system, and all transfer paths

**"How does the Fee AMM work?"**
- `contracts/src/fee/` for FeeManager singleton and AMM logic
- No native gas token -- fees paid in any listed USD stablecoin
- Fixed-rate swaps: Fee Swaps at 0.9970, Rebalancing Swaps at 0.9985
- Top-of-block auction for MEV from rebalancing

**"How do Tempo Transactions (Type 0x76) work?"**
- `crates/primitives/` for transaction type definitions
- Custom EIP-2718 transaction type with built-in:
  - Fee sponsorship (third-party gas payment, dual signature domains)
  - Batch calls (atomic multi-operation execution)
  - 2D Nonces (concurrent transactions via nonce keys)
  - Expiring nonces (auto-expire within time window)
  - Passkey authentication (native P-256/secp256r1, WebAuthn, secp256k1)
  - Access keys (delegated signing with constrained permissions)
  - Scheduled transactions (time-windowed execution)

**"How does the enshrined DEX work?"**
- `contracts/src/dex/` for the orderbook implementation
- Price-time priority orderbook with flip orders and multi-hop routing
- Optimized for stablecoin-to-stablecoin trading
- Enforces TIP-403 compliance policies

**"What changed in hardfork T2/T3?"**
- `crates/chainspec/` for hardfork configuration
- T2: Compound transfer policies, Validator Config V2, TIP-20 permit support
- T3: Enhanced access keys, signature verification, virtual addresses
- Search `is_t2`, `is_t3` guards across `crates/` for feature gates

## Key Files

| File | Purpose |
|------|---------|
| `crates/consensus/src/lib.rs` | Simplex BFT consensus entry point |
| `crates/node/src/lib.rs` | Node builder (Reth SDK-based) |
| `crates/primitives/src/transaction/mod.rs` | Tempo Transaction type (0x76) definition |
| `crates/evm/src/lib.rs` | EVM execution customizations |
| `crates/payload/src/lib.rs` | Payload builder with Payment Lane support |
| `crates/pool/src/lib.rs` | Transaction pool with lane awareness |
| `crates/chainspec/src/lib.rs` | Chain spec and hardfork definitions (T2, T3) |
| `contracts/src/tip20/TIP20.sol` | TIP-20 token standard contract |
| `contracts/src/tip403/PolicyRegistry.sol` | TIP-403 policy registry contract |
| `contracts/src/fee/FeeManager.sol` | Fee AMM and FeeManager singleton |
| `contracts/src/dex/Orderbook.sol` | Enshrined DEX orderbook |

## Network Details

| Property | Value |
|----------|-------|
| Chain ID | 42431 |
| RPC (Testnet) | `https://rpc.moderato.tempo.xyz` |
| Block Explorer | `https://explore.tempo.xyz` |
| Consensus | Simplex BFT (~0.6s finality) |
| EVM Target | Osaka hardfork |
| Native Token | None (fees in USD stablecoins) |
| License | Apache 2.0 / MIT |

## Relationship to Reth

Tempo is built on Paradigm's Reth SDK. Key integration points:
1. `crates/node/` wraps Reth's node builder with Tempo-specific configuration
2. `crates/evm/` customizes Reth's EVM execution layer
3. Consensus replaces Reth's default with Simplex BFT
4. Transaction types extend EIP-2718 with Tempo Transaction (Type 0x76)

Cross-reference: Reth `crates/chainspec/` hardfork definitions map to Tempo's T2/T3 hardfork guards.

## References

- https://github.com/tempoxyz/tempo
- https://docs.tempo.xyz
- https://tempo.xyz
- https://www.paradigm.xyz/2025/09/tempo-payments-first-blockchain
