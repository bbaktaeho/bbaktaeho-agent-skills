---
title: AGENTS.md Template
impact: CRITICAL
impactDescription: AGENTS.md is a routing root, not a behavior rulebook
tags: agents-md, template, routing, findability, root
---

## Purpose

AGENTS.md 는 행동 규칙 모음이 아니라 **프로젝트 문서 라우팅 루트** 다. 자세한 설계 원칙: references/rule-findability.md

AGENTS.md 자체는 가능한 한 짧게 유지한다 (50줄 이내 목표). 상세 내용은 `agents/` 하위로 분리한다.

## Template

```markdown
# {Project Name}

{프로젝트 1줄 설명}

## Entry Point

작업을 시작하기 전에 agents/guide.md 를 읽는다. agents/guide.md 는 작업 유형별로 읽어야 할 문서를 라우팅한다.

## Directory Map

- AGENTS.md — 이 파일. 라우팅 루트
- agents/guide.md — 문서 진입점·라우팅 테이블
- agents/workflow.md — 작업 워크플로우
- agents/*.md — 주제별 상세 문서 (각 파일의 frontmatter `description` 참고)

## Document Conventions

- 모든 agents/ 파일은 6~8줄 이내 frontmatter 로 시작한다
- frontmatter 의 `description` 은 "언제 읽어야 하는지 + 얻는 것" 형식으로 작성한다
- 섹션 첫 줄은 1문장 요약이다
- 파일 분해 기준과 문서 추가·수정·삭제 원칙: agents/guide.md 의 "문서 진화" 섹션

## Project Style

{Q9 답변으로 채운다. 답변이 없으면 이 섹션 자체를 생략한다.}

예시:
- 응답 언어: 한국어
- 이모지 사용 금지
- 커밋 컨벤션: Conventional Commits
```

## 작성 가이드

1. `{Project Name}` 과 `{프로젝트 1줄 설명}` 은 Q1, Q2 답변으로 치환한다
2. `Project Style` 섹션은 Q9 답변이 있을 때만 포함한다. 없으면 섹션 제목까지 제거
3. **행동 지시문을 넣지 않는다**. 금지 예시:
   - "AI 는 매 대화마다 guide.md 를 읽어라"
   - "답하기 전에 한번 더 검토해라"
   - "기억에 의존하지 말고 파일을 먼저 읽어라"
   - 이유: references/rule-findability.md 의 Anti-Patterns 참조
4. 행동 지시문 대신 **구조로 유도**한다. Entry Point 섹션의 "agents/guide.md 를 읽는다" 는 행동 지시가 아니라 **라우팅 지도**이므로 허용
5. AGENTS.md 가 50줄을 넘기면 어떤 섹션이 상세화됐는지 확인하고 `agents/` 하위로 분리한다

## 병합 모드 (기존 instruction 파일이 있을 때)

references/link-symlink-strategy.md 의 "병합 절차" 에 따라 기존 파일 내용을 AGENTS.md 로 흡수한다. 이때 다음 원칙을 적용한다.

- Anti-Pattern (행동 지시문) 에 해당하는 내용은 **제외**하거나 `Project Style` 섹션으로 재분류한다
- 프로젝트 구조·모듈 설명은 AGENTS.md 가 아니라 `agents/stack.md` 또는 `agents/structure.md` 로 옮긴다
- 워크플로우·PR 규칙은 `agents/workflow.md` 로 옮긴다
- AGENTS.md 는 끝까지 라우팅 루트로만 남긴다
