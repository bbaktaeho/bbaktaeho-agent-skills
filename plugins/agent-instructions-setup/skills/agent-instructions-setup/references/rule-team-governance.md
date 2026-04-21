---
title: Team Governance Principles
impact: CRITICAL
impactDescription: Team agents/ without governance rots in 90 days and amplifies bad conventions
tags: team, governance, ownership, review, freshness, redaction, security
---

## Philosophy

팀에서 agents/ 를 운영할 때 핵심 리스크는 세 가지다.

1. **지식 부패** — 업데이트 안 되면 agent 가 낡은 정보로 코드를 생성
2. **나쁜 관례 증폭** — 팀 컨벤션이 애매하면 agent 가 그 애매함을 가속
3. **정보 유출** — 민감 정보가 agents/ 에 들어가면 AI 컨텍스트로 외부 노출

이 reference 는 세 리스크를 구조적으로 방어하는 원칙이다.

## 5 Governance Rules

### 1. Ownership

agents/ 는 반드시 owner 가 있어야 한다. 없으면 썩는다.

- `.github/CODEOWNERS` 에 `agents/ @{owner-team}` 등록
- 최소 2명 이상의 owner (bus factor)
- Owner 가 부재 중이면 누가 대신 승인할지 명시

### 2. Review

agents/ 변경은 코드와 동일한 PR 리뷰를 거친다.

- 최소 1명 승인 (팀 규모에 따라 조정)
- 리뷰어는 최소 1명 owner 포함
- 리뷰 관점: findability 규칙 준수, redaction 위반 여부, 기존 문서와 모순

### 3. Freshness

오래된 문서는 거짓보다 위험하다.

- 모든 agents/*.md 는 frontmatter 에 `updated: YYYY-MM-DD` 유지
- 90일 이상 `updated` 없는 문서는 분기별 리뷰
- 리뷰 결과:
  - 여전히 유효 → `updated` 갱신만
  - 수정 필요 → 수정 후 갱신
  - 더 이상 유효 X → deprecated 표시 또는 archive 이동

### 4. Redaction

민감 정보는 agents/ 에 쓰지 않는다. 자세한 금지 목록: agents/security.md (생성되면)

핵심 원칙:
- 자격 증명 (API 키, 토큰, 패스워드)
- 내부 인프라 주소 (prod URL, DB host, 내부 IP)
- 고객·사용자 PII
- 팀원 개인 연락처
- 재무·계약 관련 수치

대안:
- 실제 값 대신 placeholder + secret manager 참조 방법 기재
- 개인 연락처 대신 Slack handle / 공용 채널

### 5. Deprecation, Not Deletion

문서를 삭제하면 과거 결정의 맥락이 사라진다. Archive 해야 한다.

- ADR: Status 를 `Superseded by ADR-{NNN}` 로 변경. 삭제 X
- 운영 runbook: 더 이상 유효하지 않으면 `agents/runbook/archive/` 이동
- 일반 문서: `agents/archive/` 로 이동 + 라우팅 테이블에서 제거

## Anti-Patterns

- **Single-owner bottleneck**: owner 1명 → 휴가·퇴사 시 agents/ 방치
- **No-review merge**: PR 승인 없이 agents/ 수정 가능 → redaction 위반·일관성 붕괴
- **Timestamp-less docs**: `updated` 없음 → 낡음 여부 판단 불가
- **Delete-over-archive**: 문서 삭제 → 과거 결정 맥락 소실
- **Secrets by accident**: 디버깅 중 실제 값 commit → public repo 유출 위험

## Sign-Off 규칙

팀 규모별 권장 PR 승인 수:

| 팀 규모 | Code PR | agents/ PR |
|---------|---------|------------|
| solo | 0 (self) | 0 (self) |
| small (2-5) | 1 | 1 |
| medium (6-15) | 1 | 1 + owner |
| large (16+) | 2 | 2 (owner 1명 포함) |

## 이 원칙이 팀에 정착하는 방식

1. 초기 셋업 시 `agents/guide.md` 에 "agents/ 변경은 PR 리뷰 필수" 명시
2. `.github/PULL_REQUEST_TEMPLATE.md` 에 "agents/ 업데이트 필요?" 체크박스
3. 분기별 1회 `agents/` freshness 리뷰 회의 (30분 이내)
4. 신규 입사자 onboarding 에 이 원칙 포함
