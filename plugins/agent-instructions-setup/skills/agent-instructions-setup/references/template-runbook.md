---
title: Runbook Template
impact: HIGH
impactDescription: Operational playbook that turns 2-hour incidents into 10-minute responses
tags: template, runbook, operations, incident, deploy
---

## Purpose

Runbook 은 운영·장애·배포 절차를 단계별로 명시한 문서다.

목표: 새벽 3시 on-call 이 읽고 바로 실행 가능한 수준의 구체성.

## 언제 작성하는가

- 반복되는 운영 작업 (배포, 롤백, DB 마이그레이션)
- 장애 대응 절차 (DB 다운, 외부 API 장애, 트래픽 폭증)
- 복구 절차 (백업 복원, 인덱스 재생성)
- 정기 점검 작업

## 파일 위치 / 네이밍

`agents/runbook/{topic}.md`

예:
- `agents/runbook/deploy.md` — 배포 절차
- `agents/runbook/rollback.md` — 롤백 절차
- `agents/runbook/incident-db-down.md` — DB 장애
- `agents/runbook/incident-traffic-spike.md` — 트래픽 폭증

## Template

```markdown
---
title: {Topic} Runbook
description: {언제 실행} 시 참고. 단계별 절차와 검증 체크포인트 제공
type: workflow
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# {Topic} Runbook

## Trigger

이 runbook 을 실행해야 하는 조건.

- 증상 1
- 증상 2
- 알람 이름: `{alarm name}`

## Prerequisites

실행 전 필요한 권한·도구.

- 권한: {IAM role / 접근 권한}
- 도구: {CLI / dashboard link}
- 사전 확인: {이 runbook 시작 전 체크할 것}

## Procedure

### 1. 초기 확인
- [ ] {구체적 명령 / 확인 항목}
- [ ] 예상 출력: `{expected}`

### 2. {Action}
- [ ] 명령: `{command}`
- [ ] 확인: {검증 방법}

### 3. {Action}
- [ ] ...

### 4. 완료 확인
- [ ] 서비스 정상: `{health check command}`
- [ ] 메트릭 확인: {dashboard link}

## Rollback

위 절차가 실패한 경우.

- [ ] {rollback step}
- [ ] {verification}

## 에스컬레이션

위 절차가 10분 내 해결되지 않으면.

- 1차: {#channel} 또는 @{on-call handle}
- 2차: Engineering Lead
- 3차: CTO / Incident Commander

## 포스트모템

완료 후.

- 소요 시간 기록
- 예상치 못한 이슈가 있었으면 agents/postmortem/{YYYY-MM-DD}-{topic}.md 에 기록
- Runbook 자체 개선 필요 시 PR
```

## 작성 원칙

1. **구체적 명령**: "DB 재시작" 이 아니라 실행 가능한 명령어 그대로
2. **체크박스**: 각 단계는 [ ] 체크박스. 진행 상황 트래킹
3. **예상 출력 명시**: 명령 실행 결과가 어떠해야 하는지. 다르면 중단 신호
4. **Rollback 필수**: 모든 runbook 에 되돌리기 절차 포함
5. **Secret 금지**: rule-team-governance.md 및 security.md 준수. 실제 값 대신 `{PROD_HOST}` placeholder

## 실제성 유지

Runbook 은 6개월 내 한 번도 실행 안 되면 썩는다.

- **분기별 실행 drill**: 장애 runbook 은 분기마다 한 번 시뮬레이션
- **Deploy runbook**: 매 배포마다 이 문서를 참고했는지 체크
- **`updated` 갱신**: drill·실행·수정마다 갱신

## 금지

- 민감 정보 (자격 증명, 내부 URL 원문)
- "상황에 따라 판단" 같은 모호한 지시
- runbook 에서 다른 runbook 으로의 긴 체인 (3단계 이상 depth 금지)
- 300줄 초과 — 초과 시 runbook 분리

## Agent 활용

장애·배포 시 agent 에게 "이 상황에 맞는 runbook 찾아" 라고 요청하면 agent 는 runbook 의 `description` + Trigger 섹션으로 해당 문서를 찾음. description 에 "언제 실행" 을 반드시 포함.
