---
name: knowledge-base-setup
description: >
  Markdown knowledge base init and retrofit. Creates .kb/ meta dir
  (AI entry point, schema, conventions, tag-index) plus preset top-
  level dirs (team-docs, research, product, custom). Every .md file
  carries required frontmatter (title, created, updated, summary,
  tags, status, relations - flat list of relative paths). Adds
  .gitignore for .kb/.tag-index and .kb/local/, background-indexes
  tags, and installs a git pre-commit hook that blocks secrets
  (credentials, tokens, private keys, basic-auth URLs, internal
  endpoints). Lets AI tools (Claude Code, Codex, Cursor) read one
  entry point and immediately know where knowledge lives, how docs
  relate, and where to place new knowledge. Use when initializing a
  repo as a shared KB, adding a KB to an existing project, preparing
  docs for submodule use, standardizing team research or runbooks,
  or making markdown docs AI-navigable - even if the user only says
  "docs init", "research base", "set up wiki", or "block secrets".
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: >
    Init and retrofit skill for markdown knowledge bases. Phase 0 scans
    state, Phase 1 asks Q1~Q3 (root location, preset, AGENTS.md
    integration), Phase 2 creates .kb/ meta directory with README.md
    (AI entry point), schema.md, conventions.md, preset.json, plus
    preset top-level directories each carrying a README.md template.
    Phase 3 background-indexes tags to .kb/.tag-index. Phase 4
    verifies. Complementary kb-validator skill syncs timestamps from
    git log, prunes broken relations, rebuilds tag-index, and enforces
    length and README-per-directory rules. Philosophy: AI-first
    findability. .kb/README.md is the single AI entry point; knowledge
    lives at root; submodule-friendly.
---

# Knowledge Base Setup

마크다운 기반 지식베이스 (KB) 를 초기 셋업하거나 기존 프로젝트에 retrofit 한다. `.kb/README.md` 를 AI 단일 진입점으로 두고, 지식들은 루트 경로에 배치한다.

## Core Philosophy

"지식의 위치와 관계를 AI 가 한 파일 (`.kb/README.md`) 만 읽고 파악할 수 있도록 구조화한다."

상세: references/rule-frontmatter-schema.md, references/rule-relations.md, references/rule-lifecycle.md, references/rule-secrets-handling.md

## Directory Layout

```
{kb-root}/
├── README.md                    # 사람용 GitHub 랜딩
├── .gitignore                   # .kb/.tag-index 포함
├── .kb/
│   ├── README.md                # AI 진입점
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

`{kb-root}` 는 레포 자체이거나 서브디렉토리 (`knowledge/` 기본).

## Execution Flow

### Phase 0: State Scan

1. 대상 디렉토리 스캔: 기존 `.kb/`, `README.md`, `.gitignore` 유무 확인
2. AGENTS.md / CLAUDE.md 등 감지 (참고용. 변경 안함)
3. 모드 분기:
   - Fresh → Phase 1
   - `.kb/` 이미 존재 → 업그레이드 모드 (references/flow-retrofit.md)
   - 마크다운 문서 이미 다수 존재 → retrofit 모드 (references/flow-retrofit.md)

### Phase 1: Interactive Questions

Q1~Q3 질문: references/ask-questions.md

- Q1. KB 루트: 레포 자체 vs 서브디렉토리 (기본 `knowledge/`)
- Q2. 프리셋: team-docs / research / product / custom
- Q3. AGENTS.md 통합 여부 (스킵 / 경로 기억)

### Phase 2: Structure Setup

1. `.kb/` 생성:
   - `README.md` (references/template-kb-readme.md)
   - `schema.md` (references/template-schema.md)
   - `conventions.md` (references/template-conventions.md)
   - `preset.json` (Q2 결과 반영)
2. 루트 `README.md` 생성 (references/template-root-readme.md)
3. 프리셋별 디렉토리 생성 + 각 디렉토리 `README.md` (references/template-dir-readme.md)
   - team-docs: references/preset-team-docs.md
   - research: references/preset-research.md
   - product: references/preset-product.md
   - custom: references/preset-custom.md
4. `.gitignore` 생성/업데이트 (`.kb/.tag-index`, `.kb/local/` 추가, 멱등)
5. `.kb/local/` 디렉토리 + `.kb/local.example/` 템플릿 디렉토리 생성 (references/rule-secrets-handling.md)
   - `.kb/local/README.md` (gitignored 사본) — 이 디렉토리가 왜 gitignored 인지 설명
   - `.kb/local.example/README.md` — 로컬 파일 템플릿 사용 방법
6. `.kb/hooks/pre-commit-secrets.sh` 생성 + `chmod +x` (references/template-pre-commit-hook.md)
7. `.git/hooks/pre-commit` 자동 연결:
   - 없으면 symlink: `ln -sfn ../../.kb/hooks/pre-commit-secrets.sh .git/hooks/pre-commit`
   - 이미 다른 훅이 있으면 덮어쓰지 않고 사용자에게 병합 안내

### Phase 3: Background Tag Indexing

5. Task / background agent 가 `.tag-index` 생성 (초기엔 README frontmatter 태그 수집)

### Phase 4: Verification

8. `.kb/` 파일 frontmatter 유효성 확인
9. 각 디렉토리에 `README.md` 존재 확인
10. `.gitignore` 에 `.kb/.tag-index` / `.kb/local/` 라인 존재 확인
11. `.git/hooks/pre-commit` 가 `.kb/hooks/pre-commit-secrets.sh` 로 연결되었는지 확인
12. pre-commit 훅 self-test: `.kb/hooks/pre-commit-secrets.sh` 를 실행하여 정상 종료하는지 확인
13. 사용자에게 다음 단계 안내: 첫 지식 추가 → kb-validator 실행

### Retrofit Mode (기존 프로젝트)

references/flow-retrofit.md 참조. 기존 `.md` 에 frontmatter 보강, 디렉토리 매핑 제안.

## Reference Categories

| Priority | Category | Prefix | 대표 파일 |
|----------|----------|--------|-----------|
| CRITICAL | Frontmatter / Relations / Lifecycle | `rule-` | frontmatter-schema, relations, lifecycle |
| CRITICAL | Secrets Handling | `rule-` | secrets-handling |
| CRITICAL | Length Guidelines | `rule-` | length-guideline |
| HIGH | Meta Templates | `template-` | kb-readme, schema, conventions |
| HIGH | Knowledge Templates | `template-` | root-readme, dir-readme |
| HIGH | Hook Template | `template-` | pre-commit-hook |
| HIGH | Presets | `preset-` | team-docs, research, product, custom |
| HIGH | Flow | `ask-`, `flow-` | questions, retrofit |

전체 목록: references/_sections.md

## Companion Skill

`kb-validator` — 같은 플러그인 내 별도 스킬. 초기 셋업 후 지식이 쌓이면 주기적으로 실행하여 frontmatter, 관계, 타임스탬프, 태그 인덱스, 길이를 검증/자동수정한다.

## References

- https://agents.md
- https://diataxis.fr (디렉토리 분류 철학)
