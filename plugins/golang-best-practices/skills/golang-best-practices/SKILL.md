---
name: golang-best-practices
description: Idiomatic Go patterns and conventions for writing robust, efficient, and maintainable Go code. Use whenever working on .go files or Go modules - writing or reviewing Go code, designing packages or interfaces, handling errors, building concurrent code with goroutines/channels/context, writing table-driven tests, benchmarks or fuzz tests, tuning memory and performance, modernizing code with go fix, or configuring go vet, staticcheck, and golangci-lint.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: April 2026
  abstract: Go development guide covering idiomatic patterns across 14 categories, prioritized by impact from critical (error handling, concurrency, table-driven tests) to medium (tooling, anti-patterns). Each reference includes concise explanations and Go code examples to guide code generation and review.
---

# Go Development Patterns

Comprehensive idiomatic Go patterns and best practices guide. Contains rules across 14 categories, prioritized by impact to guide automated code generation, review, and optimization.

## When to Apply

Reference these guidelines when:

- Writing new Go functions, methods, or packages
- Reviewing or refactoring existing Go code
- Designing interfaces and package boundaries
- Implementing error handling or concurrency
- Writing tests, benchmarks, or fuzz tests
- Optimizing memory usage or performance
- Setting up linters and CI pipelines

## Rule Categories by Priority

| Priority | Category               | Impact      | Prefix    |
| -------- | ---------------------- | ----------- | --------- |
| 1        | Error Handling         | CRITICAL    | `err-`    |
| 2        | Concurrency            | CRITICAL    | `conc-`   |
| 3        | Table-Driven Tests     | CRITICAL    | `tpat-`   |
| 4        | Interface Design       | HIGH        | `iface-`  |
| 5        | Package Organization   | HIGH        | `pkg-`    |
| 6        | Struct Design          | HIGH        | `struct-` |
| 7        | TDD Workflow           | HIGH        | `tdd-`    |
| 8        | Mocking & Test Helpers | HIGH        | `tmock-`  |
| 9        | Benchmarks & Fuzzing   | HIGH        | `tbench-` |
| 10       | HTTP Handler Testing   | HIGH        | `thttp-`  |
| 11       | Doc Comments           | HIGH        | `doc-`    |
| 12       | Memory & Performance   | MEDIUM-HIGH | `perf-`   |
| 13       | Tooling Integration    | MEDIUM      | `tool-`   |
| 14       | Anti-Patterns          | MEDIUM      | `anti-`   |

## How to Use

Load only the references relevant to the current task. Start with `references/_sections.md` for the full category map, then open files by prefix (for example `err-*`, `conc-*`, `tpat-*`). Each reference contains a short rationale plus Go code examples; some include explicit Bad vs Good comparisons.

## Core Idioms

| Idiom                                               | Description                                              |
| --------------------------------------------------- | -------------------------------------------------------- |
| Accept interfaces, return structs                   | Functions accept interface params, return concrete types |
| Errors are values                                   | Treat errors as first-class values, not exceptions       |
| Don't communicate by sharing memory                 | Use channels for coordination between goroutines         |
| Make the zero value useful                          | Types should work without explicit initialization        |
| A little copying is better than a little dependency | Avoid unnecessary external dependencies                  |
| Clear is better than clever                         | Prioritize readability over cleverness                   |
| Return early                                        | Handle errors first, keep happy path unindented          |

## References

- https://go.dev/doc/effective_go
- https://go.dev/blog/error-handling-and-go
- https://go.dev/doc/modules/developing
- https://github.com/golang/go/wiki/CodeReviewComments
- https://google.github.io/styleguide/go/
