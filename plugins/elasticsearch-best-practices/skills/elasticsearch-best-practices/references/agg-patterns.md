---
title: Optimize Aggregation Queries
impact: MEDIUM
impactDescription: 2-5x faster aggregations with proper scoping and sizing
tags: aggregations, terms, range, date-histogram, composite
---

## Optimize Aggregation Queries

Poorly scoped aggregations scan entire indices unnecessarily.

**Incorrect (aggregation on full index with results):**

```json
{
  "query": { "match_all": {} },
  "aggs": {
    "categories": {
      "terms": { "field": "category" }
    }
  }
}
// Returns both hits AND aggregations — wastes bandwidth
```

**Correct (aggregation-only with nesting):**

```json
{
  "size": 0,
  "aggs": {
    "categories": {
      "terms": {
        "field": "category",
        "size": 10
      },
      "aggs": {
        "avg_price": {
          "avg": { "field": "price" }
        }
      }
    },
    "price_ranges": {
      "range": {
        "field": "price",
        "ranges": [
          { "to": 100 },
          { "from": 100, "to": 500 },
          { "from": 500 }
        ]
      }
    },
    "monthly_trend": {
      "date_histogram": {
        "field": "created_at",
        "calendar_interval": "month"
      }
    }
  }
}
```

Aggregation best practices:

| Guideline | Reason |
|-----------|--------|
| `size: 0` when only aggregations needed | Skip hit fetching |
| Set `shard_size` on terms aggs | Improve accuracy |
| Use `composite` for agg pagination | Avoid cardinality limits |
| Add `filter` agg to narrow scope | Reduce scanned docs |
