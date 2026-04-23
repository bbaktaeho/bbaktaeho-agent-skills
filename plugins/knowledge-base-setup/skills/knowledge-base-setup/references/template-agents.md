---
title: AGENTS.md Template
impact: HIGH
impactDescription: AI 에이전트의 첫 진입점. README.md (사람/소개) + .kb/README.md (AI 탐색 맵) 로 라우팅
tags: template, agents-md, entry-point
---

# `AGENTS.md` Template

`AGENTS.md` 는 레포 루트에 위치하는 **AI 에이전트 공용 첫 진입점**. Claude Code / Codex / Cursor / Windsurf / Gemini CLI 등 다수 도구가 이 파일을 자동 인지한다 (https://agents.md).

이 스킬이 만드는 지식베이스에서 AGENTS.md 의 역할은 **단 하나**: AI 가 두 개의 실제 진입점으로 가도록 라우팅.

1. `README.md` — 이 지식베이스가 **무엇이고** 왜 있는지 (맥락)
2. `.kb/README.md` — **어떻게 탐색하고 기여하는지** (규칙)

본문에 작업 규칙을 직접 담지 않는다. 규칙이 늘어나면 `.kb/` 로 분산되므로, AGENTS.md 는 항상 얇게 유지된다.

## 생성 템플릿

아래 내용을 그대로 `AGENTS.md` 로 생성한다. `{...}` 는 프리셋/이름으로 치환.

```markdown
# AGENTS.md

This repository is a knowledge base. AI coding agents (Claude Code,
Codex, Cursor, etc.) should start here.

## Entry Points (읽기 순서)

1. **[README.md](./README.md)** — 이 지식베이스가 무엇인지, 주제와 범위
2. **[.kb/README.md](./.kb/README.md)** — AI 탐색 진입점: 디렉토리 맵, frontmatter 스키마, 관계 규칙, 민감 정보 정책

질문 답변에 필요한 지식은 위 두 파일을 먼저 읽은 뒤 탐색한다.

## Quick Context

- **Preset**: `{preset-name}` — {preset-tagline}
- **KB root**: {kb-root-path} (이 레포 자체 or 서브디렉토리)
- **Tag index**: `.kb/.tag-index` (gitignored). 없으면 grep fallback.

## Core Rules (상세는 `.kb/conventions.md`)

1. 모든 `.md` 파일에 frontmatter 필수 (스키마: [`.kb/schema.md`](./.kb/schema.md))
2. 모든 디렉토리에 `README.md` 필수
3. 새 지식의 관계 판단이 **애매하면 사용자에게 확인**
4. `deprecated` / `archived` 상태 문서는 답변 컨텍스트에서 제외
5. **민감 정보 금지** — credentials, tokens, 내부 엔드포인트는 평문 저장 금지. `.kb/local/` (gitignored) 또는 `{VAR}` 플레이스홀더 사용. `.kb/hooks/pre-commit-secrets.sh` 가 커밋을 차단

## When Creating New Knowledge

1. `.kb/README.md` 의 Directory Map 으로 위치 결정. 애매하면 사용자에게 질문
2. frontmatter 기입 (필수 필드 참조: `.kb/schema.md`)
3. 관련 문서가 있으면 `relations` 에 상대 경로 추가. 확신 없으면 사용자 확인
4. 태그 5~8 개 부여. `.kb/.tag-index` 증분 갱신
5. 디렉토리에 `README.md` 없으면 동시에 생성

## When Deleting / Moving Knowledge

- 삭제: 해당 파일을 `relations` 로 가진 문서들을 찾아 관계 정리 후 삭제
- 이동: 참조하는 문서들의 `relations` 를 새 경로로 일괄 수정 후 이동
- 이후 `.kb/.tag-index` 갱신 (또는 `kb-validator` 실행)

## Validation

`kb-validator` 스킬을 주기적으로 실행하여 frontmatter / 관계 / 타임스탬프 / 길이 / 민감 정보를 검증.
```

## `{preset-tagline}` 매핑

| Preset | Tagline |
|--------|---------|
| `team-docs` | 팀 전체 (onboarding / decisions / runbooks / glossary / projects / research) |
| `research` | 리서치 전용 (topics / experiments / notes) |
| `product` | 제품 개발 (specs / designs / api / architecture) |
| `custom` | 사용자가 직접 구성 |

## Retrofit — 기존 `AGENTS.md` 가 있는 경우

기존 파일이 있으면 **덮어쓰지 않는다**. 대신:

1. 기존 AGENTS.md 에 `## Knowledge Base` 같은 섹션이 이미 있는지 확인
2. 없으면 파일 끝에 아래 블록을 append (멱등 마커 포함):

```markdown
<!-- kb-setup: knowledge-base-entry-point -->
## Knowledge Base

This repository includes a markdown knowledge base managed by the
`knowledge-base-setup` skill.

- [README.md](./README.md) — 이 지식베이스가 무엇인지, 주제와 범위
- [.kb/README.md](./.kb/README.md) — AI 탐색 진입점: 디렉토리 맵, 규칙, 민감 정보 정책

자세한 작성 규칙은 `.kb/conventions.md` 를 참조.
<!-- /kb-setup -->
```

3. 멱등 마커 (`<!-- kb-setup: knowledge-base-entry-point -->` / `<!-- /kb-setup -->`) 덕에 스킬을 재실행해도 중복 삽입되지 않는다. 섹션 업그레이드 시 이 마커 사이만 교체.

## Retrofit — CLAUDE.md / .cursor/rules 등이 이미 있는 경우

이 스킬은 AI 도구별 개별 파일은 건드리지 않는다. 대신 AGENTS.md 를 통해 연결되므로:

- Claude Code 는 `CLAUDE.md` → `AGENTS.md` 로 symlink 가 설정되어 있으면 (다른 스킬이 처리) 자동 인지
- 그 외 도구도 `AGENTS.md` 를 직접 읽거나 자체 파일에서 참조 가능

사용자에게 안내: "`agent-instructions-setup` 스킬을 함께 실행하면 AI 도구별 파일이 AGENTS.md 로 일관되게 연결됩니다."

## 스킬이 AGENTS.md 를 "만들어야 하는" 이유

- **발견 가능성**: AI 도구들이 AGENTS.md 를 자동 인지. `.kb/README.md` 를 직접 찾으라고 시키는 것보다 신뢰성 높음
- **분리된 관심사**: AGENTS.md = AI 라우팅, README.md = 사람/프로젝트 소개, `.kb/README.md` = KB 내부 탐색 규칙
- **얇게 유지**: AGENTS.md 는 라우팅만. 규칙은 `.kb/` 에 있어 진화 추적 용이
