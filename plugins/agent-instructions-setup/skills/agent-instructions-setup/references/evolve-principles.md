---
title: Document Evolution Principles
impact: HIGH
impactDescription: 셋업 이후 README 체인을 추가/수정/삭제할 때의 원칙. 라우팅이 깨지지 않게 유지
tags: evolve, maintenance, add, modify, delete, routing-table, readme-chain
---

## Purpose

셋업 이후 라우팅 체인 (`AGENTS.md` / `.agents/README.md` / `<dir>/README.md`) 을 추가·수정·삭제할 때의 원칙. 디렉토리가 늘어나도 라우팅이 깨지지 않게 유지한다.

## 추가 (Add)

새 상위 디렉토리 또는 하위 디렉토리를 추가할 때.

1. 디렉토리에 `README.md` 를 함께 만든다 (references/template-dir-readme.md)
2. frontmatter 는 references/meta-frontmatter.md 규칙 (`title`, `created`, `updated`, `summary`, `tags`, `status`, `relations`)
3. `summary` 는 **"언제 읽어야 하는지 + 얻는 것"** 형식
4. 한 단계 위 README 의 라우팅 표에 한 행 추가:
   - 새 상위 디렉토리 → `.agents/README.md` 의 `Top-Level Directories`
   - 새 하위 디렉토리 → `<dir>/README.md` 의 `Contents`
5. README 추가와 라우팅 표 갱신은 **같은 커밋** (원자성)

## 수정 (Modify)

기존 README / 콘텐츠 수정 시.

1. frontmatter 의 `updated` 는 직접 갱신할 필요 없음. meta-validator 가 git log 기준 자동 보정
2. 라우팅 표 행의 "역할" 컬럼이 본문을 여전히 반영하는지 확인
3. 디렉토리 이름 변경 시 한 단계 위 README 의 라우팅 표 갱신 + 양방향 relations 갱신
4. 길이 초과 (README.md hard 200줄) 시 그 자리에서 분해. "다음에" 금지

## 삭제 (Delete)

디렉토리 또는 README 삭제 시.

1. 한 단계 위 README 라우팅 표에서 해당 행 제거
2. 다른 README 의 `relations` 에서 해당 경로를 grep 으로 확인 후 제거
3. 빈 디렉토리는 함께 삭제
4. 디렉토리 자체는 두고 콘텐츠만 비우는 경우 README.md `summary` 에 "현재 비어있음. 다음 작업 시 채울 예정." 명시

## 라우팅 표 관리

각 README 의 라우팅 표는 그 디렉토리의 진입점이다.

- 새 항목 추가 시 반드시 한 행 추가
- 항목 제거 시 반드시 한 행 제거
- 행은 **"경로 → 역할 / 언제 읽어야 하는지"** 매핑
- 표가 10행을 넘으면 그룹핑 (예: "코드", "문서", "운영" 섹션)

## 길이 정책

| 파일 | Target | Soft warn | Hard warn |
|------|--------|-----------|-----------|
| `AGENTS.md` | 50줄 | 80줄 | 120줄 |
| `.agents/README.md` | 80줄 | 120줄 | 200줄 |
| `<dir>/README.md` (모든 깊이) | 80줄 | 120줄 | 200줄 |
| 일반 콘텐츠 (`docs/foo.md` 등) | 자유 | — | — |

라우팅 README 가 hard warn 을 넘으면 하위 README 로 분해.

## 디렉토리 분해 패턴

한 README 가 너무 길어지면 다음 패턴으로 분해.

```
docs/README.md             # 80줄 라우팅
↓ 분해
docs/
├── README.md              # 80줄 라우팅 (도메인 그룹별)
├── guide/
│   └── README.md          # 가이드 도메인 라우팅
├── reference/
│   └── README.md          # 레퍼런스 도메인 라우팅
└── tutorial/
    └── README.md          # 튜토리얼 도메인 라우팅
```

상위 README 는 하위 README 만 가리키고, 실제 콘텐츠 라우팅은 하위로 이관.

## 중복·충돌 방지

- README 추가 전 같은 역할 README 가 있는지 검색
- 중복 시 한 곳으로 통합, 나머지는 라우팅 표에서 제거
- 빈 README, 빈 디렉토리는 즉시 정리

## 신규 AI 도구 추가

셋업 이후 새 AI 도구를 추가할 때.

1. references/map-file-paths.md 에서 도구의 instruction 파일 경로 확인
2. `ln -sfn AGENTS.md {tool-path}` 로 심링크 생성 (디렉토리 필요 시 먼저 생성)
3. `.gitignore` 에서 해당 파일이 제외되어 있다면 라인 제거
4. 커밋 메시지: `chore: add {tool} instruction symlink`

## 신규 상위 디렉토리 추가 절차 (요약)

```bash
# 1. 디렉토리 + README.md 생성
mkdir -p new-dir
cat > new-dir/README.md <<'EOF'
---
title: ...
...
---
...
EOF

# 2. .agents/README.md 의 라우팅 표에 한 행 추가
# (수동 또는 agent-instructions-setup 재실행)

# 3. meta-validator 로 timestamps + tag-index 동기화
```

## 원칙 요약

- README 추가·수정·삭제는 라우팅 표와 동기화 (같은 커밋)
- frontmatter `updated` 는 git log 기준 — 사람이 손대지 않는다
- 길이 한도는 "당장" 지킨다 — 누적되면 라우팅이 부패
- `summary` 는 검색 키. 공들여 작성한다
- 구조를 유지하는 비용은 작고, 무너진 뒤 복구 비용은 크다
