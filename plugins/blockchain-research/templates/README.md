# blockchain-research Report Templates

Shared report templates for `ethereum-researcher`, `solana-researcher`, `tempo-researcher`. Every research report MUST be emitted in both Markdown and HTML, generated from these files. This directory is a plugin resource, not a skill.

## Files

| File | Role |
|------|------|
| `report.md` | Markdown skeleton. 10 fixed sections, placeholders only. |
| `report.html` | HTML twin of `report.md`. Identical anchor ids and content slots. |
| `assets/theme.css` | Authoritative visual / typography rules. Monochrome, serif body, sans-serif tables / captions / mermaid, monospace code, 860px container. |
| `assets/mermaid-init.js` | Mermaid theme shim that pins diagrams to the same monochrome palette. |

## Design philosophy (the only thing the templates encode)

- **Monochrome only.** White background, near-black body text. No color accents, no emoji.
- **Typography by role.** Serif body, sans-serif metadata / tables / captions / mermaid, monospace code.
- **Print-friendly.** 860px max width. CSS handles `@media print`.
- **Visualization is mandatory.** Each report must contain at minimum:
  - 1 Mermaid `flowchart` (raw -> derived data pipeline)
  - 1 Mermaid `sequenceDiagram` (actor interaction)
  - 1 Mermaid `stateDiagram-v2` (lifecycle / state transitions)
  - 1 inline `<svg>` (for content Mermaid cannot express: byte maps, role quadrants)

The templates intentionally do **not** ship worked-example diagrams. Authors generate diagrams from the actual research subject, then drop them into the placeholders. The CSS and `mermaid-init.js` enforce the visual contract regardless of content.

## Generation contract

1. Copy `report.md` and `report.html` to `docs/research/{chain}/{YYYY-MM-DD}-{slug}.{md,html}` (`{chain}` ∈ `ethereum`, `solana`, `tempo`).
2. Fill MD and HTML in lockstep. Identical section ids, identical Mermaid source, identical SVG, identical table rows.
3. Replace every `{{PLACEHOLDER}}`. Keep all 10 sections; if a section is empty, state the reason in-place.
4. Do not add new sections. Do not introduce color, emoji, or external CSS / JS beyond `assets/theme.css` and the Mermaid CDN already linked in `report.html`.

## Required sections (fixed order)

1. 개요와 범위 — `sec-overview`
2. Raw → 파생 뷰 다이어그램 — `sec-diagrams`
3. 프로토콜 수준 분석 — `sec-protocol`
4. 코드 수준 분석 — `sec-code`
5. 온체인 데이터 뷰 — `sec-onchain`
6. 인덱서 파생 뷰 — `sec-derivations`
7. 예제 패턴 — `sec-examples`
8. 조합 패턴 - 교차 분석 — `sec-combine`
9. 파싱 / 인덱싱 체크리스트 — `sec-checklist`
10. References — `sec-references`
