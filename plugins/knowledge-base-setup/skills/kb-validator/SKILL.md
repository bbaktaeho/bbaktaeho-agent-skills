---
name: kb-validator
description: >
  Validate and auto-fix a markdown knowledge base set up by the
  knowledge-base-setup skill. Checks every .md against the frontmatter
  schema (title, created, updated, summary, tags, status, relations),
  syncs timestamps from git log, prunes relations pointing at deleted
  files, rebuilds .kb/.tag-index, verifies every directory has
  README.md, enforces the 1000/2000/2500-line recommendations, and
  scans for secrets (credentials, tokens, private keys, basic-auth
  URLs, internal endpoints) using the same patterns as the pre-commit
  hook. Required checks auto-fix except secrets, which halt with
  ERROR for safe manual review. Recommended checks (length, deprecated
  refs, orphans, tag counts) prompt the user. Use after adding or
  deleting knowledge, before merging, after retrofit, when tag search
  is stale, when the pre-commit hook was bypassed, or to verify the
  KB is well-formed - even if the user just says "check the docs",
  "validate kb", "scan secrets", or "fix frontmatter".
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: >
    Validator companion skill to knowledge-base-setup. Operates in
    three modes: quick (required checks only, auto-fix), full
    (required + recommended, recommended needs y/n), dry-run (report
    only, no writes). Required checks: frontmatter schema compliance,
    status enum, tag normalization, relations point to existing files,
    created/updated match git log, every directory has README.md,
    .tag-index rebuilt, secret scan (AWS / GitHub / Google / Slack /
    private keys / JWT / basic-auth URLs / internal IPs / credential
    assignments) with detection-only ERROR halt. Recommended checks:
    length overflow (1000 general / 2000 visualization / 2500 soft
    and 4000 strong for research), active file referencing deprecated
    or archived, orphan files, tag over/under count, summary too
    short. All rules documented in references/rule-*.md.
---

# KB Validator

`knowledge-base-setup` 으로 셋업된 지식베이스를 검증 / 자동수정한다. 같은 플러그인 안에 동거하는 companion skill.

## When to Run

- 지식 추가 / 삭제 후
- 병합 / PR 전
- `kb-validator` 최초 실행은 초기 셋업 직후 권장
- 태그 검색이 stale 해 보일 때 (재인덱싱 목적)
- frontmatter 가 드리프트했을 때 (사용자가 외부 에디터로 직접 수정한 경우)
- retrofit 이후 일괄 검증

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

전체 목록: references/_sections.md

## Execution Flow

### Phase 0: Setup Scan

1. `.kb/preset.json` 읽기 → 프리셋 / 스키마 버전 확인. 없으면 "지식베이스가 세팅되지 않음. knowledge-base-setup 스킬을 먼저 실행하세요" 로 중단
2. 모드 확인 (사용자 지정 또는 기본 `quick`)

### Phase 1: Required Checks

각 `.md` 파일에 대해:

1. frontmatter 파싱. 유효 YAML 아니면 오류 보고 (수정 거부, 사용자 개입 필요)
2. 필수 필드 검사 / 누락 자동 보강
3. `status` enum 검증
4. `tags` 정규화 (소문자 + 하이픈)
5. `relations` 각 경로 존재 여부 → 없으면 제거
6. `created` / `updated` git log 동기화 (references/rule-git-timestamp-sync.md)
7. 디렉토리마다 `README.md` 존재 확인. 없으면 템플릿으로 생성
8. `.gitignore` 에 `.kb/.tag-index`, `.kb/local/` 라인 보장
9. **Secret Scan** — 민감 정보 감지 (references/rule-secret-scan.md). 매칭되면 ERROR 로 마감 준비 + Phase 2 의 tag-index 재생성 보류

### Phase 2: Tag Index Rebuild

- Phase 1 에서 secret 검출이 **없는 경우에만** `.kb/.tag-index` 전체 재생성 (references/rule-tag-index-rebuild.md)
- `generated_at` 갱신
- Secret 검출이 있으면 기존 인덱스 유지 (위치 노출 방지)

### Phase 3: Recommended Checks (full 모드만)

각 항목마다 사용자에게 y/n 확인. 상세: references/rule-recommended-checks.md

### Phase 4: Report

수정된 / 수정 거부된 / 경고된 항목을 요약 출력:

```
== KB Validation Report ==

Required fixes (auto-applied):
  - frontmatter 보강: 3 files
  - relations 정리: 2 broken links 제거
  - timestamps 동기화: 8 files
  - README.md 생성: 1 directory

Recommended (pending):
  - length overflow: 1 file (notes/big-paper.md: 1240 lines)
  - deprecated reference: 2 cases

Tag Index: rebuilt (generated_at: 2026-04-22T10:30:00Z)
Total .md files scanned: 42
```

## References

- https://agents.md
