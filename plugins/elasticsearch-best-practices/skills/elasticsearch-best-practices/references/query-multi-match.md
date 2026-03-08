---
title: Optimize Multi-Field Search with Field Boosting
impact: CRITICAL
impactDescription: Improved relevance ranking by weighting important fields higher
tags: multi-match, boosting, relevance, full-text
---

## Optimize Multi-Field Search with Field Boosting

Searching across multiple fields without boosting produces poor relevance.

**Incorrect (no field boosting):**

```json
{
  "query": {
    "multi_match": {
      "query": "wireless headphones",
      "fields": ["name", "description", "tags"]
    }
  }
}
// All fields weighted equally — title matches rank same as description
```

**Correct (field boosting with source filtering):**

```json
{
  "query": {
    "bool": {
      "must": {
        "multi_match": {
          "query": "wireless headphones",
          "fields": ["name^3", "tags^2", "description"],
          "type": "best_fields",
          "fuzziness": "AUTO"
        }
      },
      "filter": [
        { "term": { "active": true } },
        { "range": { "created_at": { "gte": "now-30d" } } }
      ]
    }
  },
  "size": 20,
  "from": 0,
  "_source": ["name", "price", "category"]
}
```

Best practices:
- Boost title/name fields higher (`^3`)
- Use `best_fields` type for distinct fields
- Use `cross_fields` when fields represent a single concept
- Always limit `_source` to needed fields
- Combine with `filter` for non-scoring constraints
