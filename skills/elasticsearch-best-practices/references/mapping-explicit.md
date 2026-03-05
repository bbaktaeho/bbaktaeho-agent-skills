---
title: Define Explicit Mappings
impact: CRITICAL
impactDescription: Prevents unexpected field types and reduces mapping conflicts
tags: mapping, field-types, dynamic-mapping
---

## Define Explicit Mappings

Relying on dynamic mapping causes unpredictable field types and wastes resources.

**Incorrect (dynamic mapping):**

```json
// No explicit mapping — Elasticsearch guesses types
POST /products/_doc/1
{
  "name": "Laptop",
  "price": "99.99",
  "created_at": "2024-01-15"
}
// "price" mapped as text, not numeric
// "created_at" may not parse correctly
```

**Correct (explicit mapping):**

```json
PUT /products
{
  "mappings": {
    "properties": {
      "product_id": { "type": "keyword" },
      "name": {
        "type": "text",
        "analyzer": "standard",
        "fields": {
          "keyword": { "type": "keyword", "ignore_above": 256 }
        }
      },
      "description": { "type": "text", "analyzer": "english" },
      "price": { "type": "scaled_float", "scaling_factor": 100 },
      "category": { "type": "keyword" },
      "tags": { "type": "keyword" },
      "created_at": { "type": "date" },
      "metadata": { "type": "object", "enabled": false },
      "location": { "type": "geo_point" }
    }
  }
}
```

Field type selection:

| Type | Use Case |
|------|----------|
| `keyword` | Exact values, filtering, aggregations, sorting |
| `text` | Full-text search with analysis |
| `date` | Date/time values with format specification |
| `scaled_float` | Decimal values with fixed precision |
| `boolean` | True/false values |
| `geo_point` | Latitude/longitude pairs |
| `nested` | Arrays of objects needing independent querying |
| `object` with `enabled: false` | Store-only, no indexing needed |

Disable indexing for fields you do not search on to save disk and memory.
