---
title: AI Findability Rules
impact: CRITICAL
impactDescription: Agents find the right doc by routing chain and frontmatter, not by behavior rules
tags: philosophy, findability, routing, frontmatter, readme-chain
---

## Philosophy

AI 행동을 바꾸려 하지 말고, AI 가 잘 찾을 수 있도록 문서를 최적화한다.

지시문 ("AI 는 ~해라") 은 agent 종류·버전·세션 상태에 따라 효과가 불안정하다. 반면 README 체인 + frontmatter 는 어떤 agent 든 동일하게 스캔한다. 따라서 AGENTS.md / `.agents/README.md` / `<dir>/README.md` 는 **행동 규칙 모음이 아니라 라우팅 지도** 역할을 해야 한다.

## Routing Chain

```
도구 심링크 → AGENTS.md → .agents/README.md → <dir>/README.md → 상세
```

각 hop 은 **head 8줄 frontmatter + 한 화면 분량 본문**. AI 가 head 만 읽고 다음 hop 으로 진행 가능해야 한다.

## 6 Core Rules

### 1. Scannable Head

라우팅 README 모두 상단 6~8줄 frontmatter 로 식별. 상세: references/meta-frontmatter.md

### 2. Summary-First Sections

모든 `##` 섹션 첫 줄은 1문장 요약. 이 요약이 섹션 index — agent 가 더 읽을지 판단하는 기준.

잘못된 예:

```
## Contents
| 경로 | 역할 |
| --- | --- |
| ./api/ | ... |
```

올바른 예:

```
## Contents

이 디렉토리는 백엔드 / 프론트엔드 / 공유 타입 3개 모듈을 포함한다.

| 경로 | 역할 |
| --- | --- |
| ./api/ | ... |
```

### 3. README Per Directory

라우팅 hop 의 디렉토리는 항상 `README.md` 가 진입점. 디렉토리에 들어와 즉시 무엇이 있는지 파악 가능.

- 새 상위 디렉토리 추가 → README.md 동시 추가 + `.agents/README.md` 라우팅 표 갱신
- 디렉토리 깊이 증가 → 하위 README.md 추가 (template-dir-readme.md 의 "하위 디렉토리 README" 참조)

### 4. Self-Describing Names

파일명·디렉토리명은 내용을 예측 가능하게 한다.

- 좋음: `docs/`, `src/`, `scripts/`, `payments-api.md`, `setup-guide.md`
- 나쁨: `misc/`, `etc/`, `doc1.md`, `notes.md`

### 5. Direct References

다른 문서 참조 시 항상 상대/절대 경로 명시.

- 금지: "위 문서 참고", "앞서 설명한대로"
- 권장: `../docs/api/README.md 참고`, `.agents/conventions.md 의 "Naming" 섹션 참고`

지시 대명사 (이것/그것/저것) 를 피하고 대상을 직접 명시한다.

### 6. Terminology Lock

동일 개념은 동일 용어로 고정. 문서 전체에서 혼용하지 않는다.

## Anti-Patterns

다음 패턴은 행동 지시이므로 AGENTS.md / `.agents/README.md` / `<dir>/README.md` 에 넣지 않는다.

- "AI 는 매 대화마다 ~을 읽어라"
- "AI 는 ~하지 마라"
- "답하기 전에 ~하라"
- "기억에 의존하지 말고 파일을 읽어라"

이런 규칙은 agent 마다 무시·준수 편차가 크다. 대신 **README 체인·frontmatter 로 agent 가 자연스럽게 올바른 문서에 도달하게 한다**.

## 예외

프로젝트 스타일 규칙 (응답 언어, 이모지 허용 여부, 네이밍 컨벤션, 커밋 컨벤션 등) 은 행동 규칙이지만 포함해도 된다. 단 AGENTS.md 의 `Project Style` 같은 별도 섹션으로 분리하고, 프로젝트 맥락임을 명확히 한다.

## 왜 이 철학이 중요한가

- 행동 지시문은 agent 가 무시할 수 있음 → README 체인은 agent 가 "읽을 수밖에 없게" 만듦
- 행동 지시문은 agent 버전마다 해석이 달라짐 → 구조는 버전 무관
- 지시문이 늘수록 컨텍스트 토큰 소모 → frontmatter 8줄만 소모해도 라우팅 가능
- 사용자가 디렉토리를 추가할 때 README.md 만 추가하면 라우팅이 자동 확장. 별도 카탈로그 갱신 비용 없음
