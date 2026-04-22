---
title: Recommended Checks (Confirm)
impact: HIGH
impactDescription: 사용자 판단이 필요한 권장 검증 항목. 자동 수정하지 않고 y/n 확인
tags: validation, recommended, confirm
---

# Recommended Checks

아래 항목들은 **정답이 상황마다 다르다**. 자동 수정하지 않고 사용자에게 diff 와 함께 y/n 확인한다. `full` 모드에서만 실행.

## 1. Length Overflow

### 검출

- 파일 줄 수 > 1000 (일반)
- 파일 줄 수 > 2000 (시각화 태그 있는 경우)
- `tags` 에 `length-exempt` 있으면 제외

### 확인 질문

```
{path}: {lines}줄 (권장 {max}줄 초과)

이 파일을 분리할까요?
  y) 예 — 나는 지금 분리하겠습니다. (스킬이 분리 수행하진 않음, 나중에 수동)
  n) 아니오 — 현재 크기 유지
  e) 예외 처리 — 이 파일에 length-exempt 태그 추가

선택 [n]: _
```

`y` 선택 → 안내만 (이 스킬이 실제 분리는 안 함). 다음 실행 때 다시 묻지 않도록 이 세션 메모리에 기록.
`e` 선택 → 파일의 `tags` 에 `length-exempt` 추가.

## 2. Active → Deprecated/Archived Reference

### 검출

- `status: active` 문서가 `relations` 로 `status: deprecated` 또는 `archived` 문서를 참조

### 확인 질문

```
{active-file} 이 {deprecated-file} 을 참조합니다.
  {deprecated-file} 은 {status} 상태입니다.

  1) 관계 제거 — relations 에서 삭제
  2) 유지     — 의도적 참조 (역사 인용 등)
  3) {deprecated-file} 의 status 재검토 — active 로 되돌리기

선택 [2]: _
```

## 3. Orphan Files

### 검출

- 어디서도 `relations` 로 참조되지 않음
- 본인의 `relations` 도 비어있음
- 디렉토리 `README.md` 는 제외 대상
- `.kb/` 파일은 제외 대상

### 확인 질문

```
{path} 는 다른 지식과 관계가 없는 "고아" 파일입니다.

  1) skip     — 의도된 상태 (단독 지식)
  2) tag-hint — 관련 문서 탐색 (tag-index 로 유사 태그 후보 제안)
  3) review   — 이 세션 메모리에 "재검토 필요" 로 마킹, 지금은 수정 안함

선택 [1]: _
```

`tag-hint` 선택 시: 이 파일의 태그와 겹치는 다른 파일 목록 보여주기. 사용자가 직접 `relations` 추가.

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

`suggested-tags` 는 본문 H1/H2 헤딩 + 디렉토리명을 기반으로 AI 가 생성 (최대 5개).

### 확인 질문 (과다 태그)

```
{path} 는 태그가 {count} 개 있습니다 (권장 5~8개).

사용 빈도가 낮은 태그: [{low-usage-tags}]  (전체 지식베이스에서 1회만 사용)

  1) prune   — 빈도 낮은 태그 제거
  2) skip    — 유지

선택 [2]: _
```

## 5. Summary Too Short

### 검출

- `summary` 길이 < 20자

### 확인 질문

```
{path} 의 summary 가 너무 짧습니다: "{summary}"

  1) suggest — AI 가 첫 문단 기반으로 제안 생성, 사용자 편집 후 적용
  2) skip    — 유지

선택 [1]: _
```

## 6. Moved File Detection

### 검출

- 다른 파일의 `relations` 에서 제거된 (broken) 경로가 있음
- 동일 파일명을 가진 파일이 다른 디렉토리에 존재함 (이동되었을 가능성)

### 확인 질문

```
{old-path} 참조가 broken 입니다. 같은 파일명이 {new-path} 에 존재합니다.

  1) update — 참조를 {new-path} 로 업데이트
  2) remove — broken 그대로 제거
  3) skip

선택 [1]: _
```

## 7. README.md Stale Summary

### 검출

- 디렉토리 `README.md` 의 `summary` 가 템플릿 placeholder 그대로 (`"(이 디렉토리의 역할 한 줄 — 사용자가 채움)"` 같은 패턴)

### 확인 질문

```
{dir}/README.md 의 summary 가 아직 템플릿 placeholder 입니다.

  1) suggest — 디렉토리 내 파일 태그 기반으로 제안
  2) edit    — 직접 입력
  3) skip    — 나중에

선택 [1]: _
```

## 권장 항목의 "skip" 동작

- 이 세션에서만 무시
- 다음 kb-validator 실행 때 다시 검출
- 영구 예외 처리를 원하면 해당 파일에 `tags: [kb-validator-ignore-{rule}]` 추가 (이 태그가 있으면 해당 룰 건너뜀)

## 순서

Phase 3 에서 recommended 는 다음 순서로 묻는다. 파일별이 아니라 **룰별**:

1. Length overflow (영향 큰 파일부터)
2. Moved file detection
3. Active → deprecated reference
4. Orphan files
5. Tag over/under
6. Summary too short
7. README stale summary

각 룰 시작 전에 "이 룰에 {N}개 항목이 있습니다. 진행할까요? (y/n/skip-all)" 제시. `skip-all` 하면 이 룰 건너뜀.
