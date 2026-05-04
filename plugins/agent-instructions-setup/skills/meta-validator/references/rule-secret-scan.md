---
title: Secret Scan Rule
impact: CRITICAL
impactDescription: agents 문서에 유입된 민감 정보를 감지하여 검증을 차단하는 규칙
tags: validation, secrets, security
---

# Secret Scan

meta-validator 가 Phase 1 (Required Checks) 에서 스캔하는 민감 정보 검출 룰. `.agents/hooks/pre-commit-secrets.sh` 와 **동일한 패턴**. pre-commit 이 우회됐거나 미설치인 경우를 커버.

## 동작

- **감지만 하고 자동 수정하지 않는다**. 본문 파괴 방지
- 검출 시 meta-validator 는 **ERROR 로 차단**. 다른 체크는 계속하지만 리포트 종료 시 `ERROR` 상태로 마감
- 사용자 해결 (제거 / pragma 추가 / `.agents/local/` 이동) 후 재실행

## 스캔 범위

- 대상: `agents/**/*.md` + `.agents/*.md`
- 제외:
  - `.agents/local/` (gitignored)
  - `.agents/.tag-index`
  - submodule 내부
  - 파일 전체 pragma `<!-- agents-secrets: allow-file -->`

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

대소문자 구분 없음.

## False Positive 우회

같은 줄에 pragma:

```markdown
예시: `ghp_AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIII` <!-- agents-secrets: allow -->
```

파일 전체 우회 (예시 데이터 파일 등, 매우 신중히):

```markdown
---
...
---
<!-- agents-secrets: allow-file -->

# ...
```

파일 pragma 는 frontmatter 바로 다음 줄에 있어야 인식.

## 리포트 포맷

```
[SECRETS] 2 potential secrets detected. Validator halted with ERROR.

  agents/security.md:42
    DB 접속 예시: postgres://admin:Sup3r...@10.0.1.5:5432/app
  agents/onboarding.md:73
    GitHub PAT 사용: ghp_aBcDeFgH1234567890aBcDeFgH1234567890aBcD

Resolution:
  1. Remove and move to .agents/local/ (gitignored), reference path in docs.
  2. Replace with placeholder: {VAR_NAME} or ${ENV_VAR}.
  3. If false positive, add '<!-- agents-secrets: allow -->' on the same line.

If the value is already in git history, rotate credentials and run
git-filter-repo / BFG. Deleting the file is not enough.

Validator will refuse to rebuild .agents/.tag-index while secrets remain.
```

## 의도적 "허용" 설계

- **자동 수정 금지**: 본문 자동 삭제 시 결과물 소실
- **차단 방식**: `ERROR` 마감. CI 에서 exit code 확인
- **`.tag-index` 재생성 지연**: secret 이 남아있는 동안 보류 (위치 노출 방지)

## `.agents/local/` 와의 상호작용

- `.agents/local/` 내부 파일은 스캔 **제외**
- 다만 거기 있는 secret 을 다른 agents/*.md 에 복붙한 경우 일반 스캔에 걸림

## 패턴 동기화

pre-commit hook 과 validator 의 패턴은 일치해야 한다. 패턴 수정 시 함께 수정:

- `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-pre-commit-hook.md`
- `plugins/agent-instructions-setup/skills/meta-validator/references/rule-secret-scan.md`
- `plugins/agent-instructions-setup/skills/meta-validator/references/rule-required-checks.md` (#10)
