---
title: Document Evolution Principles
impact: HIGH
impactDescription: Rules for adding, modifying, and deleting agents/ docs post-setup to keep findability
tags: evolve, maintenance, add, modify, delete, routing-table
---

## Purpose

셋업 이후 `agents/` 하위 문서를 추가·수정·삭제할 때 따르는 원칙이다. 목적: 문서 수가 늘어도 findability 가 유지되도록 한다.

이 원칙은 agents/guide.md 의 "문서 진화" 섹션에도 축약되어 들어간다. 사용자는 셋업 이후 agents/guide.md 만 열어도 규칙을 따를 수 있다.

## 추가 (Add)

새 문서를 만들 때.

1. `agents/{topic}.md` 단일 파일로 시작한다. 디렉토리를 미리 만들지 않는다
2. frontmatter 는 references/meta-frontmatter.md 규칙을 따른다
3. description 은 **"언제 읽어야 하는지 + 얻는 것"** 형식으로 작성한다
4. 파일 생성 후 agents/guide.md 의 라우팅 테이블에 한 줄 등록한다
5. 파일 생성과 라우팅 등록은 같은 커밋에 포함한다 (원자성)

파일 분해 기준:

- 300줄 초과 → 분해한다
- 주제가 2개 이상 섞임 → 분해한다
- 분해 시 `agents/{topic}.md` 는 index 로 남기고 섹션별 1문장 요약 + 링크만 둔다
- 상세는 `agents/{topic}/{N}-{name}.md` 로 이동한다 (순서가 있으면 N, 없으면 생략)

## 수정 (Modify)

기존 문서 수정 시.

1. frontmatter 의 `updated: YYYY-MM-DD` 를 갱신한다 (없으면 추가)
2. 섹션 첫 줄 요약이 여전히 본문을 반영하는지 확인한다
3. 용어 변경 시 `agents/` 전체를 grep 하여 일괄 갱신한다
4. 섹션 제거 시 다른 문서에서 해당 섹션을 참조하는지 확인한다
5. 300줄 초과하면 그 자리에서 분해한다. "다음에" 금지

## 삭제 (Delete)

문서 삭제 시.

1. `agents/` 내 참조를 grep 으로 확인한다
2. 참조가 있으면 먼저 대체 경로로 갱신한다
3. agents/guide.md 라우팅 테이블에서 해당 행을 제거한다
4. 빈 디렉토리는 함께 삭제한다

## 라우팅 테이블 관리

agents/guide.md 의 라우팅 테이블은 프로젝트 문서 진입점이다.

- 문서 추가 시 반드시 한 행 추가
- 문서 제거 시 반드시 한 행 제거
- 행은 **"작업 유형 → 읽을 문서"** 매핑으로 작성
- 테이블이 10행을 넘으면 그룹핑을 고려한다 (예: "개발", "운영", "문서" 섹션으로 분리)

## 로그·계획 디렉토리

### Development Log

`agents/develop/daily/{YYYY-MM-DD}-{요약}.md` 파일이 100개 초과하면 연도별로 분리한다.

- `agents/develop/daily/2026/{YYYY-MM-DD}-{요약}.md`
- 이전 연도 파일은 `agents/develop/daily/archive/{YEAR}/` 로 이동한다

### Plan

계획은 `agents/plan/{N}-{YYYY-MM-DD}-{name}/plan.md` 에 작성한다.

- `plan.md` 는 핵심 요약만
- 상세는 같은 디렉토리의 `{N}-{topic}.md` 로 분리
- 완료된 계획은 `agents/plan/archive/` 로 이동한다

## 중복·충돌 방지

- 문서 추가 전에 이미 같은 내용을 다루는 문서가 있는지 검색한다
- 중복 발견 시 한 곳으로 통합하고 나머지는 참조로 대체한다
- 빈 파일·빈 디렉토리는 즉시 정리한다

## 신규 AI 도구 추가

셋업 이후 새 AI 도구를 추가할 때.

1. references/map-file-paths.md 에서 해당 도구의 instruction 파일 경로 확인
2. `ln -sfn AGENTS.md {tool-path}` 로 심링크 생성 (디렉토리가 필요하면 먼저 생성)
3. `.gitignore` 에서 해당 파일이 제외되어 있다면 제거
4. 커밋 메시지: `chore: add {tool} instruction symlink`

## 원칙 요약

- 추가·수정·삭제 모두 라우팅 테이블과 동기화
- 300줄 한도는 "당장" 지킨다
- description 은 검색 키다. 공들여 작성한다
- 구조를 유지하는 비용은 작고, 무너진 뒤 복구 비용은 크다
