---
title: Optimize Segment Merging for Search Performance
impact: MEDIUM-HIGH
impactDescription: 2-10x search speed improvement by reducing segment count on read-only indices
tags: segment, merge, force-merge, lucene, read-only
---

## Optimize Segment Merging for Search Performance

Elasticsearch stores data in immutable Lucene segments. Too many small segments degrade search performance because each query must check every segment.

### Segment Lifecycle

```
Write → New segment created (in-memory buffer → disk)
Delete → Soft-delete marker (not actually removed)
Merge  → Background process combines small segments, purges deletes
```

### 문제: 과도한 세그먼트

```
GET /products/_segments

// 결과: 수십~수백 개의 작은 세그먼트
// 각 검색 쿼리가 모든 세그먼트를 순회 → 느림
```

### Force Merge on Read-Only Indices

**읽기 전용 인덱스에서만** force merge를 사용하세요.

**Incorrect (활성 인덱스에서 force merge):**

```json
// 아직 쓰기가 진행 중인 인덱스에 force merge
POST /active-logs/_forcemerge?max_num_segments=1
// 거대한 세그먼트 생성 → soft-delete 누적 → 디스크 사용량 증가
// 일반 merge에 의해 처리되지 않음 (>5GB 세그먼트)
// 스냅샷 비용 증가
```

**Correct (읽기 전용 인덱스에서 force merge):**

```json
// Step 1: 인덱스를 읽기 전용으로 설정
PUT /logs-2024-01/_settings
{
  "index.blocks.write": true
}

// Step 2: Force merge (1 segment = 최적 검색 성능)
POST /logs-2024-01/_forcemerge?max_num_segments=1

// Step 3: 세그먼트 수 확인
GET /logs-2024-01/_segments
```

### Merge Policy 튜닝

백그라운드 자동 머지 동작을 조정합니다.

```json
PUT /products/_settings
{
  "index.merge.policy.max_merge_at_once": 10,
  "index.merge.policy.max_merged_segment": "5gb",
  "index.merge.policy.segments_per_tier": 10,
  "index.merge.scheduler.max_thread_count": 1
}
```

| Setting | Default | Description |
|---------|---------|-------------|
| `max_merge_at_once` | 10 | 한 번에 합칠 최대 세그먼트 수 |
| `max_merged_segment` | 5gb | 머지 결과 세그먼트 최대 크기 |
| `segments_per_tier` | 10 | tier당 허용 세그먼트 수 (낮을수록 자주 머지) |
| `max_thread_count` | 1 (spinning disk) | 머지 스레드 수 (SSD: `Math.max(1, cores/2)`) |

### ILM과 연계

ILM의 warm phase에서 자동으로 force merge를 수행하면 수동 관리가 불필요합니다.

```json
PUT _ilm/policy/optimized_policy
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": { "max_size": "50gb", "max_age": "7d" }
        }
      },
      "warm": {
        "min_age": "30d",
        "actions": {
          "shrink": { "number_of_shards": 1 },
          "forcemerge": { "max_num_segments": 1 },
          "readonly": {}
        }
      }
    }
  }
}
```

### 세그먼트 모니터링

```
GET _cat/segments/products?v&s=size:desc
GET _cat/indices/products?v&h=index,docs.count,store.size,pri.segments.count
```

| Metric | 건강한 상태 | 문제 |
|--------|-------------|------|
| Segments per shard | 5-20 | 100+ (검색 느림) |
| Deleted docs ratio | < 10% | > 30% (디스크 낭비) |
| Max segment size | < 5GB (active) | > 5GB on active index |

Reference: [Force merge API](https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-forcemerge.html), [Merge process](https://www.elastic.co/guide/en/elasticsearch/guide/current/merge-process.html)
