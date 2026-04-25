---
title: KB Directory Layout Overview
impact: HIGH
impactDescription: AI가 한눈에 KB 구조를 파악하도록 단일 진입점과 디렉토리 배치를 정의
tags: layout, structure, directory, kb-root
---

# KB Directory Layout

`{kb-root}` 는 레포 자체이거나 서브디렉토리 (`knowledge/` 기본). 지식은 루트 경로에 배치하고, 메타 정보는 `.kb/` 에 격리한다.

## 전체 트리

```
{kb-root}/
├── AGENTS.md                    # AI 에이전트 공용 진입점 (README.md + .kb/README.md 로 라우팅)
├── README.md                    # 사람용 GitHub 랜딩 + "이 지식베이스가 무엇인지" 설명
├── .gitignore                   # .kb/.tag-index, .kb/local/ 포함
├── .kb/
│   ├── README.md                # AI 탐색 진입점 (디렉토리 맵, 규칙 요약)
│   ├── schema.md                # frontmatter 스키마
│   ├── conventions.md           # 관계/네이밍/라이프사이클/민감정보 규칙
│   ├── preset.json              # kb-validator 가 참조
│   ├── .tag-index               # gitignored. 태그 인덱스
│   ├── hooks/
│   │   └── pre-commit-secrets.sh  # git pre-commit 훅 (민감정보 차단)
│   ├── local/                   # gitignored. 로컬 전용 민감 정보
│   └── local.example/           # 커밋 대상. 로컬 파일 템플릿
├── {preset-dir-1}/
│   └── README.md                # 디렉토리별 필수
└── ...
```

## 핵심 원칙

- **AI 진입점은 `.kb/README.md`** — 디렉토리 맵과 규칙 요약을 담고, AI 가 한 파일만 읽고도 KB 구조를 파악 가능해야 함
- **사람 진입점은 루트 `README.md`** — About 섹션에 "이 KB 가 무엇인지" 명시
- **AGENTS.md** — Claude Code / Codex / Cursor 등 AI 도구가 공통으로 읽는 파일. README.md 와 `.kb/README.md` 로 라우팅
- **각 디렉토리에 `README.md` 필수** — 해당 디렉토리의 목적, 인덱스, 네이밍 규칙 명시 (kb-validator 가 강제)
- **민감 정보는 `.kb/local/`** — gitignored. 커밋 대상 템플릿은 `.kb/local.example/` 에 보관
