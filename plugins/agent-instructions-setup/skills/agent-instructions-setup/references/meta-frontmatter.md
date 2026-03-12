---
title: Documentation Frontmatter Rules
impact: CRITICAL
impactDescription: Enables agents to scan docs/ files by reading only 6 lines instead of full documents
tags: frontmatter, docs, metadata, head
---

## Frontmatter 규칙

docs/ 하위 모든 파일은 YAML frontmatter를 포함해야 한다. agent가 head 6줄만 읽고 문서를 읽을지 판단한다.

## 필수 필드

```yaml
---
title: 문서 제목
description: 이 문서가 무엇인지 1줄 설명
type: guide | workflow | spec | reference
created: YYYY-MM-DD
---
```

## 규칙

- frontmatter는 6줄 이내 (`---` 열기/닫기 포함)
- description은 반드시 1줄로 작성한다
- type 값: guide, workflow, spec, reference
- frontmatter 바로 다음에 본문을 시작한다 (빈 줄 1개만 허용)
- agent는 파일 탐색 시 head 6줄만 읽고 이 문서가 현재 작업에 필요한지 판단한다

## 올바른 예

```yaml
---
title: Project Guide
description: 프로젝트 핵심 구조와 기술 스택 설명
type: guide
created: 2026-03-12
---
```

## 잘못된 예

```yaml
---
title: Project Guide
description: >
  이 문서는 프로젝트의 핵심 구조와
  기술 스택에 대해 상세하게 설명합니다.
type: guide
created: 2026-03-12
tags: [project, guide, architecture]
---
```

description이 여러 줄이고, 불필요한 tags 필드로 6줄을 초과한다.
