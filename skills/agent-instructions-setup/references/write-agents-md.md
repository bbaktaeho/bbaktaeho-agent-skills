---
title: Write Effective AGENTS.md Instructions
impact: HIGH
impactDescription: Well-structured instructions reduce agent errors and improve code generation quality
tags: agents-md, writing, best-practices, instructions
---

## AGENTS.md 작성 가이드

AGENTS.md는 AI coding agent에게 프로젝트 컨텍스트를 전달하는 파일이다. 필수 필드는 없으며 표준 Markdown을 사용한다.

**핵심 원칙: AGENTS.md는 간결하게 유지한다.** 상세 내용은 `docs/guide.md`와 `docs/workflow.md`로 분리한다. `docs-structure.md` 참조.

## 권장 섹션 구조

```markdown
# Project Name

프로젝트 1줄 설명.

## Build & Run

프로젝트 빌드, 실행, 테스트 명령어.

## Code Style

코딩 컨벤션, 네이밍 규칙, 포매터 설정.

## Rules

agent가 반드시 따라야 할 규칙.

## Documentation

상세 가이드는 아래 문서를 참고한다.

- [docs/guide.md](docs/guide.md) - 프로젝트 가이드
- [docs/workflow.md](docs/workflow.md) - 개발 워크플로우
```

## 작성 원칙

### 명확하고 구체적으로 작성한다

```markdown
# Bad
코드를 깔끔하게 작성하세요.

# Good
함수는 단일 책임 원칙을 따른다. 한 함수는 20줄을 넘지 않는다.
에러는 반드시 처리한다. 빈 catch 블록을 사용하지 않는다.
```

### 명령형으로 작성한다

```markdown
# Bad
테스트를 작성하면 좋겠습니다.

# Good
모든 public 함수에 테스트를 작성한다.
```

### 빌드/테스트 명령은 복사 가능한 형태로 제공한다

```markdown
## Build & Run

go build ./...
go test ./...
go test -race ./...
```

### 프로젝트 특화 정보를 포함한다

- 사용하는 프레임워크와 버전
- 환경변수 목록과 설명
- 배포 환경 (로컬, staging, production)
- 외부 서비스 의존성

## 피해야 할 것

- 일반적인 프로그래밍 조언 (agent가 이미 알고 있음)
- 너무 긴 문서 (토큰 낭비). Architecture, Testing, Security 등 상세 내용은 docs/로 분리한다
- 모호한 지시 ("적절하게 처리하세요")
- 도구별 특화 문법 (symlink로 공유하므로 범용적으로 작성)
