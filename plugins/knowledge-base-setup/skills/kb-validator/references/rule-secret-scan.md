---
title: Secret Scan Rule
impact: CRITICAL
impactDescription: 지식베이스에 유입된 민감 정보를 감지하여 검증을 차단하는 규칙
tags: validation, secrets, security
---

# Secret Scan

kb-validator 가 Phase 1 (Required Checks) 에서 스캔하는 민감 정보 검출 룰. `.kb/hooks/pre-commit-secrets.sh` 와 **동일한 패턴** 을 사용하여 "pre-commit 이 바이패스됐거나 설치되지 않은 경우" 를 커버.

## 동작

- **감지만 하고 자동 수정하지 않는다**. 사용자 본문을 파괴적으로 수정하지 않음
- 검출 시 kb-validator 는 **ERROR 로 차단**. 다른 체크는 계속 진행하지만 리포트 종료 시 `ERROR` 상태로 마감
- 사용자가 해결 (제거 / pragma 추가 / `.kb/local/` 이동) 후 재실행 요구

## 스캔 범위

- 대상: 지식베이스 내 모든 `.md` 파일 + `.kb/*.md`
- 제외:
  - `.kb/local/` (gitignored)
  - `.kb/.tag-index`
  - 외부 submodule 내부
  - 파일 자체에 `<!-- kb-secrets: allow-file -->` pragma 가 있는 경우 (매우 드물게 사용)

## 패턴

`rule-required-checks.md` 의 #10 과 `template-pre-commit-hook.md` 와 동일:

| 카테고리 | 정규식 |
|----------|--------|
| AWS access key | `AKIA[0-9A-Z]{16}` |
| GitHub PAT / OAuth / Server / User / Refresh | `gh[pousr]_[A-Za-z0-9]{36,}` |
| GitHub fine-grained PAT | `github_pat_[A-Za-z0-9_]{22,}` |
| Google API | `AIza[0-9A-Za-z_\-]{35}` |
| Slack | `xox[baprs]-[A-Za-z0-9-]{10,}` |
| Private key | `-----BEGIN [A-Z ]*PRIVATE KEY-----` |
| JWT | `eyJ[A-Za-z0-9_-]+\.eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+` |
| Basic auth URL | `https?://[A-Za-z0-9._%+-]+:[^@\s]+@` |
| RFC1918 내부 IP URL | `https?://(10\.\|172\.(1[6-9]\|2[0-9]\|3[01])\.\|192\.168\.)[0-9.]+` |
| 일반 credential 할당 | `(password\|passwd\|secret\|api[_-]?key\|access[_-]?key\|auth[_-]?token\|bearer)\s*[:=]\s*['"]?[A-Za-z0-9/+=_-]{12,}` |

대소문자 구분 없음 (`-i`).

## False Positive 우회

같은 줄에 pragma:

```markdown
예시: `ghp_AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIII` <!-- kb-secrets: allow -->
```

파일 전체 우회 (drop-in 샘플 데이터 파일 등, 매우 신중히 사용):

```markdown
---
...
---
<!-- kb-secrets: allow-file -->

# ...
```

파일 pragma 는 frontmatter 바로 다음 줄에 있어야 인식.

## 리포트 포맷

```
[SECRETS] 3 potential secrets detected. Validator halted with ERROR.

  research/old-setup-notes.md:42
    DB 접속: postgres://admin:Sup3r...@10.0.1.5:5432/app
  runbooks/deploy.md:18
    export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
  onboarding/local-dev.md:73
    ghp_aBcDeFgH1234567890aBcDeFgH1234567890aBcD

Resolution:
  1. Remove and move to .kb/local/ (gitignored), reference path in docs.
  2. Replace with placeholder: {VAR_NAME} or ${ENV_VAR}.
  3. If false positive, add '<!-- kb-secrets: allow -->' on the same line.

If the value is already in git history, rotate credentials and run
git-filter-repo / BFG. Deleting the file is not enough.

Validator will refuse to rebuild .tag-index while secrets remain.
```

## 의도적 "허용" 설계

- **자동 수정 금지**: 본문 내용을 자동으로 지우면 실제 결과물이 소실됨. 사용자 개입 필수
- **차단 방식**: `ERROR` 상태로 마감. CI 에서 exit code 로 확인 가능 (flow-modes.md 의 Exit Codes)
- **`.tag-index` 재생성 지연**: secret 이 남아있는 동안 인덱스 재생성 보류 (인덱스에 secret 위치 노출 방지)

## `.kb/local/` 와의 상호작용

- `.kb/local/` 내부 파일은 스캔 **제외** (gitignored 된 로컬 저장소라 전제)
- 다만 `.kb/local/` 경로에 실제 secret 이 있고, 다른 `.md` 에서 해당 내용을 **복붙해서** 가져온 경우는 일반 스캔에 걸린다

## 릴리스 노트 / 템플릿 동기화

pre-commit hook 과 validator 의 패턴은 반드시 일치해야 한다. 둘 중 하나가 더 관대하면 우회가 가능해짐. 패턴 수정 시 두 파일을 함께 수정:

- `plugins/knowledge-base-setup/skills/knowledge-base-setup/references/template-pre-commit-hook.md`
- `plugins/knowledge-base-setup/skills/kb-validator/references/rule-secret-scan.md`
- `plugins/knowledge-base-setup/skills/kb-validator/references/rule-required-checks.md` (#10 섹션)
