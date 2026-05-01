---
name: knowledge-base-setup
description: >
  Markdown knowledge base init and retrofit. Creates .kb/ meta dir
  (AI entry point, schema, conventions, tag-index) plus preset top-
  level dirs (team-docs, research, product, custom, career). Every
  .md file carries required frontmatter (title, created, updated,
  summary, tags, status, relations). Phase 0.5 checks tool deps
  (yq or python+PyYAML; optional ripgrep/gitleaks/lychee; gh for
  career) and offers OS-aware install on opt-in. Installs a pre-
  commit secret-scan hook, and for the career preset also a pre-
  push hook that blocks pushing to a public repository. Lets AI
  tools (Claude Code, Codex, Cursor) read one entry point and know
  where knowledge lives. Use when initializing a repo as a shared
  KB, adding a KB to an existing project, preparing docs as a
  submodule, standardizing team runbooks, building a personal
  career KB, or making markdown docs AI-navigable - even if the
  user says "docs init", "career portfolio", or "wiki".
license: MIT
metadata:
  author: bbaktaeho
  version: "1.1.0"
  date: May 2026
  abstract: >
    Init and retrofit skill for markdown knowledge bases. Phase 0
    scans state, Phase 0.5 verifies tool dependencies (required:
    bash/git/grep/sed/awk; recommended: yq or python3+PyYAML, plus
    gh for the career preset; optional: ripgrep/gitleaks/trufflehog/
    lychee) with OS-aware install commands and explicit user opt-in
    (default skip, sudo only on yes). Phase 1 asks Q1~Q3 (root,
    preset, AGENTS.md), Phase 2 creates .kb/ meta plus preset dirs
    and hooks (pre-commit secret scan, plus pre-push visibility hook
    for career). Phase 3 indexes tags. Phase 4 verifies. Five
    presets: team-docs, research, product, custom, career - the
    career preset (roles / resumes / projects / skills / brag /
    learning / reviews / goals) blocks public pushes by hook and at
    setup. Philosophy: AI-first findability.
---

# Knowledge Base Setup

마크다운 기반 지식베이스 (KB) 를 초기 셋업하거나 기존 프로젝트에 retrofit 한다. `.kb/README.md` 를 AI 단일 진입점으로 두고, 지식들은 루트 경로에 배치한다.

## Core Philosophy

"지식의 위치와 관계를 AI 가 한 파일 (`.kb/README.md`) 만 읽고 파악할 수 있도록 구조화한다."

상세: references/rule-frontmatter-schema.md, references/rule-relations.md, references/rule-lifecycle.md, references/rule-secrets-handling.md

## Directory Layout

`{kb-root}` 는 레포 자체 또는 서브디렉토리 (`knowledge/` 기본). `.kb/` 메타 디렉토리에 AI 진입점과 규칙을 격리하고, 지식은 루트 경로에 배치한다. 전체 트리와 핵심 원칙: references/layout-overview.md

## Execution Flow

| Phase | 내용 | Reference |
|-------|------|-----------|
| 0. State Scan | 기존 `.kb/`, README, AGENTS.md 감지 → Fresh / Upgrade / Retrofit 모드 | references/flow-execution.md |
| 0.5. Tool Check | 도구 매트릭스 검사 + OS 별 install 옵션 (사용자 confirm) | references/flow-tool-check.md, references/rule-tool-dependencies.md |
| 1. Interactive Q1~Q3 | KB 루트, 프리셋(team-docs/research/product/custom/career), AGENTS.md | references/ask-questions.md |
| 2. Structure Setup | `.kb/` 메타, 프리셋 디렉토리, `.gitignore`, hooks (pre-commit + career 면 pre-push) | references/flow-execution.md, references/template-*.md |
| 3. Background Tag Index | `.tag-index` 생성 (background agent) | references/flow-execution.md |
| 4. Verification | frontmatter, README, AGENTS.md, .gitignore, 훅 self-test, career 면 visibility 1회 검사 | references/flow-execution.md |
| Retrofit Mode | 기존 `.md` 에 frontmatter 보강 | references/flow-retrofit.md |

## Reference Categories

| Priority | Category | Prefix | 대표 파일 |
|----------|----------|--------|-----------|
| CRITICAL | Frontmatter / Relations / Lifecycle | `rule-` | frontmatter-schema, relations, lifecycle |
| CRITICAL | Secrets / Tool Deps | `rule-` | secrets-handling, tool-dependencies |
| CRITICAL | Length Guidelines | `rule-` | length-guideline |
| CRITICAL | Execution Flow | `flow-` | execution, tool-check, retrofit |
| HIGH | Meta / Knowledge / AI Templates | `template-` | kb-readme, schema, conventions, root-readme, dir-readme, agents |
| HIGH | Hook Templates | `template-` | pre-commit-hook, pre-push-visibility-hook |
| HIGH | Presets | `preset-` | team-docs, research, product, custom, career |
| HIGH | Layout / Questions | `layout-`, `ask-` | overview, questions |

전체 목록: references/_sections.md

## Companion Skill

`kb-validator` — 같은 플러그인 내 별도 스킬. 초기 셋업 후 지식이 쌓이면 주기적으로 실행하여 frontmatter, 관계, 타임스탬프, 태그 인덱스, 길이를 검증/자동수정한다.

## References

- https://agents.md
- https://diataxis.fr (디렉토리 분류 철학)
