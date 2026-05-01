---
title: Tool Dependency Matrix and Install Flow
impact: HIGH
impactDescription: KB 셋업과 검증에 필요한 외부 도구의 존재 확인 및 설치 흐름 표준화
tags: tools, dependencies, install, environment
---

# Tool Dependencies

`knowledge-base-setup` 의 Phase 0.5 와 `kb-validator` 의 Phase 0 에서 동일하게 사용한다. 결과 매트릭스는 reference 파일 이 한 곳에서만 관리한다.

## Tool Matrix

| Tier | Tool | Purpose | Missing 시 동작 |
|------|------|---------|----------------|
| required | `bash`, `git`, `grep`, `sed`, `awk` | pre-commit hook 기본, 디렉토리/파일 처리 | ERROR + 수동 설치 안내. 자동 설치 대상 아님 (OS 기본 도구) |
| recommended | `yq` 또는 `python3` + `PyYAML` (one-of) | kb-validator 의 frontmatter YAML 파싱 | 사용자에게 install 옵션 제시. 기본값 skip |
| recommended (career 전용) | `gh` (GitHub CLI) | career 프리셋의 pre-push 단계에서 visibility 자동 감지. origin 이 github.com 일 때만 권장 | install 옵션 제시. 없으면 인터랙티브 fallback |
| optional | `ripgrep`, `gitleaks`, `trufflehog`, `lychee` | 빠른 시크릿 / 링크 스캔 | 결과 표시만. 사용자가 명시적으로 install 선택해야 설치 |

## OS Detection

순서대로 검사. 첫 번째 매치를 사용:

| 우선순위 | Detect | 패키지 매니저 | install 명령 |
|---------|--------|---------------|--------------|
| 1 | `command -v brew` | brew (macOS / Linuxbrew) | `brew install <pkg>` |
| 2 | `command -v apt-get` | apt | `sudo apt-get install -y <pkg>` |
| 3 | `command -v dnf` | dnf | `sudo dnf install -y <pkg>` |
| 4 | `command -v pacman` | pacman | `sudo pacman -S --noconfirm <pkg>` |
| 5 | (none) | unknown | 자동 설치 비활성화. 수동 안내만. |

`python3` + `PyYAML` 의 경우: `python3` 존재 시 `pip install --user pyyaml` 권장. python3 없으면 `yq` 안내.

## Confirmation Flow

```
[kb-tools] 환경 검사 결과:
  required:    bash(ok) git(ok) grep(ok) sed(ok) awk(ok)
  recommended: yq(missing), python3+PyYAML(missing)
  optional:    ripgrep(ok) gitleaks(missing) trufflehog(missing) lychee(missing)

kb-validator 의 frontmatter 파싱에는 yq 또는 python3+PyYAML 가 필요합니다.
설치할까요?

  1) yq 설치 (brew install yq)
  2) python3 PyYAML 설치 (pip install --user pyyaml)
  3) skip — 수동으로 설치 후 다시 실행

선택 [3]: _
```

기본값은 항상 `skip`. optional 도구는 별도 질문으로 분리하고, 모두 명시적 opt-in.

```
선택사항 도구도 설치할까요? (없어도 동작하지만 권장)
  - gitleaks (시크릿 스캔 강화)
  - trufflehog (시크릿 스캔 강화)
  - lychee   (markdown 링크 체크)

  1) 모두 설치
  2) 개별 선택
  3) skip

선택 [3]: _
```

## Safety Rules

- **`sudo` 가 포함된 명령은 사용자가 명시적 `y` 한 경우에만 실행.** 그 외에는 명령어를 출력하고 사용자가 직접 실행하도록 안내
- **기본값은 항상 skip** (위험 없는 옵션)
- 설치 후 재검증 + 결과 출력
- 설치 실패 (non-zero exit) 시 원본 오류 표시 후 도구 없이 진행
- OS = `unknown` 일 때 자동 설치 비활성화

## Career 프리셋 추가 동작

`preset == career` 가 결정된 시점부터 `gh` 가 recommended 로 추가된다:
- origin 원격이 github.com 매치 → `gh` 가 missing 이면 install 옵션 제시
- origin 이 github 가 아니거나 없음 → `gh` 미설치도 무시 (인터랙티브 fallback 으로 충분)

## kb-validator 에서의 부분 동작

kb-validator 가 frontmatter 파서를 못 찾으면:

1. `yq` 또는 `python3 -c "import yaml"` 둘 다 실패
2. 사용자에게 위 confirmation flow 표시
3. skip 선택 시 → "frontmatter 검증 건너뜀, secret scan / git timestamp 등 다른 검증만 수행" 으로 degraded 진행
