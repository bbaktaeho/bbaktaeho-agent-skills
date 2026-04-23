---
title: AI Entry Point Template
impact: HIGH
impactDescription: .kb/README.md 의 표준 템플릿. AI 가 가장 먼저 읽는 단일 진입점
tags: template, entry-point
---

# `.kb/README.md` Template

AGENTS.md 등 외부 진입점이 가리키는 **AI 가 처음 읽는 파일**. 한 화면에 지식베이스의 전체 그림이 잡혀야 한다.

생성 시점에는 아래 템플릿의 `{...}` 를 실제 값으로 치환한다.

```markdown
---
title: Knowledge Base Entry Point
created: {ISO8601 now}
updated: {ISO8601 now}
summary: {kb-name} 지식베이스의 AI 진입점. 디렉토리 맵과 작성 규칙 안내.
tags: [meta, entry]
status: active
relations: []
---

# {kb-name} Knowledge Base

이 문서는 AI 도구 (Claude Code, Codex, Cursor 등) 가 이 지식베이스를 빠르게 파악하기 위한 진입점입니다.

## Directory Map

{preset-directory-list}

## 작성 규칙 요약

1. 모든 `.md` 파일은 frontmatter 필수. 스키마: [./schema.md](./schema.md)
2. 각 디렉토리에 `README.md` 필수
3. 관계 판단이 애매하면 사용자에게 확인 (규칙: [./conventions.md](./conventions.md))
4. 길이 권장: 일반 1000줄, 시각화 포함 2000줄, 리서치 2500줄. 초과 시 분리 검토
5. 상태 `deprecated` / `archived` 문서는 답변 컨텍스트에서 제외
6. **민감 정보 금지**: credentials / tokens / 내부 엔드포인트는 평문 저장 금지. `.kb/local/` (gitignored) 또는 플레이스홀더 사용. git pre-commit hook 자동 차단

자세한 규칙: [./conventions.md](./conventions.md)

## Frontmatter 필수 필드

- `title` — 읽기 쉬운 제목
- `created` / `updated` — ISO 8601. kb-validator 가 git log 기준 보정
- `summary` — 1~2줄
- `tags` — 소문자-하이픈 배열
- `status` — draft | active | deprecated | archived
- `relations` — 상대경로 flat list (없으면 `[]`)

## 관계 (Relations)

- flat list. 관계 유형 구분 없음
- 현재 파일 기준 상대경로만
- 새 지식 생성 시 관련 문서가 있으면 AI 가 자동 추가. 애매하면 사용자 확인
- 지식 삭제 시 해당 경로는 다른 문서의 relations 에서 자동 제거

상세: [./conventions.md](./conventions.md) (Relations 섹션)

## Tag Index

`.kb/.tag-index` (gitignored) 에 태그 → 파일 경로 역인덱스가 저장됩니다.

- 초기 셋업 후 background agent 가 전체 생성
- AI 는 `.md` 생성/수정/삭제 시 증분 갱신
- kb-validator 가 주기적으로 전체 재생성
- 인덱스가 없거나 stale 하면 grep fallback

## Lifecycle

- **생성**: 디렉토리 선택 → frontmatter 기입 → 관계 탐색 → tag-index 증분 갱신
- **수정**: 본문 수정. `updated` 는 건드리지 않음 (git 보정). tags 변경 시 인덱스 증분
- **삭제**: 참조하는 문서들의 relations 에서 제거 → 삭제 → 인덱스 제거
- **이동**: 참조 경로 일괄 업데이트 → 이동 → 인덱스 갱신

## Secrets

- `.kb/local/` (gitignored) 에 민감 정보 저장. 지식 본문에서는 경로만 참조
- `.kb/local.example/` 에 템플릿 (커밋 대상)
- git pre-commit hook: `.kb/hooks/pre-commit-secrets.sh` — AWS/GitHub/JWT/Basic-auth/내부 IP/credential 패턴 차단
- False positive 시: 같은 줄에 `<!-- kb-secrets: allow -->` 추가
- 상세: [./conventions.md](./conventions.md) (Secrets 섹션)

## Preset

이 지식베이스는 **`{preset-name}`** 프리셋으로 셋업되었습니다. 설정: [./preset.json](./preset.json)

## Companion Skill

`kb-validator` — frontmatter / 관계 / 타임스탬프 / 태그 인덱스 / 길이 / 민감정보 검증 및 자동 수정
```

## `{preset-directory-list}` 생성 규칙

선택된 프리셋의 top-level 디렉토리들을 불릿 리스트로. 각 행은 `- \`{dir}/\` — {한줄 설명}`.

예 (research 프리셋):

```
- `topics/` — 리서치 주제별 문서
- `experiments/` — 실험 기록 / POC 결과
- `notes/` — 단편 메모, 임시 저장소
```

예 (team-docs 프리셋):

```
- `onboarding/` — 신규 팀원 온보딩 가이드
- `decisions/` — ADR (아키텍처 결정 기록)
- `runbooks/` — 운영/배포/장애 대응 절차
- `glossary/` — 도메인 용어집
- `projects/` — 프로젝트별 문서 (spec, 설계, 회고)
- `research/` — 리서치, 탐색, POC 기록
```

예 (product 프리셋):

```
- `specs/` — 제품 스펙 / 요구사항
- `designs/` — 설계 문서, 다이어그램
- `api/` — API 정의 / 레퍼런스
- `architecture/` — 아키텍처 결정, 시스템 다이어그램
```

예 (custom 프리셋):

```
(top-level 디렉토리는 아직 없습니다. 첫 지식을 만들 때 디렉토리를 결정하세요.)
```
