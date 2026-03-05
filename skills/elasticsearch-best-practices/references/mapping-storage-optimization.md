---
title: Optimize Field Storage with index, doc_values, and _source
impact: CRITICAL
impactDescription: 30-70% disk savings by disabling unused field features
tags: mapping, index, doc-values, source, storage, disk
---

## Optimize Field Storage with index, doc_values, and _source

Storing all field features by default wastes disk and memory on unused capabilities.

**Incorrect (all features enabled on every field):**

```json
PUT /logs
{
  "mappings": {
    "properties": {
      "trace_id": { "type": "keyword" },
      "message": { "type": "text" },
      "raw_payload": { "type": "text" },
      "metric_value": { "type": "float" },
      "debug_info": { "type": "object" }
    }
  }
}
// Every field indexed + doc_values + stored in _source — massive disk waste
```

**Correct (each field tuned to its access pattern):**

```json
PUT /logs
{
  "mappings": {
    "_source": { "enabled": true },
    "properties": {
      "trace_id": {
        "type": "keyword"
      },
      "message": {
        "type": "text",
        "index": true,
        "doc_values": false
      },
      "raw_payload": {
        "type": "text",
        "index": false,
        "doc_values": false
      },
      "metric_value": {
        "type": "float",
        "index": false,
        "doc_values": true
      },
      "debug_info": {
        "type": "object",
        "enabled": false
      }
    }
  }
}
```

### Field Feature Decision Matrix

| Access Pattern | `index` | `doc_values` | Example |
|----------------|---------|-------------|---------|
| Search + sort/agg | true | true | `trace_id` (keyword) |
| Search only | true | false | `message` (text) |
| Sort/agg only | false | true | `metric_value` |
| Store only (no search/agg) | false | false | `raw_payload` |
| Don't parse at all | `enabled: false` | — | `debug_info` (object) |

### _source Optimization

`_source`에는 원본 JSON 문서가 저장됩니다. document_id만 필요하고 원본 JSON이 불필요한 경우 비활성화할 수 있습니다.

**_source 비활성화 (document_id만 필요한 경우):**

```json
PUT /document_index
{
  "mappings": {
    "_source": { "enabled": false },
    "properties": {
      "user_id": { "type": "keyword" },
      "category": { "type": "keyword" },
      "score": { "type": "float", "index": false, "doc_values": true }
    }
  }
}
// Search returns _id only — no _source in response
// Aggregations still work via doc_values
```

**Synthetic _source (Elasticsearch 8.4+):**

```json
PUT /logs
{
  "mappings": {
    "_source": { "mode": "synthetic" }
  }
}
// Reconstructs _source from doc_values on retrieval
// Saves disk space, slower fetch, minor field ordering differences
```

### _source 비활성화 시 주의사항

| 기능 | _source 비활성화 시 |
|------|---------------------|
| `update` / `update_by_query` | 사용 불가 |
| `reindex` | 사용 불가 |
| Highlighting | 사용 불가 |
| `_source` filtering | 사용 불가 |
| Get/Search `_source` | 반환 없음 (_id만) |
| Aggregations (doc_values) | 정상 동작 |

_source를 비활성화하기 전에 reindex, update, highlight가 필요한지 반드시 확인하세요.

Reference: [_source field](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-source-field.html), [Tune for disk usage](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-disk-usage.html)
