---
title: Prefer Simple Algorithms for Small N
impact: HIGH
impactDescription: Avoids constant-factor overhead that makes fancy algorithms slower for typical workloads
tags: algorithm, simplicity, big-o, constant-factor, kiss, pike-rule-3
---

# Rule 3: Fancy algorithms are slow when n is small

> "Fancy algorithms are slow when n is small, and n is usually small. Fancy algorithms have big constants. Until you know that n is frequently going to be big, don't get fancy. (Even if n does get big, use Rule 2 first.)" -- Rob Pike

Ken Thompson rephrased this as:

> "When in doubt, use brute force." -- Ken Thompson

This is an instance of the KISS (Keep It Simple, Stupid) design philosophy.

## Why It Matters

Big-O notation hides constant factors. An O(n log n) algorithm with high constant overhead can be slower than O(n^2) for small n. In practice, most collections in typical applications are small (< 100 elements). The overhead of a sophisticated algorithm -- memory allocation, complex branching, cache misses -- often exceeds the theoretical advantage.

## Incorrect Approach

Using a complex data structure for a small collection:

```go
// 10 items in the config, but using a red-black tree
// for "optimal" O(log n) lookup
import "github.com/emirpasber/gods/trees/redblacktree"

func findConfig(key string) *Config {
    tree := redblacktree.NewWithStringComparator()
    for _, c := range configs { // len(configs) == 10
        tree.Put(c.Key, c)
    }
    val, found := tree.Get(key)
    if !found {
        return nil
    }
    return val.(*Config)
}
```

Tree construction overhead, pointer chasing, and memory allocation dominate. For 10 items, a linear scan is faster.

## Correct Approach

Simple linear scan for small collections:

```go
func findConfig(key string) *Config {
    for _, c := range configs { // len(configs) == 10
        if c.Key == key {
            return &c
        }
    }
    return nil
}
```

Clean, obvious, cache-friendly, zero allocation. For n=10, linear search beats tree lookup due to lower constants.

**When n is known to be large**, apply Rule 2 first (measure), then use the appropriate algorithm:

```go
// Proven large dataset (1M+ items), measured bottleneck
// Now a map is justified
configIndex := make(map[string]*Config, len(configs))
for i := range configs {
    configIndex[configs[i].Key] = &configs[i]
}
```

## Key Takeaway

Start with the simplest algorithm. Brute force (linear scan, nested loop) is often the best choice for small n. Only introduce complexity when n is proven large AND measurement shows the simple approach is the bottleneck.
