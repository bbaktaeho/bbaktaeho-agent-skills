---
title: Required Checks (Auto-Fix)
impact: CRITICAL
impactDescription: 사용자 confirm 없이 자동 수정되는 필수 검증 항목
tags: validation, auto-fix, required
---

# Required Checks

아래 항목들은 **사용자 confirm 없이 자동 수정** 된다. "지식베이스의 일관성을 깨는" 종류의 문제이기 때문.

## 1. Frontmatter Missing / Malformed

### 검출

- `.md` 파일 상단에 frontmatter 없음
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

- 대문자 포함 (예: `AUTH`)
- 공백 포함 (예: `api design`)
- 하이픈이 아닌 구분자 (예: `api_design`, `api.design`)
- 중복 태그

### 자동 수정

- 소문자 변환
- 공백/언더스코어/점 → 하이픈
- 중복 제거 (순서 유지)

## 4. Broken Relations

### 검출

- `relations` 배열의 경로가 지식베이스 내에 존재하지 않는 파일을 가리킴
- 절대 경로 / URL 포함

### 자동 수정

- 존재하지 않는 경로 → 배열에서 제거
- 절대 경로 / URL → 배열에서 제거 (regex: `^/` 또는 `^https?://`)
- 존재하지만 경로가 레포 기준이 아닌 상대경로인 경우 → 정규화 (`./` 접두사 삭제, `../` 정리)

### 이동된 파일 감지 (선택적 확장)

- "이동된 파일 가능성" 검출: 동일 파일명 + 다른 경로에 존재
- 사용자에게 `{old-path} 을 {new-path} 로 업데이트할까요?` 확인 (이건 권장 항목)
- Required 레벨에서는 단순히 broken 제거만

## 5. Timestamps Drift

### 검출

- `created` 가 git log 의 첫 커밋 타임스탬프와 다름
- `updated` 가 git log 의 마지막 커밋 타임스탬프와 다름

### 자동 수정

references/rule-git-timestamp-sync.md 참조

## 6. Missing Directory README.md

### 검출

- 지식베이스 하위 디렉토리에 `README.md` 부재
- `.kb/` 는 제외 대상이 아님 (`.kb/README.md` 도 필수)
- gitignored 디렉토리 / 서브모듈은 스킵

### 자동 수정

- `knowledge-base-setup` 의 template-dir-readme.md 템플릿으로 생성
- `title` — 디렉토리명 기반 (references/template-dir-readme.md 의 매핑 참조)
- `summary` — 빈 상태 (placeholder). 사용자가 나중에 채움

## 7. Tag Index Staleness

### 검출

- `.kb/.tag-index` 부재
- `.kb/.tag-index` 의 `generated_at` 이 가장 최근 `.md` 파일 mtime 보다 오래됨 (들여쓰기 허용 범위 초과)
- JSON 파싱 실패

### 자동 수정

- 전체 재생성 (references/rule-tag-index-rebuild.md)

## 8. `.kb/preset.json` 유효성

### 검출

- JSON 파싱 실패
- `preset` 필드가 알려진 프리셋 중 하나가 아님 (`team-docs` / `research` / `product` / `custom`)

### 자동 수정 / 오류

- 파싱 실패 → **수정 불가**. "knowledge-base-setup 으로 재초기화가 필요합니다" 오류
- 알려지지 않은 `preset` → `custom` 으로 fallback (경고와 함께)

## 9. `.gitignore` 필수 라인

### 검출

- `.gitignore` 에 `.kb/.tag-index` 라인 없음
- `.gitignore` 에 `.kb/local/` 라인 없음
- `.kb/` 전체가 ignore 되어 있음 (다른 .kb 파일이 커밋 안 됨)

### 자동 수정

- 누락된 라인 추가 (멱등)
- `.kb/` 전체 ignore → **수정 안함. 경고 리포트만** (사용자가 직접 조정해야 함, 위험)

## 9.5. AI Entry Points (AGENTS.md / README.md)

### 검출

