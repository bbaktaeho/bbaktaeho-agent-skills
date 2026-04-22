# Knowledge Base Setup Skill — Design

- **Status**: Draft
- **Date**: 2026-04-22
- **Author**: bbaktaeho
- **Related**: `agent-instructions-setup` skill (independent but interoperable)

## 1. Goal

마크다운 기반의 **지식베이스 (Knowledge Base, 이하 KB)** 를 초기 셋업/기존 프로젝트에 retrofit 할 수 있는 스킬을 만든다. 셋업된 KB 는 다음을 만족한다:

- Claude Code / Codex / Cursor 가 진입점 하나만 읽으면 **지식 위치, 관계, 작성 규칙**을 파악한다.
- 새 지식이 생성될 때 AI 가 **어디에 놓을지, 어떤 관계를 가질지** 판단한다. 애매하면 사용자에게 확인한다.
- 지식이 삭제되면 관계를 보유한 다른 지식의 frontmatter 가 **자동 정리**된다.
- 지식베이스 자체를 독립 레포로 쓰거나, 다른 레포에 **submodule 로 붙여** 공유할 수 있다.

## 2. Non-Goals

- Submodule 자동화 (AGENTS.md 자동 링크 삽입 등): 추후 iteration.
- 자체 UI / 웹뷰.
- Vector search / semantic indexing. (태그 기반 인덱싱만)
- 다국어 자동 번역.

## 3. Relationship with `agent-instructions-setup`

완전 독립 스킬이되, 같은 레포에서 공존할 때 AGENTS.md 가 `.kb/README.md` 를 가리키면 AI 가 자동으로 KB 진입점을 찾는다.

```
CLAUDE.md (symlink) → AGENTS.md → ".kb/README.md 참조"
                                           ↓
                                  .kb/README.md (KB 진입점)
```

`agent-instructions-setup` 이 없어도 KB 스킬은 독립 실행된다. 그 경우 사용자가 AGENTS.md 를 나중에 따로 세팅할 때 연결한다.

## 4. Directory Layout

**레포 루트 = KB 루트** 인 경우 (프리셋: research):

```
leo/
├── README.md                    # 사람용 GitHub 랜딩, 짧음
├── .gitignore                   # .kb/.tag-index 포함
├── .kb/
│   ├── README.md                # AI 진입점 (AGENTS.md 가 가리키는 대상)
│   ├── schema.md                # frontmatter 스키마 정의
│   ├── conventions.md           # 관계/네이밍/라이프사이클 규칙
│   ├── preset.json              # {"preset":"research","version":"1.0.0"}
│   └── .tag-index               # gitignored. 태그 인덱스 JSON
├── topics/
│   └── README.md
├── experiments/
│   └── README.md
└── notes/
    └── README.md
```

**KB 가 서브디렉토리** 인 경우: `leo/knowledge/` 아래에 위 구조를 그대로 둔다.

## 5. Presets

사용자가 초기 셋업 시 프리셋을 선택한다.

| Preset | Top-level directories |
|--------|-----------------------|
| `team-docs` | `onboarding/`, `decisions/`, `runbooks/`, `glossary/`, `projects/`, `research/` |
| `research` | `topics/`, `experiments/`, `notes/` |
| `product` | `specs/`, `designs/`, `api/`, `architecture/` |
| `custom` | 없음 (루트 + `.kb/` 만 생성) |

각 프리셋 디렉토리는 전부 `README.md` 템플릿을 포함한다 (frontmatter + "이 디렉토리 역할" 빈 섹션).

`projects/` 와 `research/` 는 서브디렉토리가 생기는 게 자연스럽다:

```
projects/
├── README.md                  # 프로젝트 레지스트리
├── payment-service/
│   ├── README.md
│   ├── spec.md
│   └── retrospective.md
└── ...
```

### 5.1 Terminology

- **runbook**: 반복 작업/장애 대응을 step-by-step 으로 정리한 운영 매뉴얼. ADR (decisions) 가 "왜 결정했는지" 라면 runbook 은 "어떻게 실행하는지".
- **ADR (decisions)**: 아키텍처 결정 기록. 맥락, 결정, 결과.

## 6. Frontmatter Schema

모든 `.md` 파일 (지식 파일 + 디렉토리 README 포함) 에 필수.

```yaml
---
title: string              # 사람이 읽는 제목
created: ISO8601           # kb-validator 가 git log 기준 보정
updated: ISO8601           # kb-validator 가 git log 기준 보정
summary: string            # 1~2줄, AI 첫 스캔 대상
tags: [string]             # 검색/그룹핑. flat array
status: enum               # draft | active | deprecated | archived
relations: [string]        # 상대 경로. flat list
---
```

