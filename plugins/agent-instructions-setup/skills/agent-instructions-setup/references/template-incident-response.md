---
title: Cross-Service Incident Response Template
impact: HIGH
impactDescription: AI helps on-call faster when incident playbook covers cross-service scenarios
tags: hub, template, incident, cross-service, on-call
---

## Purpose

팀이 운영하는 여러 서비스에 걸친 인시던트 대응 플레이북. `agents/incident-response.md` 로 생성.

단일 프로젝트 runbook 과 구분:

- 프로젝트 runbook (agents/runbook/): 해당 서비스 내 절차
- 허브 incident-response: **cross-service** 장애 (여러 프로젝트에 동시 영향)

**AI-first 목적**: on-call 시 agent 가 증상→원인 후보→초동 조치를 빠르게 제시.

## Template

```markdown
---
title: {Team Name} Incident Response
description: Cross-service 장애 발생 시 즉시 참고. 초동 대응·에스컬레이션·복구 절차 제공
type: workflow
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Cross-Service Incident Response

## 초동 대응 (첫 5분)

1. **감지 확인**: 알람 채널 {#incident-channel} 확인 + 대시보드 {대시보드 링크 참조 방법}
2. **Incident Commander 지명**: 첫 대응자가 IC. IC 는 {#incident-channel} 에 "IC: @{handle}" 선언
3. **Severity 판단** (아래 표 참고)
4. **복수 서비스 영향이면**: 이 문서. 단일 서비스면 해당 프로젝트의 agents/runbook/ 로 전환
5. **고객 공지**: SEV-1/2 이면 {상태 페이지 또는 공지 채널} 갱신

## Severity 판단

| Level | 기준 | 대응 |
|-------|------|------|
| SEV-1 | 프로덕션 전면 장애 · 고객 영향 광범위 · 매출 영향 | 전원 호출, 즉시 대응 |
| SEV-2 | 주요 기능 장애 · 일부 고객 영향 | On-call + 관련 owner 즉시 |
| SEV-3 | 성능 저하 · 기능 제한 · 우회 가능 | 업무시간 대응 |

## 에스컬레이션 체인

```
{#incident-channel}
  → On-call engineer (현재 rotation)
  → 영역 Owner (agents/team.md)
  → Engineering Lead
  → CTO (SEV-1 만)
```

PagerDuty / OpsGenie 등 도구 사용 중이면 자동 에스컬레이션. 수동일 경우 위 순서대로 {응답 대기 시간} 내 응답 없으면 다음 단계.

## 증상 → 후보 매핑

흔한 증상과 의심 서비스 매핑. agent 가 "API 500 난다" 같은 보고 받으면 후보 좁히는 용도.

| 증상 | 1차 의심 | 2차 의심 | 관련 runbook |
|------|----------|----------|--------------|
| API 전체 5xx | Load balancer / Ingress | Database | agents/runbook/incident-db-down.md |
| 특정 도메인 5xx | 해당 서비스 | 의존 서비스 | 해당 프로젝트 runbook |
| 느려짐 (p99 증가) | DB / cache | Network | |
| 이벤트 미발행 | Kafka / 발행 서비스 | consumer lag | |
| 인증 실패 | Auth service | IdP | |

## 공통 초동 조치

### 트래픽 이상
- 현재 QPS 대시보드 확인
- Rate limit 활성화 여부
- DDoS 의심이면 WAF 규칙 긴급 추가 {절차 링크}

### Database 이슈
- 현재 연결 수, CPU, IOPS 확인
- 장기 실행 쿼리 kill
- Read replica 가용 확인
- Fail-over 필요 판단

### 외부 의존성 장애
- {외부 서비스} 상태 페이지 확인
- 해당 의존성 circuit breaker 활성화
- Graceful degradation 모드 전환

## 통신 규칙

- **Public** (#incident-channel): 진행 상황 10분마다 업데이트
- **Internal** (IC war room): 기술적 논의
- **고객**: SEV-1/2 초기·복구 시 공지. 기술 상세 금지
- **사후 공지**: 복구 완료 후 {채널} 에 brief

## 복구 후

1. 서비스 정상화 확인 (알람 해제 + 사용자 flow 검증)
2. IC 가 타임라인 초안 {#incident-channel} 에 공유
3. 72시간 내 postmortem 작성 (각 프로젝트 agents/postmortem/ 또는 허브 agents/postmortem/)
4. cross-service 학습은 허브 ADR 로 반영 (영향 범위 따라)

## AI 활용

agent 가 on-call 보조로 활용될 때.

- "지금 뭐 일어나는지 요약해" → 증상 기반 1차 의심 서비스 제시
- "DB 가 다운됐어" → Database 섹션 + 해당 runbook 링크 + 에스컬레이션 경로
- "{서비스} 장애야" → 해당 프로젝트 registry + runbook 로 라우팅

Agent 는 **조치를 제안**하되 **실행은 사람이 확정**. SEV-1 자동 실행 금지.

## 금지

- 실제 자격 증명·URL·호스트 원문 (agents/security.md)
- 고객 개인 정보
- 확정되지 않은 추측을 "사실" 로 기재 (사후 Postmortem 에서 확인된 사실만)
```

## 작성 가이드

1. **초동 대응 5분** 은 **최우선 섹션**: 새벽 3시 on-call 이 가장 먼저 봄. 아래로 밀면 안 됨
2. **증상 → 후보 매핑 테이블** 이 agent 의 진단 1 단계. 공들여 작성
3. **구체적 대시보드·PagerDuty 링크는 여기 넣지 말고** placeholder + 조회 방법
4. **단일 서비스 runbook 으로 위임 명시**: 허브는 cross-service 만. 단일 서비스 상세는 프로젝트 runbook
5. **분기별 drill**: 실제 시뮬레이션으로 문서 유효성 검증

## 단일 프로젝트 runbook 과의 관계

```
허브 incident-response.md (여기)
  → 증상 분석 후 단일 서비스 원인으로 좁혀지면
  → {프로젝트}/agents/runbook/incident-{type}.md
```

상호 링크 유지.
