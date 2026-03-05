---
title: Right-Size Shards and Avoid Oversharding
impact: HIGH
impactDescription: 2-5x better cluster stability and query latency with proper shard sizing
tags: shards, replicas, oversharding, cluster
---

## Right-Size Shards and Avoid Oversharding

Too many small shards waste memory and slow down cluster operations.

**Incorrect (oversharded):**

```json
PUT /logs
{
  "settings": {
    "number_of_shards": 20,
    "number_of_replicas": 2
  }
}
// 10MB per shard on a small dataset — 60 total shards for nothing
```

**Correct (properly sized):**

```json
PUT /logs
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 1
  }
}
```

Shard sizing guidelines:

| Guideline | Value |
|-----------|-------|
| Target shard size | 20-40GB |
| Shards per GB of heap | ~20 |
| Max shards per node | 1000 (default) |
| Time-series strategy | Time-based indices + ILM |
