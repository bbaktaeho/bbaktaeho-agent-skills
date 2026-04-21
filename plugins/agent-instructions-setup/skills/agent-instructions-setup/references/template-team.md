---
title: Team Structure Template
impact: HIGH
impactDescription: Single place for ownership and escalation paths, no PII
tags: template, team, ownership, escalation
---

## Purpose

팀 구조·담당 영역·에스컬레이션 경로를 한 곳에 정리. `agents/team.md` 로 생성된다.

핵심: **개인 연락처는 쓰지 않는다**. 공용 핸들·채널만.

## Template

```markdown
---
title: {Project Name} Team
description: 업무 시작 전 참고. 팀 역할·영역 Owner·에스컬레이션 경로 제공
type: reference
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# {Project Name} Team

## 금지

개인 연락처 (전화, 개인 이메일) 는 이 문서에 쓰지 않는다. Slack handle, 공용 채널, 역할명만 사용한다.

## 팀 구조

{역할 기반 구조 — 예시}

- **Engineering Lead**: @{handle}
- **Backend**: @{handle1}, @{handle2}
- **Frontend**: @{handle3}
- **Infra/DevOps**: @{handle4}
- **QA**: @{handle5}

## 영역 Owner

코드 영역별 owner. `.github/CODEOWNERS` 와 동기화 유지.

| 영역 | Primary Owner | Backup |
|------|--------------|--------|
| {module-or-path} | @{handle} | @{handle} |
| {module-or-path} | @{handle} | @{handle} |

## 에스컬레이션 경로

| 상황 | 1차 | 2차 |
|------|-----|-----|
| 기술 이슈 | {#slack-channel} | Engineering Lead |
| 프로덕션 인시던트 | On-call (rotation) | {#incident-channel} |
| 보안 이슈 | {#security-channel} | Security Lead |
| 의사결정 필요 | agents/decisions/ ADR 또는 workflow.md 리뷰 절차 | Lead |

## 커뮤니케이션 채널

| 채널 | 용도 |
|------|------|
| {#general} | 공지·잡담 |
| {#dev} | 기술 논의 |
| {#pr-review} | PR 리뷰 요청 |
| {#incident} | 장애 대응 |

## 외부 파트너

{필요 시. 계약상 비공개인 경우 비우거나 "contact via Lead"}

- {서비스명}: 담당 Owner @{handle}. 계약 문의는 Lead 경유
```

## 작성 가이드

1. **역할명 우선**: "@김철수" 가 아니라 "Backend Lead (@handle)" 식으로 역할+핸들
2. **백업 owner 필수**: bus factor. 모든 영역에 최소 2명
3. **Slack handle 은 괜찮음**: 공용 플랫폼 핸들. 하지만 개인 이메일·전화는 금지
4. **Org chart 는 여기 넣지 않는다**: 너무 자주 바뀜. 팀·역할·담당 영역만
5. `.github/CODEOWNERS` 와 항상 동기화. CODEOWNERS 변경 시 이 문서도 PR 에 포함

## 업데이트 타이밍

- 팀원 추가/제거
- 영역 소유권 변경
- 에스컬레이션 경로 변경
- 채널 이름·용도 변경

변경 시 `updated` 갱신 + CODEOWNERS 동기화 체크.

## 금지

- 개인 전화번호·개인 이메일
- 집 주소
- 팀원 실명 외 추가 개인정보
- 연봉·계약 정보