**필드별 규칙:**
- `created` / `updated`: 사용자가 직접 쓰지 않아도 됨. kb-validator 가 git log 의 첫/마지막 커밋 타임스탬프 기준으로 보정. git 없는 환경에서는 파일 생성 시 AI 가 현재 시각 기입.
- `relations`: flat list. 관계 유형 구분 없음. 상대경로만.
- `status`: `deprecated` / `archived` 이면 AI 는 답변 컨텍스트로 쓰지 않는 게 기본. kb-validator 가 active 문서에서 deprecated 를 참조하는지 권장 경고.
- `tags`: 문자열 배열. 정규화(소문자/하이픈) 는 kb-validator 가 담당.

## 7. Entry Point — `.kb/README.md`

AI 가 가장 먼저 읽는 파일. 아래 섹션을 포함한다:

- **Directory Map**: top-level 디렉토리 이름 + 역할 한 줄
- **Rules 요약**: 대표 규칙 4~5개. 상세는 `conventions.md` 링크
- **Schema 링크**: `schema.md`
- **Tag Index**: `.tag-index` 위치, stale 시 fallback 규칙
- **Lifecycle**: 생성/수정/삭제 때 AI 가 해야 하는 행동
- **Length Guideline**: 권장 1000줄, 시각화 2000줄, 초과 시 분리 검토

한 화면에 끝나는 요약본 성격. 상세는 전부 다른 파일로 링크.

## 8. Relations

### 8.1 새 지식 생성 시 AI 의 관계 판단

1. 본문 작성 후 기존 KB 에서 관련 문서 탐색 (tag-index + grep)
2. **확신 가능한 관계 (strong signal)**: frontmatter `relations` 에 추가
3. **애매한 관계**: 사용자에게 "이 문서를 X 와 연결할까?" 확인
4. 관계 없음이 확실하면 빈 배열

판단 기준은 `conventions.md` 에 정리. 예: 같은 도메인의 상위 개념 문서가 있으면 strong signal.

### 8.2 삭제 시 관계 정리

- **AI 가 삭제**: 삭제 직전 해당 파일을 relations 에 포함한 문서들을 grep → 그 문서들의 relations 에서 제거 → 삭제 실행.
- **사용자가 수동 삭제**: 다음 kb-validator 실행에서 잡음. "relations 가 존재하지 않는 파일을 가리킴" → 필수 항목으로 자동 제거.

### 8.3 양방향 관계

단방향만 지원. A 의 relations 에 B 를 추가해도 B 에 자동으로 A 가 추가되지 않는다. 관계 스키마를 flat 으로 유지하기 위한 결정.

## 9. Tag Index (`.kb/.tag-index`)

### 9.1 Format

```json
{
  "generated_at": "2026-04-22T10:30:00Z",
  "tags": {
    "auth": ["concepts/auth.md", "guides/oauth.md"],
    "security": ["concepts/auth.md", "runbooks/rotate-keys.md"]
  }
}
```

### 9.2 Lifecycle

| 시점 | 주체 | 방식 |
|------|------|------|
| 초기 셋업 | background agent | 전체 스캔, `.tag-index` 생성 |
| AI 가 `.md` 생성/수정/삭제 | AI | 증분 갱신 |
| 사용자 수동 수정 | - | stale 허용 |
| kb-validator 실행 | validator | 전체 재생성 |
| 검색 시 stale 의심 | AI | grep fallback 병행 |

### 9.3 증분 갱신 규칙 (AI 가 수행)

- **생성**: 새 태그 → 파일 경로 추가
- **수정**: 해당 파일을 모든 태그에서 제거 → 현재 frontmatter 태그로 재삽입
- **삭제**: 모든 태그에서 파일 경로 제거 + 빈 태그 키 제거
- `generated_at` 은 전체 재생성 시점만 기록. 증분 갱신은 건드리지 않음.

### 9.4 gitignore

`.kb/.tag-index` 만 gitignore 대상. `.kb/` 전체가 이미 ignore 되어 있으면 경고 (다른 `.kb/` 파일은 커밋되어야 함).

## 10. Execution Flow (스킬 실행 단계)

### Phase 0 — State Scan

- 대상 디렉토리 스캔, 기존 `.kb/` 여부 확인
- AGENTS.md / 도구별 instruction 파일 존재 감지 (참고용)
- 분기: Fresh / Retrofit / Already setup (업그레이드 모드)

### Phase 1 — Interactive Questions

- Q1. KB 루트: 레포 자체 vs 서브디렉토리 (default `knowledge/`)
- Q2. 프리셋: team-docs / research / product / custom
- Q3. AGENTS.md 통합: 스킵 / 경로만 기억

### Phase 2 — Structure Setup

- `.kb/` 생성: `README.md`, `schema.md`, `conventions.md`, `preset.json`
- 프리셋에 따른 top-level 디렉토리 생성, 각 디렉토리에 `README.md` 템플릿 배치
- 루트 `README.md` 생성 (사람용)
- `.gitignore` 생성/업데이트 (`.kb/.tag-index`)

