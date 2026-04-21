---
title: AI Findability Rules
impact: CRITICAL
impactDescription: Agents find the right doc by structure and naming, not by being told what to do
tags: philosophy, findability, routing, frontmatter
---

## Philosophy

AI 행동을 바꾸려 하지 말고, AI 가 잘 찾을 수 있도록 문서를 최적화한다.

지시문("AI 는 ~해라") 은 agent 종류·버전·세션 상태에 따라 효과가 불안정하다. 반면 문서 구조·파일명·frontmatter 는 어떤 agent 든 동일하게 스캔한다. 따라서 AGENTS.md 와 agents/*.md 는 **행동 규칙 모음이 아니라 탐색 지도** 역할을 해야 한다.

## 6 Core Rules

### 1. Scannable Head

모든 문서 상단 6줄 frontmatter 로 식별 가능해야 한다. agent 는 파일 전부를 읽지 않고 head 만 읽고 관련성을 판단한다. 상세 규칙: references/meta-frontmatter.md

### 2. Summary-First Sections

모든 `##` 섹션 첫 줄은 1문장 요약이다. 이 요약이 섹션 index 역할을 한다 — agent 가 섹션을 더 읽을지 판단하는 기준.

잘못된 예:

```
## API Design
엔드포인트는 다음과 같이 구성된다.
- POST /auth/login
```

올바른 예:

```
## API Design
인증·사용자·결제 3개 도메인의 REST 엔드포인트를 정의한다.
- POST /auth/login
```

### 3. Predictable Paths

신규 문서는 `agents/{topic}.md` 단일 파일로 시작한다. 분량·주제가 증가하면 `agents/{topic}/{N}-{name}.md` 로 분해한다. 이 규칙이 학습되면 agent 는 경로로 내용을 예측한다.

### 4. Self-Describing Names

파일명은 내용을 예측 가능하게 한다.

- 좋음: `workflow.md`, `stack.md`, `writing-rules.md`, `api-reference.md`
- 나쁨: `doc1.md`, `notes.md`, `misc.md`, `info.md`

### 5. Direct References

다른 문서 참조 시 항상 절대 경로를 명시한다.

- 금지: "위 문서 참고", "앞서 설명한대로"
- 권장: `agents/workflow.md 참고`, `agents/stack.md 의 "DB" 섹션 참고`

지시 대명사(이것/그것/저것)를 피하고 대상을 직접 명시한다.

### 6. Terminology Lock

동일 개념은 동일 용어로 고정한다. 문서 전체에서 혼용하지 않는다. 용어가 많아지면 `agents/glossary.md` 를 둔다.

## Anti-Patterns

다음 패턴은 행동 지시이므로 AGENTS.md·guide.md 에 넣지 않는다.

- "AI 는 매 대화마다 ~을 읽어라"
- "AI 는 ~하지 마라"
- "답하기 전에 ~하라"
- "기억에 의존하지 말고 파일을 읽어라"

이런 규칙은 agent 마다 무시·준수 편차가 크다. 대신 **문서 구조·라우팅·frontmatter 로 agent 가 자연스럽게 올바른 문서에 도달하게 한다**.

## 예외

프로젝트 스타일 규칙(응답 언어, 이모지 허용 여부, 네이밍 컨벤션, 커밋 컨벤션 등) 은 행동 규칙이지만 포함해도 된다. 단 AGENTS.md 의 `Project Style` 같은 별도 섹션으로 분리하고, 프로젝트 맥락임을 명확히 한다.

## 왜 이 철학이 중요한가

- 행동 지시문은 agent 가 무시할 수 있음 → findability 최적화는 agent 가 "읽을 수밖에 없게" 만듦
- 행동 지시문은 agent 버전마다 해석이 달라짐 → 구조는 버전 무관
- 지시문이 늘수록 컨텍스트 토큰 소모 → 구조는 head 6줄만 소모
- 셋업 후 사용자가 문서를 추가할 때 일관성 유지 비용 낮음
