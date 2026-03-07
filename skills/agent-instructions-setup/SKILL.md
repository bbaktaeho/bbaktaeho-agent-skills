---
name: agent-instructions-setup
description: >
  AI coding agent instruction file setup and management.
  Configures AGENTS.md as single source of truth and creates symlinks
  for tool-specific files (CLAUDE.md, .cursorrules, copilot-instructions.md, etc.).
  Use when initializing a new project for AI-assisted development,
  setting up agent instruction files,
  or unifying configuration across multiple AI coding tools.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: March 2026
  abstract: >
    Guide for setting up AI coding agent instruction files across projects.
    Covers file path mapping for 8+ AI tools, symlink-based unification strategy,
    and AGENTS.md authoring best practices.
---

# Agent Instructions Setup

AI coding agent instruction file setup guide. AGENTS.md를 single source of truth로 두고 각 도구별 파일을 symlink로 관리한다.

## When to Apply

Reference these guidelines when:
- 새 프로젝트에서 AI agent 설정 파일을 초기화할 때
- 여러 AI coding tool을 동시에 사용하는 프로젝트를 구성할 때
- 기존 프로젝트에 AGENTS.md를 도입할 때
- agent instruction 파일을 통합 관리하고 싶을 때

## Setup Flow

초기 셋업 순서:
1. AGENTS.md 생성 + symlink (CLAUDE.md, .cursorrules 등)
2. docs/guide.md, docs/workflow.md 생성
3. AGENTS.md는 간결하게, 상세 내용은 docs/로 위임

## Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | File Mapping | CRITICAL | `map-` |
| 2 | Symlink Strategy | HIGH | `link-` |
| 3 | Documentation Structure | HIGH | `docs-` |
| 4 | Writing Guide | HIGH | `write-` |

## How to Use

Read individual rule files for detailed guidance:

```
references/map-file-paths.md
references/link-symlink-strategy.md
references/docs-structure.md
references/write-agents-md.md
references/_sections.md
```

Each rule file contains:
- AI tool별 instruction file 경로
- Symlink 생성 및 관리 방법
- docs/ 디렉토리 구조 및 분리 전략
- AGENTS.md 작성 가이드

## References

- https://agents.md
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://docs.cursor.com/context/rules-for-ai
