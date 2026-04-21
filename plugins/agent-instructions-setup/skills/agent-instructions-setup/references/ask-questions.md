---
title: Interactive Setup Question Script
impact: HIGH
impactDescription: Standardized question flow for Phase 2 reduces ambiguity and improves ergonomics
tags: interactive, questions, setup, phase2, pingpong, team
---

## Purpose

Phase 2 에서 사용자에게 묻는 질문 시퀀스를 표준화한다. 각 질문은 default 를 제시하고, 사용자가 답하지 않으면 default 를 적용한다. 질문은 한 번에 한 개씩 묻는다.

## Solo Mode Questions (기본)

### Q1. 프로젝트 이름

- default: 현재 디렉토리 이름 (`basename $PWD`)
- 용도: AGENTS.md 제목, guide.md frontmatter title

### Q2. 1줄 설명

- default: 없음 (필수)
- 용도: AGENTS.md 첫 문단, guide.md frontmatter description 보조

### Q3. 프로젝트 유형

- 선택지: `dev` / `docs` / `hybrid` / `other`
- default: `dev`
- 용도: guide·workflow 템플릿 선택
- `hybrid` → dev + docs 둘 다 생성 (guide 는 양쪽 라우팅 테이블 병합)
- `other` → 사용자에게 커스텀 템플릿 요구사항을 추가로 질문

### Q4. 기본 언어

- 선택지: `ko` / `en` / 기타
- default: `ko`
- 용도: 템플릿 한글·영문 분기. 기타 입력 시 해당 언어로 생성 시도

### Q5. 워크플로우 무게

- 선택지: `lite` (5-step) / `full` (14-step)
- default: `lite` (POC·솔로), `full` (팀·프로덕션) — 사용자 상황을 간단히 물어 제안
- 용도: workflow.md 템플릿 선택

### Q6. 사용할 AI 도구

- 체크리스트: Codex / Claude Code / Cursor / Copilot / Windsurf / Cline / Roo Code / Gemini CLI / Antigravity / Zed / Amp / Aider / Continue / 기타
- default: Phase 0 에서 감지된 설정 파일 기반으로 사전 체크 + Claude Code + Codex
- 용도: 심링크 생성 대상, .gitignore 추가 대상 (체크 해제된 도구)

### Q7. PR 타겟 브랜치

- default: `main`
- 용도: workflow.md 의 PR 섹션, workflow.md 의 Branch Strategy 기본값

### Q8. 감지된 스택 확인 (자동 감지)

질문이 아니라 확인 단계.

- `package.json` → Node.js + {framework 추정}
- `pyproject.toml` → Python + {framework 추정}
- `Cargo.toml` → Rust
- `go.mod` → Go
- `Gemfile` → Ruby
- `pom.xml` / `build.gradle` → Java / Kotlin

감지 결과를 보여주고 수정 여부 확인. 사용자가 수정하면 반영, 확인하면 그대로.

- 용도: guide.md 기술 스택 섹션, agents/stack.md 초안

### Q9. 프로젝트 스타일 규칙

- 예시 항목:
  - 응답 언어 (ko / en / 프로젝트 언어 따름)
  - 이모지 허용 여부
  - 주석 언어
  - 네이밍 컨벤션 (있으면)
  - 커밋 컨벤션 (Conventional Commits / 프로젝트 규칙 / 자유)
- default: 없음 (비워두면 AGENTS.md 의 Project Style 섹션 자체를 생략)
- 용도: AGENTS.md 의 Project Style 섹션

### Q10. 팀 사용 모드

- 선택지: `n` / `project` / `hub`
- default: Q5 답변이 `full` 이면 `project`, `lite` 면 `n`
- 용도:
  - `n` → 솔로 모드로 종료
  - `project` → 이 레포를 팀이 함께 쓸 프로젝트 레포로 세팅. T1~T7 질문 진행
  - `hub` → 이 레포를 팀 지식 허브 (cross-project knowledge base) 로 세팅. HUB1~HUB6 질문 진행
- `project` 와 `hub` 는 본질적으로 다른 모드:
  - `project`: 단일 레포 내 팀 협업 (CODEOWNERS, onboarding, ADR, security 생성)
  - `hub`: 여러 프로젝트를 카탈로그·메타-인덱스화 (registry, tech-radar, cross-service incident, org-level ADR 생성)

## Project Team Mode Questions (Q10=project)

단일 레포 내 팀 협업 세팅에 필요한 추가 질문. 원칙: references/rule-team-governance.md

### T1. 팀 규모

- 선택지: `solo` / `small` (2-5) / `medium` (6-15) / `large` (16+)
- default: 없음 (필수)
- 용도:
  - PR 승인 수 기본값 (solo: 0 / small: 1 / medium: 1+owner / large: 2)
  - onboarding.md 생성 여부 (small 이상)
  - runbook 권장 여부 (medium 이상)

