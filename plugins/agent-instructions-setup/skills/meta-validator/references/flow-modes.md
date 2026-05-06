---
title: Execution Modes
impact: HIGH
impactDescription: meta-validator 의 quick / full / dry-run 모드 차이
tags: modes, flow, execution
---

# Execution Modes

meta-validator 는 세 가지 모드로 동작한다. 호출 시 mode 인자로 전달 (기본 `quick`).

## Mode Matrix

| Mode | Required Checks | Recommended Checks | Writes Files | 사용 시점 |
|------|-----------------|---------------------|--------------|-----------|
| `quick` | 자동 수정 | 건너뜀 | Yes | 매일 / 커밋 전 |
| `full` | 자동 수정 | y/n 확인 후 수정 | Yes | 주기적 점검 / PR 전 |
| `dry-run` | 감지만 | 감지만 | No | 대규모 변경 전 사전 확인 |

## `quick` (기본)

- 실행 시간 짧음
- 사용자 개입 없음. 자동 수정
- git hook 에 걸어두기 적합
- 리포트: 자동 수정된 항목 목록

### Phase 실행

1. Phase 0: Setup Scan + Tool Check
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

Phase 0 ~ 4 전부. Phase 3 는 references/rule-recommended-checks.md 의 룰을 순서대로.

### 사용자 인터랙션 예시

```
[Rule 1/7] Length Overflow
3 files exceed recommended length.

  .agents/README.md (212 lines, hard 200 초과)
  docs/README.md (135 lines, soft 120 초과)
  AGENTS.md (88 lines, soft 80 초과)

Continue? [y/n/skip-all]: y
```

## `dry-run`

- 파일 수정 / 쓰기 없음
- 감지만 수행. 상세 리포트 출력
- 대규모 retrofit 직후, 또는 "뭐가 바뀔지" 확인할 때

### Phase 실행

- Phase 0: Setup Scan + Tool Check
- Phase 1: Required Checks (감지만)
- Phase 2: Tag Index (기존 유지, 재생성 안 함)
- Phase 3: 감지만 (full 수준의 분석)
- Phase 4: 상세 Report

## 모드 선택 기본 규칙

- 그냥 `/meta-validator` → `quick`
- `/meta-validator full` → `full`
- `/meta-validator dry-run` → `dry-run`
- agent-instructions-setup retrofit 직후 권장: `dry-run`

## 사용자가 명시적 모드 전환

실행 중 프롬프트에서:

- `skip-all`: 현재 룰 전체 skip, 다음 룰로
- `abort`: 즉시 종료. 지금까지의 수정은 유지

## Exit Codes (자동화 용)

리포트에 명시:

- `OK` — 수정 없음 또는 자동 수정 성공
- `CHANGED` — 자동 수정 발생 (CI 에서 "커밋 필요")
- `WARN` — 권장 항목 감지
- `ERROR` — parse 실패 또는 secret 검출. 수동 개입 필요
