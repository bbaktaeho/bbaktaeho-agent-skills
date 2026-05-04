---
title: Recommended Checks (Confirm)
impact: HIGH
impactDescription: 사용자 판단이 필요한 권장 검증 항목. 자동 수정하지 않고 y/n 확인
tags: validation, recommended, confirm, length, lifecycle
---

# Recommended Checks

`full` 모드에서만 실행. 정답이 상황마다 다른 항목들이라 자동 수정하지 않고 사용자 확인.

## 1. Length Overflow

agents 문서는 짧게 유지하는 게 핵심. 임계값은 kb 보다 훨씬 strict.

### 임계값

| 파일 유형 | Target | Soft warn | Hard warn |
|-----------|--------|-----------|-----------|
| `AGENTS.md` (루트) | 50줄 | 80줄 | 120줄 |
| `agents/guide.md` | 80줄 | 100줄 | 150줄 |
| `agents/*.md` (그 외) | 80줄 | 100줄 | 150줄 |
| 디렉토리 README.md | 50줄 | 80줄 | 120줄 |

- `tags` 에 `length-exempt` 있으면 검사 제외
- soft 초과: 한 번 확인. "keep" 선택 시 이번 분량은 묵시적 허용
- hard 초과: 분할 강력 권장 메시지 (다른 톤으로)

### 확인 질문 (soft 초과)

```
{path}: {lines}줄 (soft 임계값 {soft}줄 초과, target {target}줄)

이 파일을 분리할까요?
  y) 예 — 분리 계획 (스킬이 분할은 안 함)
  n) 아니오 — 현재 크기 유지
  e) 예외 처리 — 이 파일에 length-exempt 태그 추가

선택 [n]: _
```

### 확인 질문 (hard 초과)

```
{path}: {lines}줄 (hard 임계값 {hard}줄 초과)

agents/ 문서는 짧게 유지해야 합니다 (target {target}줄). 분할을 강력 권장합니다.

권장 분할 패턴:
  agents/{topic}.md            # 단일 파일
  ↓
  agents/{topic}/
  ├── README.md                # 요약 + 라우팅
  ├── overview.md
  └── details-{aspect}.md

  y) 예 — 분리 계획
  n) 아니오 — 현재 크기 유지
  e) 예외 처리 — length-exempt 태그 추가

선택 [n]: _
```

## 2. Active → Deprecated/Archived Reference

### 검출

- `status: active` 문서가 `relations` 로 `status: deprecated` 또는 `archived` 문서를 참조

### 확인 질문

```
{active-file} 이 {deprecated-file} 을 참조합니다.
  {deprecated-file} 은 {status} 상태입니다.

  1) 관계 제거 — relations 에서 삭제
  2) 유지     — 의도적 참조 (역사 인용 등)
  3) {deprecated-file} status 재검토 — active 로 되돌리기

선택 [2]: _
```

## 3. Orphan Files

### 검출

- 어디서도 `relations` 로 참조되지 않음
- 본인의 `relations` 도 비어있음
- 디렉토리 `README.md` 는 제외
- `.agents/` 메타 파일은 제외

### 확인 질문

```
{path} 는 다른 agents 문서와 관계가 없습니다.

  1) skip     — 의도된 상태
  2) tag-hint — 유사 태그 후보 제안
  3) review   — 이 세션 메모리에 마킹, 지금은 수정 안함

선택 [1]: _
```

## 4. Tag Over/Under Count

### 검출

- `tags` 가 비어있음 (`[]`)
- `tags` 개수 > 10개

### 확인 질문 (빈 태그)

```
{path} 에 태그가 없습니다.

본문 기반 태그 후보: [{suggested-tags}]

  1) accept  — 제안된 태그 추가
  2) custom  — 직접 입력
  3) skip    — 유지

선택 [1]: _
```

### 확인 질문 (과다 태그)

```
{path} 는 태그가 {count} 개 (권장 5~8개).

사용 빈도 낮은 태그: [{low-usage-tags}]

  1) prune   — 빈도 낮은 태그 제거
  2) skip    — 유지

선택 [2]: _
```

## 5. Summary Too Short

### 검출

- `summary` 길이 < 20자

### 확인 질문

```
{path} 의 summary: "{summary}"

  1) suggest — 첫 문단 기반 제안 생성
  2) skip    — 유지

선택 [1]: _
```

## 6. Moved File Detection

### 검출

- 다른 파일의 `relations` 가 broken 인데 동일 파일명이 다른 경로에 존재

### 확인 질문

```
{old-path} 참조 broken. 동일 파일명이 {new-path} 에 존재.

  1) update — 참조를 {new-path} 로
  2) remove — broken 그대로 제거
  3) skip

선택 [1]: _
```

## 7. README.md Stale Summary

### 검출

- `agents/{dir}/README.md` 의 `summary` 가 placeholder 그대로

### 확인 질문

```
{dir}/README.md 의 summary 가 placeholder 입니다.

  1) suggest — 디렉토리 내 파일 태그 기반 제안
  2) edit    — 직접 입력
  3) skip    — 나중에

선택 [1]: _
```

## 권장 항목의 "skip"

- 이 세션에서만 무시. 다음 실행 때 다시 검출
- 영구 예외: 해당 파일에 `tags: [meta-validator-ignore-{rule}]` 추가

## 순서

Phase 3 에서 룰별로 묻는다:

1. Length overflow (영향 큰 파일부터)
2. Moved file detection
3. Active → deprecated
4. Orphan files
5. Tag over/under
6. Summary too short
7. README stale summary
