---
title: Custom Preset
impact: HIGH
impactDescription: 최소한의 셋업만 하고 디렉토리 구조는 사용자가 직접 구성하는 프리셋
tags: preset, custom
---

# Preset: `custom`

top-level 디렉토리를 생성하지 않는다. `.kb/` 메타와 루트 `README.md` 만 세팅. 사용자가 필요에 따라 디렉토리를 추가.

## 생성되는 구조

```
{kb-root}/
├── README.md                    # 루트 (사람용)
├── .gitignore
└── .kb/
    ├── README.md
    ├── schema.md
    ├── conventions.md
    └── preset.json              # {"preset":"custom","version":"1.0.0"}
```

## 사용 케이스

- 기존 프로젝트를 retrofit 할 때 기존 디렉토리 구조 유지
- 도메인이 특이해서 프리셋들이 안 맞을 때
- 매우 작은 지식베이스 (파일 몇 개) 로 시작할 때

## 새 디렉토리 추가 가이드

custom 프리셋은 규칙이 덜 강제되지만 몇 가지는 유지한다:

- 새 디렉토리 생성 시 `README.md` 필수
- `README.md` frontmatter 에 `tags: [{dir-slug}]` 포함
- 디렉토리 이름: 소문자 + 하이픈, 복수형 권장

## `.kb/README.md` 의 Directory Map

custom 프리셋은 초기 디렉토리 맵이 비어있다. 아래처럼 자리를 비워둔다:

```markdown
## Directory Map

(top-level 디렉토리는 아직 없습니다. 첫 지식을 만들 때 디렉토리를 결정하세요.)

### 추천 디렉토리 (필요 시 생성)

- `concepts/` — 핵심 개념
- `guides/` — 작업 가이드
- `references/` — 참조 자료
- `runbooks/` — 운영 매뉴얼
- `research/` — 리서치 / 탐색
```

AI 가 첫 지식을 추가할 때 이 "추천 디렉토리" 를 참고하여 제안하거나, 사용자에게 디렉토리명을 물어본다.

## kb-validator 와의 관계

custom 이라도 kb-validator 의 검증 규칙은 동일하게 적용:
- frontmatter 스키마
- 디렉토리 README 필수
- relations 유효성
- 타임스탬프 git 동기화

프리셋 고유 검증 (예: team-docs 의 `decisions/` 파일명 규칙) 은 custom 에서는 건너뜀.
