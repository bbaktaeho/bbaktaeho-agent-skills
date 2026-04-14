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
- Relevance to the current Solana protocol state
- Scope of this research (which sources were used, what was excluded)

### Technical Analysis

Explain the topic at the protocol specification level:
- Protocol-level description of the mechanism or change
- Design rationale and trade-offs
- Consensus implications (how does this affect validator behavior, slot production, or network rules)
- Relationship to existing Solana specifications (SIMDs, runtime spec)

### Code-Level Analysis

Reference client implementations directly. The solana and agave repositories cover the runtime and validator; solana-program-library covers on-chain programs:
- Relevant packages and files within `<RESEARCH_ROOT>/solana/`, `<RESEARCH_ROOT>/agave/`, and `<RESEARCH_ROOT>/solana-program-library/`
- Implementation details explaining how the protocol rule is encoded in code
- File path references in the format `<RESEARCH_ROOT>/{repo}/<path>:<line>`
- Code snippets where the exact implementation text is necessary for understanding
- Cross-repo comparison when solana and agave diverge in approach

Example code reference format:

```
<RESEARCH_ROOT>/solana/runtime/src/bank.rs:412
<RESEARCH_ROOT>/agave/svm/src/transaction_processor.rs:85
<RESEARCH_ROOT>/solana-program-library/token/program/src/processor.rs:42
```

Use fenced code blocks for all source excerpts.

### SIMD / Protocol Change Mapping

List related SIMDs using a table:

| SIMD | Title | Status | Link |
|------|-------|--------|------|
| SIMD-XXXX | Title here | Accepted / Draft / Withdrawn | https://github.com/solana-foundation/solana-improvement-documents/blob/main/proposals/XXXX.md |

List related protocol milestones or feature flags using a table:

| Feature | Activation Epoch | Status | Notes |
|---------|-----------------|--------|-------|
| Name | NNNN | Active / Pending / Deprecated | Brief note |

Data for the SIMD table must be drawn from the SIMD repository. Feature activation data must be drawn from `<RESEARCH_ROOT>/solana/sdk/src/feature_set.rs` or `<RESEARCH_ROOT>/agave/sdk/src/feature_set.rs`.

### Community Discussion

Summarize key community content:
- Notable threads from forum.solana.com (title, URL, one-sentence summary)
- Relevant Solana blog posts from solana.com/news (title, URL, date)
- Relevant Anza engineering posts from anza.xyz/blog (title, URL, one-sentence summary)
- Any significant open debates or unresolved questions visible in the community sources

### References

List every source used in the report. Include:
- All local file paths referenced (solana, agave, solana-program-library)
- All web URLs accessed (forum.solana.com, solana.com/news, anza.xyz/blog, SIMD repo)
- SIMD specification links
- Any external documentation referenced

---

## Formatting Guidelines

Tables must be used for:
- SIMD listings in the SIMD / Protocol Change Mapping section
- Feature activation listings in the SIMD / Protocol Change Mapping section

Code blocks must be used for:
- All source references and excerpts
- All shell commands referenced in the report

File references must include line numbers when citing specific logic:

```
<RESEARCH_ROOT>/solana/runtime/src/bank.rs:87
<RESEARCH_ROOT>/agave/svm/src/transaction_processor.rs:95
<RESEARCH_ROOT>/solana-program-library/token/program/src/processor.rs:42
```

Web links must be full URLs, not shortened or abbreviated. Every claim derived from a web source must have a corresponding URL in the References section.
