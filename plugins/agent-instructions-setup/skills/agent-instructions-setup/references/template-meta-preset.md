---
title: .agents/preset.json Template
impact: HIGH
impactDescription: meta-validator 가 메타 디렉토리 종류와 모드를 식별하기 위한 단일 식별자
tags: template, preset, meta-validator
---

# `.agents/preset.json`

메타 디렉토리의 종류와 셋업 모드를 표시하는 단일 식별자 파일. meta-validator 가 가장 먼저 읽는다.

## 생성 경로

`{repo}/.agents/preset.json`

## Schema

```json
{
  "kind": "agents",
  "version": "{semver}"
}
```

| Field | Required | 값 |
|-------|----------|----|
| `kind` | Yes | 항상 `"agents"`. meta-validator 가 `.agents/` 와 `.kb/` 를 구분하는 데 사용. `"agents"` 가 아니면 ERROR |
| `version` | Yes | 셋업 시점의 agent-instructions-setup 플러그인 semver |

## Example

```json
{
  "kind": "agents",
  "version": "4.0.0"
}
```

## meta-validator 가 사용하는 방식

1. `.agents/preset.json` 부재 → "agent-instructions-setup 을 먼저 실행하세요" 로 중단
2. 파싱 실패 → ERROR. 수동 복구 필요
3. `kind != "agents"` → ERROR. 잘못된 메타 디렉토리에 호출됨
4. `version` 은 향후 마이그레이션 검사용. 현재는 정보성

## 갱신 시점

- `agent-instructions-setup` 재실행 시 멱등 갱신 (version bump)
- 사용자가 직접 수정하지 말 것 — agent-instructions-setup 으로 재실행 권장
