---
name: meta-validator
description: >
  Validate and auto-fix agents/ instruction docs and the .agents/
  meta directory set up by agent-instructions-setup. Checks every
  .md against the frontmatter schema (title, created, updated,
  summary, tags, status, relations), syncs timestamps from git log,
  prunes broken relations, rebuilds .agents/.tag-index, verifies
  every directory has README.md, enforces tight length limits
  (AGENTS.md 50/80/120, agents/*.md 80/100/150), and scans for
  secrets using the same patterns as the .agents/hooks/ pre-commit
  hook. Required checks auto-fix except secrets, which halt with
  ERROR. Recommended checks (length, deprecated refs, orphans,
  tag counts, summary, moved files, stale README summary) prompt
  the user. Use after editing AGENTS.md or agents/, before merging,
  after retrofit, when tag search is stale, when the pre-commit
  hook was bypassed, or to verify agents docs - even if the user
  says "check agents docs", "validate AGENTS.md", or "scan secrets".
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: May 2026
  abstract: >
    Validator companion skill to agent-instructions-setup. Operates
    in three modes: quick (required checks only, auto-fix), full
    (required + recommended, recommended needs y/n), dry-run (report
    only, no writes). Required checks: frontmatter schema compliance,
    status enum, tag normalization, relations point to existing
    files, created/updated match git log, every agents/ subdirectory
    has README.md, .agents/.tag-index rebuilt, .agents/preset.json
    valid (kind=="agents"), AGENTS.md exists with idempotent marker,
    .gitignore has .agents/.tag-index and .agents/local/, secret
    scan with detection-only ERROR halt. Recommended checks: length
    overflow (50/80 for AGENTS.md, 80/100/150 for agents/*.md - much
    stricter than kb docs), deprecated references, orphans, tag
    over/under count, summary too short, moved files, README stale
    summary. All rules in references/rule-*.md. Reads .agents/
    preset.json mode (solo|project|hub) for mode-specific checks.
---

# Meta Validator

`agent-instructions-setup` 으로 셋업된 `.agents/` 메타 디렉토리와 `agents/` 컨텐츠를 검증 / 자동수정한다. 같은 플러그인 안에 동거하는 companion skill.

## When to Run

- `agents/*.md` 또는 `AGENTS.md` 추가 / 삭제 / 편집 후
- 병합 / PR 전
- 초기 셋업 직후 한 번
- 태그 검색이 stale 해 보일 때
- frontmatter 가 드리프트했을 때
- pre-commit hook 을 우회한 후

## Modes

references/flow-modes.md

- `quick` — 필수만. 자동 수정. 기본 모드
- `full` — 필수 + 권장. 권장은 diff + y/n confirm
- `dry-run` — 수정 없음. 리포트만

## Check Categories

| Priority | Category | Prefix | 대표 파일 |
|----------|----------|--------|-----------|
| CRITICAL | Required Checks (auto-fix) | `rule-` | required-checks |
| CRITICAL | Secret Scan (detect, halt) | `rule-` | secret-scan |
| HIGH | Recommended Checks (confirm) | `rule-` | recommended-checks |
| CRITICAL | Git Timestamp Sync | `rule-` | git-timestamp-sync |
| CRITICAL | Tag Index Rebuild | `rule-` | tag-index-rebuild |
| CRITICAL | Tool Dependencies | `rule-` | tool-dependencies |

전체 목록: references/_sections.md

## Execution Flow

### Phase 0: Setup Scan

1. `.agents/preset.json` 읽기 → `kind == "agents"` 확인. 없거나 다르면 "agent-instructions-setup 을 먼저 실행하세요" 로 중단
2. **Tool check** — `yq` 또는 `python3+PyYAML` 등 frontmatter 파서 존재 확인. 없으면 사용자에게 install 옵션 (references/rule-tool-dependencies.md). skip 시 degraded 모드 (frontmatter 검증 건너뜀)
3. 모드 확인 (사용자 지정 또는 기본 `quick`)

### Phase 1: Required Checks

각 `agents/*.md` 와 `.agents/*.md` 에 대해:

1. frontmatter 파싱. 유효 YAML 아니면 오류 보고 (수정 거부, 사용자 개입 필요). AGENTS.md 의 frontmatter 부재는 허용
2. 필수 필드 검사 / 누락 자동 보강
3. `status` enum 검증
4. `tags` 정규화 (소문자 + 하이픈)
5. `relations` 각 경로 존재 여부 → 없으면 제거
6. `created` / `updated` git log 동기화 (references/rule-git-timestamp-sync.md)
7. 디렉토리마다 `README.md` 존재 확인. 없으면 템플릿으로 생성
8. `.gitignore` 에 `.agents/.tag-index`, `.agents/local/` 라인 보장
9. **Secret Scan** — 민감 정보 감지 (references/rule-secret-scan.md). 매칭되면 ERROR 로 마감 준비 + Phase 2 의 tag-index 재생성 보류

### Phase 2: Tag Index Rebuild

- Phase 1 에서 secret 검출이 **없는 경우에만** `.agents/.tag-index` 전체 재생성 (references/rule-tag-index-rebuild.md)
- Secret 검출이 있으면 기존 인덱스 유지 (위치 노출 방지)

### Phase 3: Recommended Checks (full 모드만)

각 항목마다 사용자에게 y/n 확인. 상세: references/rule-recommended-checks.md

### Phase 4: Report

수정된 / 수정 거부된 / 경고된 항목을 요약 출력.

## References

- https://agents.md
