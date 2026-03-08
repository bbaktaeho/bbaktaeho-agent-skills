---
title: TDD Workflow
impact: HIGH
impactDescription: Test-first development catches bugs early and produces better-designed APIs
tags: tdd, red-green-refactor, test-first
---

## The RED-GREEN-REFACTOR Cycle

```
RED     → Write a failing test first
GREEN   → Write minimal code to pass the test
REFACTOR → Improve code while keeping tests green
REPEAT  → Continue with next requirement
```

## Step-by-Step TDD in Go

```go
// Step 1: Define the interface/signature
// calculator.go
package calculator

func Add(a, b int) int {
    panic("not implemented")
}

// Step 2: Write failing test (RED)
// calculator_test.go
package calculator

import "testing"

func TestAdd(t *testing.T) {
    got := Add(2, 3)
    want := 5
    if got != want {
        t.Errorf("Add(2, 3) = %d; want %d", got, want)
    }
}

// Step 3: Run test - verify FAIL
// $ go test
// --- FAIL: TestAdd (0.00s)
// panic: not implemented

// Step 4: Implement minimal code (GREEN)
func Add(a, b int) int {
    return a + b
}

// Step 5: Run test - verify PASS
// $ go test
// PASS

// Step 6: Refactor if needed, verify tests still pass
```

## Testing Commands

```bash
go test ./...                          # Run all tests
go test -v ./...                       # Verbose output
go test -run TestAdd ./...             # Run specific test
go test -run "TestUser/Create" ./...   # Run subtest by pattern
go test -race ./...                    # Race detector
go test -cover -coverprofile=c.out ./... # Coverage
go test -short ./...                   # Short tests only
go test -timeout 30s ./...             # With timeout
go test -count=10 ./...                # Repeat (flaky detection)
```

## Best Practices

**DO:**
- Write tests FIRST (TDD)
- Test behavior, not implementation
- Use meaningful test names that describe the scenario

**DON'T:**
- Test private functions directly (test through public API)
- Use `time.Sleep()` in tests (use channels or conditions)
- Ignore flaky tests (fix or remove them)
- Skip error path testing
