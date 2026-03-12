---
title: Documentation Project Guide Template
impact: HIGH
impactDescription: Provides AI-friendly documentation guide structure
tags: template, guide, documentation, ai-friendly
---

## 문서용 guide.md 템플릿

문서용 프로젝트의 guide.md를 생성할 때 이 템플릿을 기반으로 한다. `{placeholder}`는 사용자 답변으로 치환한다.

```markdown
---
title: {Project Name} Guide
description: 문서 프로젝트 구조와 AI 친화적 작성 규칙
type: guide
created: {YYYY-MM-DD}
---

# Documentation Guide

## Purpose

- 대상 독자: {대상 독자}
- 문서 목적: {문서의 목적 1줄 설명}

## Documentation Structure

> 이 구조는 문서가 추가됨에 따라 변경될 수 있다. 변경 시 이 섹션을 갱신한다.

{디렉토리 구조}

## AI-Friendly Writing Rules

### Frontmatter

모든 문서 파일은 YAML frontmatter로 시작한다. agent가 head 6줄만 읽고 문서의 필요 여부를 판단한다.

```yaml
---
title: 문서 제목
description: 이 문서가 무엇인지 1줄 설명
type: guide | workflow | spec | reference
created: YYYY-MM-DD
---
```

### 구조 규칙

- 모든 섹션은 첫 줄에 1문장 요약을 둔다. agent가 섹션을 읽을지 판단하는 기준이 된다
- 제목 계층은 `#` ~ `###` 까지만 사용한다. 그 이상 깊어지면 문서를 분리한다
- 한 문서는 하나의 주제만 다룬다. 주제가 둘 이상이면 파일을 나눈다
- 한 문서는 300줄을 넘지 않는다. 넘으면 분리한다

### 언어 규칙

- 명령형으로 작성한다 ("~한다", "~하지 않는다")
- 모호한 표현을 사용하지 않는다 ("적절하게", "필요에 따라" 대신 구체적 기준을 명시한다)
- 지시 대명사("이것", "그것", "위의")를 피하고 대상을 직접 명시한다
- 동일한 개념에는 동일한 용어를 사용한다. 문서 전체에서 용어를 통일한다

### 참조 규칙

- 다른 문서를 참조할 때 반드시 파일 경로를 명시한다 ("위 문서 참고" 가 아니라 `docs/workflow.md 참고`)
- 외부 링크는 URL을 직접 기재한다

### 검색 규칙

- 문서 작성 시 관련 스킬이 있는지 검색하고, 있다면 활용한다

### 데이터 표현

- 2개 이상의 항목을 비교하거나 나열할 때는 테이블을 사용한다
- 순서가 있는 절차는 숫자 목록을 사용한다
- 코드, 명령어, 파일명은 반드시 backtick으로 감싼다

## File Naming

- 파일명은 소문자와 하이픈을 사용한다
- 예시: `getting-started.md`, `api-reference.md`

## Workflow

작업 워크플로우는 [docs/workflow.md](workflow.md)를 참고한다.

## Additional Docs

필요시 아래 문서를 추가한다:
- docs/{topic}.md

특정 토픽의 문서가 여러 개가 되면 디렉토리로 분리한다:

순서가 있는 문서:
- docs/{topic}/001-{상세내용}.md
- docs/{topic}/002-{상세내용}.md

순서가 없는 문서:
- docs/{topic}/{상세내용}.md
```
