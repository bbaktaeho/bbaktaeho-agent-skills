---
title: .agents/hooks/pre-commit-secrets.sh Template
impact: CRITICAL
impactDescription: 라우팅 README 와 .agents/ 의 .md 파일에 민감 정보가 커밋되는 것을 차단
tags: template, hooks, pre-commit, security, agents
---

# Pre-commit Secret-Scan Hook

agent-instructions-setup 이 생성/설치하는 git pre-commit 훅. 스테이징된 `**/README.md` 와 `.agents/**/*.md` 에 대해 민감 정보 패턴 검사.

## 생성 경로

`{repo}/.agents/hooks/pre-commit-secrets.sh`

## 설치 절차

1. `.agents/hooks/` 디렉토리 생성
2. `pre-commit-secrets.sh` 작성 + `chmod +x`
3. `.git/hooks/pre-commit` 처리:
   - 없음 → symlink: `ln -sfn ../../.agents/hooks/pre-commit-secrets.sh .git/hooks/pre-commit`
   - 우리 훅을 가리키는 symlink → skip
   - **다른 파일** (예: `.kb/hooks/pre-commit-secrets.sh`) → 덮어쓰지 않음. 사용자에게 wrapper 병합 안내

## 훅 본문

```bash
#!/usr/bin/env bash
# .agents/hooks/pre-commit-secrets.sh
# Scans staged README.md and .agents/**/*.md for potential secrets.
# Managed by agent-instructions-setup. Do not edit inline.

set -euo pipefail

staged=$(git diff --cached --name-only --diff-filter=ACM \
    | grep -E '(^|/)README\.md$|^AGENTS\.md$|^\.agents/.*\.md$' \
    | grep -v '^\.agents/\.tag-index$' \
    | grep -v '^\.agents/local/' \
    || true)
[ -z "$staged" ] && exit 0

if [ "${AGENTS_SKIP_SECRET_SCAN:-0}" = "1" ]; then
    echo "[agents-secrets] AGENTS_SKIP_SECRET_SCAN=1 set, skipping scan." >&2
    exit 0
fi

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
    '(password|passwd|secret|api[_-]?key|access[_-]?key|auth[_-]?token|bearer)[[:space:]]*[:=][[:space:]]*["'"'"']?[A-Za-z0-9/+=_\-]{12,}'
)

fail=0
for file in $staged; do
    [ -f "$file" ] || continue

    for pat in "${patterns[@]}"; do
        matches=$(grep -niE "$pat" "$file" || true)
        [ -z "$matches" ] && continue

        while IFS= read -r hit; do
            [ -z "$hit" ] && continue
            linenum=$(echo "$hit" | cut -d: -f1)
            content=$(echo "$hit" | cut -d: -f2-)

            if echo "$content" | grep -q 'agents-secrets: allow'; then
                continue
            fi

            if [ "$fail" -eq 0 ]; then
                echo "" >&2
                echo "[agents-secrets] Potential secrets detected in staged changes:" >&2
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

  1. Remove the secret and move it to .agents/local/ (gitignored).
     Reference the local file path from the agents doc.
  2. Replace with a placeholder: {SECRET_NAME} or ${ENV_VAR}.
  3. If the match is a false positive, add on the same line:
         <!-- agents-secrets: allow -->
  4. To bypass this scan for one commit (not recommended):
         AGENTS_SKIP_SECRET_SCAN=1 git commit ...

If the secret is already in git history, rotate the credential and
remove it from history with git-filter-repo or BFG.

MSG
    exit 1
fi

exit 0
```

## `.kb/` 와 공존하는 경우

`.kb/hooks/pre-commit-secrets.sh` 가 이미 설치되어 있으면 `.git/hooks/pre-commit` 자동 연결을 건너뛰고 wrapper 안내:

```bash
# .git/hooks/pre-commit
#!/usr/bin/env bash
set -e
[ -x .kb/hooks/pre-commit-secrets.sh ] && .kb/hooks/pre-commit-secrets.sh
[ -x .agents/hooks/pre-commit-secrets.sh ] && .agents/hooks/pre-commit-secrets.sh
```

위 내용을 `.git/hooks/pre-commit` 에 직접 붙여넣고 `chmod +x` 안내.

## Limitations

- 스테이징만 검사. 기존 커밋 히스토리는 별도 도구 (gitleaks / trufflehog / BFG) 권장
- 해시/UUID 등 false positive 는 pragma 로 우회

## 갱신

패턴을 추가/수정하려면 이 템플릿을 수정 후 스킬을 재실행. 설치된 훅을 직접 편집해도 동작은 함 (관리 일관성을 위해 템플릿 재설치 권장).
