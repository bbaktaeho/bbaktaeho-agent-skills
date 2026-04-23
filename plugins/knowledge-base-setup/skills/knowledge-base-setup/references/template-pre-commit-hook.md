---
title: Pre-commit Secret-Scan Hook Template
impact: CRITICAL
impactDescription: 커밋 시점에 민감 정보 유출을 차단하는 git pre-commit hook 템플릿
tags: template, hooks, pre-commit, security
---

# Pre-commit Hook for Secret Scanning

스킬이 생성/설치하는 pre-commit hook. 스테이징된 `.md` 파일과 `.kb/` 메타 파일 (`.kb/local.example/` 의 예시 포함 파일 포함) 에 대해 민감 정보 패턴을 검사.

## 생성 경로

`{kb-root}/.kb/hooks/pre-commit-secrets.sh`

## 설치 방법

스킬이 Phase 2 에서 아래 순서로 설치:

1. `.kb/hooks/` 디렉토리 생성
2. `.kb/hooks/pre-commit-secrets.sh` 생성 + `chmod +x`
3. `.git/hooks/pre-commit` 기존 파일 확인:
   - 없음 → symlink 로 연결: `ln -sfn ../../.kb/hooks/pre-commit-secrets.sh .git/hooks/pre-commit`
   - 존재하나 symlink 로 우리 훅을 가리킴 → skip
   - 존재 + 다른 내용 → symlink 로 덮어쓰지 않음. 사용자에게 수동 병합 안내 출력

## 훅 스크립트 본문

아래 내용을 그대로 `.kb/hooks/pre-commit-secrets.sh` 로 생성한다.

```bash
#!/usr/bin/env bash
# .kb/hooks/pre-commit-secrets.sh
# Scans staged .md and .kb/ files for potential secrets.
# Managed by the knowledge-base-setup skill. Do not edit inline — edit the
# skill's template-pre-commit-hook.md and regenerate.

set -euo pipefail

# Only scan .md files and files under .kb/ (excluding gitignored ones).
staged=$(git diff --cached --name-only --diff-filter=ACM \
    | grep -E '(\.md$|^\.kb/)' \
    | grep -v '^\.kb/\.tag-index$' \
    | grep -v '^\.kb/local/' \
    || true)
[ -z "$staged" ] && exit 0

# Allow full bypass only when the commit message / env var asks for it.
if [ "${KB_SKIP_SECRET_SCAN:-0}" = "1" ]; then
    echo "[kb-secrets] KB_SKIP_SECRET_SCAN=1 set, skipping scan." >&2
    exit 0
fi

patterns=(
    # AWS access keys
    'AKIA[0-9A-Z]{16}'
    # GitHub tokens
    'gh[pousr]_[A-Za-z0-9]{36,}'
    'github_pat_[A-Za-z0-9_]{22,}'
    # Google API
    'AIza[0-9A-Za-z_\-]{35}'
    # Slack tokens
    'xox[baprs]-[A-Za-z0-9-]{10,}'
    # Private keys
    '-----BEGIN [A-Z ]*PRIVATE KEY-----'
    # JWT-like
    'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'
    # Basic auth in URLs
    'https?://[A-Za-z0-9._%+-]+:[^@[:space:]]+@'
    # URLs with RFC1918 private IPs
    'https?://(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)[0-9.]+'
    # Generic credential assignments with plausible-length values
    '(password|passwd|secret|api[_-]?key|access[_-]?key|auth[_-]?token|bearer)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9/+=_\-]{12,}'
)

fail=0
for file in $staged; do
    [ -f "$file" ] || continue

    for pat in "${patterns[@]}"; do
        # -n: line number, -E: extended regex, -i: case-insensitive
        matches=$(grep -niE "$pat" "$file" || true)
        [ -z "$matches" ] && continue

        while IFS= read -r hit; do
            [ -z "$hit" ] && continue
            linenum=$(echo "$hit" | cut -d: -f1)
            content=$(echo "$hit" | cut -d: -f2-)

            # Per-line pragma bypass
            if echo "$content" | grep -q 'kb-secrets: allow'; then
                continue
            fi

            if [ "$fail" -eq 0 ]; then
                echo "" >&2
                echo "[kb-secrets] Potential secrets detected in staged changes:" >&2
                echo "" >&2
            fi
            echo "  $file:$linenum" >&2
            echo "    $(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-120)" >&2
            fail=1
        done <<< "$matches"
    done
done

if [ "$fail" -ne 0 ]; then
    cat >&2 <<'MSG'

Commit blocked. Options:

  1. Remove the secret and move it to .kb/local/ (gitignored).
     Reference the local file path from the knowledge doc.
  2. Replace with a placeholder: {SECRET_NAME} or ${ENV_VAR}.
  3. If the match is a false positive, add on the same line:
         <!-- kb-secrets: allow -->
  4. To bypass this scan for one commit (not recommended):
         KB_SKIP_SECRET_SCAN=1 git commit ...

If the secret is already in git history, rotate the credential and
remove it from history with git-filter-repo or BFG. Deleting the file
in a new commit is not enough.

MSG
    exit 1
fi

exit 0
```

