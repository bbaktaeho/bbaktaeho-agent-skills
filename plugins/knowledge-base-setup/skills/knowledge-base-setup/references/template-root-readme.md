---
title: Root README Template
impact: HIGH
impactDescription: 지식베이스 루트의 사람용 README.md 템플릿. GitHub 랜딩 페이지 역할
tags: template, root, readme
---

# Root `README.md` Template

지식베이스 루트의 `README.md` 는 **사람용** 이자 **AI 가 "이 KB 가 무엇인지" 컨텍스트를 얻는 파일**이다. GitHub / GitLab 랜딩 페이지 역할이며, AGENTS.md 가 여기를 첫 번째 읽기 대상으로 지정한다.

상세 탐색 규칙은 `.kb/README.md` 에 있다. 루트 `README.md` 는 "**무엇 + 왜 + 누구를 위한**" 을 담고, "어떻게" 는 `.kb/` 로 위임한다.

## 필수 섹션

- `## About` — 이 지식베이스가 **무엇인지, 왜 존재하는지, 누구를 위한 것인지** (필수. AGENTS.md 가 이 섹션을 참조)
- `## Quick Start` — AI / 사람 각 역할별 진입 경로
- `## Structure` — top-level 디렉토리 목록
- `## Contributing` — 기여 절차 요약

## 생성 시 템플릿

```markdown
---
title: {kb-name}
created: {ISO8601 now}
updated: {ISO8601 now}
summary: {한 줄 설명 — 이 지식베이스의 주제/범위}
tags: [meta, root]
status: active
relations:
  - ./.kb/README.md
  - ./AGENTS.md
---

# {kb-name}

## About

**무엇인지**: {kb-name} 은 {preset-tagline} 을 위한 마크다운 기반 지식베이스입니다.

**왜 존재하는지**: {purpose — 사용자가 Q1~Q2 에서 힌트를 주거나, 프리셋 기본 문구로 placeholder 채움. 예: "팀이 공유하는 ADR / 런북 / 리서치를 한 곳에서 관리하고, AI 도구가 바로 참조할 수 있게 만든다."}

**누가 쓰는지**: {사용자 / AI agent / 외부 참조자 등}

**주요 주제**: {예: 팀 내 결정 기록 / OAuth 리서치 / 결제 시스템 설계 등 — 비어있으면 placeholder}

**submodule 로 사용 가능**: 이 저장소는 다른 레포의 git submodule 로 붙여서 지식을 공유할 수 있도록 설계되었습니다.

## Quick Start

- **AI agent (Claude Code, Codex, Cursor 등)**: [`AGENTS.md`](./AGENTS.md) 를 먼저 읽으세요. 이 README 와 [`.kb/README.md`](./.kb/README.md) 로 라우팅됩니다.
- **사람 기여자**: 아래 "Structure" 와 "Contributing" 을 참고하세요.

## Structure

{preset-directory-list}

메타 정보: [`.kb/`](./.kb/)
- [`.kb/README.md`](./.kb/README.md) — AI 탐색 진입점 (디렉토리 맵, 규칙 요약)
- [`.kb/schema.md`](./.kb/schema.md) — frontmatter 스키마
- [`.kb/conventions.md`](./.kb/conventions.md) — 네이밍 / 관계 / 라이프사이클 / 민감 정보 규칙

## Contributing

1. 적절한 디렉토리에 `.md` 파일 생성
2. frontmatter 기입 (필수 필드: `title`, `created`, `updated`, `summary`, `tags`, `status`, `relations`)
3. 관련 지식이 있으면 `relations` 에 상대경로 추가
4. 민감 정보 (credentials, tokens, 내부 엔드포인트) 는 본문에 평문으로 넣지 말 것 — `.kb/local/` (gitignored) 사용
5. 커밋 시 pre-commit hook 이 민감 정보를 자동 차단
6. 필요시 `kb-validator` 스킬로 전체 검증

## Preset

이 지식베이스는 **`{preset-name}`** 프리셋으로 셋업되었습니다.

## License

{기존 레포 라이선스 유지 or TBD}
```

## `{preset-directory-list}` 생성 규칙

`.kb/README.md` 의 Directory Map 과 동일한 형식. 단 루트 README 에서는 **사람이 읽는다** 는 맥락이므로 "이건 runbook 입니다" 같은 용어 뒤에 한 줄 설명을 추가하는 것이 좋다.

## 기존 README.md 가 이미 있을 때 (Retrofit)

- 기존 내용 보존
- 상단에 frontmatter 추가 (없으면)
- `## About` 섹션이 없으면 파일 앞부분에 멱등 마커와 함께 삽입:

  ```markdown
  <!-- kb-setup: about -->
  ## About

  ...
  <!-- /kb-setup -->
  ```

- `## Knowledge Base Structure` 섹션도 멱등 마커로 append (중복 방지):

  ```markdown
  <!-- kb-setup: kb-structure -->
  ## Knowledge Base Structure

  - [`AGENTS.md`](./AGENTS.md) — AI 에이전트 진입점
  - [`.kb/README.md`](./.kb/README.md) — AI 탐색 진입점 (디렉토리 맵, 규칙)
  - ...
  <!-- /kb-setup -->
  ```

- 스킬 재실행 시 마커 사이만 교체. 기존 내용은 손대지 않음.

## AGENTS.md 와의 관계

루트 README 는 AGENTS.md 의 **"무엇 / 왜" 부분** 을 담는다. AGENTS.md 는 얇은 라우터로, "무엇인지" 질문에 답할 때 README.md 의 About 섹션을 참조한다.

- AGENTS.md — AI 진입점 (라우팅, 규칙 요약)
- README.md — 사람/AI 공용. "이 KB 가 무엇이고 왜 존재하는지"
- .kb/README.md — AI 탐색 맵 (디렉토리 / 스키마 / 규칙)

세 파일은 역할이 분리되어 있으므로 서로 중복 기술하지 않는다.
