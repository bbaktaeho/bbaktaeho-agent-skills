---
title: Map AI Tool Instruction File Paths
impact: CRITICAL
impactDescription: Correct file path mapping ensures every AI tool reads project instructions
tags: agents-md, claude-md, cursorrules, copilot, windsurf, cline, gemini
---

## AI Tool File Path Reference

각 AI coding tool은 고유한 경로에서 instruction 파일을 읽는다.

| AI Tool | File Path | Notes |
|---------|-----------|-------|
| OpenAI Codex | `AGENTS.md` | Source of truth |
| Claude Code | `CLAUDE.md` | 프로젝트 루트. `~/.claude/CLAUDE.md`로 user-level 설정도 가능 |
| Cursor | `.cursorrules` | 프로젝트 루트. `.cursor/rules/*.md`로 scoped rule도 지원 |
| GitHub Copilot | `.github/copilot-instructions.md` | Chat에만 적용. autocomplete에는 미적용 |
| Windsurf | `.windsurfrules` | 프로젝트 루트 |
| Cline | `.clinerules` | 프로젝트 루트 |
| Gemini CLI | `GEMINI.md` | 프로젝트 루트 |
| Google Antigravity | `.agent/rules/rules.md` | 디렉토리 구조 필요 |
| Zed | `AGENTS.md` | AGENTS.md 직접 지원 |

## AGENTS.md 지원 현황

AGENTS.md를 직접 읽는 도구:
- OpenAI Codex
- Zed
- Aider (`.aider.conf.yml` 설정 후)

AGENTS.md를 직접 읽지 않는 도구:
- Claude Code (CLAUDE.md 필요)
- Cursor (.cursorrules 필요)
- GitHub Copilot (.github/copilot-instructions.md 필요)
- Windsurf (.windsurfrules 필요)

## 파일 우선순위

프로젝트 루트에 AGENTS.md를 작성하고, 나머지 도구별 파일은 symlink로 연결한다. 이렇게 하면 하나의 파일만 관리하면 된다.
