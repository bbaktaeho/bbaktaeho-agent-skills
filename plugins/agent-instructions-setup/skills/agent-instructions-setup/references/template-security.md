---
title: Security Rules Template
impact: CRITICAL
impactDescription: agents/ leaks into AI context; without redaction rules, secrets leak externally
tags: template, security, redaction, pii, secrets
---

## Purpose

agents/ 하위 문서의 민감 정보 금지 규칙. `agents/security.md` 로 생성된다.

핵심: agents/ 에 들어간 모든 정보는 AI 컨텍스트로 들어가고, 외부 모델 제공자로 전송될 수 있다. 민감 정보는 반드시 제외해야 한다.

## Template

```markdown
---
title: {Project Name} Security Rules for agents/
description: agents/ 에 쓰기 전 필독. 금지 항목과 redaction 규칙 제공
type: spec
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Security Rules for agents/

## 핵심 원칙

agents/ 하위 문서는 AI 컨텍스트로 들어가 외부 모델 제공자로 전송된다. 민감 정보는 이 디렉토리에 쓰지 않는다.

## 절대 금지

- **자격 증명**: API 키, 토큰, 비밀번호, SSH 키, OAuth secret
- **내부 인프라 주소**: 프로덕션 URL, DB 호스트·포트, 내부 IP, VPN endpoint
- **고객·사용자 PII**: 실명, 이메일, 전화, 주소, 주민번호, 카드번호
- **재무 정보**: 내부 KPI 수치, 계약 금액, 연봉
- **개인 연락처**: 팀원 전화·개인 이메일
- **보안 취약점 상세**: 아직 패치 안 된 CVE, 익스플로잇 코드
- **외부 파트너 이름**: 계약상 비공개인 경우
{T6 답변에 따라 프로젝트별 추가 항목}

## 대안 (redaction)

| 금지 항목 | 대안 |
|-----------|------|
| API 키 값 | placeholder (`{API_KEY}`) + 조회 경로 ("secret manager: 1Password / AWS Secrets Manager") |
| 프로덕션 URL | `{PROD_HOST}` 로 기재 + 실제 값은 env var 이름만 |
| 팀원 연락처 | Slack handle 또는 agents/team.md 역할명 참조 |
| 고객 예시 데이터 | 가명·synthetic data |
| 내부 메트릭 | "월간 활성 사용자" 같이 추상적 표현 |

## 리뷰 시 체크

PR 에서 agents/ 변경 리뷰 시 아래 패턴을 grep.

```bash
# API key 형태
rg 'sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|AKIA[0-9A-Z]{16}' agents/

# 개인 이메일 (도메인 기준)
rg '[a-z0-9._%+-]+@(gmail|naver|daum|hanmail|yahoo)\.' agents/

# 내부 IP
rg '10\.\d+\.\d+\.\d+|172\.(1[6-9]|2[0-9]|3[01])\.\d+\.\d+|192\.168\.' agents/

# URL 패턴 (프로덕션 호스트가 알려져 있으면 추가)
rg 'https?://[a-z0-9.-]*\.{internal-domain}' agents/
```

## 공개 수준별 대응

현재 프로젝트: **{T5 답변 - public OSS / internal / regulated}**

### Public OSS 인 경우
- 위 규칙을 엄격히 적용
- PR 은 외부 기여자도 볼 수 있음 — agents/ 내용이 공개된다고 가정
- PII / 내부 정보 완전 제외

### Internal 인 경우
- 위 규칙 적용하되, 팀 내부 공유 정보(예: 역할명, 공용 채널)는 허용
- 외부로 공유 시 재검토 (예: 벤더 미팅 자료로 쓸 때)

### Regulated (금융·의료·개인정보) 인 경우
- 위 규칙 + 추가 compliance 요구사항 반영
- 감사 로그 / 접근 기록 유지
- 법무/보안팀 검토 필수

## 사고 대응

민감 정보가 agents/ 에 커밋된 것을 발견하면:

1. **즉시 보안 채널 알림**: {#security-channel}
2. **Rotation**: 유출된 자격 증명 즉시 rotate
3. **Git history 제거**: `git filter-branch` 또는 BFG Repo-Cleaner. 단, push 이미 된 경우 이미 외부 복사본 존재 가정
4. **사후 ADR**: agents/decisions/ 에 사고 원인·개선 방안 기록 (ADR 쓰는 팀)

## 금지 항목 추가

팀에서 추가로 금지할 항목이 생기면 위 "절대 금지" 섹션에 추가. 추가 시 PR 로 공유 + 팀 공지.
```

## 작성 가이드

1. T5 답변에 따라 "공개 수준별 대응" 섹션 중 해당 항목만 남기고 나머지는 제거해도 됨 (간결성)
2. T6 답변이 있으면 "절대 금지" 섹션에 프로젝트별 항목 추가
3. Grep 패턴은 프로젝트 도메인에 맞게 조정 (내부 도메인, 고객 이름 패턴 등)
4. 사고 대응 연락처 (#security-channel) 는 agents/team.md 와 동기화
5. CI 에 위 grep 패턴을 자동 검사하는 step 추가 권장 (별도 PR)

## 금지

security.md 자체에 실제 민감 정보를 예시로 쓰지 않는다. 모든 예시는 placeholder.
