---
title: Tech Radar Template
impact: HIGH
impactDescription: Prevents AI from suggesting deprecated tech and enforces team-approved stack
tags: hub, template, tech-radar, standards, approved, deprecated
---

## Purpose

팀이 승인한 기술·실험 중인 기술·폐기한 기술을 명시. `agents/tech-radar.md` 로 생성.

**AI-first 목적**: agent 가 새 코드·의존성을 제안할 때 이 문서를 참조하여 deprecated 기술 제안을 방지, 승인된 기술만 사용.

## Template

```markdown
---
title: {Team Name} Tech Radar
description: 새 기술·라이브러리 선택 전 필독. 승인·실험·폐기 기술 목록 제공
type: spec
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Tech Radar

## 사용법

- **Approved**: 팀 표준. 새 프로젝트에서 사용 권장
- **Experimental**: 평가 중. 새 프로젝트에서 신중하게 도입, pilot 결과 공유 필요
- **Deprecated**: 더 이상 채택하지 않음. 기존 사용처는 마이그레이션 계획 필요
- **Banned**: 보안·라이선스·안정성 문제로 금지

AI 에이전트는 새 기술 제안 전 이 문서를 확인한다. Deprecated/Banned 를 제안하지 않는다.

## Languages

| 기술 | Status | 비고 |
|------|--------|------|
| {language} | Approved | 기본 언어 |
| {language} | Approved | 특정 도메인 |
| {language} | Deprecated | → {마이그레이션 대상} |

## Frameworks

### Backend
| 기술 | Status | 비고 |
|------|--------|------|
| {framework} | Approved | |
| {framework} | Experimental | pilot: {프로젝트} |

### Frontend
| 기술 | Status | 비고 |
|------|--------|------|
| {framework} | Approved | |

## Databases / Data Stores

| 기술 | Status | 사용 시나리오 |
|------|--------|---------------|
| {db} | Approved | Primary OLTP |
| {db} | Approved | Cache |
| {db} | Experimental | |
| {db} | Banned | 보안 이슈 |

## Infrastructure / Platform

| 기술 | Status | 비고 |
|------|--------|------|
| {cloud} | Approved | |
| {container} | Approved | |
| {orchestration} | Approved | |

## Observability

| 기술 | Status | 비고 |
|------|--------|------|
| {tool} | Approved | Logs |
| {tool} | Approved | Metrics |
| {tool} | Approved | Tracing |

## CI / CD

| 기술 | Status | 비고 |
|------|--------|------|
| {tool} | Approved | |

## Languages for Agent Assistance

AI 에이전트가 생성하는 코드에 적용되는 추가 규칙.

- 새 코드는 **Approved** 언어·프레임워크만 사용
- Deprecated 기술로 된 기존 코드 수정 시 **기존 기술 유지** (리팩토링과 분리)
- Experimental 도입 제안은 ADR 로 올림
- Banned 는 제안·사용 금지

## Status 전환 규칙

기술의 Status 변경은 ADR 로 기록한다.

- Approved → Deprecated: 마이그레이션 기한 포함 ADR
- Deprecated → Banned: 기한 경과 또는 심각한 이슈 발견
- Experimental → Approved: pilot 결과 + 도입 계획 ADR
- Experimental → Deprecated: pilot 실패 ADR

## 범주 추가

새 범주 (예: Messaging, Search, ML Platform) 는 이 문서 내 섹션 추가.
```

## 작성 가이드

1. **테이블 형식 고수**: agent 가 파싱하기 쉬움. 서술형 금지
2. **Status 는 4개로 제한**: Approved / Experimental / Deprecated / Banned. 세분화 금지 (agent 혼란)
3. **비고는 짧게**: 30자 이내. 상세 이유는 관련 ADR 링크
4. **Cadence**: 분기에 1회 리뷰. `updated` 갱신
5. **범주는 프로젝트 특성에 맞게 조정**: Mobile, ML 등 없으면 삭제
6. **Banned 는 이유 필수**: 보안·라이선스·안정성 중 하나 명시

## AI 활용

Agent 가 새 의존성·라이브러리·기술 스택 제안 시 이 문서를 먼저 조회.

예: "사용자가 '새 메시지 큐 추가하자' 요청" →
1. agent 가 tech-radar.md 의 Messaging 섹션 확인
2. Approved 중 하나 제안
3. Approved 에 없으면 Experimental 중 pilot 중인 것 제안 + ADR 작성 권고
4. Deprecated/Banned 는 제안 금지

## 금지

- 장황한 기술 설명 (위키피디아화) — 링크만
- 개인 취향 기반 분류 — 팀 합의·ADR 기반만
- 내부 자격 증명·라이선스 키 원문
