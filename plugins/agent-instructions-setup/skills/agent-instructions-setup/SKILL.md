---
name: agent-instructions-setup
description: >
  AI coding agent instruction file init and retrofit. Creates AGENTS.md as the
  single source of truth, symlinks across major AI tools (Claude Code, Cursor,
  Copilot, Windsurf, Cline, Roo Code, Gemini CLI, Codex, Zed, Antigravity, Amp,
  Aider, Continue), and agents/ directory optimized for AI discoverability
  (routing index + workflow). Make sure to use this skill whenever the user
  wants to initialize a new project for AI-assisted development, bootstrap
  AGENTS.md, unify or consolidate instruction files across multiple AI tools,
  retrofit an existing project with AGENTS.md and agents/, add a new AI tool
  to an existing setup, migrate CLAUDE.md / .cursorrules / .windsurfrules into
  a single AGENTS.md, or evolve agents/ docs after initial setup - even if
  they only mention one tool by name or ask generically about "AI rules" or
  "agent config".
license: MIT
metadata:
  author: bbaktaeho
  version: "3.0.0"
  date: April 2026
  abstract: >
    Init and retrofit skill for AI coding agent instruction files. Phase 0 scans
    state, Phase 1 sets up AGENTS.md and idempotent symlinks, Phase 2 interactively
    generates agents/guide.md (routing index) and agents/workflow.md from modular
    templates, Phase 3 verifies. Philosophy: optimize docs for agent findability
    rather than prescribing agent behavior.
---

# Agent Instructions Setup

AGENTS.md 를 single source of truth 로 두고, `agents/` 디렉토리를 AI 탐색 최적화된 형태로 구축·유지한다.

## Core Philosophy

"AI 행동을 바꾸려 하지 말고, AI 가 잘 찾을 수 있도록 문서를 최적화한다."

AGENTS.md 와 agents/guide.md 는 행동 지시문이 아니라 **탐색 라우팅** 역할이다. 상세: references/rule-findability.md

## Directory Name

생성되는 디렉토리 이름은 `agents/` 이다. AGENTS.md 와 네임스페이스가 일치하여 agent 가 한눈에 식별한다. 기존 소스에 `agents/` 디렉토리가 있으면 Phase 0 에서 충돌을 감지하고 fallback 이름(`.agents/`)을 제안한다.

## Execution Flow

### Phase 0: State Scan

현재 프로젝트 상태를 스캔하여 진행 모드를 결정한다.

1. AGENTS.md, 도구별 instruction 파일, `agents/` 디렉토리 유무 확인
2. `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile` 스캔하여 스택 자동 감지
3. 모드 분기:
   - Fresh → Phase 1 부터 진행
   - Legacy files only → 병합 후 Phase 1 (references/link-symlink-strategy.md 병합 절차)
   - Already set up → 업그레이드·문서 추가 모드 (references/evolve-principles.md 원칙 적용)

### Phase 1: Structure Setup

1. AGENTS.md 생성 또는 병합 (references/template-agents.md)
2. `agents/` 디렉토리 생성 (충돌 시 fallback)
3. `ln -sfn` 으로 사용 도구별 심링크 멱등 생성 (references/link-symlink-strategy.md, references/map-file-paths.md)
4. `.gitignore` 에 미사용 도구 파일 추가

### Phase 2: Interactive Setup

5. references/ask-questions.md 스크립트로 Q1~Q9 질문
6. Q3 답변에 따라 agents/guide.md 생성 (routing index, 80줄 이내)
7. Q5 답변에 따라 agents/workflow.md 생성 (lite 5-step / full 14-step)
8. 모든 agents/*.md 파일은 references/meta-frontmatter.md 규칙 적용

### Phase 3: Verification

9. 심링크 타겟 검증: `ls -la`, `diff AGENTS.md CLAUDE.md`
10. agents/ 파일의 frontmatter 6줄 이내 확인
11. 응답 마지막에 읽은·생성한 파일 나열

## Reference Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Findability Philosophy | CRITICAL | `rule-` |
| 2 | File Mapping | CRITICAL | `map-` |
| 3 | Frontmatter Rules | CRITICAL | `meta-` |
| 4 | Symlink Strategy | HIGH | `link-` |
| 5 | Doc Evolution | HIGH | `evolve-` |
| 6 | Interactive Questions | HIGH | `ask-` |
| 7 | Templates | HIGH | `template-` |

## References

```
references/rule-findability.md
references/map-file-paths.md
references/meta-frontmatter.md
references/link-symlink-strategy.md
references/evolve-principles.md
references/ask-questions.md
references/template-agents.md
references/template-dev-guide.md
references/template-dev-workflow.md
references/template-docs-guide.md
references/template-docs-workflow.md
references/_sections.md
```

- https://agents.md
- https://docs.cursor.com/context/rules
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
