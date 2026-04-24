# blockchain-research Report Templates

Shared report templates for every skill in the `blockchain-research` plugin (`ethereum-researcher`, `solana-researcher`, `tempo-researcher`). Every research report must be generated from these templates and emitted in both Markdown and HTML so the two formats stay consistent.

This directory is a plugin resource, not a skill. There is no `SKILL.md` here.

## Files

| File | Purpose |
|------|---------|
| `report.md` | Canonical Markdown template. H1 title, YAML-ish frontmatter, TOC, 10 required sections, Mermaid blocks, inline SVG, GitHub task-list checklist. |
| `report.html` | Canonical HTML template. Same sections, same anchor ids, same Mermaid source, same inline SVG. Links `assets/theme.css` and loads Mermaid from CDN. |
| `assets/theme.css` | Monochrome print-friendly CSS used by the HTML template. White background, Times-style serif body, sans-serif tables / captions / callouts, monospace code. |
| `assets/mermaid-init.js` | Mermaid theme shim keeping diagrams in the same monochrome palette as the report body. |

## Generation Contract

An author agent that produces a research report **must**:

1. Read all five template files before writing anything.
2. Draft a single structured outline covering the 10 required sections, the list of required diagrams, the list of required tables, and the code excerpts to include.
3. Copy `report.md` and `report.html` to the user project at:

   ```
   docs/research/{chain}/{YYYY-MM-DD}-{slug}.md
   docs/research/{chain}/{YYYY-MM-DD}-{slug}.html
   ```

   where `{chain}` is `ethereum`, `solana`, or `tempo`, and `{slug}` is a kebab-case short name.
4. Fill both files in lockstep. Never draft one format fully before starting the other.
5. Keep MD and HTML **content-equivalent**: identical section ids, identical Mermaid source blocks, identical inline SVG, identical table rows, identical text.
6. Replace every `{{PLACEHOLDER}}` and every `<!-- TODO: ... -->` / `> ` guidance block before finishing. The section-intro guidance blocks in the templates are author hints and must be replaced with real content.

## Required Sections

The 10 sections are hard-coded in the templates. Keep the order. If a section has no content, state the reason explicitly rather than removing it.

1. 개요와 범위 (`sec-overview`)
2. Raw → 파생 뷰 다이어그램 (`sec-diagrams`)
3. 프로토콜 수준 분석 (`sec-protocol`)
4. 코드 수준 분석 (`sec-code`)
5. 온체인 데이터 뷰 (`sec-onchain`)
6. 인덱서 파생 뷰 (`sec-derivations`)
7. 예제 패턴 (`sec-examples`)
8. 조합 패턴 - 교차 분석 (`sec-combine`)
9. 파싱 / 인덱싱 체크리스트 (`sec-checklist`)
10. References (`sec-references`)

Section 2 (Raw → Derived Diagrams) ships as a **fully worked example**: it contains one Mermaid flowchart, one Mermaid sequence diagram, one Mermaid state diagram, and one inline SVG. When writing a new report, replace the labels and field names in those diagrams with the chain-specific and topic-specific content. Do not remove the diagrams; each type is required.

## Required Visualizations

Every report must include at minimum:

- One Mermaid flowchart (raw → derived pipeline).
- One Mermaid sequence diagram (actor interaction for the topic).
- One Mermaid state diagram (state transitions, e.g., commitment / ix / tx lifecycle).
- At least one inline SVG (for content Mermaid cannot express cleanly: byte-offset maps, role quadrants, tree reconstructions).
- Field-by-field tables for every raw response decomposition.
- Callouts (> blockquote in MD, `.callout` in HTML) for invariants and version-specific caveats.
- A parsing / indexing checklist at the end.

## Visual Style

- White background, near-black body text (`#111`).
- Serif body (Times New Roman / Noto Serif KR), sans-serif tables / captions / callouts, monospace code.
- 860 px max container width.
- Monochrome diagrams only. No color accents except the callout warning border.
- No emoji anywhere.

These rules are enforced visually by `assets/theme.css` for HTML. For MD, keep diagrams and prose within the same conventions so that MD-to-HTML conversion renders consistently.

## MD / HTML Consistency Rules

- Identical section ids (`sec-overview` ... `sec-references`).
- Identical Mermaid source blocks (copy the source, do not re-author).
- Identical inline SVG source. In MD, SVG is embedded directly; in HTML, also embedded directly. Both work.
- Identical table contents (rows and columns).
- MD uses `> blockquote` where HTML uses `<p class="section-intro">`. The text inside is identical.
- MD uses GitHub task-list syntax (`- [ ]`) where HTML uses `<ul class="check-list">`. The item text is identical.

## What NOT to Do

- Do not add new sections. The 10-section structure is load-bearing.
- Do not color diagrams. Monochrome only.
- Do not use emoji anywhere in the report content, captions, or code excerpts.
- Do not remove the `<details>` ASCII fallback in the MD template under Section 2.4 -- it serves viewers that do not render inline SVG.
- Do not link external CSS or JS beyond `assets/theme.css` and the Mermaid CDN already present in `report.html`.
