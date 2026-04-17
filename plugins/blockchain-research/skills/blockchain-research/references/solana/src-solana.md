---
title: solana-labs/solana Source Code Navigation
impact: CRITICAL
impactDescription: Primary source for Solana runtime and SVM implementation analysis
tags: solana, runtime, svm, poh, turbine
---

# solana-labs/solana Source Code Navigation

solana-labs/solana is the original Rust implementation of the Solana validator, runtime, and SVM (Solana Virtual Machine). While active development has largely moved to anza-xyz/agave (a fork), this repository remains an important historical and architectural reference. Key subsystems such as the runtime, PoH, banking stage, and turbine block propagation originated here.

Local submodule path: `<RESEARCH_ROOT>/solana`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `runtime/` | Bank -- the core ledger state machine; transaction execution, account management, fee handling |
| `svm/` | Solana Virtual Machine -- BPF loader, program execution, instruction processing |
| `poh/` | Proof of History service -- SHA-256 chain-based cryptographic clock |
| `core/` | Validator core: banking stage, broadcast stage, replay stage, cluster info |
| `core/src/banking_stage/` | Transaction ingestion, deduplication, and scheduling |
| `turbine/` | Turbine block propagation -- shred creation, erasure coding, retransmit tree |
| `gossip/` | Gossip protocol -- cluster membership, crds table, push/pull propagation |
| `ledger/` | Blockstore -- persistent storage for shreds, slots, and entries |
| `accounts-db/` | AccountsDB -- account storage, append-vec, snapshot management |
| `sdk/` | Solana SDK types -- instructions, transactions, accounts, pubkeys, feature set |
| `sdk/src/feature_set.rs` | Feature flags and their activation status |
| `programs/` | Builtin on-chain programs (system, vote, stake, BPF loader, config) |
| `vote/` | Vote program logic and tower state |
| `stake/` | Stake program logic and delegation |
| `rpc/` | JSON-RPC server implementation |
| `streamer/` | UDP packet streaming layer |
| `perf/` | Performance utilities (packet batching, CUDA, SIMD) |
| `net-utils/` | Network utilities and port configuration |
| `validator/` | Validator startup, configuration, and lifecycle |
| `cli/` | CLI entry point and subcommands |
| `bench-tps/` | Transaction throughput benchmark tool |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/solana`:

```bash
# Find where a feature flag is declared
grep -rn "lazy_static\|declare_id\|feature_name" sdk/src/feature_set.rs

# Find where a specific feature is gated
grep -rn "feature_set.is_active\|is_active.*feature" runtime/src/

# Find PoH service tick handling
grep -rn "record_slot\|tick_height\|PohRecorder" poh/src/

# Find banking stage transaction processing
grep -rn "process_transactions\|BankingStage\|TransactionBatch" core/src/banking_stage/

# Find SVM instruction dispatch
grep -rn "process_instruction\|InvokeContext\|BpfLoader" svm/src/

# Find account state management in Bank
grep -rn "get_account\|store_account\|AccountSharedData" runtime/src/bank.rs

# Find turbine shred handling
grep -rn "Shred\|retransmit\|erasure_code" turbine/src/

# Find gossip CRDS updates
grep -rn "CrdsValue\|push_message\|pull_request" gossip/src/
```

## Common Investigation Paths

**"How does transaction execution work?"**
- Start at `runtime/src/bank.rs` -- `process_transaction` and `load_execute_and_commit_transactions`
- `svm/src/transaction_processor.rs` -- instruction-level dispatch
- `svm/src/message_processor.rs` -- per-instruction invocation
- `programs/` -- builtin program implementations

**"How does Proof of History work?"**
- `poh/src/poh_service.rs` -- PoH tick loop
- `poh/src/poh.rs` -- SHA-256 hash chain
- `core/src/banking_stage/` -- how transactions are embedded in PoH entries

**"How does Tower BFT consensus work?"**
- `core/src/replay_stage.rs` -- block replay and vote generation
- `vote/src/vote_state/` -- vote state and lockout
- `core/src/consensus/` -- tower state, threshold checks, fork switching

**"How does block propagation work?"**
- `turbine/src/broadcast_stage.rs` -- leader shred creation and sending
- `turbine/src/retransmit_stage.rs` -- turbine retransmit tree
- `ledger/src/shred/` -- shred format and erasure coding

**"How does account storage work?"**
- `accounts-db/src/accounts_db.rs` -- append-vec storage and snapshots
- `runtime/src/bank.rs` -- account loading and caching (accounts cache)
- `accounts-db/src/accounts_index.rs` -- in-memory index for account lookups

**"What feature flags exist and which are active?"**
- `sdk/src/feature_set.rs` -- all feature declarations
- Runtime checks: `bank.feature_set.is_active(&feature_set::FEATURE_NAME::id())`

## Key Files

| File | Purpose |
|------|---------|
| `runtime/src/bank.rs` | Core ledger state machine; transaction processing entry point |
| `svm/src/transaction_processor.rs` | SVM transaction processor |
| `svm/src/message_processor.rs` | Per-instruction invocation and CPI handling |
| `poh/src/poh.rs` | SHA-256 hash chain implementation |
| `poh/src/poh_service.rs` | PoH service tick loop |
| `core/src/banking_stage/mod.rs` | Banking stage -- transaction ingestion |
| `core/src/replay_stage.rs` | Block replay and vote generation |
| `core/src/consensus/mod.rs` | Tower BFT consensus |
| `turbine/src/broadcast_stage.rs` | Block broadcast (leader side) |
| `turbine/src/retransmit_stage.rs` | Turbine retransmit tree |
| `accounts-db/src/accounts_db.rs` | AccountsDB storage engine |
| `sdk/src/feature_set.rs` | Feature flags and activation |
| `ledger/src/blockstore.rs` | Shred and slot persistent storage |
| `gossip/src/cluster_info.rs` | Gossip cluster membership |

## References

- https://github.com/solana-labs/solana
- https://docs.solanalabs.com/
