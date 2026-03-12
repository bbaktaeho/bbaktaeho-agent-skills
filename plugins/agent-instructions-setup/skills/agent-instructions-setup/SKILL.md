---
name: agent-instructions-setup
description: >
  AI coding agent instruction file init setup.
  Creates AGENTS.md as single source of truth, symlinks for 8 AI tools,
  and docs/ structure with guide and workflow templates.
  Use when initializing a new project for AI-assisted development,
  setting up agent instruction files,
  or unifying configuration across multiple AI coding tools.
license: MIT
metadata:
  author: bbaktaeho
  version: "2.0.0"
  date: March 2026
  abstract: >
    Init skill for AI coding agent instruction files. Phase 1 auto-creates
    AGENTS.md and symlinks for 8 tools. Phase 2 interactively generates
    docs/guide.md and docs/workflow.md from dev or docs templates.
    Phase 3 verifies all files and symlinks.
---

# Agent Instructions Setup

AGENTS.md를 single source of truth로 두고, symlink와 docs/ 구조를 자동 셋업하는 init skill이다.

## Execution Flow

### Phase 1: Auto Setup

1. AGENTS.md 존재 확인. 없으면 `template-agents.md` 기반 생성
2. 기존 instruction 파일(CLAUDE.md, .cursorrules 등)이 있으면 내용을 AGENTS.md로 병합
3. `map-file-paths.md` 참조하여 8개 도구 symlink 전부 생성. `link-symlink-strategy.md` 참조
4. `docs/` 디렉토리 생성

### Phase 2: Interactive Setup

5. 사용자에게 프로젝트 용도 질문:
   - 개발용 (software development)
   - 문서용 (documentation/writing)
   - 기타 (사용자 직접 입력)
6. 기술스택 등 추가 질문
7. 용도에 따라 `docs/guide.md` 생성. `meta-frontmatter.md` 규칙 적용
   - 개발용: `template-dev-guide.md` 기반
   - 문서용: `template-docs-guide.md` 기반
8. 용도에 따라 `docs/workflow.md` 생성
   - 개발용: `template-dev-workflow.md` 기반
   - 문서용: `template-docs-workflow.md` 기반

### Phase 3: Verification

9. 생성된 파일 목록 출력
10. symlink 연결 상태 검증 (`ls -la`)
11. 응답 마지막에 읽은/생성한 파일 나열

## Reference Categories

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | File Mapping | CRITICAL | `map-` |
| 2 | Symlink Strategy | HIGH | `link-` |
| 3 | Frontmatter Rules | CRITICAL | `meta-` |
| 4 | Templates | HIGH | `template-` |

## References

```
references/map-file-paths.md
references/link-symlink-strategy.md
references/meta-frontmatter.md
references/template-agents.md
references/template-dev-guide.md
references/template-dev-workflow.md
references/template-docs-guide.md
references/template-docs-workflow.md
references/_sections.md
```

- https://agents.md
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
- https://docs.cursor.com/context/rules-for-ai
