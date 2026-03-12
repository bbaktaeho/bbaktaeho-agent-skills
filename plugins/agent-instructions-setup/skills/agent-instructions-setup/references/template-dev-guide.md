---
title: Development Project Guide Template
impact: HIGH
impactDescription: Provides consistent project guide structure for development projects
tags: template, guide, development, project
---

## 개발용 guide.md 템플릿

개발용 프로젝트의 guide.md를 생성할 때 이 템플릿을 기반으로 한다. `{placeholder}`는 사용자 답변으로 치환한다.

```markdown
---
title: {Project Name} Guide
description: 프로젝트 핵심 구조와 기술 스택 설명
type: guide
created: {YYYY-MM-DD}
---

# Project Guide

## Tech Stack

- {언어/프레임워크}
- {데이터베이스}
- {기타 주요 기술}

## Project Structure

> 이 구조는 개발 진행에 따라 변경될 수 있다. 변경 시 이 섹션을 갱신한다.

{디렉토리 구조}

## Key Modules

- {모듈 1} - {역할}
- {모듈 2} - {역할}

## Build & Run

{빌드 명령어}
{실행 명령어}
{테스트 명령어}

## Development Log

개발 일지는 `docs/develop/daily/` 에 작성한다.

파일 형식: `{YYYY-MM-DD}-{개발한 내용 요약}.md`

예시: `2026-03-12-auth-api-구현.md`

## Workflow

작업 워크플로우는 [docs/workflow.md](workflow.md)를 참고한다.

## Additional Docs

필요시 아래 문서를 추가한다:
- docs/{topic}.md

특정 토픽의 문서가 여러 개가 되면 디렉토리로 분리한다:

순서가 있는 문서:
- docs/{topic}/001-{상세내용}.md
- docs/{topic}/002-{상세내용}.md

순서가 없는 문서:
- docs/{topic}/{상세내용}.md
```
