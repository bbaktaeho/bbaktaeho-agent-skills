---
title: Conventions Document Template
impact: HIGH
impactDescription: .kb/conventions.md — AI 가 반복적으로 참조할 네이밍 / 관계 / 라이프사이클 규칙
tags: template, conventions
---

# `.kb/conventions.md` Template

아래 내용을 그대로 `.kb/conventions.md` 로 생성한다. AI 가 지식 생성/수정 시 매번 참조하도록 설계되어 있다.

```markdown
---
title: Knowledge Base Conventions
created: {ISO8601 now}
updated: {ISO8601 now}
summary: 지식 생성 / 수정 / 삭제 / 관계 판단에 대한 AI 및 사람 공통 규칙.
tags: [meta, conventions]
status: active
relations:
  - ./README.md
  - ./schema.md
---

# Conventions

## Naming

- 파일명: 소문자 + 하이픈. `.md` 확장자. 예: `oauth-flow.md`, `db-failover.md`
- `README.md` 는 디렉토리마다 1개. 대소문자 정확히 `README.md`
- 디렉토리명: 소문자 + 하이픈. 복수형 권장 (`runbooks/`, `decisions/`, `topics/`)

## Directory Rules

- 모든 디렉토리에 `README.md` 필수. 없으면 kb-validator 가 감지
- 빈 디렉토리 금지. 내용이 없다면 디렉토리 자체를 두지 않는다
- 디렉토리가 5개 이상의 관련 문서를 담으면 서브디렉토리 분리 고려

## Relations

- `relations` 는 flat list. 유형 구분 없음
- 현재 파일 기준 상대경로만. 절대경로 / URL 금지
- 양방향 자동 추가 없음. 필요하면 양쪽에 각자 추가

### 새 지식 생성 시 AI 의 관계 판단

1. 본문 완성 후 관련 문서 탐색 (tag-index + grep)
2. Strong signal 있으면 `relations` 에 추가:
   - 본문에서 명시적으로 언급한 문서
   - 같은 도메인의 상위 개념 문서
   - 대체되는 구버전 문서
   - 본문이 참조한 API/규약을 정의한 문서
3. Weak signal (같은 태그지만 간접 관련, 느슨한 유사성) → **사용자에게 확인**
4. 관계 없음 확실 → `relations: []`

### 삭제 시 정리

1. `grep -l "{target-path}"` 로 참조 문서들 찾기
2. 각 문서의 `relations` 에서 제거
3. 대상 파일 삭제
4. `.tag-index` 에서 경로 제거 + 빈 태그 키 제거

## Lifecycle

### 생성

1. 디렉토리 판단 (애매하면 사용자 확인)
2. frontmatter 기입: status 는 `draft` (작성 중) 또는 `active` (완성)
3. 관계 탐색 (위 규칙)
4. 디렉토리에 `README.md` 없으면 동시 생성
5. `.tag-index` 증분 갱신:
   - 파일 태그 각각에 대해 `tags[{tag}]` 배열에 경로 추가
   - 없던 태그면 새 키로 추가

### 수정

- 본문 수정. `updated` 는 건드리지 않음 (git log 에서 보정됨)
- `tags` 가 바뀌었으면: 기존 태그 엔트리에서 경로 제거 → 현재 태그들로 재삽입
- `relations` 변경 시 위 "관계 판단" 규칙 준수

### 삭제 / 이동

- 위 "삭제 시 정리" 참고
- 이동: 참조 문서들의 relations 일괄 업데이트 → 이동 → `.tag-index` 에서 경로 치환

## Tag Index

### 파일 위치

`.kb/.tag-index` (gitignored)

### 포맷

```json
{
  "generated_at": "2026-04-22T10:30:00Z",
  "tags": {
    "auth": ["concepts/auth.md", "guides/oauth.md"],
    "security": ["concepts/auth.md", "runbooks/rotate-keys.md"]
  }
}
```

### 갱신 주체

- 초기 셋업: background agent (전체)
- AI 가 `.md` 생성/수정/삭제: AI 가 증분 갱신
- 사용자 수동 수정: stale 허용
- kb-validator: 전체 재생성

### `generated_at`

전체 재생성 시점만 기록. 증분 갱신은 건드리지 않는다.

### 태그 검색 순서

1. `.kb/.tag-index` 존재 + 최신이면 → 인덱스에서 조회
2. 없거나 stale 의심 → grep fallback
3. 병행 가능 (인덱스 히트 + grep 보완)

## Status 전환

- `draft → active`: 완성 시
- `active → deprecated`: 대체 문서가 생겼을 때. 대체 경로를 `relations` 에 포함. 본문 상단에 "이 문서는 [대체문서](...) 로 대체되었습니다." 명시
- `deprecated → archived`: 역사 기록으로만 남길 때

AI 는 `status: deprecated` / `archived` 인 문서를 답변 컨텍스트로 사용하지 않는다.

## Length

- 권장 최대: 일반 1000줄, 시각화 포함 2000줄
- 초과 시 kb-validator 가 분리 여부 확인 (권장 항목, 필수 아님)
- 예외 허용: `tags` 에 `length-exempt` 추가

## Non-Markdown Attachments

- JSON / CSV / 이미지 등 참조 데이터: frontmatter 없이 허용
- 지식 본문에서 상대 경로로 링크하여 사용
- `.tag-index` 는 `.md` 만 인덱싱
```

## 생성 시 치환

- `{ISO8601 now}` → UTC 현재 시각 (예: `2026-04-22T10:30:00Z`)
