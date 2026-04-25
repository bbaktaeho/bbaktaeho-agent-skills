# Blockchain Research Plugin Split + Report Template -- Design Spec

- Date: 2026-04-24
- Target plugin: `plugins/blockchain-research`
- Author: bbaktaeho

## Purpose

1. Split the single `blockchain-research` skill into three chain-specific skills so each one loads only its chain's references and triggers more precisely.
2. Give the plugin a shared, high-quality **research report template** in both Markdown and HTML so every chain's research output looks the same, reads the same, and visualizes the same concepts with the same diagrams.
3. Make sure every change to the plugin runs through the existing skill-format validation workflow before a PR is merged.

## Goals

- Replace the current single `blockchain-research` skill with three chain-specific skills.
- Each skill owns only its chain's setup, flow, sources, and indexing references.
- Keep the plugin identity (`blockchain-research`) and the marketplace entry.
- Preserve the existing prefix convention (`setup-`, `flow-`, `report-`, `src-`, `web-`, `idx-`) and `_sections.md` per skill.
- Introduce a plugin-level `templates/` directory with canonical MD and HTML report templates used by all three skills.
- Every research report produced by any chain skill must be emitted as both a Markdown file and an HTML file whose structure, content, and diagrams are consistent.
- Emphasize visualization (Mermaid diagrams, inline SVG, data-flow diagrams, sequence diagrams, tables) as a first-class reporting requirement.
- Ensure `.github/workflows/validate-skills.yml` remains the final gate before merge: all new skills pass the existing validator.

## Non-Goals

- No cross-chain comparison content inside per-skill references. Cross-chain questions are handled by the user invoking multiple skills.
- No changes to the submodule upstream repositories or their URLs.
- No rewrite of `protocol/src-*.md` or `protocol/web-*.md` navigation content. Files move, content stays.
- No new CI workflow; the existing `validate-skills.yml` already covers structural validation and is triggered on PR.
- No client-side interactivity beyond Mermaid rendering. Reports are static documents.

---

## Part A -- Skill Split

### A.1 Target Skills

| Skill | Plugin path | Covers |
|-------|-------------|--------|
| `blockchain-research:ethereum-researcher` | `plugins/blockchain-research/skills/ethereum-researcher/` | Ethereum protocol, EVM, EIPs, hardforks, go-ethereum, reth, revm, prysm, forkcast, plus Ethereum indexing concerns |
| `blockchain-research:solana-researcher` | `plugins/blockchain-research/skills/solana-researcher/` | Solana protocol, SVM, SIMDs, PoH, Tower BFT, Turbine, Sealevel, agave, SPL programs, plus Solana indexing concerns |
| `blockchain-research:tempo-researcher` | `plugins/blockchain-research/skills/tempo-researcher/` | Tempo chain, TIP-20, TIP-403, MPP, Simplex BFT, Payment Lanes, Fee AMM, Zones, tidx, plus Tempo indexing concerns |

### A.2 Directory Layout (per skill)

```
plugins/blockchain-research/skills/{chain}-researcher/
  SKILL.md
  references/
    _sections.md
    setup-submodules.md
    flow-research.md
    report-template.md        # points to ../../templates/ (shared)
    protocol/
      src-*.md
      web-*.md
    indexing/
      idx-*.md
```

Per-chain file inventories remain identical to the pre-split skill's chain subdirectories:

- Ethereum `protocol/`: `src-go-ethereum.md`, `src-reth.md`, `src-revm.md`, `src-prysm.md`, `src-eips.md`, `src-forkcast.md`, `web-ethresearch.md`, `web-ethereum-blog.md`, `web-vitalik-blog.md`, `web-organmo-blog.md`
- Solana `protocol/`: `src-solana.md`, `src-agave.md`, `src-spl.md`, `web-solana-forum.md`, `web-solana-blog.md`
- Tempo `protocol/`: `src-tempo.md`, `src-tempo-go.md`, `src-mpp-go.md`, `src-mpp-rs.md`, `src-tidx.md`, `web-tempo-docs.md`, `web-mpp.md`
- All three `indexing/`: the eight `idx-*.md` files (`idx-reorg-finality.md`, `idx-state-access.md`, `idx-rpc-api.md`, `idx-tx-envelope.md`, `idx-event-decoding.md`, `idx-asset-standards.md`, `idx-protocol-transfers.md`, `idx-official-indexers.md`)

### A.3 Content Transformation Rules