### T2. CODEOWNERS 사용 + 담당자

- 선택지: `y` (handle 입력) / `n`
- default: `n` (solo/small), `y` (medium/large)
- `y` 선택 시 담당자 Slack handle 또는 GitHub team 입력
- 용도:
  - `.github/CODEOWNERS` 에 `agents/ @{handle}` 자동 추가
  - agents/team.md Owner 섹션 초안

### T3. 팀 문서 실천 (multi-select)

- 선택지 (복수 선택 가능):
  - `adr` — Architecture Decision Records
  - `rfc` — Request for Comments (설계 제안)
  - `postmortem` — 인시던트 포스트모템
  - `runbook` — 운영 플레이북
- default: `adr` (선택 권장), 나머지는 비선택
- 용도:
  - 선택된 항목별로 agents/guide.md 라우팅 테이블 행 추가
  - 선택된 항목별 template 파일을 agents/{topic}/TEMPLATE.md 로 복사 (사용자가 이후 복사해 사용)
  - 비선택 항목은 생성하지 않음 (빈 디렉토리 방지)

### T4. Onboarding 스타일

- 선택지: `buddy` (멘토 1:1) / `solo` (문서 기반 자체) / `pair` (페어 프로그래밍)
- default: T1 기반 — small: `buddy`, medium/large: `buddy`, solo: 스킵
- 용도: agents/onboarding.md 의 "First Day" 섹션 마지막 액션 분기
- T1 이 `solo` 이면 이 질문 스킵 (onboarding.md 자체를 생성하지 않음)

### T5. 보안 포스처

- 선택지: `public` (OSS) / `internal` (사내) / `regulated` (금융·의료·개인정보)
- default: Phase 0 감지 기반 — git remote 가 public github 이면 `public`, 아니면 `internal`
- 용도:
  - agents/security.md 의 공개 수준별 대응 섹션 선택
  - `regulated` 면 compliance 관련 추가 항목 포함
  - `public` 이면 외부 기여자 가이드 링크 포함

### T6. 금지 항목 추가 (optional)

- default: 기본 목록 제시 (자격 증명, 내부 URL, PII, 재무, 개인 연락처, 보안 취약점)
- 사용자가 프로젝트별 추가 항목 입력 가능:
  - 예: 고객사명, 특정 도메인, 내부 코드네임
- 용도: agents/security.md 의 "절대 금지" 섹션 확장

### T7. Monorepo 내 다중 팀 공존

- 선택지: `y` / `n`
- default: `n`
- `y` 선택 시 추가 질문:
  - 이 팀의 작업 영역 (path prefix, 예: `backend/`, `packages/ui/`)
- 용도:
  - agents/ 자체는 공용 유지
  - agents/team.md 에 "이 팀 영역" 섹션 포함
  - scoped rules (Cursor `.cursor/rules/*.mdc`) 사용 권장 가이드 포함

## Hub Mode Questions (Q10=hub)

팀 지식 허브 (cross-project knowledge base) 세팅. 원칙: references/rule-hub-principles.md

허브의 정체성: **팀이 관리하는 여러 프로젝트의 AI-first 메타-인덱스**. 사람용 위키가 아니다.

### HUB1. 허브 이름

- default: `{team}-hub` 또는 현재 디렉토리 이름
- 용도: AGENTS.md 제목, guide.md frontmatter title

### HUB2. 팀 범위

- 선택지: `squad` (5명 이내) / `team` (6-15) / `multi-team` (16+, 여러 팀)
- default: `team`
- 용도:
  - `squad` → 간소화된 허브 (projects + decisions + team + glossary 만)
  - `team` → 기본 허브 (+ tech-radar, incident-response, infrastructure 추가 권장)
  - `multi-team` → 풀 허브 (+ shared-libraries, architecture/ 추가 권장)

### HUB3. 초기 등록 프로젝트

- 선택지: `none` (나중에) / 프로젝트 리스트
- default: `none`
- 리스트 입력 시 각 프로젝트당 물어볼 것 (최소):
  - 프로젝트 이름 (kebab-case)
  - 레포 URL
  - Primary owner (Slack handle 또는 GitHub handle)
  - Status (`active` / `maintenance`)
- 용도: `agents/projects/{name}.md` 초기 생성 (template-project-registry.md 기반)
- 스택·의존성 등 상세는 비워둠 — 각 프로젝트 owner 가 이후 PR 로 채움

### HUB4. 공통 리소스 (multi-select)

- 선택지 (복수 가능):
  - `tech-radar` — 기술 표준
  - `shared-libraries` — 공유 라이브러리 카탈로그
  - `infrastructure` — 공유 인프라 맵
  - `incident-response` — cross-service 인시던트 플레이북
  - `architecture` — 서비스 의존성·아키텍처 맵 (디렉토리)
- default: HUB2 기반
  - squad: `tech-radar`
  - team: `tech-radar`, `incident-response`, `infrastructure`
  - multi-team: 모두 선택
