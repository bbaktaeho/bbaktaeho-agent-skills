---
title: Unify Agent Files with Symlinks
impact: HIGH
impactDescription: Single source of truth eliminates drift across 5+ tool-specific instruction files
tags: symlink, agents-md, unification, setup
---

## Symlink Strategy

AGENTS.md를 원본으로 두고 각 도구별 파일을 symlink로 연결한다.

## Setup Commands

```bash
# AGENTS.md가 이미 존재한다고 가정

# Claude Code
ln -s AGENTS.md CLAUDE.md

# Cursor
ln -s AGENTS.md .cursorrules

# Windsurf
ln -s AGENTS.md .windsurfrules

# Cline
ln -s AGENTS.md .clinerules

# Gemini CLI
ln -s AGENTS.md GEMINI.md

# GitHub Copilot (디렉토리 생성 필요)
mkdir -p .github
ln -s ../AGENTS.md .github/copilot-instructions.md

# Google Antigravity (디렉토리 생성 필요)
mkdir -p .agent/rules
ln -s ../../AGENTS.md .agent/rules/rules.md
```

## .gitignore 설정

symlink 파일은 git에 포함해야 한다. 다른 collaborator도 동일한 설정을 사용하려면 symlink를 커밋한다.

```gitignore
# 사용하지 않는 도구의 파일은 gitignore에 추가
# .windsurfrules
# .clinerules
```

## 주의 사항

- symlink 생성 전에 기존 파일이 있는지 확인한다. 있으면 내용을 AGENTS.md로 병합한 후 삭제하고 symlink를 만든다
- Windows에서는 symlink 생성에 관리자 권한이 필요할 수 있다. Git for Windows의 `core.symlinks=true` 설정을 확인한다
- `.github/copilot-instructions.md`는 상위 디렉토리를 가리키므로 `../AGENTS.md`로 경로를 지정한다
- 모노레포에서는 하위 디렉토리에 별도의 AGENTS.md를 둘 수 있다. 가장 가까운 AGENTS.md가 우선한다

## 검증

```bash
# symlink가 올바르게 연결되었는지 확인
ls -la CLAUDE.md .cursorrules .windsurfrules

# 실제 내용이 동일한지 확인
diff AGENTS.md CLAUDE.md
```