- **SKILL.md (per chain)**: rewrite with chain-only `description`, `metadata.abstract`, `When to Apply`, `Skill Trigger Flow`, `Source Categories by Priority`, `How to Use`, `References`. Default `<RESEARCH_ROOT>` is `.ethereum-research` / `.solana-research` / `.tempo-research`. Body stays under the 100-line validator ceiling. The `description` includes the phrase "even if they just ask 'how does X work' or 'why does Y behave this way' without the word 'research'" to preserve existing trigger behavior. Each skill description also lists enough chain-specific keywords (see Trigger Accuracy below).
- **setup-submodules.md**: keep only the target chain's path row, prerequisite check, setup commands, `.gitignore` recommendation, and verification commands.
- **flow-research.md**: drop Phase 0's cross-chain keyword table (skill is already chain-specific). Keep only the target chain's Source Selection Matrix and its rows in the Indexing Source Selection Matrix. Source Navigation lists only the target chain's references and uses the new `protocol/` and `indexing/` subpaths. Local-First Research Policy examples are filtered to the target chain.
- **report-template.md**: rewritten to instruct the agent to use the shared templates at `../../templates/report.md` and `../../templates/report.html`, then fill them in. See Part B for the template shape.
- **protocol/src-*.md and protocol/web-*.md**: move existing files from the current `references/{chain}/` directories into `references/protocol/`. Content preserved verbatim.
- **indexing/idx-*.md**: for each idx file, remove the cross-chain comparison table and strip sections tied to the other two chains. Keep the "Concept" intro, the target chain's dedicated section, and the "Indexer Design Implications" filtered to the target chain. Remove `<RESEARCH_ROOT>/{other-chain}/...` path references. Update `tags:` frontmatter to mention only the target chain. If a given chain has no dedicated section in a source idx file, add a short "not applicable" note rather than leaving an empty file.
- **_sections.md**: keep existing section definitions. Same six prefixes apply.

### A.4 Trigger Accuracy Considerations

Each new skill's description is the single largest factor for correct triggering.

- Ethereum skill must include: EVM, EIP, go-ethereum, geth, reth, revm, prysm, beacon chain, PoS, Merge, hardfork, Ethereum, ERC-20, ERC-721, ERC-1155, Blockscout, reorg, finality, gwei, JSON-RPC.
- Solana skill must include: SVM, SIMD, PoH, Tower BFT, Turbine, Sealevel, Gulf Stream, agave, SPL, Solana, Helius, commitment levels, geyser, Anchor.
- Tempo skill must include: TIP-20, TIP-403, MPP, Machine Payments, Payment Lanes, Fee AMM, Simplex BFT, Commonware, Zones, Tempo, tidx, Tempo Transactions (Type 0x76).

### A.5 Removal

Delete `plugins/blockchain-research/skills/blockchain-research/` entirely once the three new skills are in place. No router skill is kept.

### A.6 Plugin Manifest and Marketplace

- `plugins/blockchain-research/.claude-plugin/plugin.json`: bump `version` to `2.0.0`, update `description` to reflect the three sub-skills and the shared report templates.
- `.claude-plugin/marketplace.json`: update the `blockchain-research` entry `description` to mention the three chain-specific skills. Source path, category, and plugin name stay unchanged.

---

## Part B -- Shared Report Template

### B.1 Location

```
plugins/blockchain-research/
  templates/
    report.md              # canonical Markdown report template
    report.html            # canonical HTML report template
    README.md              # how to use the templates (author-facing, not a skill)
    assets/
      theme.css            # extracted inline CSS (sourced by report.html)
      mermaid-init.js      # small shim to initialize Mermaid on load
```

Kept at plugin root (not per-skill) so the three skills share one canonical source of truth. The per-skill `references/report-template.md` is a thin pointer that explains:
- Where the shared templates live.
- How to populate placeholders for the current chain.
- Which sections must always be present vs. optional.
- The requirement that every report ships both MD and HTML variants with matching content.

### B.2 Visual Design Principles (both formats)

- Pure white background, near-black (`#111`) body text. No color accents except sparingly for callouts (warning border `#a33`) and highlight rows.
- Serif primary font for body text (Times New Roman / Noto Serif KR fallback), sans-serif (Noto Sans KR) for tables, captions, callouts, checklists.
- Monospace (`SF Mono` / `Consolas` / `Menlo`) for all `code` and `pre` blocks.
- Container max width 860 px, generous leading (1.8), print-friendly (media print styles).
- Diagrams are centered, captioned, with a thin light border. Captions use sans-serif italic.
- No emoji anywhere.

### B.3 Canonical Section Order

Every research report must follow this section order. Sections not applicable to a given research topic must still be represented with a one-line explanation of why they are omitted, rather than silently skipped.