- 용도: 선택된 항목별 agents/{name}.md 또는 agents/architecture/ 생성

### HUB5. 공개 수준

- 선택지: `private` (팀 내부) / `team-internal` (사내 전체) / `public` (외부 공개 handbook)
- default: `private`
- 용도:
  - security.md 의 redaction 강도
  - `public` 이면 외부 기여자 가이드 링크 포함
  - `public` 이면 agents/projects/{name}.md 에서 내부 시스템 정보 추가 redaction

### HUB6. Registry 유지 정책

- 선택지:
  - `manual` — 사람이 PR 로 업데이트
  - `pr-template` — `.github/PULL_REQUEST_TEMPLATE.md` 에 "허브 registry 업데이트 필요?" 체크박스 추가
  - `automated` — CI 로 각 프로젝트 AGENTS.md 변경 감지·허브 PR 자동 생성
- default: `pr-template`
- 용도: evolve-principles.md 의 허브 freshness 정책 구체화

## 진행 흐름

1. 질문은 한 번에 한 개씩 묻는다 (병렬 질문 금지)
2. 각 질문에 default 와 선택지를 명시한다
3. 사용자 답변 이후 다음 질문으로 진행
4. 모든 답변 수집 후 **요약 테이블**을 보여주고 최종 확인 받는다
5. 확인 후 Phase 1·2 실행

## 요약 테이블 형식

```
다음 설정으로 생성합니다. 수정이 필요하면 항목 번호를 말씀해 주세요.

[Solo Mode]
1. 프로젝트 이름: {A1}
2. 1줄 설명: {A2}
3. 유형: {A3}
4. 언어: {A4}
5. 워크플로우: {A5}
6. AI 도구: {A6}
7. PR 타겟: {A7}
8. 스택: {A8}
9. 스타일 규칙: {A9 or "없음"}
10. 팀 모드: {A10}

[Project Team Mode] (Q10=project 인 경우만)
T1. 팀 규모: {answer}
T2. CODEOWNERS: {answer}
T3. 문서 실천: {answer}
T4. Onboarding: {answer}
T5. 보안: {answer}
T6. 금지 항목 추가: {answer or "기본만"}
T7. 다중 팀: {answer}

[Hub Mode] (Q10=hub 인 경우만)
HUB1. 허브 이름: {answer}
HUB2. 팀 범위: {answer}
HUB3. 초기 프로젝트: {answer}
HUB4. 공통 리소스: {answer}
HUB5. 공개 수준: {answer}
HUB6. Registry 정책: {answer}

생성될 추가 파일 (Q10=project):
- agents/onboarding.md, agents/team.md, agents/glossary.md, agents/security.md, agents/stack.md
- agents/{decisions,rfc,runbook,postmortem}/TEMPLATE.md (T3 선택 항목만)
- .github/CODEOWNERS (T2=y 인 경우)

생성될 추가 파일 (Q10=hub):
- agents/guide.md (hub 버전, template-hub-guide.md)
- agents/projects/{name}.md (HUB3 등록 프로젝트 각각, template-project-registry.md)
- agents/decisions/ (org-level ADR 디렉토리)
- agents/team.md, agents/glossary.md, agents/security.md, agents/onboarding.md (2-hop 버전)
- agents/tech-radar.md (HUB4 포함 시)
- agents/shared-libraries.md (HUB4 포함 시)
- agents/infrastructure.md (HUB4 포함 시)
- agents/incident-response.md (HUB4 포함 시)
- agents/architecture/ (HUB4 포함 시, 디렉토리)
- .github/CODEOWNERS (허브 owner)
- .github/PULL_REQUEST_TEMPLATE.md (HUB6=pr-template 시 registry 체크박스 추가)
```

## Phase 0 에서 기존 셋업 감지 시

이미 AGENTS.md + agents/ 가 존재하면 Q1~Q5, Q7~Q9 를 스킵하고 다음만 묻는다.

- Q6 (도구 추가·제거) — 심링크만 갱신
- Q10 (팀 모드 전환) — 솔로 셋업을 팀 모드로 업그레이드
- 또는 "새 문서 추가" 모드 → references/evolve-principles.md 규칙으로 진행
- 또는 "템플릿 업그레이드" 모드 → 기존 guide/workflow 를 최신 템플릿과 diff 하여 제안

## 스킵 원칙

- 사용자가 "기본값으로 다 해줘" 라고 하면 Q1 (필수) 과 Q2 (필수) 만 받고 나머지 default 로 진행
- 사용자가 answer 없이 Enter 만 치면 default 적용
- T 질문은 Q10≠project 이면 전부 스킵
- HUB 질문은 Q10≠hub 이면 전부 스킵
- Hub 모드는 Q3 (프로젝트 유형) 과 독립. Hub 레포 자체의 "dev vs docs" 구분이 무의미하므로 Q3 스킵 가능
