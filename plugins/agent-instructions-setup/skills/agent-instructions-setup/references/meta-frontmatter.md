---
title: Documentation Frontmatter Rules
impact: CRITICAL
impactDescription: Enables agents to scan docs by reading only head 6 lines instead of full documents
tags: frontmatter, docs, metadata, head, scannable, description
---

## Purpose

`agents/` 하위 모든 파일은 YAML frontmatter 로 시작한다. agent 는 head 6줄만 읽고 이 문서를 더 읽을지 판단한다.

## 필수 필드

```yaml
---
title: 문서 제목
description: 언제 읽어야 하는지 + 얻는 것
type: guide | workflow | spec | reference | index | log | plan
created: YYYY-MM-DD
---
```

## Optional 필드

필요 시 추가. 단 frontmatter 전체는 가능한 짧게 유지 (기본 6줄, 최대 8줄).

```yaml
updated: YYYY-MM-DD              # 마지막 수정일. 신선도 판단
depends_on: [agents/stack.md]    # 선행 읽기 권장 문서
```

## description 작성법 (가장 중요)

description 은 agent 가 문서 필요 여부를 판단하는 핵심 검색 키다. **"이 문서가 무엇인지"** 가 아니라 **"언제 읽어야 하는지 + 얻는 것"** 형식으로 작성한다.

나쁜 예:

```
description: 프로젝트 구조 설명
description: API 문서
description: 개발 가이드
```

좋은 예:

```
description: 코드 수정 전 필독. 모듈 의존성과 빌드 명령 제공
description: REST API 호출 시 참고. 엔드포인트·요청/응답 스키마 제공
description: 새 기능 추가 전 참고. 단계별 워크플로우와 PR 규칙 제공
```

description 길이는 120자 이내를 권장한다. 넘치면 frontmatter 가 비대해진다.

## type 값

| type | 용도 |
|------|------|
| guide | 진입점. 다른 문서로 라우팅 |
| workflow | 절차·순서가 있는 작업 흐름 |
| spec | 스펙·규칙·정책 |
| reference | 참고 자료·API·용어집 |
| index | 디렉토리 색인 (`agents/{topic}.md` 가 하위 문서 링크만 가질 때) |
| log | 시간순 축적 기록 (개발 일지 등) |
| plan | 계획서 |

## 규칙

- frontmatter 는 기본 6줄 (`---` 열기·닫기 포함), optional 필드 포함 시 최대 8줄
- description 은 반드시 1줄 (folded scalar `>` 사용 금지 — 여러 줄 되면 head 스캔이 무너진다)
- frontmatter 바로 다음에 본문 시작 (빈 줄 1개만 허용)
- frontmatter 이전에는 아무 것도 쓰지 않는다

## 복붙 Snippet

새 파일 생성 시 아래 snippet 으로 시작한다.

### Guide

```
---
title:
description:
type: guide
created:
---
```

### Workflow

```
---
title:
description:
type: workflow
created:
---
```

### Reference

```
---
title:
description:
type: reference
created:
---
```

### Plan

```
---
title:
description:
type: plan
created:
---
```

### Log

```
---
title:
description:
type: log
created:
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
created: 2026-04-21
tags: [project, guide, architecture]
---
```

문제:
- description 이 여러 줄 (head 스캔 불가)
- tags 필드로 6줄 초과
- description 이 "언제 읽어야 하는지" 를 포함하지 않음

## 검증 규칙

문서 작성 후 스스로 확인한다.

1. head 6~8줄만 읽고 이 문서가 어떤 상황에 필요한지 판단 가능한가?
2. description 이 "언제 + 얻는 것" 형식인가?
3. description 이 1줄인가?
4. type 이 7개 중 하나인가?
