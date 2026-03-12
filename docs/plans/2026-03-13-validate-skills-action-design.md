# Skill Format Validation GitHub Action Design

## Goal

plugins/ 또는 marketplace.json 변경 시 자동으로 스킬 포맷을 검증하는 GitHub Action을 만든다.

## Trigger

- pull_request: plugins/** 또는 .claude-plugin/marketplace.json 변경 시
- push to main: 동일 경로 변경 시

## Validation Rules

| # | 대상 | 검증 내용 | 근거 |
|---|------|----------|------|
| 1 | SKILL.md frontmatter | name 필수, 최대 64자, 소문자+숫자+하이픈만 | 공식 스펙 |
| 2 | SKILL.md frontmatter | name에 "anthropic", "claude" 예약어 불가 | 공식 스펙 |
| 3 | SKILL.md frontmatter | name이 디렉토리명과 일치 | 저장소 규칙 |
| 4 | SKILL.md frontmatter | description 필수, 비어있지 않음, 최대 1024자 | 공식 스펙 |
| 5 | SKILL.md frontmatter | XML 태그 불포함 (name, description 모두) | 공식 스펙 |
| 6 | SKILL.md body | 100줄 이하 | 저장소 규칙 |
| 7 | plugin.json | name, description, author, version 필수 | 저장소 규칙 |
| 8 | marketplace.json | 각 plugin의 name, description, source, category 필수 | 저장소 규칙 |
| 9 | marketplace.json | source 경로가 실제 디렉토리로 존재 | 일관성 |
| 10 | 디렉토리 구조 | plugins/{name}/.claude-plugin/plugin.json 존재 | 저장소 규칙 |
| 11 | 디렉토리 구조 | plugins/{name}/skills/{skill-name}/SKILL.md 존재 | 저장소 규칙 |

## File Structure

```
.github/
  workflows/
    validate-skills.yml
  scripts/
    validate-skills.sh
```

## Implementation

- Bash script: 의존성 없음
- 로컬 실행 가능: bash .github/scripts/validate-skills.sh
- 출력: [PASS]/[FAIL] 형식
- 실패 시 exit 1로 PR 블로킹

## Decisions

- 언어: Bash (의존성 없음)
- 검증 범위: SKILL.md + plugin.json + marketplace.json + 디렉토리 구조
- 공식 스펙 + 저장소 자체 규칙 모두 검증
