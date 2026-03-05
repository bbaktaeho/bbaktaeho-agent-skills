---
name: elasticsearch-best-practices
description: Elasticsearch development best practices for indexing, querying, mapping, and search optimization. Use this skill when designing indices, writing queries, configuring analyzers, or optimizing Elasticsearch cluster performance.
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
references/mapping-explicit.md              # Explicit mapping, field types
references/mapping-storage-optimization.md  # index, doc_values, _source tuning
references/query-bool-filter.md             # Filter context caching
references/query-term-vs-match.md           # Query type vs field type
references/index-shard-sizing.md            # Shard sizing guidelines
references/bulk-indexing.md                 # Bulk API throughput
references/analysis-custom.md              # Custom analyzers
references/perf-segment-merge.md           # Segment merge optimization
references/perf-pagination.md              # search_after pagination
references/_sections.md                    # Section definitions
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
