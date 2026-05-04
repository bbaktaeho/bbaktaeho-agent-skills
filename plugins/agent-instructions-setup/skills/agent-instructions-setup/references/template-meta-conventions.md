---
title: .agents/conventions.md Template
impact: CRITICAL
impactDescription: agents 문서의 findability / lifecycle / 네이밍 규칙
tags: template, conventions, findability, lifecycle
---

# `.agents/conventions.md`

agents 문서가 따라야 하는 운영 규칙. AGENTS.md 의 행동 지시문이 아니라 **문서 작성 / 진화** 규칙.

## 생성 경로

`{repo}/.agents/conventions.md`

## Template

```markdown
---
title: Agents Conventions
created: {ISO8601}
updated: {ISO8601}
summary: agents/ 문서의 작성·진화·네이밍 규칙. AI 가 빠르게 찾고 정확하게 갱신할 수 있도록 설계.
tags: [meta, conventions, findability, lifecycle]
status: active
relations:
  - ./README.md
  - ./schema.md
---

# Conventions

## Findability First

문서는 "AI 가 찾기 쉽게" 작성한다. 행동 지시문은 금지.

- **OK**: "/payments 도메인 작업 전에 `agents/security.md` 의 PII 규칙을 확인한다."
- **NG**: "AI 는 매 대화마다 guide.md 를 읽어라."

상세는 agent-instructions-setup 의 references/rule-findability.md 참조.

## Naming

- 파일명: 소문자 + 하이픈, kebab-case (`workflow.md`, `dev-loop.md`)
- 디렉토리명: 복수형 권장 (`decisions/`, `runbooks/`)
- 단일 주제 → 파일, 복수 주제 → 디렉토리 + README.md

## Length Targets

| 파일 | Target | Soft warn | Hard warn |
|------|--------|-----------|-----------|
| `AGENTS.md` | 50줄 | 80줄 | 120줄 |
| `agents/guide.md` | 80줄 | 100줄 | 150줄 |
| `agents/*.md` | 80줄 | 100줄 | 150줄 |
| 디렉토리 README.md | 50줄 | 80줄 | 120줄 |

길이 초과 시 분할 권장. `tags: [length-exempt]` 추가하면 검사 제외.

## Lifecycle

- 신규 문서: `status: draft` 로 시작. 사용자 검토 후 `active` 승급
- 더 이상 유효하지 않은 문서: `status: deprecated`. 가능하면 `relations` 로 후속 문서 링크
- 역사적 기록: `status: archived`. AI 답변에서 제외
- 삭제 대신 archived 권장 (history 보존)

## Relations

- 양방향 권장: 자주 함께 읽히는 두 문서는 서로의 `relations` 에 포함
- broken link: meta-validator 가 자동 제거. 의도된 경우 `<!-- meta-validator: keep-broken -->` 으로 우회

## File 분해 기준

한 파일이 hard warn (150줄) 을 넘으면 다음 패턴으로 분해:

\`\`\`
agents/{topic}.md          # 단일 파일
↓ 분해
agents/{topic}/
├── README.md               # 요약 + 라우팅
├── overview.md
├── details-{aspect}.md
└── ...
\`\`\`

## 새 문서 추가 시

1. AGENTS.md / .agents/README.md / agents/guide.md 의 Directory Map 또는 라우팅 테이블 업데이트
2. frontmatter `created` 만 채우고 `updated` 는 동일하게 시작
3. `relations` 에 가장 가까운 인접 문서 1~2개 포함
4. 첫 머지 후 meta-validator 1회 실행으로 timestamps 동기화

## 민감 정보

- API 키 / 토큰 / 내부 호스트 / 사용자명+비밀번호 URL 은 .agents/local/ 에만
- 본문에는 `{API_KEY}` / `${ENV_VAR}` 같은 placeholder
- pre-commit hook (`.agents/hooks/pre-commit-secrets.sh`) 이 커밋 차단
- false positive: 같은 줄에 `<!-- agents-secrets: allow -->` 추가
```

## 작성 가이드

- conventions.md 본문은 80줄 이내 권장. 길어지면 항목별로 분리
- 행동 지시문 (must / should not) 보다 **사실 진술** + **예시** 위주
