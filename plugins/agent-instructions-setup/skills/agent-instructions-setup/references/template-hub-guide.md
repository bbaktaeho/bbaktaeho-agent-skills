---
title: Hub Guide Template
impact: HIGH
impactDescription: Hub guide.md is a project dashboard + cross-project routing index
tags: hub, template, guide, dashboard, routing
---

## Purpose

허브 레포용 `agents/guide.md`. **프로젝트 대시보드 + cross-project 라우팅 index**.

80줄 이내 유지. 각 프로젝트의 상세는 `agents/projects/{name}.md` 또는 해당 레포로 분산.

## Template

```markdown
---
title: {Team Name} Hub Guide
description: 팀 cross-project 작업 시작 전 필독. 프로젝트 대시보드·공용 리소스 라우팅 제공
type: guide
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# {Team Name} Hub

{팀 1~2줄 설명}

## 작업 유형별 라우팅

| 작업 | 먼저 읽을 문서 |
|------|----------------|
| 특정 프로젝트 작업 | agents/projects/{name}.md → 해당 레포 agents/guide.md |
| Cross-project 설계 | agents/architecture/, agents/decisions/ |
| 기술 선택 / 라이브러리 | agents/tech-radar.md, agents/shared-libraries.md |
| 인프라·배포 cross-service | agents/infrastructure.md |
| Cross-service 인시던트 | agents/incident-response.md |
| 신규 입사자 (2-hop) | agents/onboarding.md → 배정 프로젝트 |
| 누가 담당? | agents/team.md |
| 용어 확인 | agents/glossary.md |

## 프로젝트 대시보드

agents/projects/ 하위 관리 대상 프로젝트.

| 프로젝트 | Status | Owner | Stack | Registry |
|----------|--------|-------|-------|----------|
| {project-a} | active | @{handle} | {lang}, {framework} | agents/projects/{project-a}.md |
| {project-b} | active | @{handle} | {lang}, {framework} | agents/projects/{project-b}.md |
| {project-c} | maintenance | @{handle} | {lang} | agents/projects/{project-c}.md |

Archived: agents/projects/archived/ 참고

## 공용 리소스

- **기술 표준**: agents/tech-radar.md
- **공유 라이브러리**: agents/shared-libraries.md
- **인프라 맵**: agents/infrastructure.md
- **인시던트 대응**: agents/incident-response.md
- **용어**: agents/glossary.md
- **보안**: agents/security.md

## 최근 org-level ADR

- [ADR-NNN {제목}](decisions/...) — {1줄}
- [ADR-NNN {제목}](decisions/...) — {1줄}

전체: agents/decisions/

## 문서 진화

- 새 프로젝트 등록: agents/projects/{name}.md 생성 (template-project-registry.md 참고) + 위 대시보드 행 추가
- 프로젝트 archive: Status 를 `archived` 로, agents/projects/archived/ 이동, 대시보드에서 제거
- 프로젝트 owner·status 변경: registry 파일의 `updated` 갱신 + 대시보드 동기화
- 90일 이상 `updated` 없는 registry 항목은 분기 리뷰 대상
- Cross-project ADR 추가: agents/decisions/ + 위 "최근 org-level ADR" 섹션 최대 3개 유지
- 허브 운영 원칙 상세: (skill reference) references/rule-hub-principles.md

## 사람용 정보는 agents/ 에 넣지 않는다

agents/ 는 AI 에이전트가 읽는 디렉토리다. 다음은 여기에 넣지 않는다.

- 회의록·스탠드업 로그
- 분기별 발표 자료
- 개인 일정·TODO
- 사내 이벤트·회식

이런 내용은 Notion / Slack / 다른 사람용 저장소로.
```

## 작성 가이드

1. 프로젝트 대시보드는 가장 눈에 띄는 위치. agent 가 cross-project 질문 받으면 여기부터 훑음
2. 프로젝트가 10개 초과하면 대시보드를 그룹핑 (예: "Backend Services", "Frontend Apps")
3. "공용 리소스" 섹션은 생성된 파일만 나열. HUB4 에서 선택 안 한 리소스는 제거
4. "최근 org-level ADR" 은 최대 3개. ADR 추가 시 자동 업데이트 (CI 권장)
5. "문서 진화" 섹션은 references/rule-hub-principles.md 의 요약. 허브에서 작업하는 누구나 이 섹션만 봐도 규칙을 따를 수 있게
6. 마지막 "사람용 정보 금지" 섹션은 **삭제 금지** — 허브의 AI-first 정체성 유지 핵심

## 단일 프로젝트 guide.md 와 다른 점

| 섹션 | 단일 프로젝트 | 허브 |
|------|---------------|------|
| 작업 유형별 라우팅 | 이 레포 내부 | cross-project 포함 |
| 프로젝트 대시보드 | 없음 | **핵심 섹션** |
| 기술 스택 | 이 프로젝트 스택 | tech-radar (전체 허용/금지) |
| 디렉토리 맵 | 이 레포 구조 | agents/projects/ 중심 |