1. Header (title, meta line with subtitle + date + sample / scope reference)
2. Table of contents (anchors)
3. Overview and scope
4. Raw → derived diagrams (pipeline-level overview)
5. Protocol-level analysis
6. Code-level analysis (client implementation paths, line references)
7. On-chain data view (fields, records, balance deltas, log semantics, fee breakdown)
8. Indexer derivations (named derived views, how they are built)
9. Example patterns (synthetic if needed)
10. Combining patterns (cross-sectional reasoning)
11. Parsing / indexing checklist
12. References (local sources, external docs, data samples)
13. Footer (generation date, author-agent, source skill)

Each section requires at least one visualization: a table, a Mermaid diagram, an inline SVG, or a code excerpt with annotations.

### B.4 Required Visualization Elements

Every report must include **at minimum**:

- **One Mermaid flowchart** that shows the raw-to-derived data pipeline (what source fields feed which derived views).
- **One Mermaid sequence diagram** that shows the time-ordered interaction between actors relevant to the topic (e.g., payer / runtime / program / recipient).
- **One Mermaid state diagram** (when state transitions are in scope, e.g., log FSM, commitment progression).
- **At least one inline SVG diagram** for content that Mermaid cannot express cleanly (e.g., byte-offset maps of an event body, annotated account-role quadrants, stackHeight-to-tree reconstruction). SVGs must use the monochrome theme and be accessible (`<title>` element inside the SVG).
- **Tables** for field-by-field decomposition of raw responses and per-account balance deltas.
- **Callouts** (`callout`, `callout.warn`) for invariants, gotchas, and version-specific caveats.
- **A parsing checklist** using the empty-box style to allow readers to self-audit.

### B.5 HTML Template Details

`report.html` contains:

- `<!DOCTYPE html>` with `lang` attribute matching the report's language (default `ko`, can be overridden per report).
- A single external stylesheet link to `assets/theme.css` containing the CSS from the user's reference template (white background, serif body, fixed 860 px container, print styles, etc.).
- Mermaid loaded from jsDelivr CDN with `startOnLoad: true, theme: 'neutral', securityLevel: 'loose'`.
- Sectioning: `<header class="report-header">`, `<nav class="toc">`, `<section id="...">` blocks per the canonical order, `<footer class="report-footer">`.
- Placeholder tokens in the form `{{TITLE}}`, `{{META_LINE}}`, `{{SECTION_N_BODY}}` so agents know exactly what to fill in. The template ships with one fully worked example section (section 1) so the structure is self-documenting.
- CSS isolation: no CSS variables, no resets that would interfere with printing, no outside font loads (falls back to system fonts gracefully).

### B.6 Markdown Template Details

`report.md` mirrors `report.html` one-to-one but uses:

