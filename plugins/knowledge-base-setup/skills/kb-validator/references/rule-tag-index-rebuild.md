---
title: Tag Index Rebuild Logic
impact: CRITICAL
impactDescription: .kb/.tag-index 전체 재생성 로직. 증분 갱신의 drift 를 주기적으로 교정
tags: validation, tag-index, rebuild
---

# Tag Index Rebuild

`.kb/.tag-index` 를 전체 스캔으로 재생성한다. AI 의 증분 갱신이 누락했거나 사용자의 수동 수정으로 drift 가 생겼을 때 교정.

## Input

- KB 루트 디렉토리
- 스캔 대상: 모든 `.md` 파일
- 제외: `.kb/` 하위 파일 (**메타 파일은 태그 인덱싱 대상이 아님**), gitignored 파일, submodule 내부

## Output 포맷

```json
{
  "generated_at": "2026-04-22T10:30:00Z",
  "tags": {
    "auth": ["concepts/auth.md", "guides/oauth.md"],
    "security": ["concepts/auth.md", "runbooks/rotate-keys.md"]
  }
}
```

- `generated_at`: 전체 재생성 시각 (UTC ISO 8601)
- `tags`: 키가 태그, 값이 파일 경로 배열
- 경로는 KB 루트 기준 상대경로 (`./` prefix 없음)
- 배열 내 경로 정렬: 사전순
- 태그 키 정렬: 사전순

## 재생성 알고리즘

```
tags = {}

for each .md file in kb_root (excluding .kb/, .gitignore):
    parse frontmatter
    for tag in frontmatter.tags:
        normalized = normalize(tag)           # 소문자 + 하이픈
        if normalized not in tags:
            tags[normalized] = []
        tags[normalized].append(relative_path)

for tag in tags:
    tags[tag].sort()
    tags[tag] = dedupe(tags[tag])

sort tags by key

write .kb/.tag-index with generated_at = now_utc()
```

## `.kb/` 제외 이유

`.kb/README.md`, `.kb/schema.md` 등의 frontmatter 에 `tags: [meta, entry]` 같은 태그가 있지만, 이들은 **인덱스 노이즈**. 실제 지식 탐색에서 "meta" 태그로 검색할 일은 거의 없음. 따라서 인덱스 대상에서 제외.

## `.gitignore` 되거나 숨김 파일 처리

- `.gitignore` 규칙 존중 (git check-ignore 로 판단)
- 숨김 디렉토리 (`.` 으로 시작) 는 기본 제외 (단 `.kb/` 은 이미 위에서 제외됨)

## Submodule 처리

- Submodule 내부 `.md` 파일은 기본 제외
- 호스트 레포의 kb-validator 가 submodule 내부의 지식을 인덱싱하지 않음
- Submodule 내부는 해당 submodule 의 자체 kb-validator 가 관리

## Frontmatter 파싱 실패 처리

- 해당 파일은 스킵
- 리포트에 "parse failed: {path}" 기록 (경고)
- 재생성 자체는 계속 진행

## `tags` 필드 없거나 빈 배열

- 해당 파일은 어느 태그에도 추가되지 않음 (정상 처리)
- 빈 태그 키 (`"auth": []`) 는 생성하지 않음

## 정렬 규칙

- 태그 키: Unicode lexical order (소문자라 ASCII 와 동일)
- 배열 내 경로: 같은 규칙. 디렉토리 구분자 `/` 는 일반 문자처럼 정렬

## 성능

- 파일 수 N, 평균 태그 수 T → O(N·T) 스캔 + O(N·T·log(N·T)) 정렬
- 1000 파일 × 5 태그 = 5000 엔트리. 수 ms 수준
- 성능 이슈는 지식베이스가 수만 파일일 때만 실감, 그 경우 증분 갱신 정확도로 전체 재생성 빈도 줄임

## 증분 갱신과의 일관성

- 증분 갱신 포맷 === 전체 재생성 포맷
- AI 의 증분 갱신이 정렬 규칙을 어길 수 있음 (append 만 하면 정렬 깨짐). 다음 재생성 때 정렬 복구
- `generated_at` 은 증분 갱신 때 건드리지 않음 → kb-validator 가 "마지막 전체 재생성 이후 얼마 지났는지" 판단 가능

## 재생성 빈도 판단

kb-validator 는 항상 태그 인덱스를 재생성한다 (Phase 2 에서 항상 실행). 증분 갱신의 drift 를 누적시키지 않는 것이 핵심.

## Atomicity

- 쓰기는 atomic 하게: 임시 파일 `.kb/.tag-index.tmp` 에 쓰고 `mv` 로 치환
- 이렇게 해야 중간에 실패해도 기존 인덱스가 깨지지 않음
