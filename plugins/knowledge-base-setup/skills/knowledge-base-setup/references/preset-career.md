---
title: Career Preset
impact: HIGH
impactDescription: 개인이 커리어 (이력 / 이력서 / 프로젝트 / 스킬 / 성과 / 학습 / 회고 / 목표) 를 KB 화하는 프리셋
tags: preset, career, personal
---

# Preset: `career`

개인 사용자가 커리어 전체 (이력, 이력서, 프로젝트, 스킬, 성과, 학습, 회고, 목표) 를 한 KB 에 모은다. 민감 정보 분리는 디렉토리 분할이 아닌 **레포 visibility 강제** (private/internal only) 로 처리. references/template-pre-push-visibility-hook.md 참조.

## Top-level Directories

```
{kb-root}/
├── README.md
├── .gitignore
├── .kb/
│   ├── README.md
│   ├── schema.md
│   ├── conventions.md
│   ├── preset.json                    # {"preset":"career","version":"1.0.0"}
│   └── hooks/
│       ├── pre-commit-secrets.sh
│       └── pre-push-visibility.sh     # career 전용
│
├── roles/
│   └── README.md
├── resumes/
│   └── README.md
├── projects/
│   └── README.md
├── skills/
│   └── README.md
├── brag/
│   └── README.md
├── learning/
│   └── README.md
├── reviews/
│   └── README.md
└── goals/
    └── README.md
```

## 각 디렉토리

### `roles/` — 회사 / 직무 이력
- 명명: `{YYYY-MM}-{company-slug}.md` (예: `2024-03-acme.md`)
- 한 회사에서 직무 변경 → 같은 파일 안에 timeline 추가. 큰 조직이면 서브디렉토리로 분리.
- 권장 태그: `[role, {company}, {discipline}]`
- `status`: 재직 중 → `active`, 퇴사 → `archived`

### `resumes/` — 이력서
- 마스터 1개 + 타깃별 fork 여러 개 모델
- 명명:
  - `master.md` — 전체 경력/성과를 담은 단일 소스
  - `{YYYY-MM}-{target-slug}.md` — 지원용 tailored (예: `2026-05-stripe-staff-be.md`)
- 서브디렉토리:
  - `resumes/cover-letters/` — 커버레터
  - `resumes/exports/` — 빌드된 PDF / HTML (`.gitignore` 에 자동 추가)
- 권장 태그: `[resume, master|tailored, {target}]`
- `relations` 로 `roles/`, `projects/`, `brag/` 항목과 연결 → 이력서 한 줄 한 줄의 근거 추적 가능

### `projects/` — 개인 / 회사 프로젝트
- 명명: `{slug}.md` 또는 큰 프로젝트는 `{slug}/{README,spec,architecture,retrospective}.md`
- 권장 태그: `[project, side|work, {domain}]`
- side / work 구분은 frontmatter tag 로만, 디렉토리 분리하지 않음

### `skills/` — 스킬 인벤토리
- 카테고리별 파일: `backend.md`, `infra.md`, `frontend.md`, `data.md`, `soft-skills.md` 등
- 각 스킬에 **레벨** (1-5 또는 novice / intermediate / advanced / expert) + 마지막 사용 시점 + `relations` 로 사용한 프로젝트 연결
- 권장 태그: `[skill, {category}]`

### `brag/` — 분기/연도별 성과 (brag doc)
- 명명: `{YYYY-Q#}.md` (예: `2026-Q1.md`) 또는 `{YYYY}.md`
- 한 항목 = 하나의 성과. 본문에 4 요소: 상황 / 행동 / 영향 / 증거 링크
- 권장 태그: `[brag, {quarter}]`
- `relations` 로 해당 `projects/`, `roles/` 연결

### `learning/` — 학습 기록
- 명명: `{YYYY}-{topic-slug}.md` (예: `2026-distributed-systems.md`)
- 책 / 강의 / 컨퍼런스 / 논문 통합. 자료 종류는 frontmatter tag 로 구분
- 권장 태그: `[learning, book|course|talk|paper, {domain}]`

### `reviews/` — 회고 + 1:1
- `reviews/self/{YYYY-Q#}.md` — 자기 회고
- `reviews/1on1/{YYYY-MM}-{counterpart-initials}.md` — 1:1 미팅 요약
- 권장 태그: `[review, self|1on1]`

### `goals/` — 목표
- 명명: `{YYYY}.md` (연), `{YYYY-Q#}.md` (분기)
- OKR 또는 자유 형식. 종료 후 retro 추가
- 권장 태그: `[goal, {timeframe}]`

## `.gitignore` 추가 항목

career 프리셋 셋업 시 `.gitignore` 에 자동 추가:

```
# Career KB
resumes/exports/
```

`.kb/local/career/` 같은 분리 디렉토리는 사용하지 않음. 모든 career 문서는 메인 디렉토리에 두되, **레포 자체를 private / internal 로 유지** 하는 것이 보호 메커니즘.

## Public 레포 푸시 차단

career 프리셋이 선택되면 Phase 2 에서 `pre-push-visibility.sh` 훅이 자동 설치된다. 이 훅이 push 시점에 origin 의 visibility 를 검사하여 public 이면 차단한다. 상세: references/template-pre-push-visibility-hook.md.

Phase 4 verification 에서도 한 번 검사하여 public 이면 셋업 직후 사용자에게 경고 (실패 처리는 아님 — 훅이 push 시점에 다시 막아줌).

## kb-validator 와의 관계

career 도 다른 프리셋과 동일하게 kb-validator 의 검증 대상. 추가 career 전용 검증은 도입하지 않음 (1000/2000/2500 라인 권장도 동일 적용).

## `.kb/README.md` Directory Map

career 프리셋용 Directory Map 본문:

```markdown
## Directory Map

- roles/      — 회사 / 직무 이력
- resumes/    — 이력서 (master + 지원용 tailored)
- projects/   — 개인 / 회사 프로젝트
- skills/     — 스킬 인벤토리
- brag/       — 분기 / 연도별 성과
- learning/   — 책 / 강의 / 컨퍼런스 / 논문 학습 기록
- reviews/    — 자기 회고 + 1:1 메모
- goals/      — 분기 / 연간 목표

## Privacy

이 KB 는 개인 커리어 정보를 담습니다. 레포 visibility 는 반드시 private 또는 internal 로 유지하세요. pre-push 훅이 public 푸시를 차단합니다.
```
