---
title: Research Preset
impact: HIGH
impactDescription: 개인 또는 소규모 팀의 리서치 / 학습 전용 프리셋
tags: preset, research
---

# Preset: `research`

리서치, 학습, 탐색 전용. 가볍고 빠르게 시작. team-docs 보다 범위가 좁음.

## Top-level Directories

```
{kb-root}/
├── topics/
│   └── README.md
├── experiments/
│   └── README.md
└── notes/
    └── README.md
```

## 각 디렉토리의 역할

### `topics/`
리서치 주제별로 정리된 본격 문서. 한 주제가 커지면 `topics/{topic-name}/` 서브디렉토리로 분리.

예:

```
topics/
├── README.md
├── consensus-algorithms.md              # 단일 파일
└── mev/                                  # 서브디렉토리
    ├── README.md
    ├── sandwich-attacks.md
    └── flashloans.md
```

### `experiments/`
실험 / POC / 벤치마크 결과. 재현 가능한 절차와 측정 결과 중심.

```
experiments/
├── README.md
├── postgres-vs-clickhouse-write/
│   ├── README.md
│   ├── methodology.md
│   ├── results.md
│   └── raw-data.json        # 참조 데이터
└── ...
```

### `notes/`
임시 메모, 아이디어 스케치, 미완성 초안. 여기 있는 문서는 대부분 `status: draft`. 완성되면 `topics/` 또는 `experiments/` 로 이동.

## 초기 README.md 템플릿

references/template-dir-readme.md 의 Title 매핑 참고.

## 권장 태그

- `research`, `experiment`, `note` (디렉토리 slug)
- 주제별 태그 자유롭게 (`mev`, `consensus`, `benchmark`)

## Growth Path

지식이 많아지고 팀이 커지면 `team-docs` 프리셋으로 마이그레이션을 고려:

1. `topics/` 중 실제 의사결정의 근거가 된 것 → `decisions/` 로 이동
2. 반복 실행 절차가 정리된 것 → `runbooks/` 로 이동
3. 그 외 리서치는 `research/` 하위로 유지

이 마이그레이션은 수동. 디렉토리 구조만 추가하면 된다.
