---
title: Reth Execution Layer Source Code Navigation
impact: CRITICAL
impactDescription: Rust-based execution layer implementation for multi-client analysis
tags: reth, rust, execution-layer, paradigm
---

# Reth Execution Layer Source Code Navigation

Reth is a Rust implementation of the Ethereum execution layer built by Paradigm. It provides a modular, performance-focused alternative to go-ethereum for running Ethereum nodes. Reth uses revm as its EVM engine.

Local submodule path: `<RESEARCH_ROOT>/reth`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `crates/ethereum/node/` | Ethereum node builder and configuration |
| `crates/evm/` | EVM abstraction layer (delegates to revm) |
| `crates/consensus/consensus/` | Consensus validation rules |
| `crates/consensus/auto-seal/` | Auto-sealing for dev mode |
| `crates/primitives/` | Core types (blocks, transactions, accounts, headers) |
| `crates/storage/db/` | Database layer (MDBX) |
| `crates/storage/provider/` | State and chain data providers |
| `crates/net/network/` | P2P networking (devp2p, eth protocol) |
| `crates/net/discv4/` | Node discovery v4 |
| `crates/rpc/rpc/` | JSON-RPC endpoint handlers |
| `crates/rpc/rpc-eth-api/` | eth_ namespace API types |
| `crates/trie/trie/` | Merkle Patricia trie implementation |
| `crates/stages/stages/` | Sync pipeline stages (headers, bodies, execution, etc.) |
| `crates/payload/builder/` | Payload builder for block production |
| `crates/transaction-pool/` | Transaction pool management |
| `crates/chain-state/` | In-memory chain state and canonical chain tracking |
| `crates/chainspec/` | Chain specification and hardfork configuration |
| `crates/engine/tree/` | Engine API tree-based state management |
| `bin/reth/` | CLI entry point |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/reth`:

```bash
# Find hardfork activation logic
grep -rn "is_shanghai\|is_cancun\|is_prague\|Hardfork" crates/chainspec/

# Find EVM execution entry point
grep -rn "execute\|ExecuteOutput\|BlockExecutor" crates/evm/

# Find state transition logic
grep -rn "StateProvider\|StateRoot\|AccountReader" crates/storage/provider/

# Find consensus validation
grep -rn "validate_header\|validate_block\|validate_body" crates/consensus/

# Find RPC handler for specific method
grep -rn "eth_getBalance\|eth_call\|eth_sendTransaction" crates/rpc/

# Find transaction pool logic
grep -rn "add_transaction\|validate_transaction\|BestTransactions" crates/transaction-pool/

# Find pipeline stage definitions
grep -rn "Stage\|ExecutionStage\|HeaderStage" crates/stages/stages/

# Find Engine API handling
grep -rn "new_payload\|forkchoice_updated\|get_payload" crates/engine/
```

## Common Investigation Paths

**"How does reth execute blocks?"**
- `crates/evm/src/execute.rs` for the `BlockExecutor` trait
- `crates/ethereum/evm/src/execute.rs` for Ethereum-specific block execution
- revm integration via `crates/evm/` crate which wraps revm calls
- `crates/stages/stages/src/stages/execution.rs` for the execution pipeline stage

**"How does reth handle state?"**
- `crates/storage/provider/` for state provider traits and implementations
- `crates/storage/db/` for the underlying MDBX database
- `crates/trie/trie/` for state root computation
- `crates/chain-state/` for in-memory canonical chain state

**"How does reth sync the chain?"**
- `crates/stages/stages/` for the staged sync pipeline
- Stage order: Headers -> Bodies -> SenderRecovery -> Execution -> AccountHashing -> StorageHashing -> MerkleUnwind -> Finish
- `crates/net/network/` for peer management and block propagation

**"How does reth integrate with the consensus layer?"**
- `crates/engine/tree/` for the engine API state tree
- Engine API handlers process `newPayload`, `forkchoiceUpdated`
- `crates/payload/builder/` for building execution payloads

**"How does reth differ from go-ethereum?"**
- Rust vs Go: different concurrency models, memory management
- Staged sync pipeline vs monolithic sync
- MDBX vs LevelDB storage
- revm as pluggable EVM vs integrated interpreter
- Modular crate-based architecture vs package-based

## Key Files

| File | Purpose |
|------|---------|
| `crates/chainspec/src/spec.rs` | Chain specification with hardfork definitions |
| `crates/evm/src/execute.rs` | Block executor trait definition |
| `crates/ethereum/evm/src/execute.rs` | Ethereum block execution implementation |
| `crates/consensus/consensus/src/lib.rs` | Consensus trait and validation interface |
| `crates/primitives/src/transaction/mod.rs` | Transaction type definitions |
| `crates/storage/provider/src/providers/state/latest.rs` | Latest state provider |
| `crates/stages/stages/src/stages/execution.rs` | Execution pipeline stage |
| `crates/trie/trie/src/state.rs` | State trie computation |
| `crates/transaction-pool/src/pool/mod.rs` | Transaction pool core logic |

## Relationship to revm

Reth delegates EVM execution to revm:

1. `crates/evm/` defines the `BlockExecutor` trait
2. The Ethereum implementation in `crates/ethereum/evm/` wraps revm
3. revm handles opcode interpretation, gas accounting, and precompiles
4. Reth provides the state database interface that revm reads from and writes to

Cross-reference: reth `crates/chainspec/` hardfork definitions correspond to revm `crates/specification/` `SpecId` variants.

## References

- https://github.com/paradigmxyz/reth
- https://reth.rs/
- https://paradigmxyz.github.io/reth/
