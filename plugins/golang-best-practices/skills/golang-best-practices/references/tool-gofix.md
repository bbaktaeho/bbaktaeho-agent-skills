---
title: Modernize Go Code with go fix
impact: MEDIUM
impactDescription: Eliminates 90%+ of manual pattern migration effort across Go version upgrades
tags: go-fix, modernization, refactoring, tooling
---

## Overview

`go fix`는 Go 1.26에서 완전히 재작성된 코드 모더나이제이션 도구다. 구버전 Go 패턴을 최신 idiom으로 자동 변환한다.

## Basic Usage

```bash
# 모든 fix 적용
go fix ./...

# 변경 사항 미리보기 (적용하지 않음)
go fix -diff ./...

# 사용 가능한 fixer 목록 확인
go tool fix help
```

## Modernizers

각 modernizer는 특정 Go 버전 이상에서만 동작한다. 프로젝트의 `go.mod`에 명시된 Go 버전에 따라 적용 가능한 modernizer가 결정된다.

### minmax (Go 1.21+)

조건문 기반 min/max 패턴을 빌트인 함수로 변환한다.

```go
// Before
if a < b {
    a = b
}

// After
a = max(a, b)
```

### stringscut (Go 1.18+)

`strings.Index` + 슬라이싱 패턴을 `strings.Cut`으로 변환한다.

```go
// Before
if i := strings.Index(s, sep); i >= 0 {
    before, after := s[:i], s[i+len(sep):]
    // ...
}

// After
if before, after, ok := strings.Cut(s, sep); ok {
    // ...
}
```

### rangeint (Go 1.22+)

3-clause for 루프를 range-over-int 구문으로 변환한다.

```go
// Before
for i := 0; i < n; i++ {
    // ...
}

// After
for i := range n {
    // ...
}
```

### newexpr (Go 1.26+)

헬퍼 함수 기반 포인터 생성을 `new(expr)` 구문으로 변환한다.

```go
// Before
func newInt(v int) *int { return &v }
p := newInt(42)

// After
p := new(42)
```

## Go Version Compatibility Summary

| Modernizer   | 최소 Go 버전 | 변환 대상                        |
| ------------ | ------------- | -------------------------------- |
| stringscut   | 1.18          | strings.Index -> strings.Cut     |
| minmax       | 1.21          | if 조건문 -> min()/max()         |
| rangeint     | 1.22          | 3-clause for -> range int        |
| newexpr      | 1.26          | 헬퍼 함수 -> new(expr)           |

## 주의 사항

- `go fix`는 프로젝트의 `go.mod`에 선언된 Go 버전을 기준으로 적용 가능한 modernizer를 자동 판단한다
- 여러 modernizer를 순차 적용하면 시너지 효과가 발생할 수 있다 (한 fix가 다른 fix의 기회를 만듦)
- 충돌하는 편집은 three-way merge 알고리즘으로 자동 해결된다
- 사용하지 않는 import는 자동으로 제거된다

## References

- https://go.dev/blog/gofix
