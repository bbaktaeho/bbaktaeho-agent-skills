---
title: Directory README Template
impact: HIGH
impactDescription: 각 지식 디렉토리에 필수 배치되는 README.md 의 표준 템플릿
tags: template, directory, readme
---

# Directory `README.md` Template

모든 디렉토리에는 `README.md` 가 필수. 사용자가 아직 내용을 채우지 않았어도 최소한 frontmatter + 빈 섹션 구조는 존재해야 한다.

## 생성 시 템플릿

```markdown
---
title: {Directory Title}
created: {ISO8601 now}
updated: {ISO8601 now}
summary: {한 줄 설명 — 이 디렉토리가 담는 지식의 범위}
tags: [{dir-slug}]
status: active
relations: []
---

# {Directory Title}

이 디렉토리는 {역할 설명} 을 담습니다.

## Scope

{이 디렉토리에 들어가는 것 / 들어가지 않는 것}

## 작성 가이드

- {디렉토리 특화 작성 규칙, 있으면}

## Index

(이 섹션은 선택사항입니다. 문서 수가 많아지면 AI 또는 kb-validator 가 목록을 생성/갱신할 수 있습니다.)
```

## Title 매핑 (프리셋별 기본값)

| Directory | Title | Summary (placeholder) |
|-----------|-------|------------------------|
| `onboarding` | Onboarding | 신규 팀원이 프로젝트에 합류할 때 읽는 가이드 모음. |
| `decisions` | Decisions (ADR) | 아키텍처 결정 기록 (ADR). 결정의 맥락 / 근거 / 결과. |
| `runbooks` | Runbooks | 반복 작업 / 장애 대응을 step-by-step 으로 정리한 운영 매뉴얼. |
| `glossary` | Glossary | 이 프로젝트에서 사용하는 도메인 용어 정의. |
| `projects` | Projects | 프로젝트별 spec / 설계 / 회고. |
| `research` | Research | 리서치, 탐색, POC 기록. |
| `topics` | Topics | 리서치 주제별로 정리한 지식. |
| `experiments` | Experiments | 실험 결과, POC, 벤치마크. |
| `notes` | Notes | 단편 메모, 임시 저장소. |
| `specs` | Specs | 제품 스펙, 요구사항. |
| `designs` | Designs | 설계 문서, 다이어그램, 시나리오. |
| `api` | API | API 정의 / 레퍼런스. |
| `architecture` | Architecture | 아키텍처 결정, 시스템 다이어그램. |

## 사용자가 커스텀 디렉토리를 만들 때

- `title` / `summary` 를 직접 기입
- `tags` 에 디렉토리 slug 자체를 넣어두면 `.tag-index` 에서 조회 가능

## 빈 README.md 금지

frontmatter 만 있고 본문이 비어 있는 상태는 허용 (이제 막 생성된 경우). 하지만 지식이 1개 이상 쌓이면 `## Scope`, `## 작성 가이드` 중 하나는 채우는 것이 권장. kb-validator 가 고아 디렉토리 경고에서 이를 판단.

## Projects / Research 같은 "상위 디렉토리"

서브디렉토리가 생기는 구조의 상위 디렉토리 (예: `projects/`, `research/`) 의 `README.md` 에는:

- 서브디렉토리 목록 (레지스트리)
- 각 서브디렉토리의 요약 + 상태

예: `projects/README.md`

```markdown
---
title: Projects
summary: 프로젝트별 spec / 설계 / 회고. 각 프로젝트는 서브디렉토리로 관리.
tags: [projects, registry]
...
---

# Projects

## Registry

- [payment-service](./payment-service/) — 결제 시스템 v2. active
- [user-auth-v2](./user-auth-v2/) — 인증 리팩토링. archived (2026-03 완료)
```
