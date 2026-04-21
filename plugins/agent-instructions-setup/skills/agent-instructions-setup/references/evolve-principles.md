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

## 팀 모드 추가 원칙

팀에서 agents/ 를 운영할 때는 위 원칙에 더해 references/rule-team-governance.md 의 5 원칙을 적용한다.

### Freshness 리뷰 (분기별)

분기에 한 번 agents/ freshness 를 리뷰한다.

1. `updated` 가 90일 이상 된 문서 목록 추출
2. 각 문서를 Owner 가 검토:
   - 여전히 유효 → `updated` 갱신만
   - 수정 필요 → 수정 후 `updated` 갱신
   - 더 이상 유효 X → deprecate 또는 archive
3. ADR 은 Status 확인 (Accepted 상태가 여전히 유효한지)
4. 리뷰 결과를 agents/postmortem/ 이 아닌 간단한 log 로 agents/changelog.md 에 기록 (선택)

### Archive, Not Delete

팀 맥락에서 문서 삭제는 역사 소실이다.

- ADR: Status 변경만. 삭제 X
- Runbook: `agents/runbook/archive/` 이동
- RFC (기각/철회): Status 변경 + 그대로 유지
- Postmortem: 영구 보존 (해당 사건의 맥락)
- 기타: `agents/archive/` 이동

archive 된 문서는 agents/guide.md 라우팅 테이블에서 제거하지만 파일은 남긴다.

### PR 리뷰 규칙 (팀 규모별)

rule-team-governance.md 의 Sign-Off 규칙 적용.

| 팀 규모 | agents/ PR 승인 수 |
|---------|--------------------|
| solo | 0 |
| small (2-5) | 1 |
| medium (6-15) | 1 + owner |
| large (16+) | 2 (owner 1명 포함) |

이 규칙은 agents/workflow.md 의 PR 섹션에도 반영된다.

### Redaction 확인

팀 모드에서는 모든 agents/ PR 에서 민감 정보 혼입을 체크한다.

- references/template-security.md 의 grep 패턴 활용
- 반복 실수 발견 시 CI 에 자동 검사 step 추가

### 신규 AI 도구 추가 시 팀 동기화

개인 판단으로 AI 도구를 추가하지 않는다.

1. 추가 제안은 short RFC (`agents/rfc/*.md`) 또는 Slack 논의
2. 팀 합의 후 `.github/CODEOWNERS`, `.gitignore`, 심링크 반영
3. agents/guide.md 의 "사용 도구" 섹션 업데이트

### ADR / RFC / Postmortem 의 evolve

이 세 종류는 일반 문서와 다른 evolve 규칙을 따른다.

- **ADR**: Accepted 이후 본문 수정 금지. 번복은 새 ADR 로 Supersede
- **RFC**: Under Review 에서 Accepted 전환 시 ADR 로 추출
- **Postmortem**: Action Items 만 Status 갱신. 본문은 불변

상세: references/template-decision.md, references/template-rfc.md, references/template-postmortem.md

## 허브 모드 추가 원칙

허브 (cross-project knowledge base) 를 운영할 때는 위 원칙에 더해 references/rule-hub-principles.md 의 6 원칙을 적용한다.

### Project Registry Sync

`agents/projects/{name}.md` 는 원본이 아니라 메타-인덱스다.

- 프로젝트 레포의 상태 변경 (owner·stack·status) → 허브 registry 도 갱신
- 분기별 registry 전수 리뷰:
  - Owner 가 여전히 유효한가
  - Status 가 정확한가 (active/maintenance/archived)
  - Stack 이 실제와 일치하는가
  - Depends On / Depended By 링크가 살아있는가
- 90일 이상 `updated` 없는 registry 항목은 archive 후보

### Registry 갱신 트리거

- 프로젝트 레포의 AGENTS.md 변경 (대규모 변경 시)
- Owner 변경
- Stack 주요 변경
- Status 변경
- 새 ADR 이 해당 프로젝트에 중대한 영향

자동화 옵션 (HUB6=automated): CI 가 각 프로젝트 레포의 변경을 감지하여 허브에 PR 자동 생성.

### Cross-Project ADR vs Project ADR

- 단일 프로젝트에만 영향 → 해당 프로젝트의 agents/decisions/
- 여러 프로젝트에 영향 (예: API 계약 변경, 공유 기술 결정) → 허브의 agents/decisions/
- 애매하면 허브에 올리고 각 프로젝트의 agents/decisions/ 에는 링크만

### Tech Radar 갱신

`agents/tech-radar.md` 상태 변경은 반드시 ADR 동반.

- Approved → Deprecated: 마이그레이션 기한 포함 ADR
- Deprecated → Banned: 기한 경과 또는 새 리스크 발견
- Experimental → Approved: pilot 결과 ADR

사용자 요청이 Deprecated/Banned 기술 사용이면 agent 는 거부하지 말고 agents/tech-radar.md 의 이유를 인용하며 대안 제시.

### 프로젝트 Archive 절차

프로젝트가 종료되면.

1. 프로젝트 registry 의 Status 를 `archived` 로 변경
2. `agents/projects/archived/{name}.md` 로 파일 이동
3. agents/guide.md 의 프로젝트 대시보드에서 제거
4. 다른 프로젝트의 `Depends On` 에 이 프로젝트가 있는지 grep 후 대체 경로 명시
5. 허브 agents/decisions/ 에 archive 결정 ADR (선택, 하지만 권장)

### 허브 owner 책임

허브 owner 는 위 sync 를 주기적으로 확인. Owner 없는 허브는 3개월 내 부패한다.

- CODEOWNERS 에 최소 2명 (bus factor)
- 분기별 30분 freshness 리뷰 회의
- 리뷰 결과는 허브 agents/changelog.md 에 간단히 기록 (선택)

### 허브 vs 프로젝트 정보 상충 시

허브와 프로젝트 내용이 불일치하면 **프로젝트가 우선**.

- 발견 시 허브 registry 를 프로젝트 실제 상태로 갱신
- 상충 자체가 허브가 썩고 있다는 신호 — sync 자동화 검토
