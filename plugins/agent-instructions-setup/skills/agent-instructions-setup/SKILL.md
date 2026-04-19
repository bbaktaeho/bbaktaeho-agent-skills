---
name: agent-instructions-setup
description: >
  Initialize AI coding agent instruction files for a project. Creates AGENTS.md
  as the single source of truth, generates symlinks for 7 tool-specific files
  (CLAUDE.md, .cursorrules, .windsurfrules, .clinerules, GEMINI.md,
  .github/copilot-instructions.md, .agent/rules/rules.md), and scaffolds
  docs/guide.md and docs/workflow.md from dev or docs templates. Make sure to
  use this skill whenever the user wants to initialize a new project for
  AI-assisted development, bootstrap AGENTS.md, unify or consolidate
  instruction files across Claude Code, Cursor, Copilot, Windsurf, Cline,
  Gemini CLI, Codex, Zed, or Antigravity, migrate existing CLAUDE.md /
  .cursorrules / .windsurfrules into a single AGENTS.md, or set up coding
  conventions and workflow docs for multiple AI tools - even if they only
  mention one tool by name or ask generically about "AI rules" or "agent
  config".
license: MIT
metadata:
  author: bbaktaeho
  version: "2.0.0"
  date: April 2026
  abstract: >
    Init skill for AI coding agent instruction files. Phase 1 auto-creates
    AGENTS.md and 7 symlinks covering 9 AI tools. Phase 2 interactively
    generates docs/guide.md and docs/workflow.md from dev or docs templates.
    Phase 3 verifies all files and symlink targets.
---

# Agent Instructions Setup

AGENTS.md를 single source of truth로 두고, symlink와 docs/ 구조를 자동 셋업하는 init skill이다.

## Execution Flow

### Phase 1: Auto Setup

1. AGENTS.md 존재 확인. 없으면 `template-agents.md` 기반으로 생성한다
2. 기존 instruction 파일(CLAUDE.md, .cursorrules, .windsurfrules, .clinerules, GEMINI.md, .github/copilot-instructions.md, .agent/rules/rules.md)이 존재하면 내용을 AGENTS.md로 병합한다
3. `map-file-paths.md`로 대상 경로를 확인하고 `link-symlink-strategy.md`의 명령으로 7개 symlink를 생성한다
4. `docs/` 디렉토리를 생성한다

### Phase 2: Interactive Setup

5. 프로젝트 용도를 사용자에게 질문한다
   - 개발용 (software development)
   - 문서용 (documentation/writing)
   - 기타 (사용자 직접 입력)
6. 기술 스택, 프로젝트 이름 등 치환에 필요한 값을 질문한다
7. 용도에 따라 `docs/guide.md`를 생성한다. `meta-frontmatter.md` 규칙을 적용한다
   - 개발용: `template-dev-guide.md` 기반
   - 문서용: `template-docs-guide.md` 기반
8. 용도에 따라 `docs/workflow.md`를 생성한다
   - 개발용: `template-dev-workflow.md` 기반
   - 문서용: `template-docs-workflow.md` 기반

### Phase 3: Verification

9. 생성된 파일 목록을 출력한다
10. `ls -la`로 symlink 연결 상태를 검증한다. `diff AGENTS.md CLAUDE.md`로 내용 일치를 확인한다
11. 응답 마지막에 읽은 파일과 생성한 파일을 나열한다

## Tool Coverage

| Category | Tools |
|----------|-------|
| AGENTS.md를 직접 읽음 (symlink 불필요) | OpenAI Codex, Zed |
| symlink로 연결해야 함 | Claude Code, Cursor, GitHub Copilot, Windsurf, Cline, Gemini CLI, Google Antigravity |

총 9개 도구, 7개 symlink.

## Reference Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | File Mapping | CRITICAL | `map-` |
| 2 | Symlink Strategy | HIGH | `link-` |
| 3 | Frontmatter Rules | CRITICAL | `meta-` |
| 4 | Templates | HIGH | `template-` |

## References

- references/\_sections.md
- references/map-file-paths.md
- references/link-symlink-strategy.md
- references/meta-frontmatter.md
- references/template-agents.md
- references/template-dev-guide.md
- references/template-dev-workflow.md
- references/template-docs-guide.md
- references/template-docs-workflow.md

## External Docs

- https://agents.md
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://docs.cursor.com/context/rules-for-ai
