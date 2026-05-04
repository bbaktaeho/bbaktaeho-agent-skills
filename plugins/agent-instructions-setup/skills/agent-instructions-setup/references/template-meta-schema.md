---
title: .agents/schema.md Template
impact: CRITICAL
impactDescription: agents/*.md frontmatter 단일 표준 정의
tags: template, schema, frontmatter, meta
---

# `.agents/schema.md`

`agents/*.md` 와 `.agents/*.md` 의 frontmatter 스키마. meta-validator 가 이 파일을 기준으로 검증한다.

## 생성 경로

`{repo}/.agents/schema.md`

## Template

```markdown
---
title: Agents Frontmatter Schema
created: {ISO8601}
updated: {ISO8601}
summary: agents/ 와 .agents/ 의 모든 .md 파일이 따라야 하는 frontmatter 스키마.
tags: [meta, schema, frontmatter]
status: active
relations:
  - ./README.md
  - ./conventions.md
---

# Frontmatter Schema

모든 `agents/*.md` 와 `.agents/*.md` (디렉토리 README.md 포함) 에 필수.

## Required Fields

\`\`\`yaml
---
title: string              # 사람이 읽는 제목
created: ISO8601           # 2026-05-05T10:30:00Z
updated: ISO8601           # 2026-05-05T14:05:00Z
summary: string            # 1~2줄. "언제 읽어야 하는지 + 얻는 것"
tags: [string]             # 검색/그룹핑용. flat array. 5~8개 권장
status: enum               # draft | active | deprecated | archived
relations: [string]        # 상대경로 flat list. 없으면 []
---
\`\`\`

## Field Rules

- **title** — 한 줄. 파일명 slug 와 다른 가독적 제목 OK
- **created / updated** — ISO 8601 with timezone. meta-validator 가 git log 기준 자동 보정. 사용자/AI 가 직접 수정하지 말 것
- **summary** — 1~2줄. AI 가 본문을 모르고도 이 문서가 무엇인지 파악할 수 있어야 함
- **tags** — 소문자 + 하이픈. 공백/언더스코어 금지. meta-validator 가 정규화
- **status** —
  - `draft`: 작성 중. AI 답변 컨텍스트 제외
  - `active`: 최신. 기본값
  - `deprecated`: 더 이상 유효하지 않음. 대체 문서 있으면 relations 로 연결
  - `archived`: 역사적 기록
- **relations** — flat list, 상대 경로 (`./` / `../` 시작). 절대 경로 / URL 금지

## Example

\`\`\`yaml
---
title: Workflow — daily dev loop
created: 2026-05-05T10:30:00Z
updated: 2026-05-05T14:05:00Z
summary: 일일 개발 사이클 (브랜치 → 커밋 → PR → 머지) 의 표준 워크플로우와 자동화 도구.
tags: [workflow, dev, daily]
status: active
relations:
  - ../AGENTS.md
  - ./security.md
---
\`\`\`

## Non-Markdown Attachments

agents/ 가 참조하는 비-`.md` 파일 (JSON, 다이어그램 SVG 등) 은 frontmatter 가 없어도 됨. `.tag-index` 는 `.md` 만 인덱싱한다.
```

## 작성 가이드

- frontmatter 자체는 6~8줄 권장. tags 가 1줄에 안 들어가면 다음 줄에 array literal 사용
- `relations` 는 빈 배열 `[]` 도 허용. 없으면 명시적으로 `relations: []` 라고 작성
- AGENTS.md 자체는 frontmatter 가 없는 게 표준 (라우팅 루트). meta-validator 는 AGENTS.md 의 frontmatter 부재를 허용
