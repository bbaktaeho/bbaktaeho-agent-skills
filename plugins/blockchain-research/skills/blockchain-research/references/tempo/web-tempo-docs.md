---
title: Tempo Documentation and Blog Navigation Guide
impact: HIGH
impactDescription: Official Tempo chain documentation and announcements
tags: tempo, docs, blog, documentation
---

# Tempo Documentation and Blog Navigation Guide

Tempo has several official web sources for protocol documentation, developer guides, and ecosystem announcements.

## Tempo Documentation

URL: `https://docs.tempo.xyz`

### Key Documentation Sections

| Section | URL | Description |
|---------|-----|-------------|
| Getting Started | `https://docs.tempo.xyz/getting-started` | Quick start, chain overview, key concepts |
| Protocol | `https://docs.tempo.xyz/protocol` | Consensus, Payment Lanes, Fee AMM, Zones |
| TIP-20 | `https://docs.tempo.xyz/protocol/tip-20` | TIP-20 token standard specification |
| TIP-403 | `https://docs.tempo.xyz/protocol/tip-403` | Policy registry and compliance framework |
| Transactions | `https://docs.tempo.xyz/protocol/transactions` | Tempo Transaction (Type 0x76), fee sponsorship, batch calls |
| DEX | `https://docs.tempo.xyz/protocol/dex` | Enshrined DEX, orderbook, flip orders |
| Zones | `https://docs.tempo.xyz/protocol/zones` | Privacy layer, confidential balances |
| Developers | `https://docs.tempo.xyz/developers` | RPC endpoints, SDK guides, Foundry setup |
| MPP | `https://docs.tempo.xyz/mpp` | Machine Payments Protocol integration |
| Validators | `https://docs.tempo.xyz/validators` | Validator setup and operation |

### Search Strategy

Use WebSearch with site restriction:

```
site:docs.tempo.xyz TIP-20 transfer memo
site:docs.tempo.xyz Fee AMM mechanism
site:docs.tempo.xyz Payment Lanes blockspace
site:docs.tempo.xyz Tempo Transaction 0x76
site:docs.tempo.xyz passkey P-256 authentication
site:docs.tempo.xyz Zones confidential
```

### Using WebFetch

Fetch documentation pages directly:

```
https://docs.tempo.xyz/protocol/tip-20
https://docs.tempo.xyz/protocol/transactions
https://docs.tempo.xyz/protocol/fee-amm
```

## Tempo Blog

URL: `https://tempo.xyz/blog`

### Coverage Areas

| Topic | What to expect |
|-------|----------------|
| Protocol announcements | Mainnet launch, hardfork activations, validator onboarding |
| Technical deep-dives | Architecture explanations, design rationale |
| Partnership announcements | Validator additions (Visa, Stripe), design partner updates |
| Ecosystem news | MPP adoption, developer tooling, grant programs |

### Search Strategy

Use WebSearch:

```
site:tempo.xyz/blog mainnet launch
site:tempo.xyz/blog MPP machine payments
site:tempo.xyz/blog validator
site:tempo.xyz/blog hardfork T2 T3
```

Fetch the blog listing:

```
https://tempo.xyz/blog
```

## Tempo Block Explorer

URL: `https://explore.tempo.xyz`

Use the block explorer for on-chain data verification:
- Transaction details and status
- Block and slot information
- Contract interactions
- TIP-20 token transfers and balances

## Paradigm Blog (Tempo-related)

URL: `https://www.paradigm.xyz`

Paradigm publishes architectural deep-dives and research related to Tempo.

### Search Strategy

```
site:paradigm.xyz tempo
site:paradigm.xyz payments blockchain
site:paradigm.xyz commonware simplex
```

Key article: `https://www.paradigm.xyz/2025/09/tempo-payments-first-blockchain`

## tempo-std (Contract Libraries)

Repository: `https://github.com/tempoxyz/tempo-std`

Foundry contract libraries with 16+ precompile interfaces, transaction builders, TIP-20/TIP-403 interfaces. Useful for understanding the Solidity-level API.

```
site:github.com/tempoxyz/tempo-std precompile
site:github.com/tempoxyz/tempo-std TIP20
```

## Citation Format

When citing Tempo documentation:

```
"Page Title," Tempo Documentation, Month Year. URL: https://docs.tempo.xyz/...
```

When citing Tempo blog:

```
"Post Title," Tempo Blog, Month Year. URL: https://tempo.xyz/blog/...
```

## References

- https://docs.tempo.xyz
- https://tempo.xyz/blog
- https://explore.tempo.xyz
- https://www.paradigm.xyz/2025/09/tempo-payments-first-blockchain
- https://github.com/tempoxyz/tempo-std
- https://github.com/tempoxyz/tempo-apps
- https://github.com/tempoxyz/docs
