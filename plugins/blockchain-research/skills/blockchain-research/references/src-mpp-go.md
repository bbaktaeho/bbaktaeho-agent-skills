---
title: mpp-go SDK Source Code Navigation
impact: HIGH
impactDescription: Go SDK for Machine Payments Protocol integration
tags: mpp, machine-payments, go, http-402, charge, session
---

# mpp-go SDK Source Code Navigation

mpp-go is the official Go SDK for the Machine Payments Protocol (MPP). MPP is an open standard co-authored by Stripe and Tempo that revives the HTTP 402 "Payment Required" status code for machine-to-machine payments. This SDK provides both client and server packages for implementing MPP-compatible HTTP services with Tempo blockchain payment method integration.

Local submodule path: `<RESEARCH_ROOT>/mpp-go`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `client/` | MPP client -- sends payments and retries requests with payment proof |
| `server/` | MPP server -- issues 402 challenges and verifies payment proofs |
| `method/` | Payment method implementations (Tempo stablecoins, others) |
| `method/tempo/` | Tempo payment method -- TIP-20 on-chain settlement |
| `intent/` | Payment intent types (charge, session) |
| `intent/charge/` | Charge intent -- one-time per-request payments |
| `intent/session/` | Session intent -- escrow deposit with cumulative vouchers |
| `challenge/` | 402 challenge construction and parsing |
| `proof/` | Payment proof generation and verification |
| `voucher/` | EIP-712 signed cumulative vouchers for session intent |
| `middleware/` | HTTP middleware for Go servers (net/http, gin, echo) |
| `types/` | Core types -- payment request, response, receipt |
| `examples/` | Example client/server applications |

## How to Search

```bash
# Find 402 challenge construction
grep -rn "WWW-Authenticate\|Payment Required\|402\|Challenge" challenge/ server/

# Find payment proof handling
grep -rn "Authorization.*Payment\|PaymentProof\|Proof\|proof" proof/ client/

# Find charge intent implementation
grep -rn "Charge\|ChargeIntent\|one_time\|per_request" intent/charge/

# Find session intent implementation
grep -rn "Session\|SessionIntent\|Escrow\|escrow\|Voucher\|voucher" intent/session/

# Find Tempo payment method
grep -rn "TempoMethod\|TIP20\|stablecoin\|on_chain" method/tempo/

# Find EIP-712 voucher signing
grep -rn "EIP712\|TypedData\|SignVoucher\|cumulative" voucher/

# Find HTTP middleware
grep -rn "Middleware\|Handler\|Wrap\|ServeHTTP" middleware/

# Find payment receipt handling
grep -rn "Payment-Receipt\|Receipt\|receipt" types/ server/
```

## Common Investigation Paths

**"How does the MPP challenge-response flow work?"**
1. `server/` -- server returns HTTP 402 with `WWW-Authenticate: Payment` header
2. `challenge/` -- challenge includes payment intent, amount, recipient, method
3. `client/` -- client fulfills payment challenge
4. `proof/` -- client retries with `Authorization: Payment` header containing proof
5. `server/` -- server verifies and returns resource with `Payment-Receipt` header

**"How does the charge intent work?"**
- `intent/charge/` for one-time payment per request
- Each request triggers an on-chain settlement
- Payment is verified by checking the on-chain transaction receipt

**"How does the session intent work?"**
- `intent/session/` for escrow-based session payments
- Client deposits into escrow contract at session start
- `voucher/` for cumulative EIP-712 signed vouchers
- Each subsequent request sends a voucher (off-chain, sub-100ms latency)
- Micro-payments down to $0.0001 per request
- Session ends with a single batch settlement on-chain

**"How to add MPP to a Go HTTP server?"**
- `middleware/` for drop-in HTTP middleware
- `server/` for lower-level server-side logic
- Configure payment method, pricing, and challenge parameters

**"How does Tempo payment method work?"**
- `method/tempo/` for on-chain TIP-20 settlement
- Uses Tempo chain for payment verification
- Supports any listed USD stablecoin via TIP-20

## Key Files

| File | Purpose |
|------|---------|
| `client/client.go` | MPP client -- sends requests, handles 402, fulfills payments |
| `server/server.go` | MPP server -- issues challenges, verifies proofs |
| `challenge/challenge.go` | 402 challenge construction and parsing |
| `proof/proof.go` | Payment proof generation and verification |
| `intent/charge/charge.go` | Charge intent (one-time payment) |
| `intent/session/session.go` | Session intent (escrow + vouchers) |
| `voucher/voucher.go` | EIP-712 cumulative voucher signing |
| `method/tempo/tempo.go` | Tempo on-chain payment method |
| `middleware/middleware.go` | HTTP middleware for Go servers |
| `types/types.go` | Core MPP types |

## MPP Protocol Flow

```
Client                              Server
  |                                    |
  |-- HTTP Request ------------------>|
  |                                    |
  |<-- 402 + WWW-Authenticate: Payment|
  |    (challenge: intent, amount,     |
  |     method, recipient)             |
  |                                    |
  |-- Fulfill payment (on-chain or    |
  |   voucher depending on intent)     |
  |                                    |
  |-- Retry + Authorization: Payment ->|
  |    (proof of payment)              |
  |                                    |
  |<-- 200 + Payment-Receipt ---------|
  |    (resource + receipt header)     |
```

## References

- https://github.com/tempoxyz/mpp-go
- https://mpp.dev
- https://mpp.dev/overview
