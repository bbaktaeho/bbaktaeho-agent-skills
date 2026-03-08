---
title: Use Filter Context for Non-Scoring Queries
impact: CRITICAL
impactDescription: 2-10x faster queries via automatic caching of filter clauses
tags: bool-query, filter, scoring, cache
---

## Use Filter Context for Non-Scoring Queries

Queries in `filter` context skip scoring and are cached automatically.

**Incorrect (everything in must):**

```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "name": "laptop" } },
        { "term": { "category": "electronics" } },
        { "range": { "price": { "gte": 500, "lte": 2000 } } },
        { "term": { "status": "active" } }
      ]
    }
  }
}
// All clauses computed for scoring — slow and uncacheable
```

**Correct (scoring vs filtering separated):**

```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "name": "laptop" } }
      ],
      "filter": [
        { "term": { "category": "electronics" } },
        { "range": { "price": { "gte": 500, "lte": 2000 } } }
      ],
      "should": [
        { "term": { "brand": "apple" } }
      ],
      "must_not": [
        { "term": { "status": "discontinued" } }
      ]
    }
  }
}
```

Bool query clause purposes:

| Clause | Scoring | Cached | Use For |
|--------|---------|--------|---------|
| `must` | Yes | No | Full-text search, relevance |
| `filter` | No | Yes | Exact matches, ranges, status |
| `should` | Yes | No | Optional boosting |
| `must_not` | No | Yes | Exclusion |
