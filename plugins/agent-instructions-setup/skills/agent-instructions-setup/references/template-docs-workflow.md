---
title: Documentation Workflow Template
impact: HIGH
impactDescription: Provides lite (5-step) and full (14-step) doc workflow options
tags: template, workflow, documentation, lite, full
---

## Purpose

문서용 `agents/workflow.md` 템플릿. Phase 2 Q5 답변에 따라 lite 또는 full 중 하나를 선택한다.

## Lite (5-step)

```markdown
---
title: {Project Name} Workflow
description: 문서 작성 시작 시 필독. 5단계 워크플로우와 커밋 규칙 제공
type: workflow
created: {YYYY-MM-DD}
---

# Documentation Workflow (Lite)

각 단계 첫 줄은 목적 요약이다.

1. 계획 — 목적·대상·다룰 질문 정의
2. 초안 — frontmatter 먼저, 섹션 첫 줄 요약, 단일 주제
3. 자체 검토 — 중복·모순·참조 유효성 확인
4. 정리 — 불필요 섹션·빈 파일 제거
5. 커밋·PR — 아래 규칙

## Branch Strategy

- main — production
- docs/{name} — 문서 작업

## Commit Convention

`type: subject`
type: docs, fix, chore
```

## Full (14-step)

```markdown
---
title: {Project Name} Workflow
description: 문서 작성 시작 시 필독. 14단계 검토 워크플로우와 AI 친화 규칙 제공
type: workflow
created: {YYYY-MM-DD}
---

# Documentation Workflow (Full)

각 단계 첫 줄은 단계의 목적 요약이다.

1. 계획 수립 — 목적·대상·다룰 질문 정의
2. 계획 검토 — 범위·깊이·대상 독자 수준 점검
3. 초안 작성 — frontmatter·섹션 요약·단일 주제 원칙
4. 목적 부합 검토 — 계획한 질문에 모두 답하는지
5. 구조·가독성 검토 — 제목 계층·300줄 한도·목록 형식
6. AI 친화성 검토 — findability 6 규칙 준수 (description, 섹션 요약, 절대 경로, 용어 고정 등)
7. 중복·모순 검토 — 기존 문서와의 관계
8. 참조 유효성 검토 — 파일 경로·URL·절대 참조 확인
9. 전체 diff 재검토 — 불필요 변경·민감 정보 혼입 확인
10. 불필요 문서 정리 — 통합된 원본·빈 파일·빈 디렉토리 삭제
11. 최종 품질 검토 — 맞춤법·파일명 규칙·frontmatter 6~8줄
12. 독자 흐름 확인 — guide.md 진입점에서 해당 문서 도달 가능성
13. 배포 가능성 검토 — 민감 정보·placeholder 잔존 여부
14. 커밋·PR — 아래 규칙

## 계획 문서

계획은 `agents/plan/{N}-{YYYY-MM-DD}-{name}/plan.md` 에 작성한다.

- plan.md 는 핵심 요약만
- 상세는 같은 디렉토리의 `{N}-{topic}.md` 로 분리

## Branch Strategy

- main — production
- develop — 통합
- docs/{name} — 문서 작성·수정

## Commit Convention

`type: subject`
type: docs, fix, chore

예:
- docs: API 레퍼런스 추가
- fix: getting-started 오류 수정

## PR

- 타겟 브랜치: {PR 타겟}
- 변경된 문서 목록과 변경 목적 기술
- 리뷰어 지정
```

## 작성 가이드

1. Q5 답변이 `lite` → lite 블록, `full` → full 블록
2. `{PR 타겟}` 은 Q7 답변으로 치환
3. 단계 6 (AI 친화성 검토) 는 삭제하지 않는다 — findability 유지 핵심 단계
4. lite 에서 full 로 교체 시 워크플로우 전체를 재작성한다
