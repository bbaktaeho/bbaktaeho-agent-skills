---
title: Execution Flow (Phase 0 ~ 4)
impact: CRITICAL
impactDescription: KB 셋업의 전체 실행 흐름 정의 - state scan부터 verification까지
tags: flow, phases, setup, execution, verification
---

# Execution Flow

## Phase 0: State Scan

1. 대상 디렉토리 스캔: 기존 `.kb/`, `README.md`, `.gitignore` 유무 확인
2. AGENTS.md / CLAUDE.md 등 감지 (참고용. 변경 안함)
3. 모드 분기:
   - **Fresh** → Phase 1 진행
   - **`.kb/` 이미 존재** → 업그레이드 모드 (references/flow-retrofit.md)
   - **마크다운 문서 이미 다수 존재** → retrofit 모드 (references/flow-retrofit.md)

## Phase 1: Interactive Questions

상세: references/ask-questions.md

- **Q1.** KB 루트: 레포 자체 vs 서브디렉토리 (기본 `knowledge/`)
- **Q2.** 프리셋: team-docs / research / product / custom
- **Q3.** AGENTS.md 통합 여부 (스킵 / 경로 기억)

## Phase 2: Structure Setup

1. `.kb/` 생성:
   - `README.md` (references/template-kb-readme.md)
   - `schema.md` (references/template-schema.md)
   - `conventions.md` (references/template-conventions.md)
   - `preset.json` (Q2 결과 반영)
2. 루트 `README.md` 생성/갱신 (references/template-root-readme.md) — About 섹션 포함
3. `AGENTS.md` 생성/갱신 (references/template-agents.md) — README.md + .kb/README.md 로 라우팅. 기존 파일 있으면 멱등 마커 블록만 append
4. 프리셋별 디렉토리 생성 + 각 디렉토리 `README.md` (references/template-dir-readme.md)
   - team-docs: references/preset-team-docs.md
   - research: references/preset-research.md
   - product: references/preset-product.md
   - custom: references/preset-custom.md
5. `.gitignore` 생성/업데이트 (`.kb/.tag-index`, `.kb/local/` 추가, 멱등)
6. `.kb/local/` 디렉토리 + `.kb/local.example/` 템플릿 디렉토리 생성 (references/rule-secrets-handling.md)
   - `.kb/local/README.md` (gitignored 사본) — 이 디렉토리가 왜 gitignored 인지 설명
   - `.kb/local.example/README.md` — 로컬 파일 템플릿 사용 방법
7. `.kb/hooks/pre-commit-secrets.sh` 생성 + `chmod +x` (references/template-pre-commit-hook.md)
8. `.git/hooks/pre-commit` 자동 연결:
   - 없으면 symlink: `ln -sfn ../../.kb/hooks/pre-commit-secrets.sh .git/hooks/pre-commit`
   - 이미 다른 훅이 있으면 덮어쓰지 않고 사용자에게 병합 안내

## Phase 3: Background Tag Indexing

- Task / background agent 가 `.tag-index` 생성 (초기엔 README frontmatter 태그 수집)

## Phase 4: Verification

1. `.kb/` 파일 frontmatter 유효성 확인
2. 각 디렉토리에 `README.md` 존재 확인
3. 루트 `README.md` 에 About 섹션 존재 확인
4. `AGENTS.md` 존재 및 `.kb/README.md` / `README.md` 링크 포함 확인 (멱등 마커 사이)
5. `.gitignore` 에 `.kb/.tag-index` / `.kb/local/` 라인 존재 확인
6. `.git/hooks/pre-commit` 가 `.kb/hooks/pre-commit-secrets.sh` 로 연결되었는지 확인
7. pre-commit 훅 self-test: `.kb/hooks/pre-commit-secrets.sh` 를 실행하여 정상 종료하는지 확인
8. 사용자에게 다음 단계 안내: 첫 지식 추가 → kb-validator 실행

## Retrofit Mode (기존 프로젝트)

references/flow-retrofit.md 참조. 기존 `.md` 에 frontmatter 보강, 디렉토리 매핑 제안.
