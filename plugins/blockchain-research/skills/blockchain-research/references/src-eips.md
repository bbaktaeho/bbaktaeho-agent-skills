---
title: EIP Repository Navigation
impact: CRITICAL
impactDescription: EIP document analysis and navigation
tags: eip, proposal, standard
---

# EIP Repository Navigation

The EIPs repository (https://github.com/ethereum/EIPs) is the canonical source of all Ethereum Improvement Proposals. Every protocol change, interface standard, and meta process goes through this repository.

Local submodule path: `<RESEARCH_ROOT>/EIPs`

## Directory Structure

```
EIPS/
  eip-1.md          -- EIP Purpose and Guidelines (meta)
  eip-20.md         -- ERC-20 Token Standard
  eip-721.md        -- ERC-721 Non-Fungible Token Standard
  eip-1559.md       -- Fee market change (London hardfork)
  eip-4844.md       -- Proto-danksharding / blob transactions (Dencun)
  eip-4895.md       -- Beacon chain push withdrawals (Shapella)
  eip-7702.md       -- Set EOA account code (Pectra)
  ...
assets/
  eip-NNNN/         -- Images and supplementary files for EIP NNNN
config/
  eips.json         -- Machine-readable EIP metadata index
```

Each EIP is a single Markdown file: `EIPS/eip-NNNN.md`

## EIP Frontmatter Fields

Every EIP begins with a YAML frontmatter block:

```yaml
---
eip: 4844
title: Shard Blob Transactions
author: Vitalik Buterin (@vbuterin), Dankrad Feist (@dankrad), ...
discussions-to: https://ethereum-magicians.org/t/...
status: Final
type: Standards Track
category: Core
created: 2022-02-25
requires: 1559, 2718, 2930
---
```

| Field | Description |
|-------|-------------|
| `eip` | EIP number (integer) |
| `title` | Short descriptive title |
| `author` | Authors with optional GitHub handles |
| `discussions-to` | Ethereum Magicians thread URL |
| `status` | Current status in the lifecycle |
| `type` | Standards Track, Meta, or Informational |
| `category` | Core, Networking, Interface, or ERC (Standards Track only) |
| `created` | ISO date of original creation |
| `requires` | EIP numbers this EIP depends on |

## EIP Status Lifecycle

```
Draft -> Review -> Last Call -> Final

Stagnant   (inactive Draft/Review)
Withdrawn  (author-withdrawn)
Living     (continuously updated; e.g., EIP-1)
```

| Status | Meaning |
|--------|---------|
| Draft | Initial submission, open for discussion |
| Review | Authors request peer review |
| Last Call | Final review window before Final; `last-call-deadline` set |
| Final | Accepted and normative |
| Stagnant | No activity for 6 months; reverts to Draft on update |
| Withdrawn | Author has withdrawn the proposal |
| Living | Intended to be perpetually updated (e.g., EIP-1) |

## EIP Types

**Standards Track** -- defines protocol changes or application standards:
- `Core` -- consensus and EVM changes; requires a hardfork or network upgrade
- `Networking` -- p2p protocol and DevP2P changes
- `Interface` -- client API/RPC specifications and standards
- `ERC` -- application-layer standards (tokens, signatures, etc.)

**Meta** -- describes a process or proposes a change to an EIP process

**Informational** -- provides general guidelines or information; not a protocol standard

## How to Search for EIPs

**By number** (when you know the EIP):
```bash
cat <RESEARCH_ROOT>/EIPs/EIPS/eip-4844.md
```

**By status** (find all Final Core EIPs):
```bash
grep -l "status: Final" <RESEARCH_ROOT>/EIPs/EIPS/ | xargs grep -l "category: Core"
```

**By category**:
```bash
grep -rl "category: Core" <RESEARCH_ROOT>/EIPs/EIPS/
grep -rl "category: ERC" <RESEARCH_ROOT>/EIPs/EIPS/
```

**By keyword in body**:
```bash
grep -rl "blob\|shard" <RESEARCH_ROOT>/EIPs/EIPS/
grep -rl "account abstraction" <RESEARCH_ROOT>/EIPs/EIPS/
```

**Using the machine-readable index**:
```bash
# List all EIPs with status and type
cat <RESEARCH_ROOT>/EIPs/config/eips.json | jq '.[] | select(.status == "Final") | {eip, title, category}'
```

**On the web** -- https://eips.ethereum.org/ provides a searchable interface.

## Key EIPs for Protocol Research

| EIP | Title | Hardfork | Significance |
|-----|-------|----------|-------------|
| EIP-1 | EIP Purpose and Guidelines | -- | The meta-EIP defining the EIP process itself |
| EIP-1559 | Fee Market Change | London | Base fee burn, priority fee model |
| EIP-3675 | Upgrade Consensus to PoS | The Merge | Defines the PoW-to-PoS transition |
| EIP-4895 | Beacon Chain Push Withdrawals | Shapella | Enables staked ETH withdrawals |
| EIP-4844 | Shard Blob Transactions | Dencun | Proto-danksharding; blob tx type, KZG commitments |
| EIP-7702 | Set EOA Account Code | Pectra | EOA-level account abstraction |
| EIP-4788 | Beacon Block Root in EVM | Dencun | CL state accessible from EL |
| EIP-7251 | Increase Max Effective Balance | Pectra | Validator balance consolidation |

## Relationship to go-ethereum and Forkcast

- An EIP reaches `Final` status after implementation and hardfork activation
- `params/config.go` in go-ethereum contains the activation timestamps matching the EIP's hardfork
- Forkcast `src/data/eips/{number}.json` tracks the governance journey of each EIP through protocol calls

Cross-reference workflow:
1. Read the EIP spec in `EIPS/eip-NNNN.md`
2. Check forkcast `src/data/eips/NNNN.json` for inclusion history
3. Find implementation in go-ethereum via the hardfork guard pattern

## References

- https://eips.ethereum.org/
- https://github.com/ethereum/EIPs
- https://ethereum.org/en/eips/
