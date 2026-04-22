---
title: Schema Definition Template
impact: HIGH
impactDescription: .kb/schema.md — 지식베이스 frontmatter 스키마의 단일 진실 원천
tags: template, schema
---

# `.kb/schema.md` Template

이 파일은 지식베이스의 frontmatter 표준을 **고정된 참조** 로 제공한다. kb-validator 가 검증 기준으로 사용. submodule 로 공유될 때도 이 파일 하나면 스키마가 전달된다.

아래 내용을 그대로 `.kb/schema.md` 로 생성한다.

```markdown
---
title: Knowledge Base Frontmatter Schema
created: {ISO8601 now}
updated: {ISO8601 now}
summary: 지식베이스의 frontmatter 필수 스키마 정의. kb-validator 검증 기준.
tags: [meta, schema]
status: active
relations:
  - ./README.md
  - ./conventions.md
---

# Frontmatter Schema

## Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `title` | string | 사람이 읽는 제목. 파일명과 달라도 됨 |
| `created` | ISO 8601 | 생성 시각. kb-validator 가 git log 기준 보정 |
| `updated` | ISO 8601 | 마지막 수정 시각. kb-validator 가 git log 기준 보정 |
| `summary` | string | 1~2줄. AI 첫 스캔 시 컨텍스트 |
| `tags` | array of string | 소문자-하이픈. 5~8개 권장 |
| `status` | enum | draft \| active \| deprecated \| archived |
| `relations` | array of string | 상대경로 flat list |

## Status Values

- `draft` — 작성 중. AI 답변 컨텍스트 제외
- `active` — 최신. 기본값
- `deprecated` — 더 이상 유효하지 않음. 대체 문서 있으면 `relations` 포함
- `archived` — 역사적 기록

## Example

```yaml
---
title: OAuth 2.0 인증 플로우
created: 2026-04-22T10:30:00Z
updated: 2026-04-22T14:05:00Z
summary: 이 프로젝트의 OAuth 2.0 authorization code flow 단계 설명.
tags: [auth, oauth2, security]
status: active
relations:
  - ../concepts/session.md
  - ./pkce.md
---
```

## Validation Rules

| Rule | Severity |
|------|----------|
| 모든 필수 필드 존재 | ERROR (auto-fix) |
| `status` 가 enum 값 중 하나 | ERROR (auto-fix) |
| `tags` 가 소문자-하이픈 | ERROR (auto-fix: 정규화) |
| `relations` 가 존재하는 상대 경로 | ERROR (auto-fix: 제거) |
| `created` / `updated` 가 git log 와 일치 | ERROR (auto-fix) |
| 태그 5~8개 권장 범위 | WARNING |
| `summary` 가 30자 이상 | WARNING |

kb-validator 는 ERROR 는 자동 수정, WARNING 은 사용자 확인.

## Directory README.md

모든 디렉토리에는 `README.md` 가 필수. 위 스키마를 그대로 따른다. `summary` 에는 디렉토리의 역할/범위를 명시.

## Non-Markdown Attachments

JSON, CSV 등 참조용 데이터 파일은 frontmatter 없이 허용. 지식 문서 본문에서 링크하여 사용.
```

## 생성 시 `{ISO8601 now}` 치환

- UTC timezone (`Z` suffix) 권장
- 예: `2026-04-22T10:30:00Z`
