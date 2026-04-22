---
title: Frontmatter Schema Rules
impact: CRITICAL
impactDescription: AI 가 지식을 인덱싱/탐색/관계추적할 때 사용하는 단일 표준
tags: frontmatter, schema, metadata
---

# Frontmatter Schema

모든 `.md` 파일 (지식 파일 + 모든 디렉토리의 `README.md`) 에 필수. 파일 최상단에 YAML frontmatter 로 작성.

## Required Fields

```yaml
---
title: string              # 사람이 읽는 제목 (파일명과 달라도 됨)
created: ISO8601           # 2026-04-22T10:30:00Z
updated: ISO8601           # 2026-04-22T14:05:00Z
summary: string            # 1~2줄. AI 가 빠른 스캔에 사용
tags: [string]             # 검색/그룹핑용. flat array
status: enum               # draft | active | deprecated | archived
relations: [string]        # 상대경로 flat list. 없으면 []
---
```

## Field Rules

### title
- 파일명은 slug (예: `oauth-flow.md`), title 은 읽기 쉬운 제목 (예: `OAuth 2.0 인증 플로우`)
- 반드시 한 줄

### created / updated
- ISO 8601 with timezone (UTC 권장)
- 사용자/AI 가 직접 쓰지 않아도 됨. **kb-validator 가 git log 기준으로 자동 보정**
- git log 사용 불가한 환경 (new file not yet committed): AI 가 현재 시각 기입
- **AI 가 수동으로 값을 바꾸지 말 것** — 규칙 위반임

### summary
- 1~2줄. 본문을 모르는 AI 가 "이 문서가 무엇인지" 바로 알 수 있어야 함
- 마침표로 끝내는 완결 문장 권장

### tags
- 문자열 배열. 소문자 + 하이픈 (`auth`, `oauth2`, `session-mgmt`)
- 대소문자 혼용, 공백 금지 (kb-validator 가 정규화)
- 5~8개 권장. 너무 많으면 인덱스 노이즈

### status
- `draft` — 작성 중, AI 답변 컨텍스트 제외
- `active` — 최신. 기본값
- `deprecated` — 더 이상 유효하지 않음. 대체 문서 있으면 relations 로 연결 권장. AI 답변에서 제외
- `archived` — 역사적 기록. AI 답변에서 제외

### relations
- **Flat list**. 관계 유형 구분 없음
- 상대 경로. 현재 파일 기준 (`../concepts/auth.md`, `./oauth-flow.md`)
- 절대 경로, URL 금지
- 빈 배열 `[]` 허용

## Example

```yaml
---
title: OAuth 2.0 인증 플로우
created: 2026-04-22T10:30:00Z
updated: 2026-04-22T14:05:00Z
summary: 이 프로젝트에서 사용하는 OAuth 2.0 authorization code flow 단계별 설명.
tags: [auth, oauth2, security]
status: active
relations:
  - ../concepts/session.md
  - ./pkce.md
  - ../runbooks/rotate-oauth-client-secret.md
---
```

## Incorrect

```yaml
# 빈 frontmatter 없음 — 필수 누락
---
title: OAuth Flow
tags: [AUTH, OAuth2]          # 대소문자 혼용
status: in-progress           # 허용되지 않는 enum
relations:
  - /abs/path/foo.md          # 절대 경로 금지
  - https://example.com       # URL 금지
---
```

## Correct

```yaml
---
title: OAuth Flow
created: 2026-04-22T10:30:00Z
updated: 2026-04-22T10:30:00Z
summary: 승인 코드 기반 OAuth 인증 단계 정리.
tags: [auth, oauth2]
status: draft
relations: []
---
```

## Non-Markdown Attachments

지식이 참조하는 데이터 파일 (예: JSON 스키마, 예시 payload) 은 frontmatter 가 없어도 됨. 대신 지식 문서의 본문에서 상대 경로로 링크. `.tag-index` 는 `.md` 파일만 인덱싱 대상.
