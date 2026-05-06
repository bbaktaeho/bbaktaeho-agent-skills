---
name: agent-instructions-setup
description: >
  AI coding agent instruction file init and retrofit. Builds a single
  routing chain so every AI tool (Claude Code, Cursor, Copilot,
  Windsurf, Cline, Roo Code, Gemini CLI, Codex, Zed, Antigravity, Amp,
  Aider, Continue) reads the same source. The chain is tool-symlink
  to AGENTS.md to .agents/README.md (overview plus top-level
  directory routing table) to each top-level directory README.md to
  detail files. Sets up AGENTS.md, idempotent symlinks across tools,
  and a .agents/ meta directory (README, schema, conventions,
  preset.json, hooks/pre-commit-secrets.sh, local). No agents/
  content directory is created. Use whenever the user wants to
  initialize a project, bootstrap AGENTS.md, unify instruction files
  across AI tools, retrofit an existing project, or make a repo
  AI-navigable - even if they just say "AI rules" or "agent config".
license: MIT
metadata:
  author: bbaktaeho
  version: "4.0.0"
  date: May 2026
  abstract: >
    Init and retrofit skill that wires a 4-hop routing chain. Phase 0
    scans state. Phase 1 creates AGENTS.md (slim) and the .agents/
    meta directory plus idempotent tool symlinks. Phase 2 detects
    top-level project directories, populates the .agents/README.md
    routing index, and scaffolds a README.md inside each top-level
    directory the user opts in. Phase 3 verifies the chain. No
    agents/ content directory, no project-team or hub modes, no team
    template families. Philosophy: AI-first findability through
    structure (frontmatter + README chain), not behavior rules.
---

# Agent Instructions Setup

AGENTS.md 를 single source of truth 로 두고 모든 AI 도구가 같은 라우팅 체인을 읽게 만든다.

## Routing Chain

```
도구 심링크 (CLAUDE.md, .cursorrules, GEMINI.md, ...)
  -> AGENTS.md                       # 50줄 이내, 진입점만
       -> .agents/README.md          # 개요 + 상위 디렉토리 요약 + 라우팅 표
            -> <top-level-dir>/README.md   # 도메인 요약 + 하위 라우팅
                 -> 상세 파일 / 하위 README
```

행동 지시문이 아니라 **README 체인** 으로 AI 가 자연스럽게 올바른 문서에 도달하게 한다. 상세: references/rule-findability.md

## Directory Layout

```
{repo}/
├── AGENTS.md                          # 라우팅 루트 (50줄 이내)
├── .agents/                           # 메타 + 라우팅 인덱스
│   ├── README.md                      # 라우팅 인덱스 (개요 + 상위 dir 요약)
│   ├── schema.md                      # README.md frontmatter 스키마
│   ├── conventions.md                 # 네이밍 / lifecycle / findability
│   ├── preset.json                    # kind=agents, version
│   ├── .tag-index                     # gitignored
│   ├── hooks/pre-commit-secrets.sh    # 민감 정보 차단
│   ├── local/                         # gitignored
│   └── local.example/
├── <top-level-dir>/README.md          # 각 상위 dir 의 라우팅 README
└── (도구 심링크: CLAUDE.md, .cursorrules, ...)
```

`.agents/` 만 메타 전용. 상위 디렉토리는 사용자 기존 구조(`docs/`, `src/`, `apps/`, ...) 를 그대로 사용. 상세: references/layout-overview.md

## Execution Flow

### Phase 0: State Scan

1. `AGENTS.md` / 도구별 instruction 파일 / `.agents/` 존재 여부
2. 매니페스트 (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`) 로 스택 추정
3. 분기: Fresh / Legacy 병합 / 기존 셋업 업그레이드 (references/link-symlink-strategy.md)

### Phase 1: Structure Setup

1. AGENTS.md 생성 또는 병합 (references/template-agents.md)
2. `.agents/` 메타 디렉토리: README/schema/conventions/preset.json + local/ + local.example/ + hooks/pre-commit-secrets.sh + `.git/hooks/pre-commit` symlink (references/template-meta-*.md, references/template-pre-commit-hook.md)
3. `ln -sfn` 으로 도구별 심링크 멱등 생성 (references/link-symlink-strategy.md, references/map-file-paths.md)
4. `.gitignore` 에 `.agents/.tag-index`, `.agents/local/`, 미사용 도구 파일 라인 추가

### Phase 2: Routing Population

5. references/ask-questions.md 의 Q1~Q6 질문 (프로젝트명 / 1줄 설명 / 언어 / 도구 / 상위 dir / 스타일)
6. Q5 로 결정된 상위 디렉토리 목록을 `.agents/README.md` 의 라우팅 표에 채운다
7. 각 상위 dir 에 `README.md` 가 없으면 references/template-dir-readme.md 로 스캐폴드 (사용자 opt-in)
8. 기존 `<dir>/README.md` 에 frontmatter 가 없으면 보완 (사용자 확인)

### Phase 3: Verification

9. 심링크 확인: `ls -la`, `diff AGENTS.md CLAUDE.md`
10. AGENTS.md 가 `.agents/README.md` 를 가리키는지 확인
11. `.agents/README.md` 라우팅 표의 모든 경로가 실제 존재하는지 확인
12. `.agents/preset.json` (`kind: "agents"`), `.git/hooks/pre-commit` symlink, `.gitignore` 라인 검증
13. 응답 마지막에 읽은·생성한 파일 나열 + 다음 단계 안내: `meta-validator` 실행

## Companion Skill

`meta-validator` — 같은 플러그인 내 별도 스킬. 셋업 후 `AGENTS.md`, `.agents/*.md`, 그리고 라우팅 표가 가리키는 `<dir>/README.md` 의 frontmatter / relations / git timestamps / tag-index / 시크릿 / 길이 (AGENTS.md 50/80/120, README.md 80/120/200) 를 검증·자동수정한다.

## Reference Categories

| Priority | Category | Prefix | 대표 파일 |
|----------|----------|--------|-----------|
| CRITICAL | Findability / File Mapping / Frontmatter | `rule-`, `map-`, `meta-` | findability, file-paths, frontmatter |
| HIGH | Symlink / Evolve / Questions | `link-`, `evolve-`, `ask-` | symlink-strategy, evolve-principles, ask-questions |
| HIGH | Templates (Root / Routing / Dir) | `template-`, `layout-` | agents, meta-readme, dir-readme, layout-overview |
| HIGH | Meta Files / Hooks | `template-` | meta-schema, meta-conventions, meta-preset, pre-commit-hook |

전체 목록: references/_sections.md

- https://agents.md
- https://docs.cursor.com/context/rules
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
