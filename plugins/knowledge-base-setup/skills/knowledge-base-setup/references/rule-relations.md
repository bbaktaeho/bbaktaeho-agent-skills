---
title: Knowledge Relations Rules
impact: CRITICAL
impactDescription: AI 가 지식 간 연결을 해석하고 새 지식 배치를 판단하는 핵심 규칙
tags: relations, graph, linking
---

# Relations

`frontmatter.relations` 는 flat list 로, 현재 파일이 참조하는 다른 지식 파일의 상대 경로를 담는다. 관계 유형 (parent/supersedes/...) 은 구분하지 않는다.

## Why Flat

- 스키마 단순. 사용자/AI 가 고민 없이 경로만 추가
- 관계 유형은 본문 맥락 (또는 `status: deprecated` + `relations` 조합) 으로 충분히 표현 가능
- 확장 필요 시 상위 버전에서 typed 로 마이그레이션 가능

## 새 지식 생성 시 판단 흐름 (AI)

1. 본문 작성 완료 후 관련 문서 탐색:
   - `.kb/.tag-index` 에서 현재 태그와 겹치는 파일 조회
   - 본문의 주요 키워드로 지식베이스 전체 grep
2. 발견된 후보들에 대해 **Strong signal** 인지 판단:
   - 본문에서 해당 문서를 명시적으로 언급/인용했다
   - 같은 도메인의 상위 개념 (`concepts/`) 이 존재한다
   - 대체 관계 (구버전 문서가 존재한다)
   - 본문에서 참조한 API/규약을 정의한 문서가 있다
3. Strong signal → `relations` 에 추가
4. **Weak signal / 애매함** → 사용자에게 확인: `"이 문서를 X 와 연결할까요? (y/n/skip)"`
5. 신호 없음 → `relations: []`

## Weak Signal 예시

- 같은 태그가 있지만 서로 다른 도메인 (`auth` 태그가 security 와 user-onboarding 양쪽에 걸림)
- 본문에서 간접 언급만 있고 직접 참조는 안함
- 상위/하위 관계가 아닌 느슨한 주제적 유사성

이런 경우 반드시 사용자에게 질문한다.

## 양방향 관계

**단방향만 지원**. A 의 relations 에 B 를 추가해도 B 에 자동으로 A 가 추가되지 않는다.

이유:
- 양방향 자동 추가는 "spam 관계" 를 만들기 쉬움 (A 가 B 를 간단 참조했을 뿐인데 B 입장에서는 원치 않는 backlink)
- tag-index 와 grep 으로 역참조 조회가 충분

역참조가 필요하면 양쪽 문서에 각각 명시적으로 relations 추가.

## 삭제 시 관계 정리

### AI 가 삭제할 때 (권장 경로)

```
1. 삭제 대상 파일 경로 확인 (e.g., concepts/old-auth.md)
2. grep -l "old-auth.md" 로 해당 파일을 relations 에 포함한 문서들 찾음
3. 각 문서의 frontmatter.relations 에서 해당 경로 제거
4. 대상 파일 삭제
5. .tag-index 에서 해당 파일 경로 제거
```

### 사용자가 수동 삭제했을 때

AI 가 감지하지 못한 상태. 다음 **kb-validator** 실행 시 잡힘:
- "relations 가 존재하지 않는 파일을 가리킴" → 필수 항목으로 자동 제거
- 사용자 confirm 없이 수정 (필수 규칙이므로)

## 이동 (rename / move) 시

파일 경로가 바뀌면 기존 relations 가 깨진다.
- AI 가 이동을 수행하면: 이동 전 `grep -l "{old-path}"` → 모든 참조를 새 경로로 일괄 수정 → 이동 수행
- 사용자가 수동 이동: kb-validator 가 "broken relation" 감지. 해당 파일의 존재 여부 + 유사 이름 탐색 → 사용자에게 `"{old-path}" 를 "{new-path}" 로 업데이트할까요?` 확인

## Deprecation 체인

구문서가 새 문서로 대체될 때:

```yaml
# old/auth-v1.md
---
status: deprecated
relations:
  - ../new/auth-v2.md      # 대체 문서를 relations 에 포함
---
```

본문 상단에 명시적으로 "이 문서는 [auth-v2.md](../new/auth-v2.md) 로 대체되었습니다." 를 적는다.

## Incorrect

```yaml
relations:
  - OAuth Flow              # 제목이 아니라 경로여야 함
  - /users/.../foo.md       # 절대 경로 금지
  - https://example.com     # URL 금지
  - ../missing.md           # 존재하지 않는 파일 (kb-validator 가 제거)
```

## Correct

```yaml
relations:
  - ../concepts/session.md
  - ./pkce.md
  - ../runbooks/rotate-oauth-client-secret.md
```
