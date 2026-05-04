---
title: Tool Dependency Matrix
impact: HIGH
impactDescription: meta-validator 동작에 필요한 외부 도구 매트릭스
tags: tools, dependencies, install, environment
---

# Tool Dependencies

meta-validator 의 Phase 0 에서 사용. 누락 도구는 사용자 confirm 후 옵션 설치.

## Tool Matrix

| Tier | Tool | Purpose | Missing 시 동작 |
|------|------|---------|----------------|
| required | `bash`, `git`, `grep`, `sed`, `awk` | git timestamp / 디렉토리 스캔 / secret pattern 매칭 | ERROR + 수동 설치 안내. 자동 설치 대상 아님 |
| recommended | `yq` 또는 `python3` + `PyYAML` (one-of) | frontmatter YAML 파싱 | 사용자에게 install 옵션 제시. skip 시 degraded 모드 |
| optional | `ripgrep`, `gitleaks`, `trufflehog` | 빠른 secret 스캔 | 표시만. 명시적 opt-in 시 설치 |

## OS Detection

| 우선순위 | Detect | install 명령 |
|---------|--------|--------------|
| 1 | `command -v brew` | `brew install <pkg>` |
| 2 | `command -v apt-get` | `sudo apt-get install -y <pkg>` |
| 3 | `command -v dnf` | `sudo dnf install -y <pkg>` |
| 4 | `command -v pacman` | `sudo pacman -S --noconfirm <pkg>` |
| 5 | (none) | unknown — 자동 설치 비활성화 |

`python3` + `PyYAML`: `python3` 존재 시 `pip install --user pyyaml` 권장.

## Confirmation Flow

```
[meta-validator-tools] 환경 검사 결과:
  required:    bash(ok) git(ok) grep(ok) sed(ok) awk(ok)
  recommended: yq(missing), python3+PyYAML(missing)

frontmatter 파싱에는 yq 또는 python3+PyYAML 가 필요합니다.
설치할까요?

  1) yq 설치 (brew install yq)
  2) python3 PyYAML 설치 (pip install --user pyyaml)
  3) skip — 수동 설치 후 다시 실행 (또는 degraded 모드 진행)

선택 [3]: _
```

기본값 `skip`. `sudo` 포함 명령은 명시적 `y` 일 때만 실행.

## Degraded 모드

frontmatter 파서가 둘 다 없고 사용자가 skip 하면:

- frontmatter 스키마 검증 건너뜀 (리포트에 `[degraded] frontmatter parser unavailable` 표기)
- 다른 검사 (git timestamp / 디렉토리 README / secret scan / tag-index) 는 정상 수행

## Safety Rules

- 자동 설치 명령에 `sudo` 가 있으면 사용자가 명시적 `y` 한 경우에만 실행
- 기본값은 항상 `skip`
- 설치 후 재검증 + 결과 출력
- OS = `unknown` 시 자동 설치 비활성화

## 비대화형 모드

`AGENTS_NONINTERACTIVE=1` 또는 stdin 이 tty 가 아닌 경우:

- required 누락 → ERROR exit
- recommended / optional → 설치 시도하지 않고 결과만 출력. degraded 모드 자동 진입
