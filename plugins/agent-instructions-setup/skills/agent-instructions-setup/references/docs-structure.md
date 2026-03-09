---
title: Delegate Details to docs/ Directory
impact: HIGH
impactDescription: Keeps AGENTS.md concise and prevents token bloat as project documentation grows
tags: agents-md, docs, guide, workflow, structure
---

## docs/ 디렉토리 구조

AGENTS.md가 길어지면 agent가 불필요한 토큰을 소비한다. 상세 내용은 `docs/` 디렉토리로 분리하고 AGENTS.md에서는 참조만 한다.

## 필수 파일

| 파일 | 역할 |
|------|------|
| `docs/guide.md` | 프로젝트 가이드. 간결한 핵심 정보만 담는다 |
| `docs/workflow.md` | 개발 워크플로우. 브랜치 전략, PR 프로세스, 배포 절차 등 |

## AGENTS.md에서의 참조 방법

AGENTS.md에는 최소한의 프로젝트 정보만 두고 docs/를 가리킨다.

```markdown
# Project Name

프로젝트 1줄 설명.

## Documentation

상세 가이드는 아래 문서를 참고한다.

- [docs/guide.md](docs/guide.md) - 프로젝트 가이드
- [docs/workflow.md](docs/workflow.md) - 개발 워크플로우
```

## docs/guide.md 작성 원칙

- 간단 명료하게 작성한다. 장황한 설명을 넣지 않는다
- 프로젝트 구조, 주요 모듈, 기술 스택 등 핵심 정보를 담는다
- 개발 시 workflow.md를 참고하라고 명시한다
- 추가 문서가 필요하면 guide.md에서 `docs/<topic>.md`를 참조한다

```markdown
# Project Guide

## Tech Stack

- Go 1.24
- PostgreSQL 16
- Redis 7

## Project Structure

cmd/           - 실행 진입점
internal/      - 비공개 패키지
pkg/           - 공개 패키지

## Key Modules

- internal/auth - 인증 처리
- internal/api  - API 핸들러

## Development

개발 워크플로우는 [docs/workflow.md](workflow.md)를 참고한다.

## Additional Docs

- [docs/api-spec.md](api-spec.md) - API 명세
```

## docs/workflow.md 작성 원칙

- 개발자가 실제 작업할 때 따라야 하는 절차를 순서대로 기술한다
- 브랜치 전략, 커밋 컨벤션, PR 프로세스, 코드 리뷰, 배포 절차를 포함한다
- 코드 구현 워크플로우를 포함한다

```markdown
# Development Workflow

## Branch Strategy

main          - production
develop       - 개발 통합
feature/*     - 기능 개발
fix/*         - 버그 수정

## Commit Convention

type: subject

type: feat, fix, refactor, docs, test, chore

## Implementation Workflow

코드를 구현할 때 다음 절차를 따른다. 매 단계에서 관련 스킬이 있는지 확인한다.

1. 계획 수립
2. 계획 검토
3. 구현
4. 구현이 목적에 부합하는지 검토
5. 잠재적 버그, 크리티컬 이슈, 보안 문제 검토
6. 개선 사항에 문제가 없는지 검토
7. 기존 코드와 통합/재사용 가능 여부 검토
8. 사이드 이펙트 검토
9. 전체 변경 사항 재검토
10. 불필요해진 코드 정리
11. 최종 코드 품질 검토
12. 사용자 흐름에서 문제가 없는지 확인
13. 배포 가능 퀄리티인지 검토
14. 커밋 및 PR 작성

## PR Process

1. feature 또는 fix 브랜치 생성
2. 작업 완료 후 PR 생성
3. 코드 리뷰 후 squash merge
4. 브랜치 삭제

## Testing

PR 생성 전 반드시 테스트를 실행한다.

go test ./...
go test -race ./...
```

## 추가 문서 확장 패턴

프로젝트가 커지면 guide.md에서 추가 문서를 참조한다.

```
docs/
  guide.md              # 필수: 프로젝트 가이드
  workflow.md           # 필수: 개발 워크플로우
  api-spec.md           # 선택: API 명세
  database-schema.md    # 선택: DB 스키마
  deployment.md         # 선택: 배포 가이드
```

guide.md에 추가 문서 링크를 명시한다. agent가 필요할 때만 해당 문서를 읽도록 한다.

## 피해야 할 것

- AGENTS.md에 모든 내용을 넣는 것. 반드시 docs/로 분리한다
- guide.md에 장황한 설명을 넣는 것. 핵심만 간결하게 작성한다
- workflow.md 없이 guide.md만 만드는 것. 두 파일은 항상 함께 생성한다
- docs/ 파일 간 순환 참조. guide.md를 진입점으로 단방향 참조한다
