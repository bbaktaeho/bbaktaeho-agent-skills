---
title: Onboarding Template
impact: HIGH
impactDescription: Day-1 entry point that cuts new-hire ramp-up by 1-2 weeks
tags: template, onboarding, team, new-hire
---

## Purpose

신규 입사자가 day-1 에 읽는 진입 문서. `agents/onboarding.md` 로 생성된다.

목표: 혼자서도 첫 주를 시작할 수 있게 하는 체크리스트 + 포인터.

## Template

```markdown
---
title: {Project Name} Onboarding
description: 신규 입사자 필독. 첫 주 체크리스트·환경 셋업·질문 창구 제공
type: guide
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# {Project Name} Onboarding

환영합니다. 이 문서는 순서대로 읽고 체크하세요.

## First Day

- [ ] agents/guide.md 읽기 (프로젝트 라우팅 index)
- [ ] agents/team.md 에서 담당 영역·에스컬레이션 경로 확인
- [ ] agents/stack.md 에서 기술 스택 파악
- [ ] 로컬 개발 환경 셋업 (아래 "Environment Setup")
- [ ] 최초 빌드·테스트 통과
- [ ] {onboarding 방식별 액션}
  - buddy: buddy 와 30분 intro
  - pair: 첫 pair session 스케줄링
  - solo: 첫 task pickup

## First Week

- [ ] agents/workflow.md 숙지 (작업 워크플로우)
- [ ] agents/decisions/ 최근 3개 ADR 읽기 (ADR 쓰는 팀만)
- [ ] agents/glossary.md 훑기 — 모르는 용어는 buddy/lead 에게 질문
- [ ] 첫 PR 제출 (작은 task 로 시작)
- [ ] 코드 리뷰 1회 수행 (다른 사람 PR)

## Environment Setup

{프로젝트별 셋업 — 예시}

1. Repository clone
2. 의존성 설치: `{install command}`
3. 환경 변수: `.env.example` 복사 후 값 채우기 (secret manager: {도구명})
4. 로컬 실행: `{run command}`
5. 테스트: `{test command}`

상세: {파일 경로 또는 생략}

## 도움 받기

| 질문 유형 | 채널·경로 |
|-----------|-----------|
| 코드·모듈 | agents/team.md 의 해당 영역 Owner |
| 워크플로우·PR | agents/workflow.md + team lead |
| 용어 | agents/glossary.md |
| 인프라·배포 | agents/runbook/ (있으면) + DevOps |
| 인사·조직 | (HR 채널) |

## 첫 2주 이후

- agents/ 에서 부족한 내용 발견 시 PR 로 추가
- 용어 추가 → agents/glossary.md
- 결정적 의사결정 참여 → agents/decisions/ 에 ADR
- onboarding 경험 피드백 → 이 문서 업데이트 PR
```

## 작성 가이드

1. `First Day` / `First Week` 는 체크박스 형태 유지 — 신규 입사자가 진행 상태를 자체 트래킹 가능
2. "도움 받기" 표는 팀 현실에 맞게 조정 — 채널 이름·Slack 핸들 등은 agents/team.md 를 참조하게 두고 여기에 직접 적지 않는다
3. Environment Setup 은 OS별 분기 필요 시 `agents/setup/{os}.md` 로 분리
4. onboarding 방식 (T4) 에 따라 First Day 마지막 action 조정
5. 신규 입사자가 2주 이후 이 문서를 스스로 개선하게 유도 (마지막 섹션)

## 금지

- 개인 연락처 기재 금지 (rule-team-governance.md Redaction)
- 실제 자격 증명 예시 금지
- "나중에 하세요" 같은 모호한 지시 금지 — 구체적 이 주에 할 것만
