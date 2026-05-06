---
title: .agents/README.md Template
impact: CRITICAL
impactDescription: 라우팅 체인의 2번째 hop. 상위 디렉토리 요약과 라우팅 표를 제공
tags: template, meta-readme, routing-index, ai-entry-point
---

# `.agents/README.md`

라우팅 체인의 핵심 인덱스.

```
AGENTS.md → .agents/README.md → <dir>/README.md → 상세
```

이 파일이 다음을 모두 담는다.

1. 프로젝트 개요 (1~3줄)
2. 상위 디렉토리 요약 + 라우팅 표
3. 메타 파일 (`schema.md`, `conventions.md`, `preset.json`, `hooks/`) 참조

## 생성 경로

`{repo}/.agents/README.md`

## Template

```markdown
---
title: {Project Name} — Routing Index
created: {ISO8601}
updated: {ISO8601}
summary: AGENTS.md 의 진입점에서 도달하는 라우팅 인덱스. 상위 디렉토리 요약과 라우팅 표를 제공.
tags: [meta, agents, routing, entry-point]
status: active
relations:
  - ../AGENTS.md
  - ./schema.md
  - ./conventions.md
---

# Routing Index

{프로젝트 1줄 설명}.

## Top-Level Directories

| 경로 | 역할 | 작업 시작점 |
|------|------|-------------|
| `../docs/README.md` | 사람용·AI용 일반 문서 | 문서 추가/수정 |
| `../src/README.md` | 애플리케이션 소스 | 코드 작업 |
| `../scripts/README.md` | 유틸리티 스크립트 | 자동화/CI 작업 |
| `../tests/README.md` | 테스트 코드 | 테스트 작성/디버깅 |

상위 디렉토리는 Q5 답변에 따라 동적으로 채워진다. 빈 디렉토리는 행에 포함하지 않는다.

## How AI Should Read

1. 작업 유형을 파악
2. 위 표에서 가장 가까운 `<dir>/README.md` 진입
3. `<dir>/README.md` 의 라우팅으로 더 깊이 진행
4. 각 README.md 는 frontmatter `summary` 로 1줄 요약 — head 8줄만 읽고 진입 여부 판단

## Meta Files

| 경로 | 역할 |
|------|------|
| `./schema.md` | README.md frontmatter 스키마 |
| `./conventions.md` | 네이밍 / lifecycle / findability 규칙 |
| `./preset.json` | meta-validator 가 참조 (kind / version) |
| `./hooks/pre-commit-secrets.sh` | git pre-commit. 민감 정보 차단 |
| `./local/` | gitignored. 내부 메모 / 임시 작업 |
| `./local.example/` | 커밋 대상. local 파일 템플릿 |

## Conventions

- 모든 라우팅 README.md 는 frontmatter 6~8줄 (`./schema.md` 참조)
- `summary` 는 "언제 읽어야 하는지 + 얻는 것" 형식
- 길이: AGENTS.md 50/80/120, README.md 80/120/200
- 행동 지시문 금지 (`./conventions.md` Anti-Patterns 참조)

## Companion Skill

`agent-instructions-setup:meta-validator` — 주기적으로 실행하여 라우팅 표의 broken link 정리, frontmatter / relations / git timestamps / 길이 / 시크릿 검증/자동수정.
```

## 작성 가이드

1. `created` / `updated` 는 셋업 시점 ISO8601 (UTC). 이후 meta-validator 가 git log 기준 자동 갱신
2. `Top-Level Directories` 표는 Q5 답변과 실제 디렉토리 존재 여부에 따라 동적 구성. 행이 없으면 표 자체 생략 가능 (단 1행 이상 권장)
3. 각 행은 **"무엇이 있는지 + 언제 들어가는지"** 둘 다 포함. AI 가 표만 읽고 라우팅 가능해야 함
4. 80~120줄 권장. 라우팅 표가 커지면 그룹핑 (예: "코드", "문서", "운영" 섹션)
5. AGENTS.md 의 `Entry Point` 섹션과 중복되지 않게 — `.agents/README.md` 가 상세, AGENTS.md 는 1줄 진입점

## 라우팅 표 갱신 시점

- 새 상위 디렉토리 추가 → 표에 행 추가, 해당 dir 에 `README.md` 스캐폴드 (references/template-dir-readme.md)
- 디렉토리 제거 / 이름 변경 → 표 갱신, broken link 제거
- 디렉토리 역할 변경 → `역할` 컬럼 갱신

이 갱신은 사용자 / AI 가 직접 수행. meta-validator 가 broken link 자동 제거.
