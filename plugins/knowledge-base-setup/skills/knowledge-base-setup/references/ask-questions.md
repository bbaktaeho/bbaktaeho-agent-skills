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

선택 [1]: _
```

- 각 선택에 대응하는 references/preset-{name}.md 를 로드하여 Phase 2 에서 사용
- `preset.json` 에 저장: `{"preset": "{name}", "version": "1.0.0"}`

## Q3. AI 도구 진입점 통합

```
AI 도구 진입점 (AGENTS.md 등) 감지 결과:
  {detected-files or "감지 안됨"}

어떻게 할까요?

  1) skip         — 지금은 지식베이스만 셋업 (AGENTS.md 는 나중에 수동 연결)
  2) note-path    — .kb/README.md 경로를 기억해두고 세션 마지막에 안내

선택 [1]: _
```

- 이 스킬은 AGENTS.md 를 **수정하지 않는다**. 그 역할은 `agent-instructions-setup` 스킬의 몫.
- `note-path` 선택 시: Phase 4 verification 끝에 `"AGENTS.md 또는 CLAUDE.md 에 다음 줄을 추가하세요: 지식베이스는 .kb/README.md 를 참조하세요."` 메시지 출력.

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
- `AGENTS.md` 에 이미 `.kb/README.md` 참조 라인 존재: Q3 생략 (`skip` 과 동일 처리)

## 질문 후 확인 단계

3개 질문 모두 답변 받은 후, Phase 2 시작 전에 요약을 보여준다:

```
다음 구조로 생성합니다:

  KB 루트: {root-path}
  프리셋:  {preset-name}
  통합:    {skip | note-path}

진행할까요? [y/N]: _
```

`N` 이면 처음으로 돌아가서 질문 재실행.
