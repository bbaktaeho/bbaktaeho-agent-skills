---
title: Development Project Guide Template
impact: HIGH
impactDescription: guide.md is a routing index for development projects, kept under 80 lines
tags: template, guide, development, routing, index
---

## Purpose

개발 프로젝트용 `agents/guide.md` 템플릿. guide.md 는 **내용이 아니라 라우팅 index** 다. 80줄 이내로 유지한다.

## Template

```markdown
---
title: {Project Name} Guide
description: 작업 시작 전 필독. 작업 유형별 진입 문서 라우팅 제공
type: guide
created: {YYYY-MM-DD}
---

# {Project Name}

{프로젝트 1줄 설명}

## 작업 유형별 라우팅

| 작업 | 먼저 읽을 문서 |
|------|----------------|
| 코드 수정·추가 | agents/workflow.md, agents/stack.md |
| 새 기능 계획 | agents/workflow.md `1. 계획 수립` |
| 디버깅 | agents/stack.md |
| 리뷰 | agents/workflow.md 리뷰 섹션 |
| 문서 추가·수정 | 이 파일의 "문서 진화" 섹션 |

## 기술 스택 (요약)

- 언어: {언어}
- 프레임워크: {프레임워크}
- 상세: agents/stack.md

## 디렉토리 맵 (루트 2 depth)

{프로젝트 루트 간략 구조 — tree 2 depth}

상세 구조가 필요하면 agents/structure.md 를 생성한다.

## 문서 색인 방법

agents/ 하위 파일은 각 파일 상단의 frontmatter `description` 으로 목적을 식별한다. 전체 목록을 여기 나열하지 않는다. 라우팅 테이블에 작업 유형별 진입 문서만 등록한다.

## 문서 진화

- 새 문서 추가: agents/{topic}.md 단일 파일로 시작. 라우팅 테이블에 한 줄 추가
- 300줄 초과 또는 주제 혼재: agents/{topic}/{N}-{name}.md 로 분해
- 문서 수정: frontmatter `updated` 갱신. 섹션 요약이 본문을 반영하는지 확인
- 문서 삭제: agents/ 내 참조를 grep 확인 후 라우팅 테이블에서 제거
- frontmatter 규칙: 6~8줄, description 은 "언제 읽어야 하는지 + 얻는 것" 형식

## Development Log

개발 일지는 `agents/develop/daily/{YYYY-MM-DD}-{요약}.md` 에 작성한다. 예: `2026-04-21-auth-api-구현.md`
```

## 작성 가이드

1. 라우팅 테이블부터 작성한다. 프로젝트에 맞게 행을 추가·삭제
2. 기술 스택은 요약 2~3줄만. 상세는 `agents/stack.md` 를 별도 생성
3. 디렉토리 맵은 2 depth 이내만. 그 이상은 `agents/structure.md` 로 분리
4. 문서 진화 섹션은 references/evolve-principles.md 의 축약 버전이다. 사용자가 셋업 이후 guide.md 만 봐도 규칙을 따를 수 있도록 포함한다
5. guide.md 가 80줄 넘으면 가장 긴 섹션을 별도 파일로 분리하고 해당 섹션은 링크만 남긴다
6. "기술 스택" 과 "디렉토리 맵" 은 분량이 커지면 반드시 `agents/stack.md`, `agents/structure.md` 로 분리한다

## 팀 모드 확장 (Q10=y)

팀 모드 선택 시 라우팅 테이블에 아래 행을 추가한다 (해당 문서가 생성된 경우만).

```
| Onboarding | agents/onboarding.md |
| 팀 구조·Owner | agents/team.md |
| 용어 확인 | agents/glossary.md |
| agents/ 에 쓰기 전 | agents/security.md |
| 기술 스택 상세 | agents/stack.md |
| 과거 기술 결정 | agents/decisions/ (최근 3개는 guide.md 에 직접 링크) |
| 설계 제안 | agents/rfc/ (Under Review 만 guide.md 에 직접 링크) |
| 장애 대응·배포 | agents/runbook/ |
| 인시던트 학습 | agents/postmortem/ |
```

"최근 ADR" / "Active RFC" 는 별도 미니 섹션으로 guide.md 에 포함한다 (최대 3개).

```markdown
## 최근 ADR

- [ADR-007 {제목}](decisions/007-...) — {1줄 요약}
- [ADR-006 {제목}](decisions/006-...)
- [ADR-005 {제목}](decisions/005-...)

전체 목록: agents/decisions/
```

팀 모드의 "문서 진화" 섹션에는 거버넌스 요약이 추가된다.

```markdown
## 문서 진화

- 새 문서 추가: agents/{topic}.md. 라우팅 테이블에 한 줄 추가
- 300줄 초과 또는 주제 혼재: agents/{topic}/{N}-{name}.md 로 분해
- 수정 시 frontmatter `updated` 갱신
- 삭제는 금지. 대신 agents/archive/ 로 이동 (ADR 은 Status 만 변경)
- agents/ PR 은 최소 1명 승인 (팀 규모별 규칙: agents/workflow.md)
- 민감 정보 금지: agents/security.md
```
