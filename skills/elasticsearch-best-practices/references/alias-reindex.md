---
title: Use Aliases for Zero-Downtime Reindexing
impact: LOW-MEDIUM
impactDescription: Enables schema changes and index migrations without service interruption
tags: alias, reindex, zero-downtime, migration
---

## Use Aliases for Zero-Downtime Reindexing

Pointing applications directly to index names causes downtime during migrations.

**Incorrect (direct index reference):**

```json
// Application hardcodes "products_v1"
// Migration requires application restart
GET /products_v1/_search
```

**Correct (alias-based access):**

```json
// Create alias
POST _aliases
{
  "actions": [
    { "add": { "index": "products_v1", "alias": "products" } }
  ]
}

// Application uses alias
GET /products/_search

// Zero-downtime migration: atomic swap
POST _aliases
{
  "actions": [
    { "remove": { "index": "products_v1", "alias": "products" } },
    { "add": { "index": "products_v2", "alias": "products" } }
  ]
}
```

**Reindex with transformation:**

```json
POST _reindex
{
  "source": { "index": "products_v1" },
  "dest": { "index": "products_v2" },
  "script": {
    "source": "ctx._source.migrated_at = new Date().toString()"
  }
}
```

Migration workflow:
1. Create new index with updated mapping
2. Reindex data from old to new
3. Atomically swap alias
4. Delete old index after verification
