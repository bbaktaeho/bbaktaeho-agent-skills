---
title: Measure Before You Tune
impact: CRITICAL
impactDescription: Ensures optimization effort targets code that actually dominates runtime
tags: measurement, profiling, benchmarking, performance, pike-rule-2
---

# Rule 2: Measure

> "Measure. Don't tune for speed until you've measured, and even then don't unless one part of the code overwhelms the rest." -- Rob Pike

## Why It Matters

Even after identifying a slow area, optimization is only worthwhile when one part of the code **overwhelms** the rest. If a function takes 5% of total runtime, a 2x speedup saves only 2.5% overall. Amdahl's Law governs: the maximum speedup is limited by the fraction of time spent in the optimized section.

## Incorrect Approach

Optimizing based on gut feeling after a vague "it's slow" report:

```go
// "The JSON parsing must be slow, let me write a custom parser"
func parseResponse(data []byte) (*Response, error) {
    r := &Response{}
    // 200 lines of hand-rolled JSON parsing
    // to avoid reflection overhead...
    pos := 0
    for pos < len(data) {
        // manual token scanning...
    }
    return r, nil
}
```

No benchmark was run. The JSON parsing takes 2ms out of a 500ms request.

## Correct Approach

Measure first, then decide whether to optimize:

```go
func BenchmarkParseResponse(b *testing.B) {
    data := loadTestData()
    for b.Loop() {
        parseResponse(data)
    }
}
```

```
BenchmarkParseResponse-8    500000    2400 ns/op
```

Total request time: 500ms. JSON parsing: 0.0024ms (0.0005% of total).
The real cost is in network I/O and database queries. Optimization here yields no meaningful improvement.

**After measurement shows a real bottleneck:**

```
BenchmarkDBQuery-8    100    15000000 ns/op    # 15ms per query, 30 queries per request = 450ms
```

Now optimizing the database layer (batching queries, adding indices) yields a real improvement.

## Key Takeaway

Measure with profilers and benchmarks. Only optimize when one component clearly dominates the total runtime. A 10x speedup on 1% of runtime is invisible; a 2x speedup on 80% of runtime is transformative.
