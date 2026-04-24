---
title: Ethereum Research Report Output Template
impact: CRITICAL
impactDescription: Every research report must be emitted in both Markdown and HTML using the plugin-level shared template
tags: report, template, output, ethereum, markdown, html, mermaid, svg
---

# Research Report Output -- Ethereum

Every research report produced by this skill is emitted **twice**: once as Markdown, once as HTML. Both files share the same structured outline, the same tables, the same Mermaid source, and the same inline SVG.

## Shared Templates

The canonical templates live at the plugin root, not inside this skill:

- Markdown: `plugins/blockchain-research/templates/report.md`
- HTML: `plugins/blockchain-research/templates/report.html`
- CSS: `plugins/blockchain-research/templates/assets/theme.css`
- Mermaid init shim: `plugins/blockchain-research/templates/assets/mermaid-init.js`
- Author-facing usage notes: `plugins/blockchain-research/templates/README.md`

Read those five files before generating any report. They encode the canonical section order, placeholder tokens, visualization requirements, and MD / HTML consistency rules.

## Output Paths

Write both files to the user project:

```
docs/research/ethereum/{YYYY-MM-DD}-{slug}.md
docs/research/ethereum/{YYYY-MM-DD}-{slug}.html
```

`{slug}` is kebab-case, derived from the report title (for example `eip-4844-blob-gas`).

## Generation Procedure

1. **Draft a single structured outline** first: title, meta line, section-by-section bullet points, list of required diagrams, list of tables, list of code excerpts.
2. **Copy `report.md` and `report.html`** to the output paths with the above naming.
3. **Fill both files in lockstep** -- never author one format before the other. The MD and HTML versions must carry identical section ids, identical Mermaid source blocks, identical inline SVG source, and identical table rows.
4. **Complete Section 4 (Raw → Derived Diagrams)** first. It is the worked example shipped with the template and anchors the visual style for the rest of the report.
5. **Embed all required visualizations** (see the checklist below) in both formats.
6. **Replace every `{{PLACEHOLDER}}` and `<!-- TODO: ... -->` marker** before considering the report done.

## Required Visualizations

Every Ethereum research report must contain **at minimum**:

- One Mermaid flowchart showing how raw fields (block header, tx envelope fields, receipts, logs, beacon block fields) flow into derived views used by an indexer or analyst.
- One Mermaid sequence diagram showing the time-ordered actor interaction relevant to the topic (for example: user wallet -> mempool -> builder -> proposer -> execution client).
- One Mermaid state diagram when state transitions are in scope (for example: attestation inclusion states, block finality states).
- At least one inline SVG diagram for content Mermaid cannot express cleanly (byte-offset maps of an EIP-2718 envelope, storage trie layout, fork-choice graph, MEV-Boost relay flow).
- Field-by-field tables for every raw response decomposition.
- Callouts for invariants and version-specific caveats (for example, EIP activation block per network).
- A parsing / indexing checklist at the end.

## Required Sections

The shared template hard-codes the section order. Keep it intact. Required sections for an Ethereum report:

1. Header (title, meta line with subtitle, date, sample / scope reference)
2. Table of contents (anchors)
3. Overview and scope
4. Raw -> Derived diagrams (pipeline-level overview)
5. Protocol-level analysis (EIPs, consensus rules, design rationale)
6. Code-level analysis (go-ethereum / reth / revm / prysm file paths and line references)
7. On-chain data view (fields, records, balance deltas, log semantics, fee breakdown)
8. Indexer derivations (named derived views, how they are built)
9. Example patterns (synthetic if needed)
10. Combining patterns (cross-sectional reasoning)
11. Parsing / indexing checklist
12. References (local source paths in `<RESEARCH_ROOT>/{repo}/{path}:{line}` format, external docs, data samples)
13. Footer (generation date, source skill = `blockchain-research:ethereum-researcher`)

If a section has no content, state the reason explicitly rather than omitting the section.

## Formatting Guidelines

- Use fenced code blocks for every source excerpt and shell command.
- Use tables for EIP listings, hardfork listings, and field-by-field decomposition.
- File references must include line numbers: `<RESEARCH_ROOT>/{repo}/{path}:{line}`.
- Every web claim must have a corresponding URL in the References section.
- No emoji anywhere.

## Ethereum-Specific References Section

The References section of an Ethereum report should always include, when relevant:

- Local source paths in `<RESEARCH_ROOT>/go-ethereum/...`, `<RESEARCH_ROOT>/reth/...`, `<RESEARCH_ROOT>/revm/...`, `<RESEARCH_ROOT>/prysm/...`.
- EIP links in the form `https://eips.ethereum.org/EIPS/eip-XXXX`.
- Ethereum docs: https://ethereum.org/en/developers/docs/
- ethresear.ch threads when applicable.
- Ethereum blog / Vitalik blog / organmo blog posts when applicable.
