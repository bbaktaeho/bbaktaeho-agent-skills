---
name: elasticsearch-best-practices
description: Elasticsearch best practices covering mapping, query DSL, index settings, bulk indexing, analyzers, shard sizing, aggregations, pagination, ILM, aliases, and cluster monitoring. Use this skill whenever designing or changing Elasticsearch index mappings, writing or tuning search/aggregation queries, configuring analyzers or tokenizers, planning shards and replicas, building bulk indexing pipelines, setting up autocomplete or highlighting, implementing reindex/ILM, or diagnosing cluster and query performance issues.
license: MIT
metadata:
  author: bbaktaeho
  version: "1.0.0"
  date: March 2026
  abstract: Comprehensive Elasticsearch best practices guide covering index design, query optimization, and cluster management across 11 categories, prioritized by impact from critical (mapping, query optimization) to low-medium (monitoring, aliases). Each rule includes detailed explanations, incorrect vs. correct JSON examples, and specific performance guidance.
---

# Elasticsearch Best Practices

Comprehensive Elasticsearch development guide. Contains rules across 11 categories, prioritized by impact to guide automated index design, query optimization, and cluster management.

## When to Apply

Reference these guidelines when:
- Designing index mappings or settings
- Writing search queries or aggregations
- Optimizing query performance
- Configuring analyzers or tokenizers
- Managing shard sizing or cluster scaling
- Implementing bulk indexing pipelines
- Setting up autocomplete or suggestions
- Configuring security and access control
- Monitoring cluster health

## Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Mapping & Field Types | CRITICAL | `mapping-` |
| 2 | Query Optimization | CRITICAL | `query-` |
| 3 | Index Settings & Sharding | HIGH | `index-` |
| 4 | Indexing & Bulk Operations | HIGH | `bulk-` |
| 5 | Analysis & Tokenization | HIGH | `analysis-` |
| 6 | Performance Optimization | MEDIUM-HIGH | `perf-` |
| 7 | Search Features | MEDIUM | `search-` |
| 8 | Aggregations | MEDIUM | `agg-` |
| 9 | Monitoring & Maintenance | LOW-MEDIUM | `monitor-` |
| 10 | Security | LOW-MEDIUM | `security-` |
| 11 | Aliases & Reindexing | LOW-MEDIUM | `alias-` |

## How to Use

Read individual rule files for detailed explanations and JSON examples:

```
references/_sections.md                     # Section definitions

references/mapping-explicit.md              # Explicit mapping, field types
references/mapping-storage-optimization.md  # index, doc_values, _source tuning

references/query-bool-filter.md             # Filter context caching
references/query-term-vs-match.md           # Query type vs field type
references/query-multi-match.md             # Multi-field search and boosting

references/index-settings.md                # refresh_interval, translog, merge
references/index-shard-sizing.md            # Shard sizing and oversharding
references/index-lifecycle.md               # ILM for time-series data

references/bulk-indexing.md                 # Bulk API throughput
references/bulk-updates.md                  # Partial updates, update-by-query

references/analysis-custom.md               # Custom analyzers and tokenizers

references/perf-segment-merge.md            # Segment merge and force-merge
references/perf-pagination.md               # search_after vs from/size
references/perf-source-filtering.md         # _source filtering, doc_values

references/search-autocomplete.md           # Completion suggester
references/search-highlighting.md           # Result highlighting

references/agg-patterns.md                  # Aggregation scoping and sizing

references/monitor-cluster-health.md        # cat API, stats, slow log
references/security-roles.md                # Index/field-level security
references/alias-reindex.md                 # Aliases and zero-downtime reindex
```

Each rule file contains:
- Brief explanation of why it matters
- Incorrect JSON example with explanation
- Correct JSON example with explanation
- Additional context and performance notes

## References

- https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html
- https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html