- KB 루트에 `AGENTS.md` 부재 **또는** 존재하지만 멱등 마커 (`<!-- kb-setup: knowledge-base-entry-point -->`) 없음
- KB 루트에 `README.md` 부재 **또는** 존재하지만 `## About` / `<!-- kb-setup: about -->` 섹션 없음
- 두 파일 모두 `.kb/README.md` 를 링크하지 않음

### 자동 수정

- `AGENTS.md` 부재: 기본 템플릿 (knowledge-base-setup 의 template-agents.md) 으로 생성
- 존재하지만 마커 블록 없음: 파일 끝에 블록 append (기존 본문 보존)
- 마커 블록 있음: 블록 내부가 현재 스킬 버전과 다르면 **업데이트하지 않음** (사용자 커스터마이징 가능성 존중). 대신 WARN 리포트만 — full 모드에서 권장 항목으로 승격
- `README.md` 부재: template-root-readme.md 로 생성 (About 섹션 placeholder 포함)
- `README.md` 존재 + About 섹션 없음: 파일 시작부에 멱등 마커 블록으로 About placeholder 추가. 사용자에게 내용 채우기 안내

### 링크 정합성

- `AGENTS.md` 본문에 `./.kb/README.md` 와 `./README.md` 둘 다 링크되어 있는지 확인
- `README.md` frontmatter `relations` 에 `./.kb/README.md`, `./AGENTS.md` 포함 확인. 없으면 추가

## 10. Secret Scan

### 검출

지식베이스 내 `.md` 파일 + `.kb/*.md` (단, `.kb/local/` 및 gitignored 파일 제외) 를 스캔. 상세 패턴: references/rule-secret-scan.md

- AWS access key (`AKIA[0-9A-Z]{16}`)
- GitHub PAT / OAuth / Server / User / Refresh tokens
- GitHub fine-grained PAT (`github_pat_`)
- Google API keys (`AIza`)
- Slack tokens (`xox[baprs]-`)
- Private key blocks (`-----BEGIN ... PRIVATE KEY-----`)
- JWT-shaped strings (`eyJ...\.eyJ...\..`)
- Basic auth URLs (`https?://user:pass@`)
- RFC1918 내부 IP URLs (`https?://(10.|172.16-31.|192.168.)...`)
- 일반 credential 할당문 (`password`/`secret`/`token`/`api_key` 등 + 12자 이상 값)

### 자동 수정

**하지 않는다**. 본문 파괴 방지. 대신 kb-validator 를 **ERROR 상태로 마감** 하여 후속 작업 차단.

- `.tag-index` 재생성은 secret 해결 전까지 보류 (인덱스에 위치 노출 방지)
- 리포트에 매칭된 경로/라인/스니펫 제공
- 사용자 해결 방법 안내:
  1. 제거 + `.kb/local/` 로 이동
  2. 플레이스홀더 (`{VAR}` / `${ENV_VAR}`) 로 치환
  3. False positive 면 같은 줄에 `<!-- kb-secrets: allow -->` 추가
- 이미 git 히스토리에 있으면 rotation + `git-filter-repo` / `BFG` 안내

### Pragma 우회

- 라인 단위: `<!-- kb-secrets: allow -->`
- 파일 단위: frontmatter 바로 다음 줄에 `<!-- kb-secrets: allow-file -->`

### pre-commit hook 과의 일관성

`.kb/hooks/pre-commit-secrets.sh` 와 **동일한 패턴** 사용. 둘 중 하나만 관대하면 우회가 가능하므로, 패턴 변경 시 양쪽을 반드시 함께 수정.

## 자동 수정 원칙

- 자동 수정은 **추가/정리** 방향만. 사용자 데이터 **파괴적 삭제** 는 하지 않음 (예: 본문 삭제, 파일 삭제)
- 단 "스키마에 맞지 않아 무효한 값" 은 제거 허용 (broken relation, invalid tag 등)
- **Secret 은 탐지만**. 파괴적 수정 금지 원칙 적용. ERROR 로 차단하여 사용자 개입 유도
- 수정 결과는 최종 리포트에 카운트/목록으로 보고
