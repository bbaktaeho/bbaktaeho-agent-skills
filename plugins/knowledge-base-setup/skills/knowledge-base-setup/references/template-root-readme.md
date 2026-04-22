---
title: Root README Template
impact: HIGH
impactDescription: 지식베이스 루트의 사람용 README.md 템플릿. GitHub 랜딩 페이지 역할
tags: template, root, readme
---

# Root `README.md` Template

지식베이스 루트의 `README.md` 는 **사람용** 이다. GitHub / GitLab 에서 레포를 처음 여는 사람이 "무엇인지, 어떻게 쓰는지" 를 5초 안에 파악할 수 있어야 한다.

AI 진입점은 별도로 `.kb/README.md` 이다. 루트 `README.md` 는 간결하게 유지하고 상세는 `.kb/` 로 위임한다.

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
---

# {kb-name}

{한두 문장 소개 — 이 지식베이스가 무엇을 담는지.}

## Quick Start

- **AI agent 사용자**: [`.kb/README.md`](./.kb/README.md) 를 읽으세요. 디렉토리 맵, frontmatter 스키마, 작성 규칙이 있습니다.
- **사람 기여자**: 아래 "Structure" 와 "Contributing" 참고.

## Structure

{preset-directory-list}

메타 정보: [`.kb/`](./.kb/)
- [`schema.md`](./.kb/schema.md) — frontmatter 스키마
- [`conventions.md`](./.kb/conventions.md) — 네이밍 / 관계 / 라이프사이클 규칙

## Contributing

1. 적절한 디렉토리에 `.md` 파일 생성
2. frontmatter 기입 (필수 필드: `title`, `created`, `updated`, `summary`, `tags`, `status`, `relations`)
3. 관련 지식이 있으면 `relations` 에 상대경로 추가
4. 커밋 후 `kb-validator` 스킬 실행하여 형식 검증

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
- 본문 끝에 "## Knowledge Base Structure" 섹션 append (중복 방지: 이미 있으면 skip)
- `.kb/README.md` 링크 문구 추가: `> AI agent 는 [`.kb/README.md`](./.kb/README.md) 를 참조하세요.`

## AGENTS.md 와의 관계

루트 README 는 AGENTS.md 를 대체하지 않는다.
- 레포가 지식베이스 **전용** → AGENTS.md 가 없어도 무방. `.kb/README.md` 가 AI 진입점 역할
- 레포가 지식베이스 + 코드 혼재 → AGENTS.md 에서 `.kb/README.md` 참조 한 줄로 연결
