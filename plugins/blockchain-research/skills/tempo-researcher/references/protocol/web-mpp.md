---
title: MPP Protocol Documentation Navigation Guide
impact: HIGH
impactDescription: Machine Payments Protocol specification and ecosystem documentation
tags: mpp, machine-payments, http-402, specification, ietf
---

# MPP Protocol Documentation Navigation Guide

MPP (Machine Payments Protocol) is an open standard co-authored by Stripe and Tempo for machine-to-machine payments over HTTP. It revives the HTTP 402 "Payment Required" status code. MPP is rail-agnostic, supporting stablecoins on Tempo, cards via Stripe, Bitcoin via Lightning, and custom payment methods.

## MPP Developer Portal

URL: `https://mpp.dev`

### Key Pages

| Page | URL | Description |
|------|-----|-------------|
| Overview | `https://mpp.dev/overview` | Protocol architecture and design philosophy |
| Quick Start | `https://mpp.dev/quickstart` | Getting started with MPP integration |
| Specification | `https://mpp.dev/spec` | Core protocol specification |
| Charge Intent | `https://mpp.dev/intents/charge` | One-time per-request payment |
| Session Intent | `https://mpp.dev/intents/session` | Escrow deposit with cumulative vouchers |
| Payment Methods | `https://mpp.dev/methods` | Supported payment rails |
| SDKs | `https://mpp.dev/sdks` | Available SDKs (Go, Rust, TypeScript, Python) |

### Search Strategy

Use WebSearch:

```
site:mpp.dev charge intent
site:mpp.dev session voucher escrow
site:mpp.dev payment method tempo
site:mpp.dev HTTP 402 challenge
```

Fetch pages directly:

```
https://mpp.dev/overview
https://mpp.dev/intents/charge
https://mpp.dev/intents/session
```

## MPP Specifications Repository

URL: `https://github.com/tempoxyz/mpp-specs`

The canonical protocol specification repository. Contains:

| Document | Description |
|----------|-------------|
| Core spec | Protocol flow, HTTP headers, status codes |
| Intents spec | Charge and session intent definitions |
| Methods spec | Payment method registration and interface |
| Extensions spec | Protocol extensions and custom behaviors |

### Fetching Specs

```
https://raw.githubusercontent.com/tempoxyz/mpp-specs/main/README.md
https://github.com/tempoxyz/mpp-specs/tree/main/specs
```

Search for specific topics:

```
site:github.com/tempoxyz/mpp-specs voucher
site:github.com/tempoxyz/mpp-specs 402 challenge
```

## IETF Draft

MPP is submitted as an IETF draft for HTTP authentication: `draft-httpauth-payment-00` (March 30, 2026).

Canonical reference: `https://paymentauth.org`

### Key IETF Concepts

| Concept | Description |
|---------|-------------|
| `WWW-Authenticate: Payment` | Server challenge header (HTTP 402 response) |
| `Authorization: Payment` | Client proof header (retry request) |
| `Payment-Receipt` | Server receipt header (successful response) |
| Charge intent | One-time payment, immediate on-chain settlement |
| Session intent | Escrow deposit, cumulative vouchers, batch settlement |

## MPP SDK Repositories

| SDK | Repository | Language |
|-----|-----------|----------|
| Go | `https://github.com/tempoxyz/mpp-go` | Go |
| Rust | `https://github.com/tempoxyz/mpp-rs` | Rust |
| TypeScript | `https://github.com/tempoxyz/mpp` | TypeScript |
| Python | `https://github.com/tempoxyz/pympp` | Python |

See `references/src-mpp-go.md` and `references/src-mpp-rs.md` for detailed Go and Rust SDK navigation.

## MPP vs x402

MPP builds on x402's foundation but adds:
- Multi-rail support (not just on-chain stablecoins)
- Session intents with off-chain vouchers for sub-100ms latency
- IETF standardization path
- Backwards compatibility with x402 charge flows

## MPP Ecosystem

100+ MPP-compatible services at launch, including Anthropic, OpenAI, DoorDash, and others.

Design partners: Anthropic, Coupang, Deutsche Bank, DoorDash, Lead Bank, Mercury, Nubank, OpenAI, Revolut, Shopify, Standard Chartered, Visa.

## Citation Format

When citing MPP documentation:

```
"Page Title," MPP Developer Portal, Month Year. URL: https://mpp.dev/...
```

When citing the IETF draft:

```
"HTTP Authentication: Payment," draft-httpauth-payment-00, March 2026. URL: https://paymentauth.org
```

When citing the specification repository:

```
"Specification Title," tempoxyz/mpp-specs, Month Year. URL: https://github.com/tempoxyz/mpp-specs/...
```

## References

- https://mpp.dev
- https://mpp.dev/overview
- https://paymentauth.org
- https://github.com/tempoxyz/mpp-specs
- https://github.com/tempoxyz/mpp
- https://github.com/tempoxyz/mpp-go
- https://github.com/tempoxyz/mpp-rs
- https://github.com/tempoxyz/pympp
