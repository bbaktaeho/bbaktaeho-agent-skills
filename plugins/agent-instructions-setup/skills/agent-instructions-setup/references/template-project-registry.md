---
title: Project Registry Entry Template
impact: CRITICAL
impactDescription: Registry entry is AI's first stop for cross-project routing
tags: hub, template, registry, project, cross-project
---

## Purpose

허브의 `agents/projects/{name}.md` 템플릿. 팀이 관리하는 각 프로젝트의 **AI-scannable 메타 요약** 이다.

AI 에이전트가 "이 프로젝트 봐야겠다" 고 판단하는 결정점. 따라서 frontmatter description 과 Summary 가 핵심.

## 파일 위치 / 네이밍

`agents/projects/{name}.md`

- `{name}`: 영문 kebab-case. 실제 레포명과 일치 권장
- Archived 프로젝트: `agents/projects/archived/{name}.md`

## Template

```markdown
---
title: {Project Name}
description: {status} {1줄 설명}. {핵심 책임}. Cross-project 작업 시 먼저 참고
type: reference
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# {Project Name}

## Quick Facts

- **Repo**: {URL}
- **Status**: active | maintenance | archived
- **Owner**: @{primary-handle} (primary), @{backup-handle} (backup)
- **Stack**: {primary-language}, {framework}, {database}
- **Deployed**: {환경 - 구체적 URL 은 secret manager / 내부 wiki 참조}
- **Project agents/**: {해당 레포의 agents/guide.md 링크}

## Summary

{2~3문단 — 이 프로젝트가 무엇을 담당하는가, 어떤 문제를 푸는가, 주요 진입점은 무엇인가}

## Depends On

이 프로젝트가 의존하는 것.

- 팀 내부 프로젝트: {name} (agents/projects/{name}.md)
- 외부 서비스: {서비스}
- 공유 라이브러리: {lib} (agents/shared-libraries.md)
- 공유 인프라: {항목} (agents/infrastructure.md)

## Depended By

이 프로젝트에 의존하는 것.

- 팀 내부 프로젝트: {name}
- 외부 소비자: {서비스}

## Key Interfaces

AI 가 알아야 할 이 프로젝트의 주요 인터페이스.

- **API**: {주요 엔드포인트 그룹 또는 프로젝트 agents/ 의 API 문서 링크}
- **Events**: {발행/구독 이벤트 주제}
- **CLI / SDK**: {있으면}

## Key Decisions (최근 ADR)

이 프로젝트의 최근 중요 결정. 상세는 프로젝트 레포 agents/decisions/.

- {ADR-NNN 제목} — {1줄 요약} ({link})
- {ADR-NNN 제목} — {1줄 요약} ({link})

## Change Cadence

- 활발함 | 안정기 | 유지보수만

## When to Touch This Project

AI 에이전트가 이 프로젝트를 건드려야 하는 신호.

- {기능/도메인 1}
- {기능/도메인 2}
- "{키워드}" 가 등장하면 이 프로젝트 후보

## When NOT to Touch

이 프로젝트를 건드리지 말아야 하는 경우 (잘못된 프로젝트에 코드 추가 방지).

- {다른 프로젝트가 더 적합한 케이스}

## Known Pitfalls

이 프로젝트 작업 시 흔한 실수 (AI 가 반복하지 않도록).

- {실수 1과 회피법}
- {실수 2와 회피법}

## References

- [프로젝트 레포]({URL})
- [프로젝트 agents/guide.md]({URL}/blob/main/agents/guide.md)
- [관련 org ADR](agents/decisions/...)
```

## AI-readability 원칙

이 템플릿의 각 섹션은 AI 에이전트가 cross-project 작업에서 질문받을 때 답하기 위해 설계됐다.

| AI 질문 | 답하는 섹션 |
|---------|-------------|
| "이 기능 어느 프로젝트에 추가해야 해?" | When to Touch / When NOT to Touch |
| "이 변경이 다른 서비스에 영향 주나?" | Depended By |
| "이 프로젝트 쓰려면 뭐 필요해?" | Depends On, Key Interfaces |
| "누가 담당?" | Quick Facts → Owner |
| "이 프로젝트 어떻게 생겼어?" | Summary + Key Interfaces |
| "이 프로젝트 어떤 기술 써?" | Quick Facts → Stack |
| "전에 여기서 어떤 결정 있었어?" | Key Decisions + 링크 |
| "조심할 거 있어?" | Known Pitfalls |

## 작성 원칙

1. **Quick Facts 는 데이터**: 표·키-값 형식으로 agent 가 파싱하기 쉽게. 서술형 금지
2. **Summary 는 3문단 이하**: 더 길면 해당 프로젝트 agents/guide.md 로 위임
3. **동적 정보 최소화**: 배포 URL 원문, 최신 버전 번호 같이 자주 바뀌는 값은 넣지 않음. 링크 + 조회 방법만
4. **When to Touch / NOT to Touch 가 핵심**: AI routing 의 승부처. 공들여 작성
5. **민감 정보 금지**: agents/security.md 준수. 실제 자격 증명·내부 IP·고객 PII 금지

## 등록·갱신 타이밍

### 신규 프로젝트 등록

1. 프로젝트 레포 생성 후 이 템플릿으로 `agents/projects/{name}.md` 작성
2. agents/guide.md 프로젝트 대시보드에 행 추가
3. 관련 프로젝트들의 `Depends On` / `Depended By` 도 업데이트 (cross-reference)

### 갱신 트리거

- Owner 변경
- Status 변경 (active ↔ maintenance ↔ archived)
- Stack 주요 변경 (언어·프레임워크 교체)
- 주요 ADR 발생 → "Key Decisions" 섹션 추가
- Known Pitfalls 발견 → 사고 후 추가

### Archived 처리

프로젝트가 더 이상 개발 안 되면.

1. Status 를 `archived` 로 변경
2. 파일을 `agents/projects/archived/{name}.md` 로 이동
3. agents/guide.md 대시보드에서 제거
4. 다른 프로젝트의 `Depends On` 에 이 프로젝트가 있으면 해당 의존성 처리 방안 명시

## 금지

- 실제 자격 증명·내부 인프라 URL
- 고객·사용자 PII
- 팀원 개인 연락처 (Slack handle 은 OK)
- 자주 변경되는 동적 값 (버전 번호·대시보드 수치)
- 회의록·내부 의사결정 논쟁 과정 (결정은 ADR 로)
