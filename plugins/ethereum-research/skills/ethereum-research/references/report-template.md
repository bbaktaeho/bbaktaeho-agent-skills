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
- Relevance to the current Ethereum protocol state
- Scope of this research (which sources were used, what was excluded)

### Technical Analysis

Explain the topic at the protocol specification level:
- Protocol-level description of the mechanism or change
- Design rationale and trade-offs
- Consensus implications (how does this affect validator behavior, block validity, or network rules)
- Relationship to existing Ethereum specifications (execution spec, consensus spec)

### Code-Level Analysis

Reference client implementations directly. Multiple EL clients (go-ethereum, reth/revm) and the CL client (prysm) are available:
- Relevant packages and files within `<RESEARCH_ROOT>/go-ethereum/`, `<RESEARCH_ROOT>/reth/`, `<RESEARCH_ROOT>/revm/`, and `<RESEARCH_ROOT>/prysm/`
- Implementation details explaining how the protocol rule is encoded in code
- File path references in the format `<RESEARCH_ROOT>/{client}/<path>:<line>`
- Code snippets where the exact implementation text is necessary for understanding
- Cross-client comparison when implementations differ in approach

Example code reference format:

```
<RESEARCH_ROOT>/go-ethereum/core/vm/evm.go:312
<RESEARCH_ROOT>/reth/crates/evm/src/execute.rs:85
<RESEARCH_ROOT>/revm/crates/interpreter/src/instructions/host.rs:42
<RESEARCH_ROOT>/prysm/beacon-chain/core/state/transition.go:45
```

Use fenced code blocks for all source excerpts.

### EIP / Hardfork Mapping

List related EIPs using a table:

| EIP | Title | Status | Link |
|-----|-------|--------|------|
| EIP-XXXX | Title here | Final / Draft / Stagnant | https://eips.ethereum.org/EIPS/eip-XXXX |

List related hardforks using a table:

| Hardfork | Date | Status | Notes |
|----------|------|--------|-------|
| Name | YYYY-MM-DD | Active / Scheduled / Proposed | Brief note |

Data for both tables must be drawn from `<RESEARCH_ROOT>/EIPs/` and `<RESEARCH_ROOT>/forkcast/`. Cross-reference both sources.

### Community Discussion

Summarize key community content:
- Notable threads from ethresear.ch (title, URL, one-sentence summary)
- Relevant Ethereum blog posts (title, URL, date)
- Relevant Vitalik blog posts or writings (title, URL, one-sentence summary)
- Relevant organmo blog posts or writings (title, URL, one-sentence summary)
- Any significant open debates or unresolved questions visible in the community sources

### References

List every source used in the report. Include:
- All local file paths referenced (go-ethereum, reth, revm, prysm, EIPs, forkcast)
- All web URLs accessed (ethresear.ch, blog.ethereum.org, vitalik.eth.limo, medium.com/@organmo)
- EIP specification links
- Any external documentation referenced

---

## Formatting Guidelines

Tables must be used for:
- EIP listings in the EIP / Hardfork Mapping section
- Hardfork listings in the EIP / Hardfork Mapping section

Code blocks must be used for:
- All go-ethereum source references and excerpts
- All shell commands referenced in the report

File references must include line numbers when citing specific logic:

```
<RESEARCH_ROOT>/go-ethereum/core/state_processor.go:87
<RESEARCH_ROOT>/reth/crates/ethereum/evm/src/execute.rs:95
<RESEARCH_ROOT>/revm/crates/interpreter/src/instructions/host.rs:42
<RESEARCH_ROOT>/prysm/beacon-chain/blockchain/process_block.go:120
```

Web links must be full URLs, not shortened or abbreviated. Every claim derived from a web source must have a corresponding URL in the References section.
