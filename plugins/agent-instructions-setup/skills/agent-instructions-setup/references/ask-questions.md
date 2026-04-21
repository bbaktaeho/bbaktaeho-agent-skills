---
title: Interactive Setup Question Script
impact: HIGH
impactDescription: Standardized question flow for Phase 2 reduces ambiguity and improves ergonomics
tags: interactive, questions, setup, phase2, pingpong
---

## Purpose

Phase 2 에서 사용자에게 묻는 질문 시퀀스를 표준화한다. 각 질문은 default 를 제시하고, 사용자가 답하지 않으면 default 를 적용한다. 질문은 한 번에 한 개씩 묻는다.

## Question Sequence

### Q1. 프로젝트 이름

- default: 현재 디렉토리 이름 (`basename $PWD`)
- 용도: AGENTS.md 제목, guide.md frontmatter title

### Q2. 1줄 설명

- default: 없음 (필수)
- 용도: AGENTS.md 첫 문단, guide.md frontmatter description 보조

### Q3. 프로젝트 유형

- 선택지: `dev` / `docs` / `hybrid` / `other`
- default: `dev`
- 용도: guide·workflow 템플릿 선택
- `hybrid` → dev + docs 둘 다 생성 (guide 는 양쪽 라우팅 테이블 병합)
- `other` → 사용자에게 커스텀 템플릿 요구사항을 추가로 질문

### Q4. 기본 언어

- 선택지: `ko` / `en` / 기타
- default: `ko`
- 용도: 템플릿 한글·영문 분기. 기타 입력 시 해당 언어로 생성 시도

### Q5. 워크플로우 무게

- 선택지: `lite` (5-step) / `full` (14-step)
- default: `lite` (POC·솔로), `full` (팀·프로덕션) — 사용자 상황을 간단히 물어 제안
- 용도: workflow.md 템플릿 선택

### Q6. 사용할 AI 도구

- 체크리스트: Codex / Claude Code / Cursor / Copilot / Windsurf / Cline / Roo Code / Gemini CLI / Antigravity / Zed / Amp / Aider / Continue / 기타
- default: Phase 0 에서 감지된 설정 파일 기반으로 사전 체크 + Claude Code + Codex
- 용도: 심링크 생성 대상, .gitignore 추가 대상 (체크 해제된 도구)

### Q7. PR 타겟 브랜치

- default: `main`
- 용도: workflow.md 의 PR 섹션

### Q8. 감지된 스택 확인 (자동 감지)

질문이 아니라 확인 단계.

- `package.json` → Node.js + {framework 추정}
- `pyproject.toml` → Python + {framework 추정}
- `Cargo.toml` → Rust
- `go.mod` → Go
- `Gemfile` → Ruby
- `pom.xml` / `build.gradle` → Java / Kotlin

감지 결과를 보여주고 수정 여부 확인. 사용자가 수정하면 반영, 확인하면 그대로.

- 용도: guide.md 기술 스택 섹션, agents/stack.md 초안

### Q9. 프로젝트 스타일 규칙

- 예시 항목:
  - 응답 언어 (ko / en / 프로젝트 언어 따름)
  - 이모지 허용 여부
  - 주석 언어
  - 네이밍 컨벤션 (있으면)
  - 커밋 컨벤션 (Conventional Commits / 프로젝트 규칙 / 자유)
- default: 없음 (비워두면 AGENTS.md 의 Project Style 섹션 자체를 생략)
- 용도: AGENTS.md 의 Project Style 섹션

## 진행 흐름

1. 질문은 한 번에 한 개씩 묻는다 (병렬 질문 금지)
2. 각 질문에 default 와 선택지를 명시한다
3. 사용자 답변 이후 다음 질문으로 진행
4. 모든 답변 수집 후 **요약 테이블**을 보여주고 최종 확인 받는다
5. 확인 후 Phase 1·2 실행

## 요약 테이블 형식

```
다음 설정으로 생성합니다. 수정이 필요하면 항목 번호를 말씀해 주세요.

1. 프로젝트 이름: {A1}
2. 1줄 설명: {A2}
3. 유형: {A3}
4. 언어: {A4}
5. 워크플로우: {A5}
6. AI 도구: {A6}
7. PR 타겟: {A7}
8. 스택: {A8}
9. 스타일 규칙: {A9 or "없음"}
```

## Phase 0 에서 기존 셋업 감지 시

이미 AGENTS.md + agents/ 가 존재하면 Q1~Q5, Q7~Q9 를 스킵하고 다음만 묻는다.

- Q6 (도구 추가·제거) — 심링크만 갱신
- 또는 "새 문서 추가" 모드 → references/evolve-principles.md 규칙으로 진행
- 또는 "템플릿 업그레이드" 모드 → 기존 guide/workflow 를 최신 템플릿과 diff 하여 제안

## 스킵 원칙

- 사용자가 "기본값으로 다 해줘" 라고 하면 Q1 (필수) 과 Q2 (필수) 만 받고 나머지 default 로 진행
- 사용자가 answer 없이 Enter 만 치면 default 적용
