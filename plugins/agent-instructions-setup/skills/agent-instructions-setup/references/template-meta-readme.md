---
title: .agents/README.md Template
impact: CRITICAL
impactDescription: AI 가 instruction 구조를 한 파일만 읽고 파악할 수 있도록 하는 단일 진입점
tags: template, meta-readme, ai-entry-point
---

# `.agents/README.md`

agents 메타 디렉토리의 AI 단일 진입점. AGENTS.md → `.agents/README.md` → 개별 agents/*.md 순으로 라우팅된다.

## 생성 경로

`{repo}/.agents/README.md`

## Template

```markdown
---
title: Agents Meta — AI Entry Point
created: {ISO8601}
updated: {ISO8601}
summary: AI 도구가 이 레포의 instruction 구조와 규칙을 한눈에 파악하기 위한 진입점.
tags: [meta, agents, entry-point]
status: active
relations:
  - ../AGENTS.md
  - ./schema.md
  - ./conventions.md
---

# Agents Meta

이 레포의 AI 코딩 에이전트 instruction 구조와 규칙을 정의한다.

## Directory Map

| 경로 | 역할 |
|------|------|
| `../AGENTS.md` | 라우팅 루트. 작업 시작점 |
| `../agents/guide.md` | 작업 유형별 라우팅 인덱스 |
| `../agents/workflow.md` | 작업 워크플로우 |
| `../agents/*.md` | 주제별 상세 문서 |
| `./schema.md` | agents/*.md frontmatter 스키마 |
| `./conventions.md` | 네이밍 / lifecycle / findability 규칙 |
| `./preset.json` | meta-validator 가 참조 (`kind`/`mode`/`version`) |
| `./hooks/pre-commit-secrets.sh` | git pre-commit. 민감정보 차단 |
| `./local/` | gitignored. 내부 메모 / 임시 작업 |

## 작성 규칙 요약

- 모든 `agents/*.md` 는 frontmatter 6~8줄 (`./schema.md` 참조)
- `description` 은 "언제 읽어야 하는지 + 얻는 것" 형식
- 파일 길이: target 80줄, soft warn 100줄, hard warn 150줄. AGENTS.md 는 50/80/120
- 행동 지시문 금지 (`./conventions.md` Anti-Patterns 참조)

## Companion Skill

`agent-instructions-setup:meta-validator` — 주기적으로 실행하여 frontmatter, relations, timestamps, 길이, 시크릿을 검증/자동수정한다.

## References

- https://agents.md
```

## 작성 가이드

1. `created` / `updated` 는 셋업 시점의 ISO8601 (UTC 권장). 이후 meta-validator 가 git log 기준 자동 갱신
2. Directory Map 행은 실제 생성된 파일에 맞춰 동적으로 구성 (예: `local/` 이 비어있어도 라인 유지)
3. AGENTS.md 의 Directory Map 과 중복되지 않게 — `.agents/README.md` 는 메타 중심, AGENTS.md 는 컨텐츠 중심
4. 50~80줄 이내 유지. 길어지면 schema.md / conventions.md 로 분리
