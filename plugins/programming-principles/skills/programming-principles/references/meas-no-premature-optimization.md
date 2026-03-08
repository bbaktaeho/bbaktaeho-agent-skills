---
title: Don't Optimize Without Evidence
impact: CRITICAL
impactDescription: Prevents wasted engineering effort on non-bottleneck code paths
tags: optimization, premature-optimization, bottleneck, performance, pike-rule-1
---

# Rule 1: You can't tell where a program is going to spend its time

> "You can't tell where a program is going to spend its time. Bottlenecks occur in surprising places, so don't try to second guess and put in a speed hack until you've proven that's where the bottleneck is." -- Rob Pike

This restates Tony Hoare's famous maxim:

> "Premature optimization is the root of all evil." -- C.A.R. Hoare

## Why It Matters

Developers consistently misjudge where performance bottlenecks occur. Optimizing code "by feel" leads to:
- Complex code in paths that rarely execute
- Simple code in actual hot paths that needs optimization
- Wasted development time with no measurable improvement

## Incorrect Approach

Optimizing a function without profiling data, based on assumption:

```go
// "This loop looks slow, let me optimize it"
func processUsers(users []User) []byte {
	// Pre-allocate, use bit manipulation, cache everything...
	cache := make(map[uint64][]byte)
	result := make([]byte, 0, len(users)*64)
	for _, u := range users {
		key := uint64(u.ID) & 0xFFFF
		if _, ok := cache[key]; !ok {
			cache[key] = expensiveLookup(u)
		}
		result = append(result, serializeFast(cache[key])...)
	}
	return result
}
```

The function processes 10 users per request. The actual bottleneck is a database query elsewhere that takes 200ms.

## Correct Approach

Write clear code first, then measure:

```go
func processUsers(users []User) []*Result {
	results := make([]*Result, len(users))
	for i, u := range users {
		results[i] = serialize(lookup(u))
	}
	return results
}
```

Profile the application, find the real bottleneck, and optimize there:

```
$ go tool pprof -top cpu.prof
      flat  flat%   cum%  function
    45.20s 90.4%  90.4%  db.fetchAllRecords    # <-- actual bottleneck
     0.003s  0.0%  90.4%  users.processUsers   # <-- not a bottleneck
```

## Key Takeaway

Never assume where the bottleneck is. Write simple code, measure with real data, and optimize only the proven hot path.
