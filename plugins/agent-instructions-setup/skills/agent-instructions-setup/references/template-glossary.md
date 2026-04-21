---
title: Glossary Template
impact: MEDIUM-HIGH
impactDescription: Shared terminology prevents AI-amplified miscommunication across team
tags: template, glossary, terminology, team
---

## Purpose

팀·도메인 용어·약어·시스템 이름을 한 곳에 정의. `agents/glossary.md` 로 생성된다.

핵심: 동일 개념에 동일 용어를 쓰면 agent 가 혼란 없이 문서·코드를 이해한다 (rule-findability.md 6번 규칙과 직결).

## Template

```markdown
---
title: {Project Name} Glossary
description: 도메인 용어·약어·시스템 이름 혼동 시 참고. 팀 공용 정의 제공
type: reference
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Glossary

## 원칙

- 용어는 문서 전체·코드 전체에서 한 가지 표기로 고정
- 새 용어가 2회 이상 등장하면 이 파일에 추가
- 동의어가 있으면 "권장 용어" 를 명시하고 나머지는 alias 로 표시

## Domain Terms

비즈니스 도메인 용어.

- **{Term}**: {1~2줄 정의}
- **{Term}**: {정의} (alias: {동의어})

## Acronyms

약어. Full form 과 함께 기재.

- **{ACRO}**: {Full Form} — {1줄 설명}
- **{ACRO}**: {Full Form} — {1줄 설명}

## Project Names / Systems

내부 프로젝트명·시스템 코드명.

- **{Name}**: {무엇인지}. 관련 경로/저장소: {위치}

## Technical Terms (프로젝트 특화)

일반 기술 용어 중 이 프로젝트에서 특수한 의미로 쓰이는 것만.

- **{Term}**: 일반적으로는 {일반 의미}, 이 프로젝트에서는 {프로젝트 의미}

## 금지 용어

혼동을 유발해 사용 금지된 용어.

- ~~{bad term}~~: 대신 **{good term}** 사용 (이유: {한 줄})
```

## 작성 가이드

1. **초기엔 비어도 됨**: 프로젝트 진행하며 추가. 신규 용어 2회 등장 시 추가 규칙
2. **정의는 1~2줄**: 길면 별도 문서로 분리하고 glossary 에는 링크만
3. **권장 용어 명시**: 동의어 존재 시 agent 가 어떤 표기를 쓸지 모름 → 한 용어로 통일
4. **금지 용어 섹션**: 의외로 중요. "~~user~~ → **customer**" 같이 명시하면 agent 가 자동 준수

## 업데이트 타이밍

- 신규 용어가 문서·코드에 2회 이상 등장
- 기존 용어 의미 변경
- 용어 통일 결정 (team 합의 후)

## Agent 활용

agent 가 새 코드·문서 생성 시 이 glossary 를 참조하면 용어 일관성 유지. agents/guide.md 의 라우팅 테이블에 "용어 확인 → agents/glossary.md" 포함 필수.

## 예시

```
## Domain Terms
- **Customer**: 유료 구독 중인 end-user. 비구독자는 "User" 로 구분
- **Tenant**: 고객 조직 단위. Customer 여러 명이 한 Tenant 에 속할 수 있음

## Acronyms
- **RLS**: Row Level Security — Postgres 행 단위 권한
- **MRR**: Monthly Recurring Revenue — 월간 반복 매출

## 금지 용어
- ~~client~~: "Customer" 와 "Customer-side code" 혼동 → **customer** (사람) 또는 **frontend** (코드)
```
