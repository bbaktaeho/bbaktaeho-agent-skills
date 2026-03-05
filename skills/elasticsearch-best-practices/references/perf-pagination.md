---
title: Use search_after Instead of Deep Pagination
impact: MEDIUM-HIGH
impactDescription: Prevents OOM errors and timeouts on large result sets
tags: pagination, search-after, deep-pagination, from-size
---

## Use search_after Instead of Deep Pagination

`from` + `size` becomes exponentially slower as offset grows.

**Incorrect (deep pagination with from/size):**

```json
{
  "query": { "match_all": {} },
  "size": 20,
  "from": 10000
}
// Elasticsearch fetches and discards 10000 docs — OOM risk
// Default max: from + size <= 10000
```

**Correct (search_after for efficient pagination):**

```json
// First page
{
  "query": { "match_all": {} },
  "size": 20,
  "sort": [
    { "created_at": "desc" },
    { "_id": "asc" }
  ]
}

// Next page — use sort values from last result
{
  "query": { "match_all": {} },
  "size": 20,
  "search_after": [1705329600000, "product_123"],
  "sort": [
    { "created_at": "desc" },
    { "_id": "asc" }
  ]
}
```

Pagination strategies:

| Method | Max Depth | Use Case |
|--------|-----------|----------|
| `from` + `size` | 10,000 | Small datasets, UI pages 1-50 |
| `search_after` | Unlimited | Large datasets, infinite scroll |
| Scroll API | Unlimited | Bulk export (not for real-time) |
