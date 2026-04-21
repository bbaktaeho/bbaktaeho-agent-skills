---
title: Postmortem Template
impact: HIGH
impactDescription: Blameless incident records turn outages into team learning
tags: template, postmortem, incident, blameless, team
---

## Purpose

Postmortem 은 인시던트·장애 이후 팀이 배운 것을 기록하는 문서다.

핵심 원칙: **비난 없는 (blameless)**. 개인이 아니라 시스템·프로세스를 분석한다.

## 언제 작성하는가

- 프로덕션 장애가 고객에 영향을 줌
- 심각한 보안 사고
- 예상치 못한 데이터 손실·훼손
- SLA 위반
- On-call 이 30분 이상 대응한 사건

## 언제 작성하지 않는가

- 일상적 버그
- 테스트 환경에서의 문제
- 빠르게 해결되고 영향이 없었던 이슈

## 파일 위치 / 네이밍

`agents/postmortem/{YYYY-MM-DD}-{name}.md`

예: `agents/postmortem/2026-04-21-payment-api-outage.md`

## Template

```markdown
---
title: Postmortem {YYYY-MM-DD} {사건 요약}
description: {사건 유형} 재발 방지 참고. 원인·타임라인·액션 아이템 제공
type: log
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
---

# Postmortem: {사건 제목}

## 핵심 원칙

이 문서는 비난 없는 (blameless) 기록이다. 개인 이름을 탓하는 표현을 쓰지 않는다.

## Summary

- **발생**: {YYYY-MM-DD HH:MM TZ}
- **감지**: {YYYY-MM-DD HH:MM TZ}
- **해결**: {YYYY-MM-DD HH:MM TZ}
- **총 지속**: {N 분/시간}
- **영향**: {고객 수, 요청 수, 수익 영향 — 민감 수치는 "유의미함/경미함" 같은 추상 표현}
- **Severity**: SEV-1 | SEV-2 | SEV-3

## Impact

{사건의 실제 영향을 간결히}

- 영향받은 서비스: ...
- 영향받은 고객: ...
- 기능 상태: {전체 다운 / 부분 장애 / 성능 저하}

## Timeline

시간순 이벤트. 타임존 명시.

| 시각 (TZ) | 이벤트 |
|-----------|--------|
| 10:23 | {첫 이상 징후} |
| 10:27 | {알람 발생} |
| 10:31 | On-call 대응 시작 |
| 10:45 | 원인 식별 |
| 11:02 | 완화 조치 적용 |
| 11:15 | 정상화 확인 |

## Root Cause

근본 원인 분석. 5 Whys 권장.

{원인 기술}

- Why 1: ...
- Why 2: ...
- Why 3: ...
- Why 4: ...
- Why 5: ...

## Contributing Factors

근본 원인 외에 사건을 악화시킨 요인들.

- 알람 설정 미흡
- Runbook 부재
- 모니터링 커버리지 부족
- 등등

## What Went Well

대응 과정에서 잘된 점. 비난 없는 기록의 핵심.

- {긍정적 측면}
- {긍정적 측면}

## What Could Be Improved

개선이 필요했던 점. 개인이 아닌 시스템·프로세스 관점.

- {시스템·프로세스 측면}
- {시스템·프로세스 측면}

## Action Items

재발 방지·개선 과제. 반드시 담당자·기한 명시.

| # | Action | Owner | Due | Status |
|---|--------|-------|-----|--------|
| 1 | {구체적 조치} | @{handle} | {YYYY-MM-DD} | Open |
| 2 | {구체적 조치} | @{handle} | {YYYY-MM-DD} | Open |

## Lessons Learned

이 사건에서 팀이 배운 것. 1~3줄.

## Related

- 관련 ADR
- 관련 runbook (생겼거나 개선된 것)
- 관련 PR·이슈
```

## 작성 원칙

1. **Blameless**: "@김철수가 잘못했다" 금지. "배포 전 검증 단계가 없었다" 같이 시스템 관점
2. **구체적 타임라인**: 분 단위. 추정이면 "~10:23" 명시
3. **Action Items 에 담당자·기한 필수**: 담당자 없는 action 은 실행 안 됨
4. **민감 수치 redaction**: 수익 손실 "$X" 대신 "유의미한 영향" 등 추상 표현 (public repo 일 경우)
5. **사건 후 72시간 내 초안**: 기억이 흐려지기 전

## 리뷰

- 대응에 참여한 인원이 리뷰
- Engineering Lead + 관련 영역 Owner Accept 후 Closed 처리
- Action Items 는 별도 트래킹 (이슈 트래커 등록)

## Action Item 추적

Postmortem 을 쓰는 것만으로는 재발 방지가 안 된다. Action Items 는:

1. 작성 시 이슈 트래커에 등록
2. 다음 retro·회의에서 진행 상황 리뷰
3. 완료 시 Postmortem 의 Status 컬럼을 Closed 로 갱신

## 금지

- 개인 비난
- 실제 자격 증명·내부 URL 원문
- 고객 PII
- 소문·추측 (확인된 사실만)

## Agent 활용

유사 사건 재발 시 agent 가 과거 postmortem 을 찾아 유사 원인·해결책을 제시. frontmatter description 에 "{사건 유형} 재발 방지 참고" 패턴 권장.
