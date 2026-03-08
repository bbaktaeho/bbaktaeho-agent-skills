---
title: Simple Algorithms Are More Correct
impact: HIGH
impactDescription: Reduces bug surface area and maintenance cost by avoiding unnecessary algorithmic complexity
tags: simplicity, correctness, bugs, maintainability, kiss, pike-rule-4
---

# Rule 4: Fancy algorithms are buggier than simple ones

> "Fancy algorithms are buggier than simple ones, and they're much harder to implement. Use simple algorithms as well as simple data structures." -- Rob Pike

This is another instance of the KISS principle and Thompson's "When in doubt, use brute force."

## Why It Matters

Complex algorithms have more edge cases, more branching logic, and more opportunities for off-by-one errors. They are harder to:
- Implement correctly the first time
- Debug when something goes wrong
- Review during code review
- Modify when requirements change
- Test exhaustively

The cost of a bug in production almost always exceeds the cost of slightly slower but correct code.

## Incorrect Approach

Custom lock-free concurrent cache with intricate eviction logic:

```go
// "We need a fast cache, let me implement lock-free LRU"
type LockFreeLRU struct {
    buckets [256]unsafe.Pointer
    clock   uint64
    // ... 300 lines of atomic operations, CAS loops,
    // memory ordering constraints, ABA problem workarounds
}

func (c *LockFreeLRU) Get(key string) (interface{}, bool) {
    hash := fnv1a(key)
    bucket := atomic.LoadPointer(&c.buckets[hash&0xFF])
    // ... complex pointer arithmetic with memory barriers
}
```

This code is likely to have subtle concurrency bugs that surface under load, are difficult to reproduce, and take days to diagnose.

## Correct Approach

Use a simple, well-tested approach:

```go
type Cache struct {
    mu    sync.RWMutex
    items map[string]*entry
    max   int
}

func (c *Cache) Get(key string) (interface{}, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    e, ok := c.items[key]
    if !ok {
        return nil, false
    }
    return e.value, true
}
```

Simple mutex-based cache. Easy to understand, easy to test, easy to debug. If profiling later shows contention is a real bottleneck (Rule 2), then consider `sync.Map` or sharded locks -- not a custom lock-free structure.

## Key Takeaway

Choose the simplest algorithm and data structure that meets requirements. Correctness and maintainability matter more than theoretical performance. When a simpler approach works, the burden of proof is on the complex alternative to justify its existence through measurement.
