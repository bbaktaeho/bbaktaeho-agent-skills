---
title: AGENTS.md Common Template
impact: CRITICAL
impactDescription: Provides the base AGENTS.md with essential rules for all AI agents
tags: agents-md, template, rules, setup
---

## AGENTS.md 공통 템플릿

아래 템플릿으로 AGENTS.md를 생성한다. `{placeholder}`는 사용자 답변으로 치환한다.

```markdown
# {Project Name}

{프로젝트 1줄 설명}

## Rules

- 이모지를 사용하지 마라.
- 응답의 마지막에는 읽은 파일을 나열해라.
- 답하기 전에 한번 더 검토해라.
- 파일 경로, 함수명, API를 언급할 때는 반드시 실제 파일을 읽고 확인한 것만 사용해라. 추측하지 마라.
- 파일을 수정하기 전에 해당 파일을 먼저 읽어라. 기억에 의존하지 마라.
- 확실하지 않은 내용은 "확실하지 않다"고 말해라. 그럴듯하게 지어내지 마라.
- 요청받은 범위만 작업해라. 요청하지 않은 리팩토링, 개선, 추가 기능을 임의로 하지 마라.
- 작업을 시작하기 전에 반드시 docs/guide.md를 읽어라.
- 적절한 skill이 있는지 찾아보고, 있다면 참고해라.

## Documentation

상세 가이드는 아래 문서를 참고한다.

- [docs/guide.md](docs/guide.md) - 프로젝트 가이드
- [docs/workflow.md](docs/workflow.md) - 작업 워크플로우
```

## 사용 방법

1. 위 템플릿의 `{Project Name}`과 `{프로젝트 1줄 설명}`을 사용자에게 물어 치환한다
2. 사용자가 추가 규칙을 원하면 Rules 섹션에 추가한다
3. 프로젝트 용도에 따라 Documentation 섹션의 링크를 조정한다
