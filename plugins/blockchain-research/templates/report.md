---
title: "{{TITLE}}"
date: "{{YYYY-MM-DD}}"
chain: "{{CHAIN}}"
sample: "{{SAMPLE_OR_SCOPE}}"
author_agent: "blockchain-research:{{CHAIN}}-researcher"
---

<!--
DESIGN CONTRACT (do not duplicate in body; obey while filling sections)

Visual style
- Monochrome only. White background, near-black body text (#111). No color accents.
- No emoji anywhere (content, captions, code, diagrams).
- 860px max container. Mirror HTML twin in lockstep.

Typography
- Body: serif (Times New Roman / Noto Serif KR).
- Tables / captions / callouts / Mermaid: sans-serif (-apple-system, Noto Sans KR).
- Code: monospace (SF Mono / Consolas / Menlo).

Visualizations (every report MUST contain at minimum)
- 1 Mermaid flowchart  (raw -> derived data pipeline)
- 1 Mermaid sequenceDiagram  (actor interaction)
- 1 Mermaid stateDiagram-v2  (lifecycle / state transitions)
- 1 inline <svg> for what Mermaid cannot express (byte maps, role quadrants, layouts)
- Field-by-field tables for raw response decomposition
- Blockquote callout(s) for invariants and version-specific caveats
- Final parsing / indexing checklist using GitHub task-list syntax
-->

# {{TITLE}}

<p><em>{{META_SUBTITLE}} &nbsp;|&nbsp; 작성일: {{YYYY-MM-DD}} &nbsp;|&nbsp; 대상: {{SAMPLE_OR_SCOPE}}</em></p>

---

## 목차

1. [개요와 범위](#sec-overview)
2. [Raw → 파생 뷰 다이어그램](#sec-diagrams)
3. [프로토콜 수준 분석](#sec-protocol)
4. [코드 수준 분석](#sec-code)
5. [온체인 데이터 뷰](#sec-onchain)
6. [인덱서 파생 뷰](#sec-derivations)
7. [예제 패턴](#sec-examples)
8. [조합 패턴 - 교차 분석](#sec-combine)
9. [파싱 / 인덱싱 체크리스트](#sec-checklist)
10. [References](#sec-references)

---

<a id="sec-overview"></a>
## 1. 개요와 범위

{{OVERVIEW_PARAGRAPH}}

### 1.1 조사 질문
- {{QUESTION_1}}

### 1.2 범위와 제약
- **다룬다:** {{IN_SCOPE}}
- **다루지 않는다:** {{OUT_OF_SCOPE}}

---

<a id="sec-diagrams"></a>
## 2. Raw → 파생 뷰 다이어그램

원시 응답 → 파생 뷰의 흐름을 4종 시각화로 표현한다 (flowchart, sequence, state, inline SVG). 각 다이어그램은 본문 그림 번호로 캡션을 단다.

### 2.1 데이터 파이프라인 (Mermaid flowchart)

```mermaid
flowchart LR
  {{FLOWCHART_BODY}}
```
*그림 1. {{FIG1_CAPTION}}*

### 2.2 시간 순 상호작용 (Mermaid sequenceDiagram)

```mermaid
sequenceDiagram
  autonumber
  {{SEQUENCE_BODY}}
```
*그림 2. {{FIG2_CAPTION}}*

### 2.3 상태 전이 (Mermaid stateDiagram-v2)

```mermaid
stateDiagram-v2
  {{STATE_BODY}}
```
*그림 3. {{FIG3_CAPTION}}*

### 2.4 구조 맵 (인라인 SVG)

```
{{INLINE_SVG_OR_REPLACEMENT}}
```
*그림 4. {{FIG4_CAPTION}}*

<details>
<summary>ASCII 대체</summary>

```
{{ASCII_FALLBACK}}
```

</details>

---

<a id="sec-protocol"></a>
## 3. 프로토콜 수준 분석

{{PROTOCOL_PARAGRAPH}}

### 3.1 관련 개선 제안

| 번호 | 제목 | 상태 | 링크 |
|------|------|------|------|
| {{ID}} | {{TITLE}} | {{STATUS}} | [{{URL}}]({{URL}}) |

---

<a id="sec-code"></a>
## 4. 코드 수준 분석

- `<RESEARCH_ROOT>/{repo}/{path}:{line}` -- {{WHAT}}

```
{{CODE_EXCERPT}}
```

---

<a id="sec-onchain"></a>
## 5. 온체인 데이터 뷰

### 5.1 최상위 필드

| 필드 | 의미 | 예시값 |
|------|------|--------|
| `{{FIELD}}` | {{MEANING}} | {{SAMPLE}} |

### 5.2 예시 응답

```
{{RAW_SAMPLE_JSON}}
```

> **불변량:** {{INVARIANT_STATEMENT}}.

---

<a id="sec-derivations"></a>
## 6. 인덱서 파생 뷰

| 파생 뷰 | 입력 조합 | 용도 |
|---------|-----------|------|
| {{VIEW}} | {{INPUTS}} | {{USE}} |

---

<a id="sec-examples"></a>
## 7. 예제 패턴

```
{{EXAMPLE_SNIPPET}}
```

---

<a id="sec-combine"></a>
## 8. 조합 패턴 - 교차 분석

1. {{STEP_1}}
2. {{STEP_2}}

---

<a id="sec-checklist"></a>
## 9. 파싱 / 인덱싱 체크리스트

- [ ] {{CHECK_1}}
- [ ] {{CHECK_2}}

---

<a id="sec-references"></a>
## 10. References

### 로컬 소스
1. `<RESEARCH_ROOT>/{repo}/{path}:{line}` -- {{DESC}}

### 공식 문서
1. [{{TITLE}}]({{URL}})

### 커뮤니티 / 블로그 / 포럼
1. [{{TITLE}}]({{URL}})

---

*본 리포트는 `blockchain-research:{{CHAIN}}-researcher` 스킬로 생성되었습니다. -- {{YYYY-MM-DD}}*