- H1 for the report title (only one H1 per document).
- An inline YAML-ish frontmatter at the top carrying `title`, `date`, `chain`, `sample`, `author_agent`, `source_skill`.
- A manually authored table of contents using relative anchor links. (GitHub renders header anchors automatically; we still include the TOC block for offline readers.)
- Fenced Mermaid blocks (```mermaid) for every diagram that is Mermaid-native. GitHub, Obsidian, and most MD viewers render these inline.
- Inline SVG embedded directly inside the Markdown (most MD renderers, including GitHub and VSCode, render inline SVG in an HTML-capable MD block). For viewers that do not, an ASCII fallback is provided inside a `<details>` block directly under each SVG.
- Tables, callouts (`> **Warning:**` style), and checklists using GitHub task-list syntax (`- [ ]`) for the parsing checklist.

### B.7 MD ↔ HTML Consistency Rules

To make the two formats truly interchangeable:

- Section ids and order are identical.
- Every diagram that appears in HTML appears in MD with an equivalent representation:
  - Mermaid diagrams: identical source block.
  - Inline SVG: the same SVG source is embedded in MD. ASCII fallback optional.
  - Data tables: identical rows and columns.
- Text content (paragraphs, headings, captions) is byte-equivalent modulo inline formatting syntax.
- Both files must be generated in the same agent turn from the same structured outline, not independently drafted. The skill instructs the agent to prepare a single structured outline first, then serialize to MD and HTML side by side.

### B.8 Template Example Coverage

`report.md` and `report.html` each ship with **one complete worked section** (Section 4: "Raw → Derived Diagrams") as a concrete example. The remaining sections contain structured placeholders plus inline comments (`<!-- TODO: ... -->` in HTML, `<!-- -->` HTML comments in MD) describing what to fill in and which visualizations are required. This gives the agent a visible exemplar and prevents drift.

### B.9 Report File Naming

Research reports are written by the agent into the user project as:

```
docs/research/{chain}/{YYYY-MM-DD}-{slug}.md
docs/research/{chain}/{YYYY-MM-DD}-{slug}.html
```

where `{chain}` is `ethereum`, `solana`, or `tempo`. Both files share the same slug so they pair cleanly.

---

## Part C -- Validation Gate

### C.1 Existing Workflow Coverage

`.github/workflows/validate-skills.yml` already runs `bash .github/scripts/validate-skills.sh` on PRs and pushes that touch `plugins/**` or `.claude-plugin/marketplace.json`. The script verifies:

- `marketplace.json` structure and that every listed source path exists.
- Each plugin has `.claude-plugin/plugin.json` with `name`, `description`, `version`, `author.name`.
- Each `SKILL.md` has a valid `name` (format, length, no reserved words, no XML, directory-name match), a valid `description` (length, no XML), and a body of at most 100 lines.

The PR opened by this work must pass this workflow unmodified. No changes to the validator are in scope.

### C.2 Per-Skill Pre-Merge Checks

Before opening the PR, the implementation plan must include a step that runs `bash .github/scripts/validate-skills.sh` locally and confirms exit code 0 and zero `[FAIL]` lines. This is the "last hook" before publishing work.

### C.3 Template Validation (out of scope but noted)

The validator does not currently check the `templates/` directory or report-format fidelity. Extending the validator to verify MD/HTML template parity is deferred to a follow-up; for this PR, correctness of the templates is confirmed by human review only.

---

## Part D -- PR Flow

1. Work happens on a feature branch (`refactor/blockchain-research-split` or similar).
2. Commits are split logically:
   - Commit 1: add the three new skill directories with their SKILL.md, _sections.md, setup, flow, report-template pointer, and empty protocol/indexing subdirectories.
   - Commit 2: copy protocol and indexing content from the old skill into the new subdirectories.
   - Commit 3: strip cross-chain content from each chain's idx files and adjust flow file paths.
   - Commit 4: add `plugins/blockchain-research/templates/` with `report.md`, `report.html`, `assets/theme.css`, `assets/mermaid-init.js`, `README.md`.
   - Commit 5: delete the old `skills/blockchain-research/` directory.
   - Commit 6: bump plugin version to 2.0.0, update plugin.json and marketplace.json descriptions.
3. Run the validator locally. Fix any reported issues.
4. Push the branch.
5. Open a PR titled `Split blockchain-research into per-chain skills + shared report template` with body that:
   - Summarizes the split (three new skills, one retired).
   - Calls out the new shared MD/HTML templates.
   - Notes the breaking change (skill rename) and version bump to 2.0.0.
   - Links the design spec.
6. Confirm the GitHub Actions validation workflow passes on the PR.

---

## Acceptance Criteria

- `plugins/blockchain-research/skills/` contains exactly three subdirectories: `ethereum-researcher`, `solana-researcher`, `tempo-researcher`.
- Each skill directory contains `SKILL.md`, `references/_sections.md`, `references/setup-submodules.md`, `references/flow-research.md`, `references/report-template.md`, a non-empty `references/protocol/`, and a non-empty `references/indexing/`.
- No reference file in any skill contains sections, tables, code paths, or indexer implications tied to the other two chains. Chain-agnostic background paragraphs (e.g., the "Concept" intro in each `idx-*.md`) may remain unchanged.
- `_sections.md` in each skill lists the same six sections as today.
- `plugins/blockchain-research/templates/` exists and contains `report.md`, `report.html`, `assets/theme.css`, `assets/mermaid-init.js`, `README.md`.
- `report.md` and `report.html` have identical section order, identical section ids/anchors, the same tables, the same Mermaid source blocks, and the same inline SVG source for Section 4's worked example.
- `.claude-plugin/marketplace.json` entry for blockchain-research has an updated description mentioning the three sub-skills.
- `plugins/blockchain-research/.claude-plugin/plugin.json` is bumped to `version: "2.0.0"` and the description is updated.
- The old `plugins/blockchain-research/skills/blockchain-research/` directory no longer exists.
- `bash .github/scripts/validate-skills.sh` run from the repo root exits 0 with zero `[FAIL]` lines.
- A PR is opened with the summary above and the existing GitHub Actions validation workflow passes.

## Out-of-Scope Follow-Ups

- Cross-chain comparison skill (user will invoke multiple skills).
- Extending `validate-skills.sh` to enforce template presence or MD/HTML parity.
- Adding more worked-example sections to the report templates (only Section 4 is fully filled in).
- Supporting additional languages beyond Korean / English in the HTML `lang` attribute.
- Any UI-level interactivity in the HTML report beyond Mermaid rendering.
