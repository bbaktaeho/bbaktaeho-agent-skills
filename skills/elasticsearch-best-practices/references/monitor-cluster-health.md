---
title: Monitor Cluster Health and Diagnose Issues
impact: LOW-MEDIUM
impactDescription: Early detection of cluster problems prevents outages
tags: cluster-health, cat-api, stats, slow-log
---

## Monitor Cluster Health and Diagnose Issues

Ignoring cluster health leads to undetected shard failures and performance degradation.

**Essential monitoring commands:**

```
GET _cluster/health
GET _cat/indices?v
GET _cat/shards?v
GET _nodes/stats
```

**Index maintenance:**

```
POST /products/_forcemerge?max_num_segments=1
POST /products/_cache/clear
POST /products/_refresh
```

**Slow query log:**

```json
PUT /products/_settings
{
  "index.search.slowlog.threshold.query.warn": "10s",
  "index.search.slowlog.threshold.query.info": "5s",
  "index.search.slowlog.threshold.fetch.warn": "1s"
}
```

Cluster health status:

| Status | Meaning | Action |
|--------|---------|--------|
| Green | All shards assigned | Normal |
| Yellow | Replicas unassigned | Add nodes or reduce replicas |
| Red | Primary shards unassigned | Immediate investigation required |
