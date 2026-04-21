---
title: Idempotent Symlink Strategy
impact: HIGH
impactDescription: Single source of truth with idempotent commands allows safe re-run and retrofit
tags: symlink, agents-md, unification, idempotent, phase0, merge
---

## Strategy

AGENTS.md 를 원본으로 두고 각 도구별 파일을 심링크로 연결한다. 모든 명령은 멱등성을 보장한다 (재실행 시 실패하지 않음).

## Phase 0: State Scan

심링크 생성 전 현재 상태를 파악한다.

```bash
# AGENTS.md 존재 여부
[ -f AGENTS.md ] && echo "AGENTS.md: exists" || echo "AGENTS.md: absent"

# 각 도구 파일 상태 (file / symlink / absent)
for f in CLAUDE.md .cursorrules .windsurfrules .clinerules .roorules GEMINI.md \
         .github/copilot-instructions.md .agent/rules/rules.md CONVENTIONS.md; do
  if [ -L "$f" ]; then
    echo "$f: symlink -> $(readlink "$f")"
  elif [ -f "$f" ]; then
    echo "$f: file (merge candidate)"
  else
    echo "$f: absent"
  fi
done
```

### 분기 규칙

| 상태 | 조치 |
|------|------|
| absent | 심링크 생성 |
| symlink → AGENTS.md | 스킵 (이미 올바름) |
| symlink → 다른 타겟 | `ln -sfn` 으로 AGENTS.md 로 재지정 |
| file | 병합 후 원본 삭제, 심링크 생성 (아래 "병합 절차") |

## Idempotent Setup Commands

`ln -sfn` 은 기존 심링크를 덮어쓴다. 일반 파일은 덮어쓰기 전에 반드시 병합을 먼저 수행한다.

```bash
# Claude Code
ln -sfn AGENTS.md CLAUDE.md

# Cursor (legacy single file)
ln -sfn AGENTS.md .cursorrules

# Windsurf
ln -sfn AGENTS.md .windsurfrules

# Cline
ln -sfn AGENTS.md .clinerules

# Roo Code
ln -sfn AGENTS.md .roorules

# Gemini CLI
ln -sfn AGENTS.md GEMINI.md

# GitHub Copilot (디렉토리 필요)
mkdir -p .github
ln -sfn ../AGENTS.md .github/copilot-instructions.md

# Google Antigravity (디렉토리 필요)
mkdir -p .agent/rules
ln -sfn ../../AGENTS.md .agent/rules/rules.md

# Aider
ln -sfn AGENTS.md CONVENTIONS.md
```

## 병합 절차 (Merge)

일반 파일 (심링크 아님) 이 존재하면 병합 후 심링크로 교체한다.

1. 기존 파일 내용 읽기
2. AGENTS.md 와 비교
   - 동일 내용 → 기존 파일 삭제 후 심링크 생성
   - 다른 내용 → 다음 절차
3. 기존 파일을 `.bak` 로 백업 (`mv CLAUDE.md CLAUDE.md.bak`)
4. 병합 규칙
   - 동일 문장 → 1회만 유지
   - 충돌하는 규칙 → 사용자에게 확인 요청, 선택 반영
   - 유효한 고유 규칙 → AGENTS.md 의 적절한 섹션(Rules / Project Style 등)에 추가
   - 단, 행동 지시문은 references/rule-findability.md 의 Anti-Patterns 에 해당하는지 확인하고, 해당하면 포함하지 않는다
5. 병합 완료 후 사용자 확인
6. `.bak` 삭제 및 심링크 생성 (`ln -sfn AGENTS.md CLAUDE.md`)

## .gitignore 관리

사용하지 않는 도구 파일은 `.gitignore` 에 추가한다. 사용하는 도구의 심링크는 커밋한다 (협업자도 동일 설정 공유).

```gitignore
# 예: 이 프로젝트에서 사용 안 하는 도구
# .windsurfrules
# .clinerules
# .roorules
```

Phase 2 Q6 의 체크 해제된 도구 파일들을 자동으로 `.gitignore` 에 추가한다.

## 플랫폼별 주의

### macOS / Linux

심링크 기본 지원. 추가 설정 불필요.

### Windows

- 심링크 생성에 관리자 권한 또는 Developer Mode 필요
- Git 설정: `git config --global core.symlinks true`
- 대안 1: `mklink` (CMD) 또는 `New-Item -ItemType SymbolicLink` (PowerShell)
- 대안 2: WSL 환경에서 작업
- 최후 대안: 심링크 대신 복사 + pre-commit hook 으로 AGENTS.md → 각 파일 동기화
  - 이 경우 도구 파일은 커밋 대상이 되고, AGENTS.md 수정 시 hook 이 자동 갱신한다

## 검증

```bash
# 심링크 연결 확인 (존재하는 것만 표시)
ls -la CLAUDE.md .cursorrules .windsurfrules .clinerules .roorules GEMINI.md \
       .github/copilot-instructions.md .agent/rules/rules.md CONVENTIONS.md 2>/dev/null

# 내용 일치 확인
diff AGENTS.md CLAUDE.md
```

## 재실행 안전성

이 절차 전체는 멱등하다.

- 이미 올바른 심링크는 재생성 없이 스킵
- 깨진 심링크는 `ln -sfn` 으로 자동 복구
- 일반 파일은 병합 절차를 거쳐야만 교체됨 (자동 덮어쓰기 방지)
- 디렉토리는 `mkdir -p` 로 존재 여부 상관없이 안전
