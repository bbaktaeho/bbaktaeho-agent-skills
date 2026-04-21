---
title: RFC (Request for Comments) Template
impact: MEDIUM-HIGH
impactDescription: Surfaces design decisions before commitment, reducing rework
tags: template, rfc, proposal, team, design
---

## Purpose

RFC (Request for Comments) 는 구현 이전에 설계·접근을 팀에 공유하고 피드백을 받는 문서다.

ADR 과의 차이: RFC 는 **결정 전**, ADR 은 **결정 후**. RFC 가 합의되면 ADR 로 전환될 수 있다.

## 언제 작성하는가

- 복잡한 기능 설계
- 여러 모듈·팀에 영향을 주는 변경
- 기술 선택이 포함된 신규 기능
- 구현 전에 접근을 검증받고 싶을 때

## 파일 위치 / 네이밍

단일 파일: `agents/rfc/{NNN}-{YYYY-MM-DD}-{name}.md`

상세 설계가 여러 문서로 나뉘면 디렉토리: `agents/rfc/{NNN}-{YYYY-MM-DD}-{name}/`
- `rfc.md` — 핵심 요약
- `01-{topic}.md`, `02-{topic}.md` — 상세

## Template

```markdown
---
title: RFC-{NNN} {제안 요약}
description: {어떤 기능·변경을 제안하는지}. {구현 전 피드백 요청}
type: plan
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# RFC-{NNN}: {제안 제목}

## Status

Draft | Under Review | Accepted | Rejected | Withdrawn

## Summary

{제안 1~2문단 요약}

## Motivation

왜 이 제안이 필요한가.

- 현재 상황
- 문제점
- 해결되면 얻는 것

## Detailed Design

구체적 설계.

### Interface
{API·이벤트·인터페이스 정의}

### Data Model
{스키마·데이터 흐름}

### Implementation Plan
1. Phase 1: ...
2. Phase 2: ...
3. Phase 3: ...

### 영향 범위
- 수정될 모듈
- 새로 생길 모듈
- Deprecated 될 기존 기능

## Alternatives Considered

검토한 대안과 기각 이유 (ADR 형식과 동일).

## Open Questions

합의 전 논의가 필요한 항목.

- Q1: ...
- Q2: ...

## Timeline

- Review 마감: {YYYY-MM-DD}
- Accepted 이후 착수 예상: {YYYY-MM-DD}
- 완료 예상: {YYYY-MM-DD}

## Reviewers

필수 리뷰어 (리스트업).

- @{handle} ({역할})
- @{handle} ({역할})

## References

- 관련 ADR
- 관련 이슈·PR
- 외부 자료
```

## RFC → ADR 전환

RFC 가 Accepted 되고 구현이 결정되면:

1. RFC Status → `Accepted`
2. 핵심 결정을 추출해 ADR 작성 (template-decision.md)
3. ADR 은 RFC 링크 포함
4. RFC 는 그대로 보존 (맥락 자료). 삭제 X

## Status 의미

| Status | 의미 |
|--------|------|
| Draft | 작성 중 |
| Under Review | 리뷰 요청 중 |
| Accepted | 합의됨. ADR 작성 후 구현 |
| Rejected | 기각됨. 이유는 본문에 기록 |
| Withdrawn | 작성자가 철회 |

## ADR 과 RFC, 어느 것을 쓸까

| 상황 | 사용 |
|------|------|
| 이미 결정된 사항 기록 | ADR |
| 구현 전 설계 공유·피드백 | RFC |
| 팀이 ADR·RFC 중 하나만 사용 | 보통 ADR 만 사용해도 충분 |
| 복잡한 설계는 RFC, 결정은 ADR | 성숙한 팀 권장 |

## 원칙

- RFC 는 결정이 아니다. 기각될 수 있음을 전제
- Open Questions 섹션을 반드시 포함 — 무엇이 아직 불확실한지 명시
- Timeline 은 느슨하게. 구속력 있는 일정은 ADR 또는 프로젝트 관리 도구
- 라우팅 테이블의 "Active RFC" 행은 Under Review 상태인 RFC 만 유지
