---
title: Agents Directory Layout Overview
impact: HIGH
impactDescription: AI 가 한눈에 instruction 구조를 파악하도록 단일 진입점과 디렉토리 배치를 정의
tags: layout, structure, directory, agents, meta
---

# Agents Directory Layout

`AGENTS.md` 는 라우팅 루트, 컨텐츠는 `agents/`, 메타는 `.agents/` 에 격리한다. 지식베이스 (`.kb/`) 와 동일한 패턴.

## 전체 트리

```
{repo}/
├── AGENTS.md                          # 라우팅 루트 (50줄 이내 슬림)
├── README.md                          # 사람용 GitHub 랜딩
├── .gitignore                         # .agents/.tag-index, .agents/local/ 포함
├── .agents/                           # 메타만 격리
│   ├── README.md                      # AI 탐색 진입점 (디렉토리 맵, 규칙 요약)
│   ├── schema.md                      # agents/*.md frontmatter 스키마
│   ├── conventions.md                 # findability / lifecycle / 네이밍
│   ├── preset.json                    # meta-validator 가 참조
│   ├── .tag-index                     # gitignored. 태그 인덱스
│   ├── hooks/
│   │   └── pre-commit-secrets.sh      # agents/ + .agents/ 민감정보 차단
│   ├── local/                         # gitignored. 로컬 전용 메모
│   └── local.example/                 # 커밋 대상. 로컬 파일 템플릿
└── agents/
    ├── guide.md                       # 라우팅 인덱스 (80줄 이내)
    ├── workflow.md
    ├── onboarding.md  (project)
    ├── team.md        (project)
    ├── glossary.md    (project)
    ├── security.md    (project)
    ├── decisions/, rfc/, runbook/, postmortem/  (project, T3 선택)
    ├── projects/, tech-radar.md, infrastructure.md, ...  (hub, HUB4 선택)
    └── ...
```

## 핵심 원칙

- **AI 진입점은 `.agents/README.md`** — 디렉토리 맵과 규칙 요약. AI 가 한 파일만 읽고도 구조 파악 가능
- **사람 진입점은 `AGENTS.md`** — 50줄 이내 라우팅 루트
- **`agents/` 는 컨텐츠 디렉토리** — guide.md, workflow.md, 도메인별 문서. 80~150줄 권장
- **메타는 `.agents/` 에만** — schema / conventions / preset.json / hooks / local. 컨텐츠 섞지 않음
- **각 `agents/` 하위 디렉토리에 `README.md` 필수** — meta-validator 가 강제
- **민감 정보는 `.agents/local/`** — gitignored. 커밋 대상 템플릿은 `.agents/local.example/`

## `.kb/` 와의 관계

같은 레포에 지식베이스 (`.kb/`) 와 instruction 셋업 (`.agents/`) 이 공존 가능. 두 메타 디렉토리는 독립적으로 유지되며 각자의 컴패니언 스킬 (`kb-validator`, `meta-validator`) 이 검증한다. 둘 다 셋업되어 있으면 `AGENTS.md` 에 README + `.kb/README.md` + `.agents/README.md` 모두 라우팅.

## fallback 디렉토리 이름

기존 소스에 `agents/` 디렉토리가 충돌하면 컨텐츠 디렉토리는 `_agents/` 로 fallback. 메타 디렉토리는 항상 `.agents/`.
