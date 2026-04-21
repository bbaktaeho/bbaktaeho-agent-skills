---
title: Shared Infrastructure Map Template
impact: HIGH
impactDescription: Enables AI to reason about deploys, cross-service connections, and infra-level changes
tags: hub, template, infrastructure, deploy, cross-service
---

## Purpose

팀이 공용으로 쓰는 인프라 맵. `agents/infrastructure.md` 로 생성.

**AI-first 목적**: agent 가 배포·환경 설정·cross-service 디버깅 질문에 답할 때 이 맵을 참조.

## Template

```markdown
---
title: {Team Name} Infrastructure Map
description: 배포·환경·cross-service 연결 질문 시 참고. 공유 인프라 구성과 접근 경로 제공
type: reference
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Infrastructure Map

## 환경

| Environment | Purpose | 배포 방식 | 접근 |
|-------------|---------|-----------|------|
| local | 개발자 로컬 | docker-compose | — |
| dev | 개발 통합 | CI 자동 | VPN / SSO |
| staging | QA·pre-prod | 수동 승인 | VPN / SSO |
| prod | production | 수동 승인 + 2-approval | 제한적 |

구체적 URL·자격 증명은 secret manager ({도구명}) 에서 조회. 여기 원문 금지.

## Compute Platform

| 항목 | 선택 | 비고 |
|------|------|------|
| Cloud | {AWS / GCP / Azure / ...} | 기본 리전 {region} |
| Container runtime | {Docker / containerd} | |
| Orchestration | {Kubernetes / ECS / ...} | |
| Service mesh | {있으면} | |

## Data Stores

공유 데이터 저장소 (프로젝트별 전용 저장소는 해당 레포에).

| 저장소 | 타입 | 용도 | Owner |
|--------|------|------|-------|
| {name} | Postgres | Primary OLTP | @{handle} |
| {name} | Redis | Session / cache | @{handle} |
| {name} | S3 bucket | Object storage | @{handle} |
| {name} | Kafka cluster | Event bus | @{handle} |

## Networking

| 항목 | 구성 |
|------|------|
| VPC | {기본 구성 요약} |
| Subnets | public / private 분리 |
| Load balancer | {type} |
| CDN | {있으면} |
| DNS | {provider} |

## CI / CD

| 단계 | 도구 | 비고 |
|------|------|------|
| Build | {tool} | |
| Test | {tool} | PR 필수 |
| Deploy | {tool} | staging: 자동 / prod: 수동 승인 |
| Rollback | {방법} | agents/incident-response.md 참고 |

## Observability

| 항목 | 도구 | 접근 |
|------|------|------|
| Logs | {tool} | {대시보드 링크 — 내부} |
| Metrics | {tool} | |
| Tracing | {tool} | |
| Alerts | {tool / PagerDuty 등} | |

## Secrets Management

자격 증명 저장소.

- 도구: {1Password / AWS Secrets Manager / Vault / ...}
- 프로젝트 코드에서 secret 읽는 방식: 환경변수 → {SDK} → {저장소}
- **agents/ 에 원문 금지**: agents/security.md 참조

## Cross-Service Dependencies

서비스 간 의존성 다이어그램.

```
{mermaid 또는 ASCII 다이어그램}

service-a → [DB] primary-postgres
service-a → [API] service-b
service-b → [Queue] kafka
service-c → [Cache] redis
```

상세 의존성: agents/architecture/ 참고.

## 권한 / 접근

- IAM 역할: {공통 역할 목록}
- SSO: {Provider}
- VPN: {언제 필요}
- Prod 접근: {승인 절차}

구체적 role ARN·그룹 이름은 secret manager / IdP 대시보드에서 조회.

## AI 활용

agent 가 아래 질문을 받으면 이 문서를 먼저 참조.

- "staging 에 배포해" → CI / CD 섹션 확인 후 적절한 명령
- "prod DB 접근은?" → Data Stores + 권한 섹션
- "cross-service 호출 추가" → Cross-Service Dependencies 검토
- "이 서비스 어디 배포돼?" → Compute Platform + 환경
```

## 작성 가이드

1. **원문 자격 증명 금지**: URL · 호스트 · 키는 모두 placeholder + 조회 방법. agents/security.md 참조
2. **테이블 우선**: agent 파싱 용이
3. **구체적 명령 금지**: "kubectl apply ..." 같은 명령은 agents/runbook/ 또는 프로젝트별 README 에
4. **다이어그램은 텍스트 기반**: mermaid / ASCII. 이미지 파일은 agent 가 읽기 어려움
5. **Owner 필수**: 문제 발생 시 누구에게 물어볼지 agent 가 답할 수 있어야 함

## 갱신 타이밍

- 새 환경·저장소 추가
- 도구 교체 (observability stack 변경 등)
- 접근 정책 변경
- 분기별 드리프트 리뷰

## 금지

- 실제 자격 증명·URL·IP 원문
- 개별 마이크로서비스 상세 (프로젝트 agents/ 로)
- 외부 파트너 시스템 이름 (계약 비공개 가능성)
- 단기 실험 인프라 (이 문서는 안정된 공유 인프라만)
