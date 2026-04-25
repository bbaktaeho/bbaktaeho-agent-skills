---
name: knowledge-base-setup
description: >
  Markdown knowledge base init and retrofit. Creates .kb/ meta dir
  (AI entry point, schema, conventions, tag-index) plus preset top-
  level dirs (team-docs, research, product, custom). Every .md file
  carries required frontmatter (title, created, updated, summary,
  tags, status, relations - flat list of relative paths). Adds
  .gitignore for .kb/.tag-index and .kb/local/, background-indexes
  tags, and installs a git pre-commit hook that blocks secrets
  (credentials, tokens, private keys, basic-auth URLs, internal
  endpoints). Lets AI tools (Claude Code, Codex, Cursor) read one
  entry point and immediately know where knowledge lives, how docs
  relate, and where to place new knowledge. Use when initializing a
  repo as a shared KB, adding a KB to an existing project, preparing
  docs for submodule use, standardizing team research or runbooks,
  or making markdown docs AI-navigable - even if the user only says
  "docs init", "research base", "set up wiki", or "block secrets".
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: >
    Init and retrofit skill for markdown knowledge bases. Phase 0 scans
    state, Phase 1 asks Q1~Q3 (root location, preset, AGENTS.md
    integration), Phase 2 creates .kb/ meta directory with README.md
    (AI entry point), schema.md, conventions.md, preset.json, plus
    preset top-level directories each carrying a README.md template.
    Phase 3 background-indexes tags to .kb/.tag-index. Phase 4
    verifies. Complementary kb-validator skill syncs timestamps from
    git log, prunes broken relations, rebuilds tag-index, and enforces
    length and README-per-directory rules. Philosophy: AI-first
    findability. .kb/README.md is the single AI entry point; knowledge
    lives at root; submodule-friendly.
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
| 0. State Scan | 기존 `.kb/`, README, AGENTS.md 감지 → Fresh / Upgrade / Retrofit 모드 분기 | references/flow-execution.md |
| 1. Interactive Q1~Q3 | KB 루트, 프리셋, AGENTS.md 통합 여부 | references/ask-questions.md |
| 2. Structure Setup | `.kb/` 메타, 프리셋 디렉토리, `.gitignore`, `.kb/local/`, pre-commit secrets hook 생성 | references/flow-execution.md, references/template-*.md |
| 3. Background Tag Index | `.tag-index` 생성 (background agent) | references/flow-execution.md |
| 4. Verification | frontmatter, README, AGENTS.md 링크, .gitignore, pre-commit hook self-test | references/flow-execution.md |
| Retrofit Mode | 기존 `.md` 에 frontmatter 보강 | references/flow-retrofit.md |

## Reference Categories

| Priority | Category | Prefix | 대표 파일 |
|----------|----------|--------|-----------|
| CRITICAL | Frontmatter / Relations / Lifecycle | `rule-` | frontmatter-schema, relations, lifecycle |
| CRITICAL | Secrets Handling | `rule-` | secrets-handling |
| CRITICAL | Length Guidelines | `rule-` | length-guideline |
| CRITICAL | Execution Flow | `flow-` | execution, retrofit |
| HIGH | Meta Templates | `template-` | kb-readme, schema, conventions |
| HIGH | Knowledge Templates | `template-` | root-readme, dir-readme |
| HIGH | AI Entry Template | `template-` | agents |
| HIGH | Hook Template | `template-` | pre-commit-hook |
| HIGH | Presets | `preset-` | team-docs, research, product, custom |
| HIGH | Layout Overview | `layout-` | overview |
| HIGH | Interactive Questions | `ask-` | questions |

전체 목록: references/_sections.md

## Companion Skill

`kb-validator` — 같은 플러그인 내 별도 스킬. 초기 셋업 후 지식이 쌓이면 주기적으로 실행하여 frontmatter, 관계, 타임스탬프, 태그 인덱스, 길이를 검증/자동수정한다.

## References

- https://agents.md
- https://diataxis.fr (디렉토리 분류 철학)
