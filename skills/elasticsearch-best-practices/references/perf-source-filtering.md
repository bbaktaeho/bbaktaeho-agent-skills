---
title: Limit _source Fields and Use doc_values
impact: MEDIUM-HIGH
impactDescription: 30-50% reduction in network transfer and memory usage
tags: source-filtering, doc-values, performance
---

## Limit _source Fields and Use doc_values

Returning full documents wastes network bandwidth and memory.

**Incorrect (returning everything):**

```json
{
  "query": { "match": { "name": "laptop" } }
}
// Returns all fields including large description, metadata, etc.
```

**Correct (source filtering):**

```json
{
  "query": { "match": { "name": "laptop" } },
  "_source": ["name", "price", "category"],
  "size": 20
}
```

Performance tips:
- Always limit `_source` to needed fields
- Use `doc_values` for sorting and aggregations (enabled by default on keyword/numeric)
- Pre-sort index for common sort orders
- Set `size` explicitly — default is 10 but be intentional
