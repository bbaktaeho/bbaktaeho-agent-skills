---
title: Product Preset
impact: HIGH
impactDescription: 제품 개발 중심 지식베이스 프리셋 (spec / design / api / architecture)
tags: preset, product
---

# Preset: `product`

제품/서비스 개발 중심의 지식베이스. 스펙, 디자인, API, 아키텍처를 한곳에서 관리.

## Top-level Directories

```
{kb-root}/
├── specs/
│   └── README.md
├── designs/
│   └── README.md
├── api/
│   └── README.md
└── architecture/
    └── README.md
```

## 각 디렉토리의 역할

### `specs/`
제품 스펙, 요구사항 문서. 기능 단위로 파일 또는 서브디렉토리.

```
specs/
├── README.md
├── user-signup.md
└── payment-v2/
    ├── README.md
    ├── requirements.md
    ├── acceptance-criteria.md
    └── mockups/              # 이미지 첨부 디렉토리
```

### `designs/`
설계 문서 / 다이어그램 / 시나리오. 기능 설계, 데이터 모델, 플로우 차트 등. mermaid 다이어그램 적극 활용.

### `api/`
API 정의 / 레퍼런스.

```
api/
├── README.md
├── rest/
│   ├── README.md
│   ├── users.md
│   ├── orders.md
│   └── openapi.yaml          # 스펙 파일 (frontmatter 불필요)
└── graphql/
    ├── README.md
    └── schema.graphql
```

### `architecture/`
아키텍처 결정 (ADR) + 시스템 다이어그램 + 컴포넌트 맵.

```
architecture/
├── README.md
├── decisions/               # ADR
│   ├── 0001-use-postgres.md
│   └── 0002-event-sourcing.md
├── system-overview.md
└── components/
    ├── README.md
    ├── gateway.md
    └── worker.md
```

## 초기 README.md 템플릿

references/template-dir-readme.md 참고.

## 권장 태그

- 디렉토리 slug (`spec`, `design`, `api`, `architecture`)
- 기능/컴포넌트 태그 (`payment`, `auth`, `gateway`)
- 상태 태그는 `status` 필드로 충분, `tags` 에는 중복 금지

## Non-Markdown Attachments (중요)

product 프리셋은 첨부 파일이 많다:
- `mockups/*.png` — 디자인 목업
- `openapi.yaml` / `schema.graphql` — API 스펙
- `*.drawio` / `*.excalidraw` — 다이어그램 소스

이들은 frontmatter 없이 허용. 지식 문서 (`.md`) 본문에서 상대경로로 링크하여 사용. `.tag-index` 는 `.md` 만 인덱싱.
