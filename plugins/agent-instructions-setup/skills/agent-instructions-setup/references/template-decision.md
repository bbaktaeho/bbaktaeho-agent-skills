---
title: ADR (Architecture Decision Record) Template
impact: HIGH
impactDescription: Captures tribal knowledge that would otherwise vanish in 6 months
tags: template, adr, decision, team, history
---

## Purpose

ADR (Architecture Decision Record) 은 팀의 중요한 기술 의사결정을 시점 기록으로 남긴다.

6개월 후 "왜 이렇게 했지?" 를 agent 와 사람이 모두 답할 수 있게 한다.

## 언제 작성하는가

- 기술 선택 (언어·프레임워크·DB·아키텍처 패턴)
- 중요한 인터페이스 변경 (API, event schema)
- 트레이드오프가 뚜렷한 결정
- 번복 시 비용이 큰 결정
- 팀에서 토론하여 합의한 내용

## 언제 작성하지 않는가

- 일상적 구현 선택 (코드 리뷰에서 논의로 충분)
- 버그 수정
- 리팩토링 중 명백한 개선

## 파일 위치 / 네이밍

`agents/decisions/{NNN}-{YYYY-MM-DD}-{name}.md`

- **NNN**: 3자리 연번 (001, 002, ...). 전체 ADR 에서 유일
- **YYYY-MM-DD**: 작성 시작일
- **name**: 영문 kebab-case. 짧게 (3~5 단어)

예: `agents/decisions/001-2026-04-21-choose-postgres.md`

## Template

```markdown
---
title: ADR-{NNN} {결정 요약}
description: {이 결정을 참고해야 하는 상황}. {핵심 trade-off 한 줄}
type: decision
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# ADR-{NNN}: {결정 제목}

## Status

Proposed | Accepted | Deprecated | Superseded by ADR-{NNN}

## Context

이 결정이 필요한 배경. 무엇이 문제인가? 어떤 제약이 있는가?

- 해결하려는 문제
- 제약 조건 (시간, 자원, 기술)
- 관련된 요구사항

## Decision

선택한 것.

{구체적으로 무엇을 하기로 했는지 1~3문단}

## Rationale

왜 이것을 선택했는가.

- 이유 1
- 이유 2
- 이유 3

## Alternatives Considered

검토했으나 선택하지 않은 대안.

### {대안 A}
- 장점: ...
- 단점: ...
- 기각 이유: ...

### {대안 B}
- 장점: ...
- 단점: ...
- 기각 이유: ...

## Consequences

이 결정의 결과.

- **긍정**: ...
- **부정**: ...
- **중립**: ...
- **미래 재검토 트리거**: {어떤 상황이 되면 이 결정을 다시 볼 것인가}

## References

- {관련 PR·이슈 링크}
- {외부 자료}
- {관련 ADR}
```

## 원칙

1. **한 ADR = 하나의 결정**. 여러 결정을 섞지 않는다
2. **Accepted 이후 수정 금지**. 번복은 새 ADR 로 Supersede
3. **Status 변경 시 `updated` 갱신**: Proposed → Accepted → Deprecated
4. **연번은 전체에서 유일**: subdirectory 별이 아니라 전체 `agents/decisions/` 기준
5. **라우팅 테이블 등록**: 새 ADR 추가 시 `agents/guide.md` 의 "최근 ADR" 행 업데이트

## Supersede 처리

ADR-007 이 ADR-003 을 대체하는 경우:

1. 새 ADR-007 작성. 첫 줄에 `Supersedes: ADR-003`
2. ADR-003 의 Status 를 `Superseded by ADR-007` 로 변경
3. ADR-003 본문은 **삭제하지 않음**. 맥락 유지를 위해 그대로 둔다

## Status 의미

| Status | 의미 |
|--------|------|
| Proposed | 작성 중 / 합의 전 |
| Accepted | 합의·적용 중 |
| Deprecated | 더 이상 적용 안 됨. 대체 없음 |
| Superseded by ADR-NNN | 후속 ADR 로 대체됨 |

## 리뷰

ADR 은 일반 PR 보다 더 많은 리뷰어가 필요할 수 있음.

- 영향받는 모든 owner 참여
- 최소 2명 Accept 후 Status 를 Accepted 로 변경
- 논의는 PR 커멘트 또는 회의록 링크로 보관

## Agent 활용

신규 코드·설계 시 agent 는 agents/decisions/ 를 참조하여 과거 결정과 일관되게 작동. agents/guide.md 의 "최근 ADR" 행이 agent 진입점 역할.
