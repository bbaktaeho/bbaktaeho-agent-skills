---
title: Development Workflow Template
impact: HIGH
impactDescription: Provides lite (5-step) and full (14-step) workflow options for development
tags: template, workflow, development, lite, full
---

## Purpose

개발용 `agents/workflow.md` 템플릿. Phase 2 Q5 답변에 따라 lite 또는 full 중 하나를 선택한다.

## Lite (5-step, POC·소규모·솔로)

```markdown
---
title: {Project Name} Workflow
description: 개발 작업 시작 시 필독. 5단계 워크플로우와 커밋·PR 규칙 제공
type: workflow
created: {YYYY-MM-DD}
---

# Development Workflow (Lite)

각 단계 첫 줄은 목적 요약이다.

1. 계획 — 요구사항·영향 파일·범위 파악
2. 구현 — 변경 최소화, 기존 패턴 따름, 테스트 동반
3. 자체 검토 — 버그·보안·사이드이펙트·불필요한 변경 확인
4. 정리 — 사용 안 하는 코드·import·주석 제거
5. 커밋·PR — 아래 규칙

## Branch Strategy

- main — production
- feature/{name} — 기능
- fix/{name} — 버그

## Commit Convention

`type: subject`
type: feat, fix, refactor, docs, test, chore

## PR

- 타겟 브랜치: {PR 타겟}
- `.github/PULL_REQUEST_TEMPLATE.md` 있으면 사용
- 변경 목적과 테스트 결과 기술
```

## Full (14-step, 팀·프로덕션)

```markdown
---
title: {Project Name} Workflow
description: 개발 작업 시작 시 필독. 14단계 검토 워크플로우와 분기·커밋 규칙 제공
type: workflow
created: {YYYY-MM-DD}
---

# Development Workflow (Full)

각 단계 첫 줄은 단계의 목적 요약이다.

1. 계획 수립 — 요구사항·영향·범위 정의
2. 계획 검토 — 과설계·누락 여부 점검
3. 구현 — 변경 최소화, 테스트 동반, 한 번에 하나의 관심사
4. 목적 부합 검토 — 요구사항과 구현 대조
5. 버그·보안 검토 — 경계값·인증·입력 검증·에러 처리
6. 개선 회귀 검토 — 기존 동작·성능 영향 확인
7. 재사용 검토 — 기존 유틸·패턴 일관성
8. 사이드이펙트 검토 — 호출처 추적·공유 상태·관련 테스트
9. 전체 diff 재검토 — 불필요한 변경·임시 파일 혼입 확인
10. 불필요 코드 정리 — 사용 안 하는 import·변수·주석 처리된 코드
11. 최종 품질 검토 — 네이밍·스타일·린터·포매터
12. 사용자 흐름 확인 — 주요 시나리오·에러 케이스 검증
13. 배포 가능성 검토 — 테스트 통과·롤백 계획·문서화
14. 커밋·PR — 아래 규칙

각 단계 상세 체크리스트가 필요하면 `agents/workflow/{N}-{name}.md` 로 확장한다.

## 계획 문서

계획은 `agents/plan/{N}-{YYYY-MM-DD}-{name}/plan.md` 에 작성한다.

- plan.md 는 핵심 요약만
- 상세는 같은 디렉토리의 `{N}-{topic}.md` 로 분리
- 완료된 계획은 `agents/plan/archive/` 로 이동

## Branch Strategy

- main — production
- develop — 통합
- feature/{name} — 기능
- fix/{name} — 버그

## Commit Convention

`type: subject`
type: feat, fix, refactor, docs, test, chore

예:
- feat: 사용자 인증 API 추가
- fix: 토큰 갱신 오류 수정

## PR

- 타겟 브랜치: {PR 타겟}
- `.github/PULL_REQUEST_TEMPLATE.md` 있으면 사용
- 변경 목적과 테스트 결과 기술
- 리뷰어 지정

## Development Log

완료 후 `agents/develop/daily/{YYYY-MM-DD}-{요약}.md` 작성
```

## 작성 가이드

1. Q5 답변이 `lite` → lite 블록, `full` → full 블록
2. `{PR 타겟}` 은 Q7 답변으로 치환
3. lite 로 시작했다가 팀이 커지면 full 로 교체한다. 부분 증분 금지 — 워크플로우 전체를 재작성한다
4. 프로젝트 맥락에 맞지 않는 단계는 삭제해도 된다. 단 번호를 다시 매긴다
