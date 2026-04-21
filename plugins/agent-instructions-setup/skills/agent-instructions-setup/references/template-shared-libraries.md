---
title: Shared Libraries Catalog Template
impact: HIGH
impactDescription: Prevents AI from reinventing wheels when team already has shared utilities
tags: hub, template, shared-libraries, catalog, reuse
---

## Purpose

팀이 유지·제공하는 공유 라이브러리·유틸 카탈로그. `agents/shared-libraries.md` 로 생성.

**AI-first 목적**: agent 가 새 기능 작성 시 재발명 대신 기존 공유 라이브러리를 먼저 탐색. "이미 있는 거 또 만들기" 방지.

## Template

```markdown
---
title: {Team Name} Shared Libraries
description: 새 코드 작성 전 필독. 재사용 가능한 팀 공유 라이브러리·유틸 카탈로그
type: reference
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Shared Libraries

## 사용 원칙

- 새 기능 작성 전 이 카탈로그를 먼저 확인. 유사 기능이 있으면 재사용
- 새 유틸을 만들고 싶으면 공유 라이브러리 추가 논의 (ADR)
- 공유 라이브러리 수정 시 모든 소비자 영향 검토

## Core Utilities

일반 목적 유틸.

| Library | Language | Purpose | Repo / Path |
|---------|----------|---------|-------------|
| {name} | {lang} | {한 줄 목적} | {URL 또는 monorepo path} |
| {name} | {lang} | {한 줄 목적} | {URL} |

## Data Access

DB·storage 공통 처리.

| Library | Purpose | Repo |
|---------|---------|------|
| {name} | Postgres 공통 connection pool·migrations | {URL} |
| {name} | S3 wrapper | {URL} |

## Observability

로깅·메트릭·트레이싱 공통.

| Library | Purpose | Repo |
|---------|---------|------|
| {name} | 구조화 로깅 | {URL} |
| {name} | Metrics 클라이언트 | {URL} |

## Auth / Security

인증·인가·crypto 공통.

| Library | Purpose | Repo |
|---------|---------|------|
| {name} | JWT 검증 | {URL} |
| {name} | Rate limiting | {URL} |

## Domain-Specific

팀 도메인 특화 라이브러리.

| Library | Purpose | Repo |
|---------|---------|------|
| {name} | {domain-specific} | {URL} |

## Per-Library Detail

각 라이브러리의 상세 사용법은 해당 레포의 README·docs 에 있다. 이 허브는 catalog 역할만.

추가 정보가 필요하면:

- Install: `{install command}`
- Minimal example: 해당 레포 README
- Maintainer: agents/team.md 의 해당 영역 Owner

## AI 활용

Agent 가 새 기능 작성 전 이 카탈로그를 조회한다.

예:
- "로깅 붙여" → Observability 섹션에서 팀 공유 로거 사용
- "JWT 파싱 해" → Auth 섹션에서 공유 라이브러리 사용
- "S3 업로드" → Data Access 섹션에서 공유 S3 wrapper 사용
- 재사용할 라이브러리가 없으면 개별 구현 + 공유 라이브러리 추가 여부를 사용자에게 제안

## 새 라이브러리 추가

새 공유 라이브러리를 만들거나 기존 내부 유틸을 공유로 승격할 때.

1. ADR 작성 (agents/decisions/) — 왜 필요한가, 범위, 의존성 규칙
2. 라이브러리 레포·패키지 생성
3. 이 카탈로그에 항목 추가 + `updated` 갱신
4. 해당 카테고리가 없으면 섹션 추가
5. 사용자 팀에 공지

## 라이브러리 Deprecation

공유 라이브러리가 더 이상 권장되지 않을 때.

1. ADR 로 deprecation 명시 (마이그레이션 경로 포함)
2. 이 카탈로그의 해당 행 옆에 `DEPRECATED → {대체 라이브러리}` 표시
3. 기한 경과 후 `agents/shared-libraries/archived.md` 로 이동
```

## 작성 가이드

1. **테이블 우선**: agent 파싱 용이
2. **Purpose 는 짧게**: 30자 이내
3. **Repo/Path 필수**: 없으면 agent 가 어떻게 찾을지 모름. monorepo 면 상대 경로
4. **카테고리는 팀 실제 구조 반영**: 위 카테고리는 예시. 없는 카테고리는 제거, 새 카테고리 추가
5. **설치·사용법은 여기 안 씀**: 카탈로그는 메타. 상세는 해당 레포
6. **Version 명시 금지**: 자주 변경됨. 버전은 각 레포의 `package.json` 등에서 조회

## AI 가 이 문서를 놓치지 않게

agent 가 새 기능 제안 시 이 문서를 참조하도록 agents/guide.md 의 라우팅 테이블에 "새 코드 작성 전 → agents/shared-libraries.md" 행 포함 필수.

## 금지

- 개별 라이브러리 상세 API (해당 레포에)
- 사용 예시 코드 (해당 레포 README 에)
- 외부 라이브러리 (npm / PyPI 공개 라이브러리는 agents/tech-radar.md)
- Deprecated 라이브러리의 상세 설명 (간단히만)
