---
title: mpp-rs SDK Source Code Navigation
impact: HIGH
impactDescription: Rust SDK for Machine Payments Protocol integration
tags: mpp, machine-payments, rust, http-402, axum, tower
---

# mpp-rs SDK Source Code Navigation

mpp-rs is the official Rust SDK for the Machine Payments Protocol (MPP). It provides a modular, feature-flag-driven implementation supporting multiple payment methods (Tempo stablecoins, Stripe cards, Lightning, custom) with integrations for axum and tower middleware. The SDK supports both client and server roles for building MPP-compatible HTTP services in Rust.

Local submodule path: `<RESEARCH_ROOT>/mpp-rs`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `crates/` | Workspace crates |
| `crates/core/` | Core MPP types, traits, and protocol logic |
| `crates/client/` | MPP client -- HTTP client with automatic 402 handling |
| `crates/server/` | MPP server -- challenge issuance and proof verification |
| `crates/tempo/` | Tempo payment method -- TIP-20 on-chain settlement |
| `crates/stripe/` | Stripe payment method -- card payments via Stripe API |
| `crates/lightning/` | Lightning payment method -- Bitcoin Lightning Network |
| `crates/axum/` | axum middleware integration for MPP servers |
| `crates/tower/` | tower service/layer integration for MPP servers |
| `crates/voucher/` | EIP-712 voucher signing and verification for session intent |
| `crates/intent/` | Payment intent implementations (charge, session) |
| `crates/challenge/` | 402 challenge encoding/decoding |
| `crates/proof/` | Payment proof types and verification |
| `examples/` | Example applications (client, server, axum, tower) |

## Feature Flags

mpp-rs uses Cargo feature flags for modular compilation:

| Feature | Description |
|---------|-------------|
| `client` | Enable MPP client functionality |
| `server` | Enable MPP server functionality |
| `axum` | Enable axum middleware integration |
| `tower` | Enable tower service/layer integration |
| `tempo` | Enable Tempo payment method |
| `stripe` | Enable Stripe payment method |
| `lightning` | Enable Lightning payment method |

## How to Search

```bash
# Find core MPP traits
grep -rn "trait.*Payment\|trait.*Method\|trait.*Intent\|trait.*Challenge" crates/core/src/

# Find 402 challenge types
grep -rn "Challenge\|WwwAuthenticate\|PaymentRequired" crates/challenge/src/

# Find payment proof types
grep -rn "Proof\|Authorization\|PaymentProof" crates/proof/src/

# Find charge intent
grep -rn "Charge\|ChargeIntent\|one_shot" crates/intent/src/

# Find session intent with vouchers
grep -rn "Session\|SessionIntent\|Escrow\|Voucher" crates/intent/src/ crates/voucher/src/

# Find Tempo payment method
grep -rn "TempoMethod\|TIP20\|tempo_settle\|on_chain" crates/tempo/src/

# Find Stripe payment method
grep -rn "StripeMethod\|stripe\|card\|PaymentIntent" crates/stripe/src/

# Find Lightning payment method
grep -rn "LightningMethod\|lightning\|invoice\|bolt11" crates/lightning/src/

# Find axum middleware
grep -rn "MppLayer\|MppService\|from_fn\|middleware" crates/axum/src/

# Find tower integration
grep -rn "Layer\|Service\|MppTower\|tower" crates/tower/src/

# Find EIP-712 voucher logic
grep -rn "EIP712\|TypedData\|sign_voucher\|cumulative\|domain_separator" crates/voucher/src/
```

## Common Investigation Paths

**"How does the Rust MPP client work?"**
- `crates/client/src/` for the HTTP client implementation
- Automatically handles 402 responses and payment fulfillment
- Configurable with different payment methods via generics
- Supports both charge (one-time) and session (escrow + voucher) intents

**"How to build an axum MPP server?"**
- `crates/axum/src/` for the axum middleware layer
- `crates/server/src/` for the core server logic
- Middleware intercepts requests, issues 402 challenges, verifies proofs
- `examples/` for complete axum server examples

**"How does multi-rail payment work?"**
- `crates/core/src/` defines the `PaymentMethod` trait
- `crates/tempo/` for Tempo stablecoin rail
- `crates/stripe/` for Stripe card rail
- `crates/lightning/` for Bitcoin Lightning rail
- Server can accept multiple methods; client selects preferred

**"How does session intent reduce latency?"**
- `crates/intent/src/` for session intent logic
- `crates/voucher/src/` for off-chain cumulative voucher signing
- First request: deposit into escrow contract (on-chain, slower)
- Subsequent requests: EIP-712 signed voucher (off-chain, sub-100ms)
- Session end: batch settlement in a single on-chain transaction

**"How does the tower integration work?"**
- `crates/tower/src/` for tower `Layer` and `Service` implementations
- Can wrap any tower-compatible service with MPP payment gating
- Composable with other tower middleware (rate limiting, auth, etc.)

## Key Files

| File | Purpose |
|------|---------|
| `crates/core/src/lib.rs` | Core MPP traits and types |
| `crates/core/src/method.rs` | `PaymentMethod` trait definition |
| `crates/client/src/lib.rs` | MPP HTTP client with 402 handling |
| `crates/server/src/lib.rs` | MPP server challenge and verification |
| `crates/challenge/src/lib.rs` | 402 challenge encoding/decoding |
| `crates/proof/src/lib.rs` | Payment proof types |
| `crates/intent/src/charge.rs` | Charge intent implementation |
| `crates/intent/src/session.rs` | Session intent implementation |
| `crates/voucher/src/lib.rs` | EIP-712 cumulative voucher |
| `crates/tempo/src/lib.rs` | Tempo payment method |
| `crates/stripe/src/lib.rs` | Stripe payment method |
| `crates/lightning/src/lib.rs` | Lightning payment method |
| `crates/axum/src/lib.rs` | axum middleware layer |
| `crates/tower/src/lib.rs` | tower service layer |

## References

- https://github.com/tempoxyz/mpp-rs
- https://mpp.dev
- https://docs.tempo.xyz
