---
title: Documentation Project Guide Template
impact: HIGH
impactDescription: guide.md is a routing index for documentation projects, kept under 80 lines
tags: template, guide, documentation, routing, index
---

## Purpose

문서 프로젝트용 `agents/guide.md` 템플릿. guide.md 는 **내용이 아니라 라우팅 index** 다. 80줄 이내로 유지한다.

## Template

```markdown
---
title: {Project Name} Guide
description: 문서 작성 시작 전 필독. 작업 유형별 진입 문서 라우팅 제공
type: guide
created: {YYYY-MM-DD}
---

# {Project Name}

{프로젝트 1줄 설명}

## 대상 독자

{대상 독자}

## 작업 유형별 라우팅

| 작업 | 먼저 읽을 문서 |
|------|----------------|
| 새 문서 작성 | agents/workflow.md, agents/writing-rules.md |
| 기존 문서 수정 | agents/writing-rules.md, 해당 문서의 frontmatter |
| 문서 구조 개편 | agents/structure.md (있으면), 이 파일의 "문서 진화" 섹션 |
| 용어 정리 | agents/glossary.md (있으면) |

## 문서 구조 (요약)

{문서 루트 2 depth}

상세 구조가 필요하면 agents/structure.md 를 생성한다.

## 작성 규칙 (요약)

- 모든 문서 상단 6~8줄 frontmatter
- description 은 "언제 읽어야 하는지 + 얻는 것" 형식
- 각 섹션 첫 줄은 1문장 요약
- 300줄 초과 시 분해
- 상세: agents/writing-rules.md

## 문서 진화

- 새 문서 추가: agents/{topic}.md 단일 파일로 시작. 라우팅 테이블에 한 줄 추가
- 300줄 초과 또는 주제 혼재: agents/{topic}/{N}-{name}.md 로 분해
- 문서 수정: frontmatter `updated` 갱신. 섹션 요약이 본문을 반영하는지 확인
- 문서 삭제: 참조를 grep 확인 후 라우팅 테이블에서 제거

## File Naming

- 소문자 + 하이픈. 예: `getting-started.md`, `api-reference.md`
```

## 작성 가이드

1. 라우팅 테이블부터 작성한다. 프로젝트 독자·용도에 맞게 행 조정
2. 작성 규칙 상세는 `agents/writing-rules.md` 로 별도 생성하고, guide.md 는 요약 4~5줄만
3. guide.md 가 80줄 넘으면 가장 긴 섹션을 별도 파일로 분리
4. 문서 진화 섹션은 references/evolve-principles.md 의 축약 버전이다. 포함 필수
5. 용어집이 필요해지면 `agents/glossary.md` 를 만들고 라우팅 테이블에 추가