### Phase 3 — Background Tag Indexing

- background agent 가 `.tag-index` 생성 (초기엔 README frontmatter 태그만)

### Phase 4 — Verification

- `.kb/` 파일들 frontmatter 유효성
- `.gitignore` 라인 존재
- 심링크/파일 충돌 없음
- 사용자에게 다음 단계 안내 (첫 지식 추가 → kb-validator 실행)

### Retrofit Mode

기존 프로젝트에 적용할 때:
- 기존 `.md` 문서에 frontmatter 자동 보강 (kb-validator 의 자동 수정 로직 재사용)
- 디렉토리 분류는 사용자에게 확인 (프리셋 매핑 제안)

## 11. kb-validator Skill

같은 플러그인 내 별도 스킬. `knowledge-base-setup` 완료 후 사용자가 필요할 때 실행.

### 11.1 필수 검사 (자동 수정)

- frontmatter 누락 / 형식 오류
- 디렉토리에 `README.md` 없음
- `relations` 경로가 존재하지 않는 파일 → 제거
- `created` / `updated` 가 git log 와 불일치 → 보정
- 삭제된 파일을 가리키는 relations → 제거
- 태그 인덱스 전체 재생성

### 11.2 권장 검사 (사용자 확인 후 수정)

- 파일 길이 1000줄 초과 (시각화 포함 2000줄 초과) → 분리 제안
- `status: deprecated` / `archived` 인데 active 문서가 참조 → 관계 끊기 or status 재검토 제안
- 고아 파일 (어디서도 참조되지 않고 본인도 relations 없음) → 의도 확인
- 태그 정규화 이슈 (대소문자 혼용, 유사 태그 등)

### 11.3 실행 모드

- `quick`: 필수만 검사 / 수정
- `full`: 필수 + 권장 모두. 권장은 diff 보여주고 y/n
- `dry-run`: 수정 없이 리포트만

## 12. Usage — Submodule Scenario

호스트 레포가 KB 를 submodule 로 가져와 쓰는 경우 (자동화는 non-goal):

```
host-repo/
├── AGENTS.md                    # 호스트가 직접 추가한 링크
│   → "지식베이스: ./kb/.kb/README.md 참조"
└── kb/                          # submodule
    ├── .kb/
    │   └── README.md
    └── ...
```

호스트 레포의 AGENTS.md 에 `./kb/.kb/README.md` 참조를 사용자가 직접 넣는다. kb-validator 는 submodule 내부에서도 문제없이 동작 (git log 는 submodule 의 것 기준).

## 13. Plugin / Skill Structure

```
plugins/knowledge-base-setup/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    ├── knowledge-base-setup/
    │   ├── SKILL.md
    │   └── references/
    │       ├── _sections.md
    │       ├── rule-frontmatter-schema.md
    │       ├── rule-relations.md
    │       ├── rule-lifecycle.md
    │       ├── rule-length-guideline.md
    │       ├── template-kb-readme.md          # .kb/README.md 템플릿
    │       ├── template-schema.md             # .kb/schema.md 템플릿
    │       ├── template-conventions.md        # .kb/conventions.md 템플릿
    │       ├── template-dir-readme.md         # 디렉토리 README 템플릿
    │       ├── template-root-readme.md        # 루트 사람용 README 템플릿
    │       ├── preset-team-docs.md
    │       ├── preset-research.md
    │       ├── preset-product.md
    │       ├── preset-custom.md
    │       ├── ask-questions.md               # Phase 1 질문 목록
    │       └── flow-retrofit.md
    └── kb-validator/
        ├── SKILL.md
        └── references/
            ├── _sections.md
            ├── rule-required-checks.md
            ├── rule-recommended-checks.md
            ├── rule-git-timestamp-sync.md
            ├── rule-tag-index-rebuild.md
            └── flow-modes.md
```

## 14. Open Questions (Post-approval)

- Retrofit 시 기존 `.md` 파일의 tags 자동 추출 여부 (본문에서 키워드 뽑기?) — 일단 비워두고 사용자 확인.
- `conventions.md` 에 넣을 "관계 판단 strong signal" 구체 기준 — 구현 시점에 다듬기.
- 디렉토리 README 가 본인 디렉토리의 자식 문서들을 relations 로 가져야 하는가? — 일단 **No**. 자식은 tag/디렉토리로 자연 그룹핑.

## 15. Success Criteria

- 빈 디렉토리에 스킬 1회 실행 후, AI 가 `.kb/README.md` 만 읽고 "지식을 어디 추가할지" 결정 가능.
- 10개 지식 추가 후 kb-validator full 실행 시 수정 항목 0개.
- 호스트 레포가 submodule 로 가져온 KB 를 수정 없이 사용 가능.
