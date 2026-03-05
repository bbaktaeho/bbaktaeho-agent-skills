---
title: Use Partial Updates and Update-by-Query Efficiently
impact: HIGH
impactDescription: Reduces reindexing overhead for field-level changes
tags: update, update-by-query, partial, script
---

## Use Partial Updates and Update-by-Query Efficiently

Full document reindexing for single field changes wastes resources.

**Incorrect (full reindex for one field change):**

```json
PUT /products/_doc/1
{
  "name": "Product 1",
  "description": "...",
  "category": "electronics",
  "tags": ["sale"],
  "price": 89.99,
  "updated_at": "2024-01-15T10:30:00Z"
}
// Rewrites entire document just to change price
```

**Correct (partial update):**

```json
POST /products/_update/1
{
  "doc": {
    "price": 89.99,
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

**Correct (update by query for batch changes):**

```json
POST /products/_update_by_query
{
  "query": {
    "term": { "category": "electronics" }
  },
  "script": {
    "source": "ctx._source.on_sale = true"
  }
}
```

Choose the right update method:

| Method | Use Case |
|--------|----------|
| `_update` (doc) | Single document, known fields |
| `_update` (script) | Conditional or computed updates |
| `_update_by_query` | Batch updates matching a query |
| `_reindex` | Schema changes or index migration |
