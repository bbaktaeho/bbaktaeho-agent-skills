---
title: Use Correct Query Type for Field Type
impact: CRITICAL
impactDescription: Prevents zero-result queries caused by analyzing keyword fields
tags: term, match, keyword, text, query-type
---

## Use Correct Query Type for Field Type

Using `match` on keyword fields or `term` on text fields produces unexpected results.

**Incorrect (term on text field):**

```json
{
  "query": {
    "term": {
      "description": "Wireless Bluetooth Headphones"
    }
  }
}
// Returns nothing — text field is analyzed (lowercased, tokenized)
// but term query does exact match against "Wireless Bluetooth Headphones"
```

**Incorrect (match on keyword field):**

```json
{
  "query": {
    "match": {
      "status": "active"
    }
  }
}
// Works but wastefully runs analysis on a keyword field
```

**Correct:**

```json
// Full-text search → match query on text fields
{
  "query": {
    "match": {
      "description": {
        "query": "wireless bluetooth headphones",
        "operator": "and",
        "fuzziness": "AUTO"
      }
    }
  }
}

// Exact match → term query on keyword fields
{
  "query": {
    "term": {
      "status": "active"
    }
  }
}
```

| Field Type | Query Type | Purpose |
|------------|-----------|---------|
| `text` | `match`, `multi_match` | Full-text search (analyzed) |
| `keyword` | `term`, `terms` | Exact match (not analyzed) |
| `date`, numeric | `range` | Range filtering |
| `text.keyword` | `term` | Exact match on multi-field |
