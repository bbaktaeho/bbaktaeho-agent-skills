---
title: Hub AGENTS.md Template
impact: CRITICAL
impactDescription: Hub AGENTS.md is a cross-project catalog routing root, not a single-repo rulebook
tags: hub, template, agents-md, catalog, cross-project
---

## Purpose

허브 레포용 AGENTS.md. 단일 프로젝트 AGENTS.md 와 역할이 다르다 — **팀이 관리하는 여러 프로젝트의 카탈로그 루트** 다.

단일 프로젝트용 버전: references/template-agents.md

## Template

```markdown
# {Team Name} Hub

{팀 이름} 팀이 관리하는 프로젝트·공용 리소스의 AI 에이전트 지식 베이스.

## Entry Point

작업 시작 전 agents/guide.md 를 읽는다. 작업 유형별 진입 문서가 라우팅되어 있다.

## Scope

이 레포는 AI 에이전트가 **cross-project 맥락** 을 찾는 허브다.

- 각 프로젝트의 소스·세부 정보는 해당 레포의 agents/ 가 정답
- 허브는 meta-index: 프로젝트 카탈로그 + 팀 공용 지식
- 허브 내용과 프로젝트 내용이 상충하면 프로젝트가 우선

자세한 허브 운영 원칙: agents/guide.md 의 "문서 진화" 섹션

## Directory Map

- AGENTS.md — 이 파일. 카탈로그 루트
- agents/guide.md — 허브 진입점·프로젝트 대시보드
- agents/projects/ — 관리 대상 프로젝트 레지스트리 (각 프로젝트 요약·링크·owner)
- agents/decisions/ — 팀 수준 ADR (cross-project 결정)
- agents/architecture/ — 서비스 의존성·아키텍처 맵
- agents/tech-radar.md — approved / experimental / deprecated 기술 표준
- agents/shared-libraries.md — 공유 라이브러리 카탈로그
- agents/infrastructure.md — 공유 인프라 (DB, 클러스터, CI/CD)
- agents/incident-response.md — cross-service 인시던트 대응
- agents/onboarding.md — 팀 신규 입사자 (2-hop: 허브 → 배정 프로젝트)
- agents/team.md — 팀 구조·Owner·에스컬레이션
- agents/glossary.md — 팀 공용 용어 (org-wide)
- agents/security.md — 공통 보안 규칙
- agents/*.md — 기타 주제별 상세 (frontmatter description 참고)

## Document Conventions

- 모든 agents/ 파일은 6~8줄 frontmatter 로 시작
- frontmatter description 은 "언제 읽어야 하는지 + 얻는 것"
- 섹션 첫 줄은 1문장 요약
- 허브 특화 규칙: agents/ 는 AI-first. 사람용 위키 내용 (회의록·스케줄·사교) 은 넣지 않는다

## Ownership

- 허브 owner: `.github/CODEOWNERS` 참고 (최소 2명 권장)
- 허브 agents/ 변경은 PR 리뷰 필수
- 각 프로젝트 registry 의 owner 는 해당 프로젝트 owner 와 동기화
- 거버넌스 원칙 상세: (skill reference) references/rule-team-governance.md, references/rule-hub-principles.md

## Project Style

{Q9 답변. 없으면 섹션 생략}
```

## 작성 가이드

1. `{Team Name}` 은 HUB1 답변으로 치환
2. Directory Map 에서 프로젝트가 선택한 공통 리소스 (HUB4 multi-select) 에 따라 해당 항목만 포함. 선택 안 한 리소스는 제거
3. Scope 섹션의 "meta-index" 역할은 **삭제 금지** — 허브의 정체성 선언이다. 이 섹션이 없으면 agent 가 허브를 단일 프로젝트로 오해할 수 있음
4. AGENTS.md 자체는 50줄 이내 유지. 상세는 agents/ 하위로
5. **행동 지시문 금지**: "AI 는 허브를 먼저 읽어라" 같은 문장은 Entry Point 로 대체. 라우팅 구조로 유도

## 단일 프로젝트 AGENTS.md 와 다른 점

| 항목 | 단일 프로젝트 | 허브 |
|------|---------------|------|
| 역할 | 이 레포 라우팅 루트 | 여러 프로젝트 카탈로그 루트 |
| Scope 섹션 | 없음 | **필수** (허브 정체성) |
| agents/projects/ | 없음 | 필수 |
| agents/decisions/ | 이 레포 ADR | 팀 수준 cross-project ADR |
| agents/tech-radar.md | 없음 (프로젝트는 stack.md) | 필수 |
| agents/incident-response.md | 단일 서비스 runbook | cross-service 인시던트 |

## 프로젝트 레포와의 양방향 링크

허브 AGENTS.md 는 **프로젝트 레포의 agents/guide.md** 로 링크 (각 registry 파일에서).

반대로 프로젝트 레포의 agents/guide.md 는 상단에 아래 라인을 포함해야 한다:

```markdown
> 소속 허브: [{Team Name} Hub]({허브 레포 URL}). cross-project 맥락은 허브 agents/ 참조
```

양방향 링크가 끊기면 agent 는 반쪽 컨텍스트만 본다.
