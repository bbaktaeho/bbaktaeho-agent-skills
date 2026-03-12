# agent-instructions-setup Redesign

## Goal

agent-instructions-setup skill을 "참고 문서 모음"에서 "실행 가능한 init skill"로 전환한다.

## Core Concept

1. 새 프로젝트 생성 시 AGENTS.md를 single source of truth로 셋업
2. 8개 AI 도구 symlink 자동 생성
3. 사용자에게 프로젝트 용도(개발용/문서용/기타) 질문
4. 용도별 템플릿 기반으로 docs/guide.md, docs/workflow.md 생성

## Execution Flow

### Phase 1: Auto Setup

1. AGENTS.md 존재 확인 -> 없으면 template-agents.md 기반 생성
2. 8개 도구 symlink 전부 자동 생성 (기존 파일 있으면 병합 후 교체)
3. docs/ 디렉토리 생성

### Phase 2: Interactive Setup

4. 프로젝트 용도 질문 (개발용/문서용/기타)
5. 기술스택 등 추가 질문
6. 용도별 템플릿 기반으로 docs/guide.md 생성
7. 용도별 템플릿 기반으로 docs/workflow.md 생성

### Phase 3: Verification

8. 생성된 파일 목록 출력
9. symlink 연결 상태 검증
10. 읽은/생성한 파일 나열

## File Structure

```
references/
  _sections.md                    # 섹션 정의 (갱신)
  map-file-paths.md              # AI 도구별 파일 경로 (갱신)
  link-symlink-strategy.md       # symlink 전략 (갱신)
  meta-frontmatter.md            # docs/ frontmatter 규칙 (신규)
  template-agents.md             # AGENTS.md 공통 템플릿 (신규)
  template-dev-guide.md          # 개발용 guide.md (신규)
  template-dev-workflow.md       # 개발용 workflow.md (신규)
  template-docs-guide.md         # 문서용 guide.md (신규)
  template-docs-workflow.md      # 문서용 workflow.md (신규)
```

삭제: docs-structure.md, write-agents-md.md

## AGENTS.md Template

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

## Documentation

상세 가이드는 아래 문서를 참고한다.

- [docs/guide.md](docs/guide.md) - 프로젝트 가이드
- [docs/workflow.md](docs/workflow.md) - 작업 워크플로우
```

## docs/ Frontmatter Rule

6줄 이내 YAML frontmatter:

```yaml
---
title: 문서 제목
description: 1줄 설명
type: guide | workflow | spec | reference
created: YYYY-MM-DD
---
```

agent는 head 6줄만 읽고 문서를 읽을지 판단한다.

## map-file-paths.md Updates

- Cursor: .cursor/rules/*.mdc 추가
- Copilot: .github/instructions/*.instructions.md 추가
- Claude Code: 계층 구조 설명 추가
- Aider: 제거

## Decisions

- 혼합형 실행: 기본 셋업은 자동, 용도/내용은 대화형
- 8개 도구 symlink 전부 자동 생성
- 용도별 완전 독립 템플릿 (조합 로직 없이 직관적)
- 기존 파일 전면 재작성 허용
