---
title: Unify Agent Files with Symlinks
impact: HIGH
impactDescription: Single source of truth eliminates drift across 7+ tool-specific instruction files
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

## 기존 파일 병합 절차

symlink 생성 전에 기존 instruction 파일이 있을 수 있다. 다음 절차를 따른다:

1. 기존 파일 탐색: CLAUDE.md, .cursorrules, .windsurfrules 등이 이미 존재하는지 확인
2. 내용 읽기: 기존 파일의 내용을 읽는다
3. AGENTS.md에 병합: 기존 파일의 유효한 규칙과 설정을 AGENTS.md에 통합한다
4. 기존 파일 삭제: 병합이 완료되면 기존 파일을 삭제한다
5. symlink 생성: 위 Setup Commands에 따라 symlink를 만든다

## .gitignore 설정

symlink 파일은 git에 포함한다. 다른 collaborator도 동일한 설정을 사용하려면 symlink를 커밋한다.

```gitignore
# 사용하지 않는 도구의 파일은 gitignore에 추가
# .windsurfrules
# .clinerules
```

## 플랫폼별 주의 사항

### macOS / Linux

symlink는 기본 지원된다. 추가 설정 불필요.

### Windows

- symlink 생성에 관리자 권한 또는 Developer Mode가 필요하다
- Git for Windows에서 `git config --global core.symlinks true` 설정을 확인한다
- 대안: `mklink` 명령을 사용하거나, WSL 환경에서 작업한다

## 검증

```bash
# symlink가 올바르게 연결되었는지 확인
ls -la CLAUDE.md .cursorrules .windsurfrules .clinerules GEMINI.md .github/copilot-instructions.md .agent/rules/rules.md

# 실제 내용이 동일한지 확인
diff AGENTS.md CLAUDE.md
```
