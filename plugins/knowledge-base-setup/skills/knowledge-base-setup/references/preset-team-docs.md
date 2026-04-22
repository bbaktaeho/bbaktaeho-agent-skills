---
title: Team Docs Preset
impact: HIGH
impactDescription: 팀 운영 + 프로젝트 작업 + 리서치를 한 지식베이스에 담는 프리셋
tags: preset, team-docs
---

# Preset: `team-docs`

팀 단위로 공유하는 모든 문서 유형을 담는 프리셋. 운영 / 결정 / 프로젝트 / 탐색 / 용어를 한곳에서 관리.

## Top-level Directories

```
{kb-root}/
├── onboarding/
│   └── README.md
├── decisions/
│   └── README.md
├── runbooks/
│   └── README.md
├── glossary/
│   └── README.md
├── projects/
│   └── README.md
└── research/
    └── README.md
```

## 각 디렉토리의 역할

### `onboarding/`
신규 팀원이 프로젝트에 합류했을 때 읽는 가이드. 환경 설정, 팀 문화, 주요 컨벤션, 첫 일주일 체크리스트 등.

### `decisions/`
ADR (Architecture Decision Record). "왜 이 기술/구조를 선택했는가" 를 맥락 / 대안 / 결정 / 결과 순으로 기록. 파일명 권장: `{번호}-{slug}.md` (예: `0001-use-postgres.md`).

### `runbooks/`
반복 작업이나 장애 대응을 step-by-step 으로 정리한 운영 매뉴얼. 예: 배포 롤백, DB 페일오버, API 키 교체. **재현 가능성** 이 핵심.

### `glossary/`
도메인 용어 정의. 팀에서만 쓰는 약어, 시스템 이름의 정의, 비즈니스 용어. 파일 1개로 전체 용어집을 관리해도 되고, 용어가 많으면 초성별로 분리.

### `projects/`
프로젝트별 서브디렉토리. 각 서브디렉토리에는 `README.md` (프로젝트 요약), `spec.md`, `architecture.md`, `retrospective.md` 등.

```
projects/
├── README.md           # 프로젝트 레지스트리
├── payment-service/
│   ├── README.md
│   ├── spec.md
│   └── retrospective.md
└── ...
```

`projects/README.md` 는 레지스트리 역할:

```markdown
## Registry

- [payment-service](./payment-service/) — 결제 시스템 v2. active
- [user-auth-v2](./user-auth-v2/) — 인증 리팩토링. archived (2026-03 완료)
```

### `research/`
리서치, 탐색, POC 기록. 주제별 서브디렉토리 권장.

```
research/
├── README.md
├── vector-db-comparison/
│   ├── README.md
│   ├── benchmark-results.md
│   └── schema.json           # 참조 데이터 (frontmatter 불필요)
└── ...
```

## 초기 README.md 템플릿

각 디렉토리 `README.md` 는 references/template-dir-readme.md 의 템플릿 + 위 역할 설명을 `summary` 에 반영.

## 권장 태그

- 디렉토리 slug 자체를 태그에 포함 (`onboarding`, `decisions`, `runbooks`, `glossary`, `projects`, `research`)
- 도메인 태그 (예: `auth`, `payment`, `infra`) 는 디렉토리 독립적으로 부여
