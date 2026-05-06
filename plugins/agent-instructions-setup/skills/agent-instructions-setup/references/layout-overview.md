---
title: Layout Overview
impact: HIGH
impactDescription: 라우팅 체인 (도구 심링크 → AGENTS.md → .agents/README.md → dir/README.md) 의 디렉토리 배치 정의
tags: layout, structure, routing-chain, agents-md, meta
---

# Layout Overview

`AGENTS.md` 는 라우팅 체인의 진입점. 모든 도구별 instruction 파일은 AGENTS.md 로 심링크되고, AGENTS.md 는 `.agents/README.md` 를, `.agents/README.md` 는 각 상위 디렉토리의 `README.md` 를 가리킨다.

## 라우팅 체인 (4 hops)

```
[hop 1] 도구 심링크 (CLAUDE.md, .cursorrules, GEMINI.md, ...)
            ↓ ln -sfn AGENTS.md
[hop 2] AGENTS.md                            (50줄 이내, 진입점)
            ↓ "Entry Point" 섹션
[hop 3] .agents/README.md                    (라우팅 인덱스)
            ↓ Top-Level Directories 표
[hop 4] <top-level-dir>/README.md            (도메인 라우팅)
            ↓ Contents 표
        하위 README 또는 상세 파일
```

각 hop 은 **1~2 화면 안에 들어오는 짧은 분량**. AI 가 head frontmatter 만 읽고 다음 hop 으로 진행 가능.

## 전체 트리

```
{repo}/
├── AGENTS.md                          # hop 2: 라우팅 진입점 (50줄)
├── README.md                          # 사람용 GitHub 랜딩 (별개)
├── .gitignore                         # .agents/.tag-index, .agents/local/ 포함
├── .agents/                           # 메타 + 라우팅 인덱스
│   ├── README.md                      # hop 3: 라우팅 인덱스
│   ├── schema.md                      # README.md frontmatter 스키마
│   ├── conventions.md                 # findability / lifecycle / 네이밍
│   ├── preset.json                    # meta-validator 가 참조
│   ├── .tag-index                     # gitignored. 태그 인덱스
│   ├── hooks/
│   │   └── pre-commit-secrets.sh      # 민감 정보 차단
│   ├── local/                         # gitignored. 로컬 메모
│   └── local.example/                 # 커밋. local 파일 템플릿
├── docs/
│   └── README.md                      # hop 4: docs 도메인 라우팅
├── src/
│   └── README.md                      # hop 4: src 도메인 라우팅
├── scripts/
│   └── README.md                      # hop 4: scripts 도메인 라우팅
└── (도구 심링크: CLAUDE.md, .cursorrules, ...)
```

## 핵심 원칙

- **AGENTS.md 는 hop 2** — 50줄 이내. 본문은 `Entry Point` 한 섹션만
- **`.agents/README.md` 는 hop 3** — 라우팅 인덱스 + 메타 파일 참조. 80~120줄
- **`<dir>/README.md` 는 hop 4** — 도메인 라우팅. 80~120줄
- **`agents/` 콘텐츠 디렉토리는 만들지 않는다** — 모든 콘텐츠는 사용자의 기존 디렉토리 (`docs/`, `src/`, ...) 에 머문다
- **frontmatter 는 `.agents/*.md` 와 `<dir>/README.md` 에만 필수** — AGENTS.md 와 일반 콘텐츠 파일 (`docs/foo.md`) 은 frontmatter 자유
- **민감 정보는 `.agents/local/`** — gitignored. 커밋 대상 템플릿은 `.agents/local.example/`

## `.kb/` 와의 관계

지식베이스 (`.kb/`) 와 instruction 셋업 (`.agents/`) 이 공존 가능. 두 메타 디렉토리는 독립이며 각자의 컴패니언 스킬 (`kb-validator`, `meta-validator`) 이 검증한다. 둘 다 셋업되어 있으면 `.agents/README.md` 의 `Top-Level Directories` 표에 `../.kb/README.md` 행 추가 권장.

## 도구 심링크 위치

`CLAUDE.md`, `.cursorrules`, `.windsurfrules`, `.clinerules`, `.roorules`, `GEMINI.md`, `.github/copilot-instructions.md`, `.agent/rules/rules.md`, `CONVENTIONS.md` 등. 전체 목록: references/map-file-paths.md

`AGENTS.md` 를 직접 읽는 도구 (Codex / Zed / Amp) 는 심링크 불필요.

## 왜 README.md 체인인가

- 모든 도구가 동일하게 `README.md` 를 인지·우선 표시 (GitHub UI, IDE 트리)
- 사람이 디렉토리에 들어가면 자연스럽게 README 부터 읽음 — AI 도 동일 동선
- frontmatter `summary` 만 읽고도 진입 여부 판단 가능
- 디렉토리가 추가될 때마다 README.md 만 추가하면 라우팅이 자동 확장
- 콘텐츠를 별도 `agents/` 로 옮기지 않으므로 기존 프로젝트 구조에 침습 없음
