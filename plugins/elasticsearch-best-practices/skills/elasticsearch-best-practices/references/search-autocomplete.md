---
title: Implement Autocomplete with Completion Suggester
impact: MEDIUM
impactDescription: Sub-millisecond prefix completion for search-as-you-type
tags: autocomplete, completion, suggest, edge-ngram
---

## Implement Autocomplete with Completion Suggester

Custom query-based autocomplete is slow for large datasets.

**Incorrect (prefix query for autocomplete):**

```json
{
  "query": {
    "prefix": {
      "name": "wire"
    }
  }
}
// Scans all terms — slow on large indices
```

**Correct (completion suggester):**

```json
// Mapping
PUT /products
{
  "mappings": {
    "properties": {
      "name": {
        "type": "text",
        "fields": {
          "suggest": { "type": "completion" }
        }
      }
    }
  }
}

// Query suggestions
POST /products/_search
{
  "suggest": {
    "product-suggest": {
      "prefix": "wire",
      "completion": {
        "field": "name.suggest",
        "size": 5
      }
    }
  }
}
```

Autocomplete strategies:

| Method | Speed | Flexibility |
|--------|-------|-------------|
| Completion suggester | Fastest (in-memory FST) | Prefix only |
| Edge n-gram | Fast | Partial matches |
| Search-as-you-type | Fast | Multi-field prefix |
