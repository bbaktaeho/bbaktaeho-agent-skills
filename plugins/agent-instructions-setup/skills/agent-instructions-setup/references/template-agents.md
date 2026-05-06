---
title: AGENTS.md Template
impact: CRITICAL
impactDescription: AGENTS.md 는 라우팅 체인의 1번째 hop. 50줄 이내 슬림 진입점
tags: agents-md, template, routing, root, entry-point
---

## Purpose

AGENTS.md 는 행동 규칙 모음이 아니라 **라우팅 체인의 진입점** 이다. 도구별 instruction 파일 (`CLAUDE.md`, `.cursorrules`, `GEMINI.md` 등) 이 모두 이 파일을 가리키게 심링크한다.

라우팅 체인:

```
도구 심링크 → AGENTS.md → .agents/README.md → <dir>/README.md → 상세
```

AGENTS.md 본인은 가능한 한 짧게 (50줄 이내). 모든 상세 라우팅은 `.agents/README.md` 가 담당한다.

## 생성 경로

`{repo}/AGENTS.md`

## Template

```markdown
# {Project Name}

{프로젝트 1줄 설명}

## Entry Point

작업을 시작하기 전에 `.agents/README.md` 를 읽는다. 이 파일이 상위 디렉토리 요약과 라우팅 표를 제공한다.

상세 라우팅:

- `.agents/README.md` — 라우팅 인덱스 (개요 + 상위 디렉토리 요약 + 라우팅 표)
- `<top-level-dir>/README.md` — 각 도메인의 라우팅 README (예: `docs/README.md`, `src/README.md`)
- `.agents/schema.md` — README.md frontmatter 스키마
- `.agents/conventions.md` — 네이밍 / lifecycle / findability 규칙

## Project Style

{Q6 스타일 답변. 답변이 없으면 이 섹션 자체를 생략한다.}

예시:
- 응답 언어: 한국어
- 이모지 사용 금지
- 커밋 컨벤션: Conventional Commits
```

## 작성 가이드

1. `{Project Name}` 과 `{프로젝트 1줄 설명}` 은 Q1, Q2 답변으로 치환
2. `Project Style` 섹션은 Q6 답변이 있을 때만 포함. 없으면 섹션 제목까지 제거
3. **행동 지시문을 넣지 않는다**. 금지 예시:
   - "AI 는 매 대화마다 .agents/README.md 를 읽어라"
   - "답하기 전에 한번 더 검토해라"
   - "기억에 의존하지 말고 파일을 먼저 읽어라"
   - 이유: references/rule-findability.md 의 Anti-Patterns 참조
4. "Entry Point" 섹션의 "`.agents/README.md` 를 읽는다" 는 행동 지시가 아니라 **라우팅 지도** 이므로 허용
5. AGENTS.md 가 50줄을 넘기면 본문을 `.agents/README.md` 또는 `<dir>/README.md` 로 옮긴다. AGENTS.md 자체는 항상 라우팅 진입점으로만 유지
6. AGENTS.md 자체에 frontmatter 는 두지 않는다. 도구별 호환을 위해 `# {Project Name}` 부터 시작

## 병합 모드 (기존 instruction 파일이 있을 때)

references/link-symlink-strategy.md 의 "병합 절차" 에 따라 기존 파일 내용을 흡수한다. 단 다음 원칙을 적용:

- Anti-Pattern (행동 지시문) 에 해당하는 내용은 **제외** 하거나 `Project Style` 섹션으로 재분류
- 프로젝트 구조·모듈 설명은 AGENTS.md 가 아니라 `.agents/README.md` 또는 해당 `<dir>/README.md` 로 이동
- 워크플로우·PR 규칙은 `<dir>/README.md` (예: `docs/development/README.md`) 로 이동
- AGENTS.md 는 끝까지 라우팅 진입점으로만 남긴다

## 검증

심링크 확인:

```bash
diff AGENTS.md CLAUDE.md   # 동일 내용이어야 함
diff AGENTS.md GEMINI.md   # 동일 내용이어야 함
```

AGENTS.md 가 `.agents/README.md` 를 본문에 명시하는지 확인:

```bash
grep -E '\.agents/README\.md' AGENTS.md
```

## 멱등 마커 (재셋업 안전성)

AGENTS.md 를 재생성/병합할 때 사용자 추가 내용을 보존하기 위해 자동 생성 영역을 마커로 감쌀 수 있다.

```markdown
<!-- agent-instructions-setup:start -->
## Entry Point
...
<!-- agent-instructions-setup:end -->
```

마커 사이 내용은 재실행 시 덮어쓰기. 마커 밖 사용자 작성 내용은 보존.
