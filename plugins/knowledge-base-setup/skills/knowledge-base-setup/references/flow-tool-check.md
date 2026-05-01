---
title: Tool Check Flow (Phase 0.5)
impact: HIGH
impactDescription: 두 스킬이 공유하는 도구 확인 절차. matrix 는 rule-tool-dependencies.md
tags: flow, tools, phase-0.5, environment
---

# Tool Check Flow

`knowledge-base-setup` 의 Phase 0.5 와 `kb-validator` 의 Phase 0 에서 동일하게 수행한다. matrix 정의: references/rule-tool-dependencies.md.

## 호출 시점

| 스킬 | 호출 시점 |
|------|-----------|
| knowledge-base-setup | Phase 0 (state scan) 직후, Phase 1 (Q1) 직전 |
| kb-validator | Phase 0 setup scan 안에서 `.kb/preset.json` 읽은 직후 |

## 단계

1. **OS 감지** — `brew`/`apt-get`/`dnf`/`pacman` 순서대로 `command -v`. 첫 매치를 OS 패키지 매니저로 결정. 없으면 `unknown`.
2. **Career-aware 확장** — `.kb/preset.json` 이 존재하고 `preset == "career"` 면 recommended 매트릭스에 `gh` 를 추가 (origin 이 github.com 인 경우 한정). 셋업 시 아직 preset.json 이 없으면 Q2 응답 후 다시 매트릭스 확장.
3. **Required 검사** — 누락되면 ERROR 출력 + 수동 안내 + 진행 중단:

   ```
   [kb-tools] required tool 누락: awk
   awk 가 없으면 셋업을 진행할 수 없습니다.

   설치 방법:
     brew install gawk        # macOS
     sudo apt-get install gawk
     sudo dnf install gawk

   설치 후 다시 실행하세요.
   ```

4. **Recommended 검사** — 누락된 도구가 있으면 confirmation flow 출력 (rule-tool-dependencies.md). 사용자 응답에 따라:
   - 설치 명령에 `sudo` 포함 → 명시적 `y` 시에만 실행
   - 설치 명령에 `sudo` 없음 → 그래도 실행 전 다시 한 번 `y/N`
   - 설치 후 재검증
5. **Optional 검사** — 결과 표시 후 별도 질문. 기본값 skip.
6. **요약 출력**:

   ```
   [kb-tools] 환경 검사 완료.
     required:    OK
     recommended: yq(installed) python3+PyYAML(skipped)
     optional:    ripgrep(ok), 나머지 skip
   ```

## kb-validator 에서의 degraded 모드

frontmatter 파서가 둘 다 없는 상태에서 사용자가 skip 했다면:

- frontmatter 스키마 검증 건너뜀 (사용자에게 명시 표기)
- 다른 검사 (git timestamp / 디렉토리 README / 시크릿 스캔 / 태그 인덱스) 는 정상 수행
- 보고서 상단에 `[degraded] frontmatter parser unavailable — schema checks skipped` 표기

## 비대화형 모드

`KB_NONINTERACTIVE=1` 또는 stdin 이 tty 가 아닌 경우:

- required 누락 → ERROR exit
- recommended / optional → 설치 시도하지 않고 결과만 출력
- preset.json 의 `tools.confirmed` 가 `true` 인 경우는 향후 한 번 더 묻지 않음 (재실행 시 빠른 진행)

## 재실행 시 동작 (멱등)

매번 검사한다. 도구 환경은 시간이 지나며 변할 수 있으므로 결과를 캐시하지 않는다. 단 한 세션 내에서 같은 흐름이 두 번 호출되는 경우는 첫 번째 결과를 재사용해도 무방.
