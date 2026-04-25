---
title: go-ethereum Source Code Navigation
impact: CRITICAL
impactDescription: Primary source for protocol implementation analysis
tags: go-ethereum, geth, source code
---

# go-ethereum Source Code Navigation

go-ethereum (geth) is the official Go implementation of the Ethereum protocol. It is the reference implementation used by most Ethereum nodes and is the primary source for understanding how Ethereum rules are enforced in production.

Local submodule path: `<RESEARCH_ROOT>/go-ethereum`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `core/` | Blockchain core logic, block processing, state management, EVM entry points |
| `core/vm/` | EVM implementation: interpreter loop, opcode dispatch, instruction set |
| `core/state/` | State database and account management (statedb, journal, trie integration) |
| `consensus/` | Consensus engine implementations (beacon, ethash, clique) |
| `eth/` | Ethereum protocol wire handling, chain sync, peer management |
| `p2p/` | Peer-to-peer networking layer, discovery (discv4/discv5), transport |
| `accounts/` | Account management, keystore, HD wallet, external signer support |
| `cmd/geth/` | geth CLI entry point, flags, subcommands |
| `params/` | Chain configuration, protocol parameters, hardfork block/slot definitions |
| `internal/ethapi/` | JSON-RPC API implementation (eth_, debug_, net_, web3_) |
| `miner/` | Block production: tx selection, payload building |
| `trie/` | Merkle Patricia trie and Verkle trie implementation |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/go-ethereum`:

```bash
# Find opcode definition
grep -rn "PUSH1\|OpCode" core/vm/opcodes.go

# Find where a hardfork is enabled
grep -rn "IsShanghai\|IsCancun\|IsPrague" params/config.go core/

# Find a specific RPC method handler
grep -rn "eth_getTransactionByHash\|GetTransactionByHash" internal/ethapi/

# Find state transition logic
grep -rn "ApplyTransaction\|StateTransition" core/

# Search for a specific EIP number
grep -rn "EIP-4844\|eip4844\|BlobTx" core/ params/
```

File naming conventions:
- `*_test.go` -- unit tests, good for understanding expected behavior
- `*_fuzz_test.go` -- fuzz targets
- Generated files often have `// Code generated` headers

## Common Investigation Paths

**"How does opcode X work?"**
- Start at `core/vm/opcodes.go` for the opcode constant
- Find the instruction implementation in `core/vm/instructions.go`
- Check the jump table wiring in `core/vm/jump_table.go`
- Review `core/vm/interpreter.go` for the execution loop

**"How does consensus work?"**
- `consensus/beacon/consensus.go` -- post-Merge PoS consensus (delegates finality to CL)
- `consensus/ethash/consensus.go` -- legacy PoW (pre-Merge reference)
- `consensus/clique/consensus.go` -- PoA for testnets

**"What changed in hardfork X?"**
- `params/config.go` -- fork activation block numbers / timestamps per network
- Search `IsShanghai`, `IsCancun`, `IsPrague`, etc. across `core/` for feature guards
- Each hardfork guard wraps new behavior: `if rules.IsCancun { ... }`

**"How does transaction processing work?"**
- `core/state_processor.go` -- `Process()` applies a block's transactions to state
- `core/state_transition.go` -- `TransitionDb()` applies a single transaction
- `core/vm/evm.go` -- `Call()`, `Create()` entry points into the EVM

**"How does blob / EIP-4844 work?"**
- `core/types/tx_blob.go` -- blob transaction type
- `params/config.go` -- `CancunTime` activation
- `core/vm/contracts.go` -- point evaluation precompile

## Key Files

| File | Purpose |
|------|---------|
| `params/config.go` | All fork activation block numbers and timestamps; `ChainConfig` struct |
| `core/vm/opcodes.go` | Complete opcode definitions and hex values |
| `core/vm/instructions.go` | Opcode implementations |
| `core/vm/jump_table.go` | Per-hardfork opcode availability tables |
| `consensus/beacon/consensus.go` | Post-Merge consensus engine |
| `core/state_transition.go` | Single transaction state transition (`TransitionDb`) |
| `core/state_processor.go` | Block-level transaction processing (`Process`) |
| `trie/trie.go` | Merkle Patricia trie core logic |

## References

- https://github.com/ethereum/go-ethereum
- https://geth.ethereum.org/docs
