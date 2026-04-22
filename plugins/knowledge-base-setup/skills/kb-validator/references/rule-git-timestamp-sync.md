---
title: Git Log Based Timestamp Sync
impact: CRITICAL
impactDescription: created / updated 를 git log 기준으로 보정하는 단일 표준 로직
tags: validation, git, timestamps
---

# Git Timestamp Sync

`created` 와 `updated` 를 git log 로부터 보정한다. 이 스킬 (knowledge-base-setup) 과 kb-validator 의 핵심 계약:

> **"사용자/AI 는 `updated` 필드를 건드릴 필요가 없다. kb-validator 가 git 기준으로 보정한다."**

## 명령어

### created

```bash
git log --diff-filter=A --follow --format=%aI -- {file-path} | tail -1
```

- `--diff-filter=A` — Added 타입만
- `--follow` — 파일 rename 추적
- `--format=%aI` — ISO 8601 strict (author date)
- `tail -1` — 가장 오래된 것 (= 최초 추가 시점)

### updated

```bash
git log -1 --format=%aI -- {file-path}
```

- 가장 최근 커밋의 author date

## 보정 규칙

### 파일이 커밋된 적 있을 때

1. git 명령어 실행
2. 결과를 ISO 8601 strict (UTC) 로 정규화
3. frontmatter 값과 비교
4. 다르면 frontmatter 값 업데이트

### 파일이 아직 커밋되지 않았을 때

1. git log 결과가 빈 문자열
2. `created` 가 비어있거나 없으면 → 현재 시각 (UTC, Z suffix) 기입
3. `updated` 도 동일
4. 이미 값이 있으면 → 그대로 유지 (다음 커밋 후 실행에서 보정됨)

### git repo 아닐 때

1. `git rev-parse --is-inside-work-tree` 실패
2. 보정 건너뜀. 현재 frontmatter 값 신뢰
3. 리포트에 "git 외 환경이라 타임스탬프 보정 skip" 기록

### `.gitignore` 된 파일

- 보정 대상이 아님 (git log 에 안 나옴). 현재 값 유지

### Submodule

- submodule 내부에서 kb-validator 를 실행하면 submodule 자체 git log 기준으로 보정됨 → 정상 동작
- 호스트 레포에서 submodule 경로 안의 파일을 kb-validator 가 타깃하는 경우: submodule 의 git context 사용 (git 이 알아서 처리)

## Timezone 정규화

- git 은 기본적으로 author timezone 유지
- kb-validator 는 UTC 로 변환하여 저장 (`Z` suffix)
- 변환: ISO 8601 파싱 → UTC 변환 → `Z` 형식으로 직렬화

## Author Date vs Commit Date

- **Author date** (`%aI`) 사용. 실제 작성 시점
- Commit date (`%cI`) 는 rebase / amend 로 바뀔 수 있어 부적합

## 성능

- 파일당 git log 명령어 1~2회 = 상대적으로 무거움
- 대용량 지식베이스에서는 한 번에 `git log --name-status` 로 전체 히스토리를 읽고 map 구축 후 lookup 하는 최적화 가능 (구현 디테일, 사용자 노출 없음)

## Edge Cases

### 파일이 rename 된 경우

- `--follow` 로 추적되지만 복잡한 rename 은 놓칠 수 있음
- 결과가 예상과 다르면 사용자가 수동 확인 가능 (dry-run 모드로 먼저 검증 권장)

### 동일 파일이 여러 번 rename 된 경우

- `--follow` 가 첫 rename 만 따라감
- 이 경우 `created` 는 "그 체인에서 가장 오래된 것" 이 나올 수 있음
- 의도와 다르면 frontmatter 의 `created` 값을 수동으로 수정 → 수동 값이 더 오래되었으면 kb-validator 가 그 값을 수용 (최소값 우선)

### 수동 값이 git log 보다 오래된 경우

- 시나리오: 마이그레이션으로 가져온 문서. git 에는 최근 커밋이지만 실제 작성은 수년 전
- 처리: `created` 는 **수동 값 우선** (더 오래된 쪽). `updated` 는 git 우선 (수정 시점은 git 이 정확)

## dry-run 모드

- 실제로 파일을 수정하지 않고 "{path}: created {old} → {new}, updated {old} → {new}" 리스트만 출력
- 대량 보정 전 확인용
