---
title: Knowledge Lifecycle Rules
impact: CRITICAL
impactDescription: 지식 생성 / 수정 / 삭제 / 인덱싱 전체 라이프사이클의 AI 행동 규칙
tags: lifecycle, workflow, tag-index
---

# Knowledge Lifecycle

지식의 생성, 수정, 삭제, 태그 인덱싱에 대한 AI 행동 규칙. 이 규칙들은 `.kb/conventions.md` 를 통해 AI 가 지속적으로 참조한다.

## 생성 (Create)

1. 적절한 디렉토리 판단 (`.kb/README.md` 의 Directory Map 참조)
2. 애매하면 사용자에게 확인
3. 파일 작성 + frontmatter 필수 필드 기입:
   - `title` — 읽기 쉬운 제목
   - `created` / `updated` — 현재 UTC 시각
   - `summary` — 1~2줄
   - `tags` — 소문자-하이픈, 5~8개 권장
   - `status: draft` (완성 전) 또는 `active` (완성)
   - `relations: []` (관계 없으면)
4. 관계 탐색: references/rule-relations.md 의 "Strong signal" 판단
5. 디렉토리에 `README.md` 없으면 동시에 생성
6. **`.kb/.tag-index` 증분 갱신**:
   ```json
   {
     "tags": {
       "{tag}": [...existing..., "{new-file-path}"]
     }
   }
   ```

## 수정 (Update)

1. 본문 수정
2. frontmatter 의 `updated` 필드는 건드리지 않음 (git log 에서 보정됨)
3. `tags` 가 바뀌었으면:
   - 기존 모든 태그 엔트리에서 해당 파일 경로 제거
   - 현재 `tags` 에 따라 재삽입
4. `relations` 추가/제거 시 references/rule-relations.md 규칙 준수
5. 상태 전환:
   - `draft → active` — 완성 시
   - `active → deprecated` — 대체 문서가 생겼을 때. 대체 문서를 `relations` 에 포함
   - `deprecated → archived` — 역사적 기록으로만 남길 때

## 삭제 (Delete)

1. 삭제 대상 파일을 `relations` 에 포함한 문서들 찾기:
   ```
   grep -l "{target-path}" --include="*.md" -r {kb-root}
   ```
2. 각 문서의 frontmatter 에서 해당 relation 제거
3. 대상 파일 삭제
4. `.tag-index` 에서 해당 파일의 모든 태그 엔트리 제거. 빈 태그 키는 삭제

## 이동 / 이름변경 (Move / Rename)

1. 이동 대상 파일을 참조하는 문서들 grep
2. 해당 문서들의 relations 를 새 경로로 일괄 수정
3. 파일 이동 수행
4. `.tag-index` 재생성 또는 증분 (기존 경로 → 새 경로로 치환)

## Tag Indexing

### `.kb/.tag-index` 구조

```json
{
  "generated_at": "2026-04-22T10:30:00Z",
  "tags": {
    "auth": ["concepts/auth.md", "guides/oauth.md"],
    "security": ["concepts/auth.md", "runbooks/rotate-keys.md"]
  }
}
```

### 갱신 주체

| 시점 | 주체 | 방식 |
|------|------|------|
| 초기 셋업 | Phase 3 background agent | 전체 스캔 → 전체 생성 |
| AI 가 `.md` 생성 | AI | 증분 추가 |
| AI 가 `.md` 수정 (태그 변경 시) | AI | 기존 경로 제거 → 재삽입 |
| AI 가 `.md` 삭제 | AI | 모든 태그에서 경로 제거 + 빈 태그 삭제 |
| 사용자가 수동 수정 | — | stale 허용 |
| kb-validator 실행 | validator | 전체 재생성 |
| 태그 검색 시 stale 의심 | AI | `.tag-index` + grep 병행 fallback |

### `generated_at`

전체 재생성 시점만 갱신. 증분 시에는 건드리지 않는다. kb-validator 가 "마지막 전체 재생성 이후 며칠 경과" 를 판단할 수 있게 함.

## Timestamp 보정 (kb-validator 담당)

- `created`: `git log --diff-filter=A --follow --format=%aI -- {file} | tail -1`
- `updated`: `git log -1 --format=%aI -- {file}`
- 파일이 아직 커밋되지 않았으면 현재 시각 그대로 둠
- 보정 결과가 기존 값과 다르면 수정 (사용자 confirm 없이 — 필수 규칙)

## Length 초과

길이가 권장치를 초과하면 references/rule-length-guideline.md 참조. 분리 제안은 권장 사항이라 사용자 확인 필요.

## Directory README 필수

모든 디렉토리에는 `README.md` 가 반드시 있어야 한다. 새 디렉토리 생성 시 `README.md` 도 같이 생성. 빈 디렉토리는 kb-validator 가 경고 (사용자 확인 후 삭제 or README 생성).
