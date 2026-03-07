# [AGENTS.md](http://AGENTS.md)

이 문서는 이 저장소에서 작업하는 **AI 코딩 에이전트를 위한 가이드**입니다.

## General Rules

- **절대 이모지를 사용하지 마세요.** 코드, 주석, 커밋 메시지, 문서, 응답 등 모든 출력에서 이모지를 사용하지 않습니다.

---

# Repository 구조

```
skills/
  {skill-name}/
    SKILL.md              # 필수: skill manifest (Agent Skills spec)
    references/
      _sections.md        # 필수: 섹션 정의
      {prefix}-{name}.md  # reference 파일
```

---

# 새로운 Skill 만들기

Skills는 **Agent Skills Open Standard** 를 따릅니다.

1. 디렉토리 생성

```
  mkdir -p skills/{skill-name}/references
```

2. `SKILL.md` 생성 (아래 형식 준수)
3. `references/_sections.md` 생성 (섹션 정의)
4. reference 파일 추가

```
  {prefix}-{reference-name}.md
```

5. `.claude-plugin/marketplace.json`의 `plugins` 배열에 새 skill 항목 추가

```json
{
  "name": "skill-name",
  "description": "skill description. Use when [trigger contexts].",
  "source": "./",
  "strict": false,
  "skills": [
    "./skills/skill-name"
  ]
}
```

---

# SKILL.md 작성 방법

`SKILL.md`는 **모든 skill의 핵심 파일**입니다.

구성:

```
YAML frontmatter
+
Markdown instructions

```

---

# Frontmatter

```yaml
---
name: skill-name
description: What this skill does. Use this skill when [trigger contexts].
license: MIT
metadata:
  author: author-name
  version: "1.0.0"
  date: Month Year
  abstract: >
    Comprehensive description for indexing. Contains rules across N categories,
    prioritized by impact. Each rule includes explanations, incorrect vs. correct
    examples, and specific guidance.
---
```

| Field       | Required | 설명                                              |
| ----------- | -------- | ------------------------------------------------- |
| name        | Yes      | 1~64자. 소문자 영숫자 + 하이픈                    |
| description | Yes      | 1~1024자. 무엇을 하는 skill인지 + 언제 사용하는지 |
| license     | No       | 라이선스 이름 또는 파일                           |
| metadata    | No       | author, version, date, abstract 등                |

---

# name 규칙

허용 문자

```
a-z
0-9
-
```

제약 조건

- `-` 로 시작 또는 끝나면 안됨
- `--` 연속 사용 금지
- 디렉토리 이름과 반드시 동일해야 함

예시

```
# 올바른 예
name: pdf-processing
name: data-analysis

# 잘못된 예
name: PDF-Processing
name: -pdf
name: pdf--processing
```

---

# description 필드 (매우 중요)

`description` 은 **skill 트리거 메커니즘의 핵심**입니다.

Claude는 이 설명을 보고  
**언제 이 skill을 사용할지 판단합니다.**

반드시 포함해야 하는 내용

- skill이 무엇을 하는지
- 언제 사용하는지 (trigger context)

좋은 예

```
Supabase database best practices for schema design, RLS policies,
indexing, and query optimization.

Use when working with Supabase projects,
writing PostgreSQL migrations,
configuring Row Level Security,
or optimizing database performance.
```

나쁜 예

```
Helps with databases.
```

주의:

> "when to use" 를 body에 넣지 마세요.  
> body는 skill이 트리거된 후에만 로드됩니다.

---

# Body Content

Markdown body에는 **skill 메타 정보와 reference 탐색 가이드**를 작성합니다.

원칙

- **코드 예제를 SKILL.md에 넣지 마세요** — 모든 코드는 `references/`로 이동
- 100줄 이하 유지 (토큰 절약)
- 카테고리별 우선순위 테이블 제공
- reference 파일 구조 설명
- 외부 공식 문서 링크 포함

권장 구조

```
# Skill Title

1줄 요약.

## When to Apply

Reference these guidelines when:
- trigger context 1
- trigger context 2

## Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Category Name | CRITICAL | `prefix-` |
| 2 | Category Name | HIGH | `prefix-` |

## How to Use

Read individual rule files for detailed explanations and examples:

references/prefix-example.md
references/_sections.md

Each rule file contains:
- Brief explanation of why it matters
- Incorrect example with explanation
- Correct example with explanation

## Quick Reference (optional)

| Key Concept | Description |
|-------------|-------------|
| Concept 1 | Short description |

## References

- https://official-docs.example.com
```

---

# Progressive Disclosure

Skill은 **3단계 로딩 구조**를 사용합니다.

| 단계       | 설명                                      |
| ---------- | ----------------------------------------- |
| Metadata   | 모든 skill에 대해 항상 로드 (~100 tokens) |
| Body       | skill이 트리거될 때 로드                  |
| References | 필요할 때만 로드                          |

따라서

> **SKILL.md 는 최대한 가볍게 유지해야 합니다.**

---

# Reference File Format

`references/` 파일은 skill의 상세 문서를 제공합니다.

```
---
title: Action-Oriented Title
impact: CRITICAL|HIGH|MEDIUM-HIGH|MEDIUM|LOW-MEDIUM|LOW
impactDescription: Quantified benefit
tags: keywords
---

[내용]

```

---

# 포함하면 안되는 파일

Skill에는 **AI가 작업하는 데 필요한 최소 파일만 포함**해야 합니다.

다음 파일은 만들지 마세요.

```
README.md
INSTALLATION_GUIDE.md
QUICK_REFERENCE.md
CHANGELOG.md
```

Skill은 **AI agent가 작업을 수행하는 데 필요한 정보만 포함**해야 합니다.
