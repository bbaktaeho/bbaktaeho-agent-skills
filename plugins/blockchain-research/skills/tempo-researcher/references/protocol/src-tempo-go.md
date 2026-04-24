---
title: tempo-go SDK Source Code Navigation
impact: HIGH
impactDescription: Go SDK for building applications on Tempo chain
tags: tempo-go, sdk, go, rpc, transaction, signing
---

# tempo-go SDK Source Code Navigation

tempo-go is the official Go SDK for building applications on Tempo. It provides transaction encoding/decoding, RPC client wrappers, signing utilities, keychain management, and helpers for constructing Tempo-specific transaction types (Type 0x76) including fee sponsorship, batch calls, 2D nonces, and passkey authentication.

Local submodule path: `<RESEARCH_ROOT>/tempo-go`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `tx/` | Transaction building and encoding -- Tempo Transaction (Type 0x76) construction |
| `tx/builder.go` | Transaction builder with fee sponsorship, batch calls, 2D nonces |
| `rpc/` | JSON-RPC client -- wrappers around Ethereum JSON-RPC with Tempo extensions |
| `signing/` | Transaction signing -- secp256k1, P-256 (passkey), access key signing |
| `keychain/` | Key management -- local keystore, hardware wallet integration |
| `types/` | Core types -- TIP-20 transfer, TIP-403 policy, Fee AMM types |
| `abi/` | ABI encoding/decoding for Tempo protocol contracts |
| `accounts/` | Account abstraction utilities -- smart account interaction helpers |
| `crypto/` | Cryptographic primitives -- P-256, BLS, signature aggregation |
| `ethclient/` | Extended ethclient with Tempo-specific methods |
| `cmd/` | CLI tools and examples |
| `examples/` | Example applications demonstrating SDK usage |

## How to Search

```bash
# Find transaction builder methods
grep -rn "func.*Builder\|NewTransaction\|WithSponsor\|WithBatch\|WithNonceKey" tx/

# Find RPC client methods
grep -rn "func.*Client\|SendTransaction\|Call\|GetBalance\|GetTIP20" rpc/

# Find signing implementations
grep -rn "Sign\|P256\|Passkey\|AccessKey\|secp256k1\|secp256r1" signing/

# Find TIP-20 helpers
grep -rn "TIP20\|Transfer\|Memo\|CurrencyID\|Mint\|Burn" types/ abi/

# Find fee sponsorship logic
grep -rn "Sponsor\|sponsor\|fee_sponsor\|SponsorSignature" tx/

# Find 2D nonce usage
grep -rn "NonceKey\|nonce_key\|WithNonceKey\|ConcurrentNonce" tx/

# Find batch call construction
grep -rn "BatchCall\|WithBatch\|batch\|MultiCall" tx/

# Find keychain management
grep -rn "Keychain\|LoadKey\|DeriveKey\|HardwareWallet" keychain/
```

## Common Investigation Paths

**"How to build a Tempo transaction in Go?"**
- Start at `tx/builder.go` for the transaction builder API
- `tx/` directory for encoding and type construction
- `signing/` for signing the constructed transaction
- `rpc/` for submitting via JSON-RPC

**"How does fee sponsorship work in the SDK?"**
- `tx/builder.go` for `WithSponsor()` builder method
- Transaction includes sponsor signature in a separate domain
- Sponsor signs over fee-related fields; sender signs over call data

**"How to use passkey authentication?"**
- `signing/` for P-256 signing implementation
- `crypto/` for P-256 curve operations
- Transaction builder supports passkey-signed transactions natively

**"How to construct batch calls?"**
- `tx/builder.go` for `WithBatch()` builder method
- Atomic multi-operation execution in a single transaction
- Each operation in the batch is encoded sequentially

**"How to interact with TIP-20 tokens?"**
- `types/` for TIP-20 transfer types and memo fields
- `abi/` for ABI encoding of TIP-20 contract calls
- Transfer memos are 32-byte fields for invoice IDs, cost centers

## Key Files

| File | Purpose |
|------|---------|
| `tx/builder.go` | Transaction builder (fee sponsorship, batch, 2D nonce) |
| `tx/types.go` | Tempo Transaction (Type 0x76) type definitions |
| `tx/encode.go` | Transaction RLP encoding |
| `rpc/client.go` | JSON-RPC client with Tempo extensions |
| `signing/signer.go` | Multi-algorithm transaction signing |
| `signing/p256.go` | P-256 (passkey) signature support |
| `keychain/keychain.go` | Local key management |
| `types/tip20.go` | TIP-20 token types and helpers |
| `accounts/account.go` | Smart account interaction utilities |

## References

- https://github.com/tempoxyz/tempo-go
- https://docs.tempo.xyz
