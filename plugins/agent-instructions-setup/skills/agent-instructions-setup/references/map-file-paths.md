---
title: AI Tool Instruction File Paths
impact: CRITICAL
impactDescription: Correct path mapping ensures every AI tool reads the unified AGENTS.md
tags: agents-md, claude-md, cursor, copilot, windsurf, cline, gemini, codex, zed, amp
---

## Purpose

각 AI coding tool 의 instruction 파일 경로를 정의한다. AGENTS.md 를 원본으로 두고, 직접 지원하지 않는 도구는 해당 경로에 심링크를 건다.

## Tool File Path Reference

| Tool | Primary Path | Secondary / Scoped | AGENTS.md Direct |
|------|--------------|--------------------|------------------|
| OpenAI Codex | `AGENTS.md` | — | Yes |
| Zed | `AGENTS.md` | — | Yes |
| Amp (Sourcegraph) | `AGENTS.md` | — | Yes |
| Claude Code | `CLAUDE.md` | `~/.claude/CLAUDE.md` (user), 서브디렉토리 `CLAUDE.md` (nearest-wins) | No |
| Cursor | `.cursor/rules/*.mdc` | `.cursorrules` (legacy) | No |
| GitHub Copilot | `.github/copilot-instructions.md` | `.github/instructions/*.instructions.md` (scoped) | No |
| Windsurf | `.windsurfrules` | — | No |
| Cline | `.clinerules` | — | No |
| Roo Code | `.roorules` | — | No |
| Gemini CLI | `GEMINI.md` | — | No |
| Google Antigravity | `.agent/rules/rules.md` | — | No |
| Aider | `CONVENTIONS.md` | — | No |
| Continue | `.continue/rules/*.md` | — | No |

## AGENTS.md Direct Support

AGENTS.md 를 직접 읽는 도구 (심링크 불필요):

- OpenAI Codex
- Zed
- Amp

그 외 모든 도구는 AGENTS.md 를 원본으로 두고 각자 경로에 심링크를 건다.

## Cursor 특별 주의

Cursor 는 `.cursorrules` (legacy) 와 `.cursor/rules/*.mdc` (권장) 를 모두 지원한다.

- `.cursorrules` → 단일 파일. AGENTS.md 심링크 가능
- `.cursor/rules/{name}.mdc` → scoped rule. glob 패턴으로 적용 파일 제한 (frontmatter `globs` 필드)
- 프로젝트 전체 규칙은 `.cursorrules` 심링크로 충분
- 파일별 규칙이 필요하면 `.cursor/rules/` 에 별도 파일 작성 (심링크 대상 아님)

## Copilot 특별 주의

Copilot 은 `.github/copilot-instructions.md` (global) 와 `.github/instructions/*.instructions.md` (scoped) 를 지원한다.

- Global 규칙 → `.github/copilot-instructions.md` 심링크
- 파일별 규칙 → `.github/instructions/{name}.instructions.md` 에 frontmatter `applyTo: "**/*.ts"` 로 제한

## Scoped Rules 는 심링크 대상 아님

Cursor `.cursor/rules/*.mdc`, Copilot `.github/instructions/*.instructions.md` 는 심링크 대상이 아니다. 필요 시 `agents/scoped/{tool}-{name}.md` 에 원본을 두고 각 도구 경로로 복사·심링크를 관리한다.

## 선택 기준

- 프로젝트 전체 규칙 → AGENTS.md + 심링크 (모든 도구 커버)
- 특정 파일·경로 전용 규칙 → 각 도구의 scoped 기능 사용

## 감지 기준 (Phase 0)

아래 파일 중 하나라도 존재하면 해당 도구가 사용 중일 가능성이 높다.

| 파일 존재 | 추정 도구 |
|-----------|-----------|
| `CLAUDE.md` | Claude Code |
| `.cursorrules` or `.cursor/` | Cursor |
| `.github/copilot-instructions.md` | Copilot |
| `.windsurfrules` | Windsurf |
| `.clinerules` | Cline |
| `.roorules` | Roo Code |
| `GEMINI.md` | Gemini CLI |
| `.agent/rules/rules.md` | Antigravity |
| `CONVENTIONS.md` | Aider |
| `.continue/` | Continue |
