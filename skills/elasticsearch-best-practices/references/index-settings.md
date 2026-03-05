---
title: Configure Index Settings for Performance
impact: HIGH
impactDescription: 30-50% indexing throughput improvement with proper refresh and merge settings
tags: refresh-interval, settings, merge, translog
---

## Configure Index Settings for Performance

Default settings are generic; tune them for your workload.

**Incorrect (defaults for high-throughput indexing):**

```json
PUT /products
{
  "settings": {
    "number_of_shards": 1
  }
}
// Default refresh_interval=1s causes excessive refreshes during bulk indexing
```

**Correct (tuned for workload):**

```json
PUT /products
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 1,
    "refresh_interval": "30s",
    "analysis": {
      "analyzer": {
        "custom_analyzer": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "asciifolding", "synonym_filter"]
        }
      },
      "filter": {
        "synonym_filter": {
          "type": "synonym",
          "synonyms": ["laptop, notebook", "phone, mobile, smartphone"]
        }
      }
    }
  }
}
```

Key settings:

| Setting | Default | Recommendation |
|---------|---------|----------------|
| `refresh_interval` | 1s | 30s for write-heavy, 1s for near-realtime |
| `number_of_replicas` | 1 | 0 during bulk load, 1+ for production |
| `translog.durability` | request | async for throughput (risk: small data loss) |
