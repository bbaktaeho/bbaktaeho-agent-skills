---
title: Execution Modes
impact: HIGH
impactDescription: kb-validator 의 quick / full / dry-run 모드 차이
tags: modes, flow, execution
---

# Execution Modes

kb-validator 는 세 가지 모드로 동작한다. 사용자가 스킬 호출 시 mode 인자로 전달 (기본 `quick`).

## Mode Matrix

| Mode | Required Checks | Recommended Checks | Writes Files | 사용 시점 |
|------|-----------------|---------------------|--------------|-----------|
| `quick` | 자동 수정 | 건너뜀 | Yes | 매일 / 커밋 전 |
| `full` | 자동 수정 | y/n 확인 후 수정 | Yes | 주기적 점검 / PR 전 |
| `dry-run` | 감지만 | 감지만 | No | 대규모 변경 전 사전 확인 |

## `quick` (기본)

- 실행 시간 짧음 (수 초 ~ 수십 초)
- 사용자 개입 없음. 자동 수정
- git hook 에 걸어두기 적합
- 리포트: 자동 수정된 항목 목록

### Phase 실행

1. Phase 0: Setup Scan
2. Phase 1: Required Checks (auto-fix)
3. Phase 2: Tag Index Rebuild
4. Phase 3: 건너뜀
5. Phase 4: Report

## `full`

- 실행 시간 길 수 있음 (권장 항목마다 사용자 확인)
- 인터랙티브. 각 룰마다 y/n/skip-all
- 분기별 또는 대규모 변경 후 권장
- 리포트: 자동 수정 + 수동 확인 결과 모두 요약

### Phase 실행

Phase 0 ~ 4 전부. Phase 3 는 references/rule-recommended-checks.md 의 7개 룰을 순서대로.

### 사용자 인터랙션 예시

```
[Rule 1/7] Length Overflow
3 files exceed recommended length.

  notes/paper-analysis.md (1342 lines)
  topics/consensus/tendermint.md (1108 lines)
  projects/payment-v2/spec.md (1034 lines)

Continue? [y/n/skip-all]: y

--- notes/paper-analysis.md: 1342 lines ---
Action? [y)split later  n)keep  e)length-exempt]: n
...
```

## `dry-run`

- 파일 수정 / 쓰기 없음
- 감지만 수행. 상세 리포트 출력
- 대규모 retrofit 직후, 또는 "뭐가 바뀔지" 확인할 때
- 리포트에 어떤 필수 수정이 발생할지 나열

### Phase 실행

- Phase 0: Setup Scan
- Phase 1: Required Checks (감지만, 수정 X)
- Phase 2: Tag Index (기존 유지, 재생성 안 함)
- Phase 3: 감지만 (full 모드 수준의 분석)
- Phase 4: 상세 Report

### 리포트 예시 (dry-run)

```
== KB Validation DRY-RUN ==

Would auto-fix (if quick/full):
  [frontmatter] research/notes/idea-01.md — missing tags, status
  [relations]   guides/auth.md — broken link to ../concepts/old-auth.md
  [timestamps]  42 files have created/updated drift (sample: topics/mev.md created 2026-04-01 → 2026-03-28)

Would warn (recommended):
  [length]      1 file over 1000 lines
  [orphan]      3 files with no relations and no backrefs

No changes made. Run without --dry-run to apply.
```

## 모드 선택 기본 규칙

- 사용자가 그냥 `/kb-validator` 실행 → `quick`
- `/kb-validator full` → `full`
- `/kb-validator dry-run` → `dry-run`
- 스킬 내부에서 retrofit 직후 권장: `dry-run` 으로 사용자에게 사전 확인

## 사용자가 명시적으로 모드 전환

실행 중 사용자 프롬프트에서 `skip-all` / `abort` 가능:

- `skip-all`: 현재 룰 전체 skip, 다음 룰로
- `abort`: kb-validator 즉시 종료. 지금까지 수정된 항목은 유지 (atomic 하게 이미 쓰여진 상태)

## Exit Codes (스크립트 자동화 용)

스킬 자체는 exit code 를 직접 쓰진 않지만, 자동화를 위해 리포트에 명시:

- `OK` — 수정 없음 또는 자동 수정 성공
- `CHANGED` — 자동 수정 발생 (CI 에서 "커밋 필요" 로 판단)
- `WARN` — 권장 항목 감지 (full/dry-run 에서)
- `ERROR` — parse 실패 등 수동 개입 필요
