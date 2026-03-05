---
name: golang-patterns
description: >
  Idiomatic Go patterns, best practices, and conventions for building robust,
  efficient, and maintainable Go applications. Use when writing new Go code,
  reviewing Go code, refactoring existing Go code, designing Go packages
  and modules, writing tests, creating benchmarks, or implementing fuzz tests.
---

# Go Development Patterns

Idiomatic Go patterns and best practices for building robust, efficient, and maintainable applications.

## Core Principles

### Simplicity and Clarity

Go favors simplicity over cleverness. Code should be obvious and easy to read.

```go
// Good: Clear and direct
func GetUser(id string) (*User, error) {
    user, err := db.FindUser(id)
    if err != nil {
        return nil, fmt.Errorf("get user %s: %w", id, err)
    }
    return user, nil
}

// Bad: Overly clever
func GetUser(id string) (*User, error) {
    return func() (*User, error) {
        if u, e := db.FindUser(id); e == nil {
            return u, nil
        } else {
            return nil, e
        }
    }()
}
```

### Make the Zero Value Useful

Design types so their zero value is immediately usable without initialization.

```go
// Good: Zero value is useful
type Counter struct {
    mu    sync.Mutex
    count int
}

func (c *Counter) Inc() {
    c.mu.Lock()
    c.count++
    c.mu.Unlock()
}

// Bad: Requires initialization
type BadCounter struct {
    counts map[string]int // nil map will panic
}
```

### Accept Interfaces, Return Structs

```go
// Good: Accepts interface, returns concrete type
func ProcessData(r io.Reader) (*Result, error) {
    data, err := io.ReadAll(r)
    if err != nil {
        return nil, err
    }
    return &Result{Data: data}, nil
}
```

## Quick Reference: Go Idioms

| Idiom | Description |
|-------|-------------|
| Accept interfaces, return structs | Functions accept interface params, return concrete types |
| Errors are values | Treat errors as first-class values, not exceptions |
| Don't communicate by sharing memory | Use channels for coordination between goroutines |
| Make the zero value useful | Types should work without explicit initialization |
| A little copying is better than a little dependency | Avoid unnecessary external dependencies |
| Clear is better than clever | Prioritize readability over cleverness |
| Return early | Handle errors first, keep happy path unindented |

## Detailed References

- **Error handling patterns**: See [references/error-handling.md](references/error-handling.md)
- **Concurrency patterns**: See [references/concurrency.md](references/concurrency.md)
- **Interface design**: See [references/interface-design.md](references/interface-design.md)
- **Package organization**: See [references/package-organization.md](references/package-organization.md)
- **Struct design**: See [references/struct-design.md](references/struct-design.md)
- **Memory and performance**: See [references/memory-performance.md](references/memory-performance.md)
- **Tooling integration**: See [references/tooling.md](references/tooling.md)
- **Anti-patterns**: See [references/anti-patterns.md](references/anti-patterns.md)
- **TDD workflow**: See [references/testing-tdd.md](references/testing-tdd.md)
- **Table-driven tests & subtests**: See [references/testing-patterns.md](references/testing-patterns.md)
- **Mocking & test helpers**: See [references/testing-mocking.md](references/testing-mocking.md)
- **Benchmarks & fuzzing**: See [references/testing-benchmarks.md](references/testing-benchmarks.md)
- **HTTP handler testing**: See [references/testing-http.md](references/testing-http.md)
