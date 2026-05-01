---
title: Pre-push Visibility Hook (career preset only)
impact: CRITICAL
impactDescription: career KB 가 public 레포로 푸시되는 것을 차단하는 git pre-push 훅
tags: template, hooks, pre-push, visibility, career
---

# Pre-push Visibility Hook

career 프리셋 KB 의 push 시점 가시성 검사. private 또는 internal 레포만 허용.

## 생성 경로

`{kb-root}/.kb/hooks/pre-push-visibility.sh`

## 설치 조건

- `.kb/preset.json` 의 `preset == "career"` 일 때만 Phase 2 에서 설치
- 그 외 프리셋에서는 생성하지 않음

## 설치 절차

1. `.kb/hooks/` 디렉토리 (이미 pre-commit-secrets.sh 에서 만들어짐)
2. `pre-push-visibility.sh` 작성 + `chmod +x`
3. `.git/hooks/pre-push` 처리:
   - 없음 → symlink: `ln -sfn ../../.kb/hooks/pre-push-visibility.sh .git/hooks/pre-push`
   - 우리 훅을 가리키는 symlink → skip
   - 다른 파일 → 덮어쓰지 않음. 사용자에게 수동 병합 안내

## 훅 본문

```bash
#!/usr/bin/env bash
# .kb/hooks/pre-push-visibility.sh
# Blocks pushing a career-preset KB to a public repository.
# Managed by knowledge-base-setup. Do not edit inline.

set -euo pipefail

REMOTE_NAME="${1:-origin}"
REMOTE_URL="${2:-}"

# Defensive: only act for the career preset
PRESET_FILE=".kb/preset.json"
[ -f "$PRESET_FILE" ] || exit 0
case "$(grep -o '"preset"[[:space:]]*:[[:space:]]*"[^"]*"' "$PRESET_FILE" | head -1)" in
    *'"career"'*) ;;
    *) exit 0 ;;
esac

# Bypass for explicitly-public usage
if [ "${KB_ALLOW_PUBLIC_PUSH:-0}" = "1" ]; then
    echo "[kb-visibility] KB_ALLOW_PUBLIC_PUSH=1 set, skipping visibility check." >&2
    exit 0
fi

# Non-interactive override (CI etc.)
if [ -n "${KB_REPO_VISIBILITY:-}" ]; then
    visibility="$KB_REPO_VISIBILITY"
else
    visibility=""
    # Try gh CLI for GitHub remotes
    if command -v gh >/dev/null 2>&1 && echo "$REMOTE_URL" | grep -qE '(^git@github\.com:|^https?://([^/@]+@)?github\.com/)'; then
        slug=$(echo "$REMOTE_URL" \
            | sed -E -e 's#^git@github\.com:#https://github.com/#' \
                     -e 's#^https?://([^/@]+@)?github\.com/##' \
                     -e 's#\.git$##')
        visibility=$(gh api "repos/$slug" --jq .visibility 2>/dev/null || true)
    fi
fi

# Interactive fallback when visibility still unknown
if [ -z "$visibility" ]; then
    if [ ! -t 0 ] && [ ! -t 1 ]; then
        echo "[kb-visibility] visibility 자동 확인 불가 + 비대화형 환경. 안전하게 차단합니다." >&2
        echo "  KB_REPO_VISIBILITY=private 환경변수로 명시하거나 gh 를 설치하세요." >&2
        exit 1
    fi
    echo "[kb-visibility] 원격 '$REMOTE_NAME' ($REMOTE_URL) 의 visibility 를 자동 확인할 수 없습니다." >&2
    echo "이 레포는 private 또는 internal 인가요?" >&2
    echo "  1) yes — 진행" >&2
    echo "  2) no  — push 차단" >&2
    printf "선택 [2]: " >&2
    read answer </dev/tty || answer=2
    case "$answer" in
        1) visibility="private" ;;
        *) visibility="public" ;;
    esac
fi

case "$visibility" in
    private|internal)
        echo "[kb-visibility] OK ($REMOTE_NAME = $visibility)" >&2
        exit 0
        ;;
    public)
        cat >&2 <<MSG

[kb-visibility] 푸시 차단됨.

원격 '$REMOTE_NAME' ($REMOTE_URL) 의 visibility: public
career 프리셋 KB 는 public 레포로 푸시할 수 없습니다.

해결 옵션:
  1. 레포를 private 또는 internal 로 변경:
       gh repo edit <owner/repo> --visibility private

  2. 의도적인 public push 가 필요하면:
       KB_ALLOW_PUBLIC_PUSH=1 git push ...
     단 발송 전 어떤 파일이 노출될지 확인하세요:
       git diff $REMOTE_NAME/main..HEAD --stat

  3. 다른 원격으로 푸시:
       git push <other-remote> <branch>

MSG
        exit 1
        ;;
    *)
        echo "[kb-visibility] visibility 값 알 수 없음: '$visibility'. 안전하게 차단합니다." >&2
        exit 1
        ;;
esac
```

## Phase 4 verification 단계 안내

셋업 직후 한 번만 동일 검사를 실행. public 이면 ERROR 가 아닌 WARNING 으로 처리하고 변경 권장:

```
[career-setup] 경고: origin 원격 (github.com/foo/career-kb) 가 public 입니다.

career 데이터를 보호하려면:
  gh repo edit foo/career-kb --visibility private

지금 변경하지 않더라도 push 시점에 pre-push 훅이 다시 막아줍니다.
```

## Bypass 옵션 요약

| 환경변수 | 용도 |
|----------|------|
| `KB_ALLOW_PUBLIC_PUSH=1` | 의도적인 public push 1회 우회. 매 push 마다 명시 필요 |
| `KB_REPO_VISIBILITY=private\|internal\|public` | 비대화형 환경에서 visibility 명시. CI 등 |

## Limitations

- GitHub 외 호스팅 (GitLab / Bitbucket / self-hosted) 은 자동 visibility 감지 안 됨 → 인터랙티브 fallback 또는 `KB_REPO_VISIBILITY` 사용
- 푸시 직전 상황만 검사. push 후 가시성을 public 으로 변경한 경우 별도 모니터링 없음

## 갱신

훅을 수정하려면 이 템플릿을 수정 후 재실행. 설치된 `.kb/hooks/pre-push-visibility.sh` 를 직접 편집해도 동작은 함 (관리 일관성을 위해 템플릿 재설치 권장).
