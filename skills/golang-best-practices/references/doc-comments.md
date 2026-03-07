---
title: Write Effective Go Doc Comments
impact: HIGH
impactDescription: Consistent doc comments enable accurate godoc generation and improve code discoverability
tags: doc-comment, godoc, documentation, comment
---

## General Rules

- 모든 exported name에 doc comment를 작성한다
- 선언 바로 위에 빈 줄 없이 작성한다
- 완전한 문장으로 시작하며, 대상 이름으로 시작한다

## Package Comments

```go
// Package path implements utility routines for
// manipulating slash-separated paths.
package path
```

- `Package <name>` 으로 시작한다
- 패키지 전체의 목적을 설명한다

## Function/Method Comments

```go
// Quote returns a double-quoted Go string literal representing s.
func Quote(s string) string { ... }

// HasPrefix reports whether the string s begins with prefix.
func HasPrefix(s, prefix string) bool { ... }
```

- 함수 이름으로 시작한다
- bool 반환 함수는 "reports whether"를 사용한다 ("or not" 불필요)
- 매개변수와 반환값을 이름으로 직접 참조한다 (backtick 불필요)

## Type Comments

```go
// A Reader serves content from a ZIP archive.
type Reader struct { ... }

// Regexp is safe for concurrent use by multiple goroutines.
type Regexp struct { ... }
```

- 인스턴스가 무엇을 나타내는지 설명한다
- 동시성 안전성은 명시적으로 문서화한다 (기본: 단일 고루틴 전용)
- zero value가 유의미하면 문서화한다

## Const/Var Comments

```go
// The result of Scan is one of these tokens or a Unicode character.
const (
    EOF = -(iota + 1)
    Ident
    Int
)

// Version is the Unicode edition from which the tables are derived.
const Version = "13.0.0"
```

- 그룹 선언: 그룹 전체를 소개하는 doc comment
- 개별 항목: 줄 끝 주석

## Linking Syntax

```go
// Encoder writes JSON objects to an output stream. See [io.EOF] for errors.
// Uses [encoding/json.Decoder] for the inverse operation.
```

- `[Name]`: 현재 패키지 식별자
- `[pkg.Name]`: 외부 패키지 식별자
- `[pkg]`: 패키지 자체 참조

## Heading Syntax (Go 1.19+)

```go
// # Numeric Conversions
//
// The most common conversions are [Atoi] and [Itoa].
```

- `#` + 공백 + 텍스트
- 전후에 빈 줄 필수

## List Syntax

```go
// Features include:
//   - Item one
//   - Item two
//   - Item three with
//     continuation line
```

- bullet: `*`, `+`, `-` + 공백
- numbered: `1.` 또는 `1)` + 공백
- 중첩 리스트는 지원하지 않는다

## Code Block

```go
// Example usage:
//
//	result := Foo(42)
//	fmt.Println(result)
```

- 들여쓰기된 비공백 줄이 코드 블록으로 렌더링된다
- gofmt가 탭 하나로 정규화한다

## Deprecation

```go
// Deprecated: Use NewReader instead.
func OldReader() { ... }
```

- `Deprecated:` 로 시작하는 문단이 deprecated 표시가 된다

## References

- https://go.dev/doc/comment
