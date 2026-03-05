---
name: golang-best-practices
description: Idiomatic Go patterns, best practices, and conventions for building robust, efficient, and maintainable Go applications. Use this skill when writing, reviewing, or optimizing Go code, designing packages, writing tests, or benchmarking performance.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: March 2026
  abstract: Comprehensive Go development guide covering idiomatic patterns across 13 categories, prioritized by impact from critical (error handling, concurrency) to medium (tooling, anti-patterns). Each reference includes detailed explanations, incorrect vs. correct Go examples, and specific guidance to enable automated code generation and review.
---

# Go Development Patterns

Comprehensive idiomatic Go patterns and best practices guide. Contains rules across 13 categories, prioritized by impact to guide automated code generation, review, and optimization.

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
| 11       | Memory & Performance   | MEDIUM-HIGH | `perf-`   |
| 12       | Tooling Integration    | MEDIUM      | `tool-`   |
| 13       | Anti-Patterns          | MEDIUM      | `anti-`   |

## How to Use

Read individual rule files for detailed explanations and Go examples:

```
references/error-handling.md
references/concurrency.md
references/testing-patterns.md
references/_sections.md
```

Each rule file contains:

- Brief explanation of why it matters
- Incorrect Go example with explanation
- Correct Go example with explanation
- Additional context and best practices

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
