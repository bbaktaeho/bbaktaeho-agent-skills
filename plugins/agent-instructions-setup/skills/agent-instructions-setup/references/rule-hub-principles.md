---
title: Team Knowledge Hub Principles
impact: CRITICAL
impactDescription: Hub that forgets it's AI-first degrades into a team wiki and loses value
tags: hub, multi-project, registry, ai-first, cross-project
---

## Philosophy

허브는 **AI 에이전트가 cross-project 맥락을 찾는 지도** 다. 팀 위키·인트라넷·회의록 보관소가 아니다.

판단 기준: 어떤 정보를 허브 agents/ 에 넣을지 고민될 때 "이 정보를 읽으면 AI 가 더 좋은 코드·답변을 만드는가?" 로 자문한다. 답이 "아니오" 면 다른 곳에 저장한다 (Notion, Slack 등).

## 허브의 정체성

- 팀이 관리하는 **여러 프로젝트의 메타-인덱스**
- 각 프로젝트의 source of truth 는 해당 레포 자체. 허브는 catalog·routing·cross-project 지식
- AI 가 "이 변경이 다른 프로젝트에 영향 주나?" "이 기술 써도 되나?" "누가 owner 야?" 를 빠르게 답하기 위한 구조

## 6 Core Rules

### 1. AI-First Content

허브에 넣을 가치가 있는 내용.

- 프로젝트 레지스트리 (이름·repo·스택·owner·status)
- Cross-project 기술 결정 (org ADR)
- 서비스 의존성·아키텍처 맵
- 기술 표준 (approved / experimental / deprecated)
- 공유 라이브러리·인프라
- 인시던트 대응 (cross-service)
- 용어·보안 규칙

허브에 넣지 않는 것 (사람용, agents/ 대상 아님).

- 회의록·스탠드업 기록
- 일정·캘린더
- 개인 TODO·메모
- 분기별 발표 슬라이드
- 사내 이벤트·회식

### 2. Registry, Not Source of Truth

agents/projects/{name}.md 는 해당 프로젝트의 **메타 요약** 이다.

- 실제 코드·세부 ADR·최신 배포 상태는 프로젝트 레포의 agents/ 가 정답
- 허브 레지스트리 = 요약 + 링크 + "언제 이 프로젝트 보면 되는지"
- 허브 내용이 프로젝트와 불일치하면 **프로젝트가 이긴다**

### 3. Sync Drift 가 최대 위험

프로젝트는 움직이고, 허브는 낡는다.

- 각 registry 항목은 분기별 리뷰 (owner 확인, status 갱신)
- 자동화: 프로젝트 레포의 AGENTS.md 변경 시 허브 registry 의 `updated` 트리거 (CI 권장)
- 낡은 registry 가 차라리 없는 게 낫다. 90일 이상 방치된 항목은 archived 로 옮기거나 owner 재지정

### 4. 2-Hop Onboarding

허브 onboarding 은 사람·AI 가 팀 전체 맥락을 한 번에 파악하지 않는다. 2단계로 분리한다.

- Hop 1: 허브 agents/onboarding.md — 팀 구조, 프로젝트 목록, 공용 리소스 훑기
- Hop 2: 배정된 프로젝트의 agents/onboarding.md — 실제 코드·환경

2-hop 원칙이 AI 에도 적용: "cross-project 질문" 이면 Hop 1, "특정 프로젝트 질문" 이면 Hop 2.

### 5. 양방향 링크 유지

허브 ↔ 프로젝트 상호 참조를 끊지 않는다.

- 허브 agents/projects/{name}.md 는 프로젝트 레포의 agents/guide.md 로 링크
- 프로젝트 레포의 agents/guide.md 는 상단에 "소속 허브: {URL}" 링크
- 양방향이 끊기면 agent 는 한쪽만 보고 반쪽 답을 줌

### 6. Archived, Not Deleted

프로젝트가 종료돼도 registry 에서 삭제하지 않는다.

- Status 를 `archived` 로 변경
- `agents/projects/archived/{name}.md` 로 이동
- 라우팅 테이블에서 제거
- 과거 맥락이 필요한 인시던트·의사결정 시 여전히 참조 가능

## Anti-Patterns

- **허브를 팀 위키화**: 회의록·로드맵 발표 슬라이드를 agents/ 에 넣음 → AI 컨텍스트 낭비
- **Single-maintainer bottleneck**: 허브 owner 가 1명 → 그 사람 부재 시 registry 썩음
- **Project-internal 정보 중복**: 허브에 프로젝트 상세를 복사 → 두 곳 모두 낡음
- **동적 정보 보관**: 배포 환경 URL·버전 번호를 허브에 박음 → 변경 시 누락
- **Meeting-driven updates**: 회의 때만 허브 업데이트 → 평상시 부패

## 허브 vs 프로젝트 레포의 역할 구분

| 정보 | 허브 | 프로젝트 레포 |
|------|------|---------------|
| 프로젝트 개요·owner·스택 | 요약 (1 페이지) | 상세 |
| 이 프로젝트만의 ADR | 링크만 | 원본 |
| Cross-project ADR | 원본 | 링크만 |
| 서비스 의존성 전체 지도 | 원본 | 이 서비스 관점 |
| 배포·환경 상세 | 링크만 | 원본 |
| 기술 표준 (허용 목록) | 원본 | 준수 |
| 용어집 | 원본 (org-wide) | 프로젝트 특화만 추가 |
| 팀 구조 | 원본 | 링크 |

## Agent 활용 시나리오

허브가 살아있을 때 AI 가 할 수 있는 것.

1. "이 기능이 다른 서비스에 영향 주나?" → agents/architecture/ + agents/projects/ 스캔
2. "이 라이브러리 써도 돼?" → agents/tech-radar.md 확인
3. "이 버그 비슷한 거 다른 팀에도 있었어?" → agents/decisions/ + agents/incident-response/ 검색
4. "{프로젝트 이름} 쪽은 누가 담당이야?" → agents/projects/{name}.md
5. "새 팀원이야. 뭐 읽어야 해?" → agents/onboarding.md → 배정 프로젝트 onboarding
