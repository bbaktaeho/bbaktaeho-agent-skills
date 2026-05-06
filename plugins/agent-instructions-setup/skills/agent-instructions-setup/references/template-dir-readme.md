---
title: Top-Level Directory README.md Template
impact: HIGH
impactDescription: 라우팅 체인의 3번째 hop. 각 상위 디렉토리의 도메인 라우팅 진입점
tags: template, dir-readme, routing, top-level
---

# `<top-level-dir>/README.md`

라우팅 체인의 3번째 hop. `.agents/README.md` 의 표에서 진입하는 도메인별 README.

```
.agents/README.md → <dir>/README.md → 하위 README / 상세 파일
```

각 상위 디렉토리 (`docs/`, `src/`, `scripts/`, `tests/`, `apps/`, `packages/` 등) 마다 한 개씩.

## 생성 경로

`{repo}/<top-level-dir>/README.md` — Phase 2 에서 사용자 opt-in 으로 스캐폴드.

## Template

```markdown
---
title: {Dir Name}
created: {ISO8601}
updated: {ISO8601}
summary: 이 디렉토리에 들어오는 작업의 진입점. 무엇이 있고 어떤 작업 시 어떤 파일을 읽는지.
tags: [{dir-name}, routing]
status: active
relations:
  - ../.agents/README.md
---

# {Dir Name}

{이 디렉토리의 역할 1~2줄 요약. 예: "사용자가 읽는 문서. 가이드 / 튜토리얼 / 레퍼런스 포함."}

## Contents

| 경로 | 역할 |
|------|------|
| `./guide/README.md` | 사용 가이드 진입점 |
| `./reference/README.md` | API 레퍼런스 |
| `./{file-or-dir}` | {역할} |

빈 행은 포함하지 않는다. 디렉토리에 README.md 가 없는 항목은 파일을 직접 가리켜도 된다.

## When To Read

- 이 도메인 작업을 시작할 때 가장 먼저 진입
- 하위 README 가 있으면 위 표를 따라 한 단계 더 진입
- 파일을 추가/수정한 뒤 이 표를 갱신
```

## 작성 가이드

1. frontmatter 6~8줄. `summary` 는 "언제 읽어야 하는지" 형식
2. `Contents` 표는 디렉토리 실제 내용에 맞게 채운다. **존재하지 않는 경로는 넣지 않는다** — broken link 는 meta-validator 가 제거
3. 행은 **하위 README → 단일 파일** 순. README 가 있는 하위는 README 로 진입하도록
4. 80~120줄 권장. 디렉토리가 크면 하위 README 로 더 분해
5. 행동 지시문 금지. references/rule-findability.md 참조

## 스캐폴드 정책

Phase 2 에서 사용자 opt-in 으로 스캐폴드한다. 정책:

- `<dir>/README.md` 가 이미 존재하면 **건드리지 않는다** (사용자 권한)
- frontmatter 가 없으면 사용자 확인 후 frontmatter 만 보강
- 비어있거나 frontmatter 부재면 위 Template 으로 초안 생성
- 스캐폴드 직후 meta-validator 1회 실행으로 timestamps / tag-index 동기화

## 하위 디렉토리 README

`<dir>/<sub>/README.md` 도 동일 템플릿 사용. relations 는 한 단계 위 README.md 를 가리킨다.

```yaml
relations:
  - ../README.md
```

라우팅이 깊어질수록 head frontmatter 만 읽고 빠르게 위치 파악 가능해야 한다.
