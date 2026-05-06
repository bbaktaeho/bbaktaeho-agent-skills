---
title: Interactive Setup Question Script
impact: HIGH
impactDescription: Phase 2 의 질문 시퀀스를 표준화. 답변이 없으면 default 적용
tags: interactive, questions, setup, phase2
---

## Purpose

Phase 2 에서 사용자에게 묻는 질문 시퀀스. 한 번에 한 개씩 묻고, default 가 있는 항목은 답변이 없으면 default 적용.

질문은 6개로 단순화. 팀 모드 / 허브 모드 / 워크플로우 분기 질문은 모두 제거 (단일 모드).

## Q1. 프로젝트 이름

- default: 현재 디렉토리 이름 (`basename $PWD`)
- 용도: AGENTS.md 제목, `.agents/README.md` frontmatter title

## Q2. 1줄 설명

- default: 없음 (필수)
- 용도: AGENTS.md 첫 문단, `.agents/README.md` 첫 문단

## Q3. 기본 언어

- 선택지: `ko` / `en` / 기타
- default: `ko`
- 용도: 템플릿 한글·영문 분기. 기타 입력 시 해당 언어로 생성 시도

## Q4. 사용할 AI 도구

- 체크리스트: Codex / Claude Code / Cursor / Copilot / Windsurf / Cline / Roo Code / Gemini CLI / Antigravity / Zed / Amp / Aider / Continue / 기타
- default: Phase 0 에서 감지된 설정 파일 기반으로 사전 체크 + Claude Code + Codex
- 용도: 심링크 생성 대상, `.gitignore` 추가 대상 (체크 해제된 도구)

## Q5. 라우팅할 상위 디렉토리 목록

- default: 레포 루트의 디렉토리 자동 스캔 결과 (단 `.git`, `.agents`, `node_modules`, `vendor`, `dist`, `build`, `.cache`, `.venv` 등 표준 ignore 제외)
- 사용자가 default 목록을 그대로 받거나 추가/제거 가능
- 각 디렉토리에 `README.md` 부재 시 스캐폴드 여부 묻기 (y/N)
- 용도: `.agents/README.md` 의 `Top-Level Directories` 표 채우기

## Q6. 프로젝트 스타일 규칙 (optional)

- 예시 항목:
  - 응답 언어 (ko / en / 프로젝트 언어 따름)
  - 이모지 허용 여부
  - 주석 언어
  - 네이밍 컨벤션
  - 커밋 컨벤션 (Conventional Commits / 자유)
- default: 없음. 비워두면 AGENTS.md 의 Project Style 섹션 자체를 생략
- 용도: AGENTS.md 의 Project Style 섹션

## 진행 흐름

1. 질문은 한 번에 한 개씩 묻는다 (병렬 질문 금지)
2. 각 질문에 default 와 선택지를 명시
3. 사용자 답변 후 다음 질문으로 진행
4. 모든 답변 수집 후 **요약 테이블**을 보여주고 최종 확인

## 요약 테이블 형식

```
다음 설정으로 생성합니다. 수정이 필요하면 항목 번호를 말씀해 주세요.

1. 프로젝트 이름: {A1}
2. 1줄 설명: {A2}
3. 언어: {A3}
4. AI 도구: {A4}
5. 라우팅 상위 디렉토리: {A5}
   - docs/      (README.md 부재 → 스캐폴드 예정)
   - src/       (README.md 존재 → frontmatter 보강만)
   - scripts/   (README.md 부재 → 스캐폴드 예정)
6. 스타일 규칙: {A6 or "없음"}

생성/수정될 파일:
- AGENTS.md
- .agents/README.md, schema.md, conventions.md, preset.json
- .agents/hooks/pre-commit-secrets.sh + .git/hooks/pre-commit symlink
- .agents/local/, .agents/local.example/
- 도구별 심링크: {Q4 선택 도구}
- 상위 디렉토리 README.md 스캐폴드: {Q5 opt-in 항목}
- .gitignore 라인 추가
```

## Phase 0 에서 기존 셋업 감지 시

이미 AGENTS.md + `.agents/` 가 존재하면 Q1, Q2, Q3, Q6 를 스킵하고 다음만 묻는다.

- Q4 (도구 추가/제거) — 심링크만 갱신
- Q5 (상위 디렉토리 추가/제거) — `.agents/README.md` 라우팅 표만 갱신
- 또는 "새 디렉토리 README 추가" 모드 → references/evolve-principles.md 규칙
- 또는 "템플릿 업그레이드" 모드 → 기존 `.agents/README.md` / `<dir>/README.md` 를 최신 템플릿과 diff 하여 제안

## 스킵 원칙

- 사용자가 "기본값으로 다 해줘" → Q1 (필수) 과 Q2 (필수) 만 받고 나머지 default
- 사용자가 answer 없이 Enter → default 적용
- Q5 의 디렉토리별 스캐폴드 opt-in 은 멀티 셀렉트 — 일괄 yes 도 가능

## 자동 감지 보조

Q5 의 default 를 만들 때 다음 패턴을 추가로 인식한다.

| 패턴 | 인식 |
|------|------|
| `apps/` | monorepo app 디렉토리. 각 sub-app 별 README 권장 |
| `packages/` | monorepo package 디렉토리. 각 sub-package 별 README 권장 |
| `services/` | 마이크로서비스. 각 service README 권장 |
| `tests/`, `test/`, `__tests__/` | 테스트 |
| `docs/`, `documentation/`, `doc/` | 문서 |
| `scripts/`, `bin/`, `tools/` | 스크립트 |

monorepo 패턴 (`apps/`, `packages/`, `services/`) 인 경우 Q5 답변에 두 단계 (`apps/README.md` + `apps/<each>/README.md`) 모두 포함할지 추가 질문.
