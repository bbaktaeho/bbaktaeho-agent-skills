---
title: Retrofit Mode Flow
impact: HIGH
impactDescription: 기존 프로젝트에 지식베이스 규격을 적용하는 단계별 흐름
tags: flow, retrofit, migration
---

# Retrofit Mode

기존에 `.md` 문서가 있거나 `.kb/` 가 이미 존재하는 레포에 스킬을 실행할 때.

## 시나리오 분류

### A. 기존 `.md` 는 있으나 `.kb/` 없음

- 목표: 문서들에 frontmatter 보강 + `.kb/` 메타 생성 + 프리셋 매핑

### B. `.kb/` 가 이미 존재 (업그레이드)

- 목표: 스키마 버전 확인, 필요 시 업그레이드, `.kb/` 파일 최신 템플릿과 diff

### C. AGENTS.md 는 있지만 지식베이스는 없음

- 목표: A 와 동일. AGENTS.md 는 건드리지 않음 (Q3 에서 `note-path` 안내만)

## A. 시나리오 플로우

### Phase 0 (확장)

1. Working directory 의 `.md` 파일 카운트 + frontmatter 유무 분석
2. 기존 디렉토리 구조 수집 (top-level)
3. 사용자에게 상황 요약:
   ```
   감지: 42개의 .md 파일, 이 중 31개가 frontmatter 없음
   기존 top-level 디렉토리: docs/, research/, specs/
   ```

### Phase 1 (확장)

Q1~Q3 기본 질문 + retrofit 전용 질문 (references/ask-questions.md 의 "Retrofit Mode 추가 질문"):

- frontmatter 자동 추가 여부
- 기존 디렉토리 → 프리셋 매핑 (가능한 경우만. 예: `docs/` → team-docs 프리셋의 어느 것에 매핑할지)

프리셋을 **custom** 으로 선택하면 매핑 질문 생략 (기존 구조 유지).

### Phase 2 (확장)

1. `.kb/` 생성 (Fresh 와 동일)
2. 루트 `README.md` — 기존에 있으면 frontmatter 만 추가 + 본문 끝에 "## Knowledge Base Structure" append (중복 방지)
3. 프리셋 디렉토리 생성 — 기존과 충돌하면 skip + 경고
4. 기존 `.md` 파일 frontmatter 보강:
   - `auto-add` 선택: 누락된 필드를 기본값으로 채움
     - `title` — 파일명에서 추론 (첫 H1 있으면 그걸 사용)
     - `created` / `updated` — git log 기준 (없으면 현재 시각)
     - `summary` — 빈 문자열 또는 첫 줄에서 추출
     - `tags` — 빈 배열 (사용자가 kb-validator 의 권장 경고로 채움)
     - `status: active`
     - `relations: []`
   - `skip` 선택: 기존 `.md` 는 건드리지 않음. 나중에 kb-validator 로 일괄 처리
   - `one-by-one` 선택: 각 파일을 사용자에게 보여주고 처리 방식 확인

5. 각 디렉토리에 `README.md` 없으면 템플릿으로 생성 (기존 README 있으면 frontmatter 만 추가)

### Phase 3 / 4 (확장)

- 태그 인덱싱: 기존 `.md` 에 태그가 없어서 인덱스가 거의 빔. 사용자에게 "kb-validator 실행으로 태그 권장 경고를 받아 보강하세요" 안내
- Verification: frontmatter 가 보강된 파일 수 / 여전히 비어있는 파일 수 출력

## B. 업그레이드 모드 플로우

### Phase 0

1. 기존 `.kb/preset.json` 읽기 → 현재 프리셋 / 스킬 버전 확인
2. 템플릿 파일 (kb-readme, schema, conventions) 을 현재 버전과 diff

### Phase 1

```
기존 .kb/ 감지 (preset: {name}, version: {old})
현재 스킬 버전: {new}

  1) upgrade     — .kb/ 파일들을 최신 템플릿으로 업데이트 (diff 보여주고 confirm)
  2) skip        — 기존 그대로 유지
  3) reset       — .kb/ 를 완전히 재생성 (기존 preset.json 의 사용자 커스텀 손실 가능)

선택 [1]: _
```

### Phase 2

- `upgrade`: 파일별 diff 를 보여주고 apply y/n. `preset.json` 의 버전만 업데이트
- `skip`: Phase 3 로 바로 진입
- `reset`: 현재 `.kb/` 백업 → 재생성. 백업 위치: `.kb.backup-{timestamp}/`

### Phase 3 / 4

기존 플로우와 동일. `.tag-index` 는 재생성 권장.

## C. AGENTS.md 만 있는 경우

A 와 동일 처리. 마지막에 Q3 의 `note-path` 선택에 따라 AGENTS.md 수정 안내 출력:

```
AGENTS.md 에 다음 줄을 추가하세요 (수동):

  지식베이스는 [.kb/README.md](./.kb/README.md) 를 참조하세요.
```

## 주의 사항

### 기존 디렉토리 이름 존중

- `documents/` 같은 기존 이름을 프리셋 이름 (`decisions/`, `research/` 등) 으로 강제 변경하지 않는다
- 매핑은 사용자 선택. 자동 이름 변경 금지

### 기존 frontmatter 와 충돌

기존 파일의 frontmatter 에 스키마에 없는 필드 (예: `author`, `category`) 가 있으면:
- 유지한다 (제거 금지)
- kb-validator 가 나중에 권장 경고로만 언급

### `.gitignore` 기존 엔트리

- 이미 `.kb/` 전체가 ignore 되어 있으면 경고 + 수정 제안 (다른 `.kb/` 파일이 커밋 안됨)
- `.kb/.tag-index` 만 ignore 되어 있으면 OK, 건드리지 않음

## Retrofit 후 권장 절차

1. 사용자에게 안내: "kb-validator 를 실행하여 형식 검증을 받으세요"
2. 주요 검출 예상 항목:
   - frontmatter 필드 누락 (이미 `auto-add` 했어도 `summary` 비어있음 등)
   - 태그 비어있는 파일 다수 (권장 경고)
   - `relations` 비어있는 파일 다수 (수동 복원 필요)
