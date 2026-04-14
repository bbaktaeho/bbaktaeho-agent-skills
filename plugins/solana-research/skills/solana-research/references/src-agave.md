---
title: anza-xyz/agave Source Code Navigation
impact: CRITICAL
impactDescription: Active Solana validator client maintained by Anza -- primary source for current implementation
tags: agave, anza, validator, svm, runtime
---

# anza-xyz/agave Source Code Navigation

agave is the active Solana validator client maintained by Anza (the company formed from Solana Labs engineers). It is a fork of solana-labs/solana and represents the primary codebase for current Solana validator development. All new feature work, SIMDs, and performance improvements target agave. The directory structure closely mirrors solana-labs/solana but diverges as agave-specific refactors land.

Local submodule path: `<RESEARCH_ROOT>/agave`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `runtime/` | Bank state machine; transaction execution, account loading, fee handling |
| `svm/` | Solana Virtual Machine -- transaction processor, message processor, BPF loader |
| `poh/` | Proof of History service -- SHA-256 chain, tick loop |
| `core/` | Validator core: banking stage, broadcast, replay, cluster info |
| `core/src/banking_stage/` | Transaction ingestion, QoS, cost model, scheduler |
| `turbine/` | Turbine block propagation -- shred creation, retransmit tree |
| `gossip/` | Gossip protocol -- cluster membership, CRDS, push/pull |
| `ledger/` | Blockstore -- shred storage, slot metadata, duplicate slot handling |
| `accounts-db/` | AccountsDB -- tiered storage, append-vec, hot/cold account separation |
| `sdk/` | SDK types -- transactions, accounts, feature set, pubkeys |
| `sdk/src/feature_set.rs` | Feature flags and activation (source of truth for agave features) |
| `program-runtime/` | Program runtime -- CPI invocation stack, compute budget |
| `programs/` | Builtin programs (system, vote, stake, BPF loaders, config) |
| `rpc/` | JSON-RPC and WebSocket server |
| `streamer/` | UDP packet streaming |
| `perf/` | Performance utilities |
| `validator/` | Validator startup and lifecycle |
| `cli/` | CLI subcommands |
| `transaction-dos/` | DOS simulation tooling |
| `unified-scheduler/` | Unified transaction scheduler (SIMD-based) |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/agave`:

```bash
# Find feature flag declarations
grep -rn "declare_id!\|pub mod " sdk/src/feature_set.rs | head -40

# Find where a feature is gated in the runtime
grep -rn "is_active(&feature_set::" runtime/src/ svm/src/

# Find compute budget enforcement
grep -rn "ComputeBudget\|compute_unit_limit\|requested_compute_units" program-runtime/src/

# Find banking stage scheduler
grep -rn "SchedulerPool\|PrioGraphScheduler\|TransactionScheduler" core/src/banking_stage/

# Find SVM transaction processing entry point
grep -rn "load_and_execute_sanitized_transactions\|process_loaded_transactions" svm/src/

# Find unified scheduler
grep -rn "UnifiedScheduler\|scheduling_mode\|task_handler" unified-scheduler/

# Find turbine shred types
grep -rn "Shred\|ShredType\|coding_shred\|data_shred" turbine/src/

# Find gossip message types
grep -rn "CrdsData\|ContactInfo\|NodeInstance" gossip/src/
```

## Common Investigation Paths

**"How does agave process transactions?"**
- `svm/src/transaction_processor.rs` -- `load_and_execute_sanitized_transactions`
- `svm/src/message_processor.rs` -- per-instruction dispatch and CPI
- `runtime/src/bank.rs` -- `process_transaction_batch` and fee handling
- `program-runtime/src/invoke_context.rs` -- compute budget and call stack

**"How does the unified scheduler work?"**
- `unified-scheduler/src/scheduler_pool.rs` -- scheduler pool management
- `core/src/banking_stage/scheduler_controller.rs` -- integration with banking stage
- Compare with legacy `core/src/banking_stage/` thread-based approach

**"How does agave differ from solana-labs/solana?"**
- Check `CHANGELOG.md` or `CONTRIBUTING.md` in agave root for divergence notes
- `unified-scheduler/` exists in agave but not in the original solana repo
- `accounts-db/` has tiered storage additions in agave
- Feature flags in `sdk/src/feature_set.rs` diverge; agave has newer SIMDs implemented

**"How does compute budget work?"**
- `program-runtime/src/compute_budget.rs` -- `ComputeBudget` struct and limits
- `program-runtime/src/compute_budget_processor.rs` -- instruction parsing for compute budget
- `svm/src/transaction_processor.rs` -- budget enforcement during execution

**"How does agave handle QoS and cost model?"**
- `core/src/banking_stage/qos_service.rs` -- Quality of Service transaction filtering
- `cost-model/src/cost_model.rs` -- per-transaction cost estimation
- `core/src/banking_stage/` -- cost-based transaction selection

**"How does account storage work in agave?"**
- `accounts-db/src/accounts_db.rs` -- AccountsDB with tiered storage support
- `accounts-db/src/tiered_storage/` -- cold/hot account tier separation
- `runtime/src/bank.rs` -- account cache layer above AccountsDB

## Key Files

| File | Purpose |
|------|---------|
| `runtime/src/bank.rs` | Core ledger state machine |
| `svm/src/transaction_processor.rs` | SVM transaction execution entry point |
| `svm/src/message_processor.rs` | Per-instruction invocation and CPI |
| `program-runtime/src/invoke_context.rs` | Invocation context, compute budget, call stack |
| `program-runtime/src/compute_budget.rs` | Compute budget struct and defaults |
| `poh/src/poh_service.rs` | PoH tick loop |
| `core/src/banking_stage/mod.rs` | Banking stage coordinator |
| `core/src/replay_stage.rs` | Block replay and vote |
| `core/src/consensus/mod.rs` | Tower BFT fork choice |
| `turbine/src/broadcast_stage.rs` | Leader shred broadcast |
| `accounts-db/src/accounts_db.rs` | AccountsDB storage engine |
| `sdk/src/feature_set.rs` | Feature flags (source of truth) |
| `unified-scheduler/src/scheduler_pool.rs` | Unified scheduler pool |
| `cost-model/src/cost_model.rs` | Transaction cost model |

## Relationship to solana-labs/solana

Agave forked from solana-labs/solana. Key differences:
1. `unified-scheduler/` -- new transaction scheduling subsystem (SIMD-83)
2. `accounts-db/tiered_storage/` -- hot/cold account tiering
3. Feature set in `sdk/src/feature_set.rs` has agave-specific SIMDs
4. Ongoing refactors split monolithic modules (e.g., SVM extracted from runtime)
5. Anza maintains agave; Solana Labs maintains solana but at a slower cadence

When comparing, prefer agave for current behavior. Use solana-labs/solana for historical context or when agave diverges from documentation.

## References

- https://github.com/anza-xyz/agave
- https://docs.anza.xyz/
- https://www.anza.xyz/blog