## GitHub Actions fallback

로컬 훅이 설치되지 않은 팀원을 대비해 CI 에서 같은 스캔을 한 번 더 돌린다. 스킬은 선택적으로 `.github/workflows/kb-secrets.yml` 도 제안한다 (존재하지 않을 때만 생성):

```yaml
name: KB Secret Scan
on:
  pull_request:
    paths:
      - '**/*.md'
      - '.kb/**'
  push:
    branches: [main]

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Run kb-secrets scan
        run: |
          # Scan all tracked .md and .kb/ files (excluding .kb/local/).
          files=$(git ls-files '*.md' '.kb/**' | grep -v '^\.kb/local/' | grep -v '^\.kb/\.tag-index$')
          fail=0
          patterns=(
            'AKIA[0-9A-Z]{16}'
            'gh[pousr]_[A-Za-z0-9]{36,}'
            'github_pat_[A-Za-z0-9_]{22,}'
            'AIza[0-9A-Za-z_\-]{35}'
            'xox[baprs]-[A-Za-z0-9-]{10,}'
            '-----BEGIN [A-Z ]*PRIVATE KEY-----'
            'eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+'
            'https?://[A-Za-z0-9._%+-]+:[^@[:space:]]+@'
            'https?://(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.)[0-9.]+'
            '(password|passwd|secret|api[_-]?key|access[_-]?key|auth[_-]?token|bearer)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9/+=_-]{12,}'
          )
          for f in $files; do
            for p in "${patterns[@]}"; do
              hits=$(grep -niE "$p" "$f" || true)
              [ -z "$hits" ] && continue
              while IFS= read -r line; do
                echo "$line" | grep -q 'kb-secrets: allow' && continue
                echo "[kb-secrets] $f: $line"
                fail=1
              done <<< "$hits"
            done
          done
          [ "$fail" -eq 0 ] || exit 1
```

설치 조건: 레포에 `.github/` 디렉토리가 이미 있고 `workflows/kb-secrets.yml` 이 없을 때만 제안 (사용자에게 install y/n). 레포가 GitHub 아닐 수도 있으므로 **기본 auto-install 은 pre-commit hook 만**.

## Limitations / Known False Positives

- 해시/UUID 가 엔트로피 기준을 넘어 매칭될 수 있음 → pragma 로 우회
- 예시 토큰, 문서 내 샘플 값 → pragma 로 우회
- 커밋 히스토리 전체 스캔은 하지 않음 (스테이징만). 기존 히스토리는 수동 도구 (gitleaks / trufflehog / BFG) 사용 권고

## 갱신

패턴을 추가/수정하려면 이 템플릿 파일을 수정 후 스킬을 재실행하거나, 설치된 `.kb/hooks/pre-commit-secrets.sh` 를 직접 편집. 재실행 시 스킬은 파일 수정 여부를 확인하고 사용자에게 덮어쓸지 묻는다 (evolve 원칙).
