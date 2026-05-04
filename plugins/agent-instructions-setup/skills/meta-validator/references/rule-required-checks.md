---
title: Required Checks (Auto-Fix)
impact: CRITICAL
impactDescription: 사용자 confirm 없이 자동 수정되는 필수 검증 항목
tags: validation, auto-fix, required
---

# Required Checks

아래 항목들은 **사용자 confirm 없이 자동 수정** 된다. agents 문서의 일관성을 깨는 종류의 문제이기 때문.

## 1. Frontmatter Missing / Malformed

### 검출

- `agents/*.md`, `.agents/*.md` 상단에 frontmatter 없음 (단 `AGENTS.md` 자체는 예외)
- frontmatter 가 유효한 YAML 이 아님 (파싱 실패)
- 필수 필드 누락: `title`, `created`, `updated`, `summary`, `tags`, `status`, `relations`

### 자동 수정

- YAML 파싱 실패는 **수정 불가**. 오류 리포트 후 해당 파일 skip
- 누락 필드는 기본값으로 채움:
  - `title` — 첫 H1 헤딩, 없으면 파일명에서 추론
  - `created` / `updated` — git log 기준 (references/rule-git-timestamp-sync.md)
  - `summary` — 첫 비어있지 않은 문단 첫 줄 또는 빈 문자열
  - `tags` — `[]`
  - `status` — `active`
  - `relations` — `[]`

## 2. Status Enum

### 검출

- `status` 값이 `draft` / `active` / `deprecated` / `archived` 중 하나가 아님

### 자동 수정

- 유사값 매핑: `todo` / `wip` / `in-progress` → `draft`, `published` → `active`
- 매핑 불가한 값은 `active` 로 기본 설정

## 3. Tags Normalization

### 검출

- 대문자 포함, 공백 포함, 하이픈 외 구분자 (`api_design`, `api.design`)
- 중복 태그

### 자동 수정

- 소문자 변환
- 공백/언더스코어/점 → 하이픈
- 중복 제거 (순서 유지)

## 4. Broken Relations

### 검출

- `relations` 배열의 경로가 레포 내에 존재하지 않는 파일을 가리킴
- 절대 경로 / URL 포함

### 자동 수정

- 존재하지 않는 경로 → 배열에서 제거
- 절대 경로 / URL → 배열에서 제거 (regex: `^/` 또는 `^https?://`)
- 상대경로 정규화 (`./` 접두사 정리)

### 의도된 broken (rare)

- 같은 줄에 `<!-- meta-validator: keep-broken -->` 주석이 있으면 유지

## 5. Timestamps Drift

### 검출

- `created` 가 git log 의 첫 커밋 타임스탬프와 다름
- `updated` 가 git log 의 마지막 커밋 타임스탬프와 다름

### 자동 수정

references/rule-git-timestamp-sync.md 참조

## 6. Missing Directory README.md

### 검출

- `agents/` 하위 디렉토리에 `README.md` 부재 (예: `agents/decisions/README.md`)
- `.agents/README.md` 부재 (이건 셋업 누락 — 별도 ERROR)
- gitignored / 서브모듈은 스킵

### 자동 수정

- `agents/` 하위: agent-instructions-setup 의 dir-readme 템플릿으로 생성
- `.agents/README.md` 부재: ERROR. agent-instructions-setup 재실행 권장

## 7. Tag Index Staleness

### 검출

- `.agents/.tag-index` 부재
- `generated_at` 이 가장 최근 `.md` mtime 보다 오래됨
- JSON 파싱 실패

### 자동 수정

- 전체 재생성 (references/rule-tag-index-rebuild.md)

## 8. `.agents/preset.json` 유효성

### 검출

- 파일 부재
- JSON 파싱 실패
- `kind` 필드가 `"agents"` 가 아님
- `mode` 가 `solo` / `project` / `hub` 중 하나가 아님

### 처리

- 파일 부재 / 파싱 실패 / `kind != "agents"` → **ERROR**. "agent-instructions-setup 을 먼저 실행하세요"
- 알려지지 않은 `mode` → 경고와 함께 `solo` 로 fallback

## 9. `.gitignore` 필수 라인

### 검출

- `.gitignore` 에 `.agents/.tag-index` 라인 없음
- `.gitignore` 에 `.agents/local/` 라인 없음
- `.agents/` 전체가 ignore 되어 있음

### 자동 수정

- 누락된 라인 추가 (멱등)
- `.agents/` 전체 ignore → **수정 안함. 경고만** (사용자가 직접 조정)

## 9.5. AI Entry Points (AGENTS.md)

### 검출

- 레포 루트에 `AGENTS.md` 부재
- `AGENTS.md` 본문에 `./.agents/README.md` 로의 링크 부재

### 자동 수정

- AGENTS.md 부재 → ERROR. agent-instructions-setup 재실행 권장
- 링크 부재 → "Entry Point" 섹션에 라인 추가 (멱등 마커 사이)

## 10. Secret Scan

### 검출

`agents/**/*.md` + `.agents/**/*.md` 를 스캔 (단 `.agents/local/` 및 gitignored 제외). 상세: references/rule-secret-scan.md

### 자동 수정

**하지 않는다**. 본문 파괴 방지. 대신 meta-validator 를 **ERROR 상태로 마감** 하여 후속 작업 차단.

- `.tag-index` 재생성은 secret 해결 전까지 보류
- 리포트에 매칭 경로/라인/스니펫
- 사용자 해결 방법:
  1. 제거 + `.agents/local/` 로 이동
  2. 플레이스홀더 (`{VAR}` / `${ENV_VAR}`) 로 치환
  3. False positive 면 `<!-- agents-secrets: allow -->`
- 이미 git 히스토리에 있으면 rotation + history-rewrite 도구 안내

### Pragma 우회

- 라인: `<!-- agents-secrets: allow -->`
- 파일: frontmatter 직후 줄에 `<!-- agents-secrets: allow-file -->`

### Hook 일관성

`.agents/hooks/pre-commit-secrets.sh` 와 **동일한 패턴**. 패턴 변경 시 양쪽 동시 수정.

## 자동 수정 원칙

- 자동 수정은 **추가/정리** 방향만. 파괴적 삭제 금지 (예: 본문 삭제, 파일 삭제)
- 단 "스키마에 맞지 않아 무효한 값" 제거는 허용
- **Secret 은 탐지만**. ERROR 로 차단
- 결과는 최종 리포트에 카운트/목록으로 보고
