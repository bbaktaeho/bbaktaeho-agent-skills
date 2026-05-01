---
title: Interactive Setup Questions
impact: HIGH
impactDescription: Phase 1 에서 사용자에게 물어볼 질문 3개의 표준 스크립트
tags: questions, interactive
---

# Interactive Setup Questions

Phase 1 에서 사용자에게 3개 질문을 던진다. 순서 고정.

## Q1. KB 루트 위치

```
이 지식베이스를 어디에 만들까요?

  1) root      — 이 레포 자체가 지식베이스
  2) subdir    — 서브디렉토리 안에 (기본: knowledge/)

선택 [1]: _
```

- `1` 선택 → KB 루트 = 현재 working directory
- `2` 선택 → "디렉토리 이름은? (기본: knowledge/)" 추가 질문
- 경로 충돌 검사: 선택한 루트 경로에 이미 `.kb/` 가 있으면 "업그레이드 모드" 로 전환 (references/flow-retrofit.md)

## Q2. 프리셋

```
어떤 프리셋으로 시작할까요?

  1) team-docs — 팀 전체 (onboarding / decisions / runbooks / glossary / projects / research)
  2) research  — 리서치 전용 (topics / experiments / notes)
  3) product   — 제품 개발 (specs / designs / api / architecture)
  4) custom    — 최소 셋업만, 디렉토리는 직접 구성
  5) career    — 개인 커리어 (roles / resumes / projects / skills / brag / learning / reviews / goals)

선택 [1]: _
```

- 각 선택에 대응하는 references/preset-{name}.md 를 로드하여 Phase 2 에서 사용
- `preset.json` 에 저장: `{"preset": "{name}", "version": "1.0.0"}`
- `career` 선택 시 추가 처리: Phase 0.5 도구 매트릭스에 `gh` 추가 후 재검사 (origin 이 github.com 인 경우). Phase 2 에서 pre-push visibility 훅도 함께 설치

## Q3. AGENTS.md (AI 에이전트 진입점) 처리

```
AGENTS.md 감지 결과:
  {detected "AGENTS.md 존재" or "감지 안됨"}

어떻게 할까요?

  1) create/merge — 없으면 생성, 있으면 멱등 마커 블록 append (권장)
  2) skip         — AGENTS.md 건드리지 않음. README.md 와 .kb/README.md 만 생성

선택 [1]: _
```

기본 동작 (`create/merge`):

- **없는 경우**: references/template-agents.md 템플릿으로 새로 생성
- **있는 경우**: 파일 끝에 멱등 마커 블록만 append (기존 내용 보존)

  ```markdown
  <!-- kb-setup: knowledge-base-entry-point -->
  ## Knowledge Base
  ...
  <!-- /kb-setup -->
  ```

- 스킬을 재실행해도 중복 삽입되지 않음 (마커 사이만 교체)

`skip` 선택 시: AGENTS.md 생성하지 않음. Phase 4 verification 끝에 안내:

```
AGENTS.md 를 생성하지 않았습니다. AI 도구가 지식베이스를 인지하려면 다음 중 하나를:
  - 지금 kb-setup 을 --create-agents 로 재실행
  - 직접 AGENTS.md 에 추가:
      - [README.md](./README.md)
      - [.kb/README.md](./.kb/README.md)
  - agent-instructions-setup 스킬 실행 (AI 도구별 파일 통합)
```

## Q3 — 관련 도구 감지 시 추가 힌트

아래 파일 중 하나라도 감지되면 사용자에게 정보 제공 (질문 추가 아님, **안내만**):

- `CLAUDE.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, `.windsurf/rules/`, `GEMINI.md` 등

```
감지됨: CLAUDE.md, .cursor/rules/
이 스킬은 이들 파일을 수정하지 않습니다. AGENTS.md 를 AI 도구별 파일로
연결하고 싶으면 `agent-instructions-setup` 스킬을 이어서 실행하세요.
```

## Retrofit Mode 추가 질문

기존 `.md` 문서가 이미 있는 경우 (references/flow-retrofit.md) Q2 다음에 추가 질문:

```
기존 {N}개의 .md 파일이 감지되었습니다. frontmatter 없는 파일도 있습니다.

  1) auto-add       — 누락된 frontmatter 를 현재 시각 / 기본값으로 자동 추가
  2) skip           — 기존 파일은 건드리지 않음 (추후 kb-validator 로 일괄 처리)
  3) one-by-one     — 파일별로 확인

선택 [1]: _
```

## 질문 형식 규칙

- 숫자 선택지. 기본값은 `[1]` 또는 가장 안전한 옵션
- 각 옵션에 한 줄 설명
- 위험한 옵션은 기본값으로 두지 않음
- 사용자가 그냥 Enter 치면 기본값 사용

## 질문 생략 조건

- 이미 `.kb/preset.json` 존재: Q1, Q2 생략하고 해당 프리셋으로 업그레이드 모드 진입
- `AGENTS.md` 에 이미 멱등 마커 블록 (`<!-- kb-setup: knowledge-base-entry-point -->`) 존재: Q3 생략 (이미 `create/merge` 완료 상태로 간주, 최신 템플릿으로 블록 갱신만 수행)

## 질문 후 확인 단계

3개 질문 모두 답변 받은 후, Phase 2 시작 전에 요약을 보여준다:

```
다음 구조로 생성합니다:

  KB 루트:   {root-path}
  프리셋:    {preset-name}
  AGENTS.md: {create/merge | skip}

진행할까요? [y/N]: _
```

`N` 이면 처음으로 돌아가서 질문 재실행.
