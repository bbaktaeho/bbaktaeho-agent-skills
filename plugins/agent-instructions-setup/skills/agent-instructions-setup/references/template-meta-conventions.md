---
title: .agents/conventions.md Template
impact: CRITICAL
impactDescription: README 체인 문서의 findability / lifecycle / 네이밍 규칙
tags: template, conventions, findability, lifecycle, readme-chain
---

# `.agents/conventions.md`

라우팅 체인 README 가 따라야 하는 운영 규칙. 행동 지시문이 아니라 **문서 작성 / 진화** 규칙.

## 생성 경로

`{repo}/.agents/conventions.md`

## Template

```markdown
---
title: Routing Conventions
created: {ISO8601}
updated: {ISO8601}
summary: README 체인 문서의 작성·진화·네이밍 규칙. AI 가 빠르게 찾고 정확하게 갱신할 수 있도록 설계.
tags: [meta, conventions, findability, lifecycle, readme]
status: active
relations:
  - ./README.md
  - ./schema.md
---

# Conventions

## Routing Chain

```
도구 심링크 → AGENTS.md → .agents/README.md → <dir>/README.md → 상세
```

각 hop 은 짧게 유지. AI 가 head frontmatter 만 읽고 다음 hop 으로 진행 가능해야 한다.

## Findability First

문서는 "AI 가 찾기 쉽게" 작성한다. 행동 지시문은 금지.

- **OK**: "결제 도메인 작업 전에 `apps/payments/README.md` 를 읽는다." (라우팅 진술)
- **NG**: "AI 는 매 대화마다 .agents/README.md 를 읽어라." (행동 지시)

상세는 agent-instructions-setup 의 references/rule-findability.md 참조.

## Naming

- 파일명: 소문자 + 하이픈, kebab-case (`setup-guide.md`, `payments-api.md`)
- 디렉토리명: 단/복수 자유. 단 라우팅 표에 명시한 이름과 일치
- 라우팅 진입은 항상 `<dir>/README.md`. 단일 파일로 충분하면 디렉토리 만들지 않음

## Length Targets

| 파일 | Target | Soft warn | Hard warn |
|------|--------|-----------|-----------|
| `AGENTS.md` | 50줄 | 80줄 | 120줄 |
| `.agents/README.md` | 80줄 | 120줄 | 200줄 |
| `<dir>/README.md` (모든 깊이) | 80줄 | 120줄 | 200줄 |
| 일반 콘텐츠 파일 | 자유 | — | — |

라우팅 README 가 hard warn 을 넘으면 하위 README 로 분해. `tags: [length-exempt]` 추가하면 검사 제외.

## Lifecycle

- 신규 문서: `status: draft` 로 시작. 사용자 검토 후 `active` 승급
- 더 이상 유효하지 않은 문서: `status: deprecated`. 가능하면 `relations` 로 후속 문서 링크
- 역사적 기록: `status: archived`. AI 답변에서 제외
- 삭제 대신 archived 권장 (history 보존)

## Relations

- 양방향 권장: 라우팅 표의 부모 ↔ 자식 README 는 서로의 `relations` 에 포함
- broken link: meta-validator 가 자동 제거. 의도된 경우 `<!-- meta-validator: keep-broken -->` 으로 우회

## File 분해 기준

라우팅 README 가 hard warn (200줄) 을 넘으면 다음 패턴으로 분해.

\`\`\`
<dir>/README.md            # 단일 라우팅
↓ 분해
<dir>/
├── README.md              # 그룹별 라우팅 (얇은 인덱스)
├── <group-a>/README.md
└── <group-b>/README.md
\`\`\`

## 새 README 추가 시

1. 한 단계 위 README 의 라우팅 표에 한 행 추가
2. frontmatter `created` 만 채우고 `updated` 는 동일하게 시작 — 이후 meta-validator 가 git log 로 보정
3. `relations` 에 한 단계 위 README 1개 + 인접 형제 README 1~2개 포함
4. 첫 머지 후 meta-validator 1회 실행으로 timestamps 동기화

## 민감 정보

- API 키 / 토큰 / 내부 호스트 / 사용자명+비밀번호 URL 은 `.agents/local/` 에만
- 본문에는 `{API_KEY}` / `${ENV_VAR}` 같은 placeholder
- pre-commit hook (`.agents/hooks/pre-commit-secrets.sh`) 이 커밋 차단
- false positive: 같은 줄에 `<!-- agents-secrets: allow -->` 추가
```

## 작성 가이드

- conventions.md 본문은 80~120줄 이내 권장. 길어지면 항목별로 분리
- 행동 지시문 (must / should not) 보다 **사실 진술** + **예시** 위주
