---
title: Configure Index and Field Level Security
impact: LOW-MEDIUM
impactDescription: Prevents unauthorized data access with granular permissions
tags: security, roles, field-level, index-level
---

## Configure Index and Field Level Security

Missing security configuration exposes all data to all users.

**Index-level security:**

```json
PUT _security/role/products_reader
{
  "indices": [
    {
      "names": ["products*"],
      "privileges": ["read"]
    }
  ]
}
```

**Field-level security:**

```json
PUT _security/role/limited_access
{
  "indices": [
    {
      "names": ["users"],
      "privileges": ["read"],
      "field_security": {
        "grant": ["name", "email", "created_at"]
      }
    }
  ]
}
```

Security model:

| Level | Scope | Example |
|-------|-------|---------|
| Cluster | Cluster-wide operations | `monitor`, `manage` |
| Index | Per-index operations | `read`, `write`, `manage` |
| Field | Per-field visibility | `grant` / `except` lists |
| Document | Row-level filtering | DLS queries |
