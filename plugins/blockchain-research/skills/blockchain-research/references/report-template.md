---
title: Research Report Output Template
impact: CRITICAL
impactDescription: Structured output format for research results
tags: report, template, output
---

# Research Report Output Template

Use this template for every research report produced by this skill. All sections are required. If a section has no content, state the reason explicitly rather than omitting the section.

---

## Report Structure

### Overview

Provide a concise topic summary covering:
- What the topic is and why it matters
- Relevance to the current protocol state of the target chain
- Scope of this research (which sources were used, what was excluded)

### Technical Analysis

Explain the topic at the protocol specification level:
- Protocol-level description of the mechanism or change
- Design rationale and trade-offs
- Consensus implications
- Relationship to existing specifications

### Code-Level Analysis

Reference client implementations directly:
- Relevant packages and files within `<RESEARCH_ROOT>/{repo}/`
- Implementation details explaining how the protocol rule is encoded in code
- File path references in the format `<RESEARCH_ROOT>/{repo}/<path>:<line>`
- Code snippets where the exact implementation text is necessary for understanding
- Cross-client or cross-repo comparison when implementations differ

Example code reference formats:

```
# Ethereum
<RESEARCH_ROOT>/go-ethereum/core/vm/evm.go:312
<RESEARCH_ROOT>/reth/crates/evm/src/execute.rs:85
<RESEARCH_ROOT>/revm/crates/interpreter/src/instructions/host.rs:42
<RESEARCH_ROOT>/prysm/beacon-chain/core/state/transition.go:45

# Solana
<RESEARCH_ROOT>/solana/runtime/src/bank.rs:412
<RESEARCH_ROOT>/agave/svm/src/transaction_processor.rs:85
<RESEARCH_ROOT>/solana-program-library/token/program/src/processor.rs:42

# Tempo
<RESEARCH_ROOT>/tempo/crates/node/src/lib.rs:100
<RESEARCH_ROOT>/tempo-go/tx/builder.go:55
<RESEARCH_ROOT>/mpp-go/client/client.go:30
<RESEARCH_ROOT>/mpp-rs/crates/core/src/lib.rs:42
```

Use fenced code blocks for all source excerpts.

### Improvement Proposal / Protocol Change Mapping

List related improvement proposals using a table. Use the appropriate proposal type for each chain:

**Ethereum (EIPs):**

| EIP | Title | Status | Link |
|-----|-------|--------|------|
| EIP-XXXX | Title here | Final / Draft / Stagnant | https://eips.ethereum.org/EIPS/eip-XXXX |

**Solana (SIMDs):**

| SIMD | Title | Status | Link |
|------|-------|--------|------|
| SIMD-XXXX | Title here | Accepted / Draft / Withdrawn | https://github.com/solana-foundation/solana-improvement-documents/blob/main/proposals/XXXX.md |

**Tempo (TIPs):**

| TIP | Title | Status | Link |
|-----|-------|--------|------|
| TIP-XX | Title here | Active / Draft | https://docs.tempo.xyz/... |

List related protocol milestones, hardforks, or feature activations:

| Name | Date / Epoch | Status | Notes |
|------|-------------|--------|-------|
| Name | YYYY-MM-DD or NNNN | Active / Scheduled / Proposed | Brief note |

### Community Discussion

Summarize key community content relevant to the target chain:

**Ethereum:**
- Notable ethresear.ch threads (title, URL, summary)
- Relevant Ethereum blog posts (title, URL, date)
- Relevant Vitalik blog posts (title, URL, summary)
- Relevant organmo blog posts (title, URL, summary)

**Solana:**
- Notable threads from forum.solana.com (title, URL, summary)
- Relevant Solana blog posts (title, URL, date)
- Relevant Anza engineering posts (title, URL, summary)

**Tempo:**
- Relevant Tempo documentation pages (title, URL, summary)
- Relevant Tempo blog posts (title, URL, date)
- MPP specification references (title, URL, summary)
- Relevant Paradigm blog posts (title, URL, summary)

Include any significant open debates or unresolved questions.

### References

List every source used in the report. Include:
- All local file paths referenced
- All web URLs accessed
- Improvement proposal links (EIPs, SIMDs, TIPs)
- Any external documentation referenced

---

## Formatting Guidelines

Tables must be used for:
- Improvement proposal listings
- Protocol milestone / hardfork / feature activation listings

Code blocks must be used for:
- All source references and excerpts
- All shell commands referenced in the report

File references must include line numbers when citing specific logic:

```
<RESEARCH_ROOT>/{repo}/{path}:{line}
```

Web links must be full URLs, not shortened or abbreviated. Every claim derived from a web source must have a corresponding URL in the References section.
