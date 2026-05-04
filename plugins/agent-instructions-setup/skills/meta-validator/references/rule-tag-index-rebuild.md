---
title: Tag Index Rebuild Logic
impact: CRITICAL
impactDescription: .agents/.tag-index 전체 재생성 로직
tags: validation, tag-index, rebuild
---

# Tag Index Rebuild

`.agents/.tag-index` 를 전체 스캔으로 재생성한다. 증분 갱신 drift 를 주기적으로 교정.

## Input

- 레포 루트 디렉토리
- 스캔 대상: `agents/**/*.md`
- 제외: `.agents/` 하위 파일 (**메타는 인덱싱 대상 아님**), gitignored, submodule 내부, AGENTS.md 자체

## Output 포맷

```json
{
  "generated_at": "2026-05-05T10:30:00Z",
  "tags": {
    "workflow": ["agents/workflow.md"],
    "security": ["agents/security.md", "agents/onboarding.md"]
  }
}
```

- `generated_at`: 전체 재생성 시각 (UTC ISO 8601)
- `tags`: 키가 태그, 값이 파일 경로 배열
- 경로는 레포 루트 기준 상대경로 (`./` prefix 없음)
- 배열 / 키 모두 사전순

## 재생성 알고리즘

```
tags = {}

for each .md in agents/ (excluding gitignored, submodules):
    parse frontmatter
    for tag in frontmatter.tags:
        normalized = normalize(tag)
        tags.setdefault(normalized, []).append(relative_path)

for tag in tags:
    tags[tag].sort()
    tags[tag] = dedupe(tags[tag])

sort tags by key
write .agents/.tag-index with generated_at = now_utc()
```

## `.agents/` / AGENTS.md 제외 이유

- `.agents/README.md` / `schema.md` / `conventions.md` 의 태그(`meta`, `schema` 등) 는 **인덱스 노이즈**
- AGENTS.md 는 frontmatter 부재가 표준이므로 처음부터 인덱싱 대상 아님

## `.gitignore` / 숨김 파일

- `.gitignore` 규칙 존중 (git check-ignore)
- 숨김 디렉토리 (`.` 시작) 는 기본 제외

## Submodule

- 내부 `.md` 는 기본 제외
- Submodule 자체에 별도 셋업이 있으면 거기 meta-validator 가 관리

## Frontmatter 파싱 실패

- 해당 파일 스킵
- 리포트에 "parse failed: {path}" 경고
- 재생성 자체는 계속

## `tags` 부재 / 빈 배열

- 해당 파일은 어느 태그에도 추가되지 않음
- 빈 태그 키는 생성하지 않음

## 정렬

- Unicode lexical order

## 재생성 빈도

meta-validator 는 Phase 2 에서 항상 재생성한다 (증분 drift 누적 방지). 단 secret 검출 시 보류.

## Atomicity

- `.agents/.tag-index.tmp` 에 쓰고 `mv` 로 치환. 실패해도 기존 인덱스 보존
