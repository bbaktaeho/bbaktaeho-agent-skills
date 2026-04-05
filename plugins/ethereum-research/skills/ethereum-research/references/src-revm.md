---
title: revm EVM Implementation Source Code Navigation
impact: HIGH
impactDescription: Rust EVM implementation used by reth for opcode-level analysis
tags: revm, rust, evm, interpreter
---

# revm EVM Implementation Source Code Navigation

revm is a Rust implementation of the Ethereum Virtual Machine. It is the EVM engine used by reth and other Rust-based Ethereum tools. revm handles bytecode interpretation, opcode execution, gas metering, and precompiled contract calls. For opcode-level and EVM internals research, revm is the primary source alongside go-ethereum's `core/vm/`.

Local submodule path: `<RESEARCH_ROOT>/revm`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `crates/revm/` | Main EVM crate, top-level execution entry |
| `crates/interpreter/` | Bytecode interpreter loop, opcode dispatch |
| `crates/interpreter/src/instructions/` | Individual opcode implementations |
| `crates/primitives/` | EVM primitive types (U256, Address, Bytes) |
| `crates/precompile/` | Precompiled contract implementations (ecrecover, sha256, bn128, etc.) |
| `crates/database/` | Database abstraction interfaces |
| `crates/context/` | EVM context types (block, transaction, call context) |
| `crates/handler/` | EVM execution handler and frame logic |
| `crates/specification/` | Hardfork specification IDs and feature flags |
| `crates/bytecode/` | Bytecode analysis, jump table, EOF support |
| `crates/state/` | State types (account, storage) |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/revm`:

```bash
# Find opcode definition
grep -rn "PUSH1\|CREATE2\|SSTORE\|OpCode" crates/interpreter/src/opcode.rs

# Find opcode implementation
grep -rn "fn sstore\|fn sload\|fn call\|fn create" crates/interpreter/src/instructions/

# Find gas cost calculation
grep -rn "gas_cost\|calc_gas\|GasSpec\|gas!" crates/interpreter/src/

# Find precompile implementation
grep -rn "ecrecover\|bn128\|point_evaluation\|kzg" crates/precompile/src/

# Find hardfork spec IDs
grep -rn "SpecId\|CANCUN\|PRAGUE\|SHANGHAI" crates/specification/src/

# Find EVM entry point
grep -rn "transact\|execute_frame\|run_interpreter" crates/handler/

# Find EOF (EVM Object Format) support
grep -rn "Eof\|EOF\|EofBody\|eof_create" crates/bytecode/ crates/interpreter/
```

## Common Investigation Paths

**"How does an opcode work in revm?"**
- Start at `crates/interpreter/src/opcode.rs` for the opcode constant and gas info
- Find the implementation in `crates/interpreter/src/instructions/` (grouped by category)
- Instruction categories: `arithmetic.rs`, `memory.rs`, `stack.rs`, `system.rs`, `host.rs`, `control.rs`, `contract.rs`, `data.rs`
- Check `crates/interpreter/src/table.rs` for the opcode dispatch table

**"How does revm handle gas?"**
- `crates/interpreter/src/gas.rs` for the gas counter and tracking
- `crates/interpreter/src/gas/calc.rs` for gas cost calculations per opcode
- `crates/interpreter/src/gas/constants.rs` for gas cost constants
- Per-hardfork gas schedules via `SpecId` in `crates/specification/`

**"How does the interpreter loop work?"**
- `crates/interpreter/src/interpreter.rs` for the main interpreter struct
- `crates/interpreter/src/interpreter_action.rs` for call/create actions
- `crates/handler/` for how frames are pushed and results propagated

**"How does revm handle precompiles?"**
- `crates/precompile/src/` for all precompile implementations
- Subdirectories per precompile category: `bn128/`, `bls12_381/`, `kzg_point_evaluation.rs`
- `crates/precompile/src/lib.rs` for the precompile registry per hardfork

**"What changed per hardfork in revm?"**
- `crates/specification/src/hardfork.rs` for `SpecId` enum (FRONTIER through PRAGUE and beyond)
- Search `SpecId::enabled` or feature gates across `crates/interpreter/src/instructions/`
- Precompile availability per hardfork in `crates/precompile/src/lib.rs`

**"How does revm compare to go-ethereum's EVM?"**
- revm `crates/interpreter/src/instructions/` corresponds to go-ethereum `core/vm/instructions.go`
- revm `crates/interpreter/src/opcode.rs` corresponds to go-ethereum `core/vm/opcodes.go`
- revm `crates/precompile/` corresponds to go-ethereum `core/vm/contracts.go`
- revm `crates/specification/` corresponds to go-ethereum `core/vm/jump_table.go` (per-fork opcode tables)

## Key Files

| File | Purpose |
|------|---------|
| `crates/interpreter/src/opcode.rs` | Complete opcode definitions |
| `crates/interpreter/src/instructions/host.rs` | SLOAD, SSTORE, BALANCE, CALL, etc. |
| `crates/interpreter/src/instructions/system.rs` | RETURN, REVERT, SELFDESTRUCT, etc. |
| `crates/interpreter/src/instructions/contract.rs` | CREATE, CREATE2, CALL variants |
| `crates/interpreter/src/gas/calc.rs` | Gas cost calculations |
| `crates/specification/src/hardfork.rs` | Hardfork SpecId definitions |
| `crates/precompile/src/lib.rs` | Precompile registry |
| `crates/handler/src/frame.rs` | EVM call frame handling |
| `crates/bytecode/src/eof.rs` | EOF bytecode format support |

## References

- https://github.com/bluealloy/revm
- https://bluealloy.github.io/revm/
