---
title: Prysm Beacon Chain Source Code Navigation
impact: CRITICAL
impactDescription: Primary source for PoS consensus layer implementation analysis
tags: prysm, beacon-chain, consensus, pos
---

# Prysm Beacon Chain Source Code Navigation

Prysm is a Go implementation of the Ethereum consensus layer (beacon chain) client. It implements the beacon chain specification including PoS consensus, validator duties, attestation handling, and slot/epoch processing. This fork (offchainlabs/prysm) is maintained by Offchain Labs.

Local submodule path: `<RESEARCH_ROOT>/prysm`

## Key Directory Map

| Directory | Description |
|-----------|-------------|
| `beacon-chain/` | Core beacon chain node logic |
| `beacon-chain/core/` | State transition functions (blocks, epochs, validators) |
| `beacon-chain/state/` | Beacon state management and accessors |
| `beacon-chain/blockchain/` | Chain service, fork choice rule (LMD-GHOST) |
| `beacon-chain/p2p/` | P2P networking, topic subscriptions, peer management |
| `beacon-chain/sync/` | Chain synchronization (initial sync, regular sync) |
| `beacon-chain/operations/` | Operations pool (attestations, deposits, slashings, exits) |
| `beacon-chain/rpc/` | gRPC and REST API endpoints |
| `beacon-chain/db/` | Database layer (beacon state, blocks) |
| `beacon-chain/forkchoice/` | Fork choice store and weight calculations |
| `beacon-chain/execution/` | Engine API communication with execution layer |
| `consensus-types/` | Shared consensus type definitions (blocks, attestations) |
| `config/` | Chain configuration, network parameters, fork versions |
| `config/params/` | Mainnet, testnet, and minimal preset values |
| `proto/` | Protobuf definitions for all beacon chain types |
| `validator/` | Validator client implementation (duties, signing, slashing protection) |
| `cmd/beacon-chain/` | Beacon node CLI entry point |
| `cmd/validator/` | Validator client CLI entry point |
| `runtime/` | Runtime utilities (version, interop) |
| `encoding/` | SSZ, bytesutil, and other encoding utilities |
| `crypto/` | BLS signatures, hashing |
| `time/slots/` | Slot/epoch time calculations |

## How to Search

Useful grep patterns inside `<RESEARCH_ROOT>/prysm`:

```bash
# Find where a specific fork is activated
grep -rn "IsBellatrix\|IsCapella\|IsDeneb\|IsElectra" config/ beacon-chain/

# Find state transition entry point
grep -rn "ExecuteStateTransition\|ProcessSlots\|ProcessBlock" beacon-chain/core/

# Find fork choice logic
grep -rn "GetHead\|ProcessAttestation\|UpdateJustified" beacon-chain/forkchoice/

# Find validator duty assignment
grep -rn "CommitteeAssignment\|ProposerIndex\|AttestationCommittee" beacon-chain/core/

# Find Engine API integration
grep -rn "NewPayload\|ForkchoiceUpdated\|GetPayload" beacon-chain/execution/

# Find slashing conditions
grep -rn "IsSlashableAttestation\|IsSlashableBlock\|ProcessProposerSlashing" beacon-chain/core/

# Find specific config parameter
grep -rn "SlotsPerEpoch\|MaxEffectiveBalance\|EjectionBalance" config/params/
```

## Common Investigation Paths

**"How does PoS consensus work?"**
- Start at `beacon-chain/blockchain/process_block.go` for block processing
- `beacon-chain/core/state/transition.go` for the state transition function
- `beacon-chain/forkchoice/` for LMD-GHOST fork choice rule
- `config/params/mainnet_config.go` for consensus constants

**"How does attestation processing work?"**
- `beacon-chain/core/blocks/attestation.go` for attestation validation
- `beacon-chain/operations/attestations/` for attestation pool management
- `beacon-chain/forkchoice/` for how attestations influence fork choice weight

**"How does validator selection work?"**
- `beacon-chain/core/helpers/committee.go` for committee computation
- `beacon-chain/core/helpers/beacon_committee.go` for beacon committee assignment
- `beacon-chain/core/helpers/validators.go` for active validator set

**"How does the beacon chain talk to the execution layer?"**
- `beacon-chain/execution/engine_client.go` for Engine API calls
- `beacon-chain/execution/payload_body.go` for payload body retrieval
- `beacon-chain/blockchain/` for how payload validation fits into block processing

**"How does epoch processing work?"**
- `beacon-chain/core/epoch/` for epoch transition logic
- Justification and finalization in `beacon-chain/core/epoch/epoch_processing.go`
- Rewards and penalties calculation
- Validator registry updates

**"What changed in fork X (Capella, Deneb, Electra)?"**
- `config/params/mainnet_config.go` for fork epochs and versions
- Search `Is{ForkName}` guards across `beacon-chain/` for feature gates
- `beacon-chain/core/` for fork-specific state transition logic

## Key Files

| File | Purpose |
|------|---------|
| `config/params/mainnet_config.go` | All mainnet configuration parameters and fork epochs |
| `beacon-chain/core/state/transition.go` | Core state transition function |
| `beacon-chain/blockchain/process_block.go` | Block processing pipeline |
| `beacon-chain/forkchoice/doubly-linked-tree/store.go` | Fork choice store (LMD-GHOST) |
| `beacon-chain/core/helpers/committee.go` | Committee and proposer computation |
| `beacon-chain/execution/engine_client.go` | Engine API client (EL communication) |
| `beacon-chain/core/blocks/attestation.go` | Attestation processing |
| `beacon-chain/core/epoch/epoch_processing.go` | Epoch boundary processing |
| `proto/prysm/v1alpha1/beacon_block.proto` | Beacon block protobuf definitions |
| `validator/client/propose.go` | Validator block proposal logic |

## Relationship to go-ethereum

Prysm (CL) communicates with go-ethereum (EL) via the Engine API:

1. `beacon-chain/execution/engine_client.go` calls `engine_newPayloadV*` and `engine_forkchoiceUpdatedV*`
2. go-ethereum `eth/catalyst/api.go` handles these Engine API calls
3. The CL drives block production: Prysm requests payloads from go-ethereum via `engine_getPayloadV*`

Cross-reference: Prysm fork epochs in `config/params/mainnet_config.go` correspond to go-ethereum fork timestamps in `params/config.go`.

## References

- https://github.com/offchainlabs/prysm
- https://docs.prylabs.network/
- https://github.com/ethereum/consensus-specs
