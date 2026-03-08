---
title: Use Index Lifecycle Management for Time-Series Data
impact: HIGH
impactDescription: Automates rollover, shrink, and deletion to reduce operational burden
tags: ilm, rollover, time-series, hot-warm-delete
---

## Use Index Lifecycle Management for Time-Series Data

Manually managing time-series indices leads to oversized indices and wasted storage.

**Incorrect (manual management):**

```json
// Creating indices manually, forgetting to delete old ones
PUT /logs-2024-01
PUT /logs-2024-02
// Old indices accumulate, consuming disk and memory
```

**Correct (ILM policy):**

```json
PUT _ilm/policy/logs_policy
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "actions": {
          "rollover": {
            "max_size": "50gb",
            "max_age": "7d"
          }
        }
      },
      "warm": {
        "min_age": "30d",
        "actions": {
          "shrink": { "number_of_shards": 1 },
          "forcemerge": { "max_num_segments": 1 }
        }
      },
      "delete": {
        "min_age": "90d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```

ILM phases:

| Phase | Purpose | Typical Actions |
|-------|---------|-----------------|
| Hot | Active writes and search | Rollover on size/age |
| Warm | Read-only, less frequent search | Shrink, force merge |
| Cold | Rare access, compliance | Freeze, searchable snapshots |
| Delete | Expired data | Delete index |
