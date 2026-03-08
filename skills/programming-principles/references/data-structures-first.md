---
title: Design Data Structures First, Algorithms Follow
impact: HIGH
impactDescription: Produces cleaner architecture where algorithms emerge naturally from well-organized data
tags: data-structures, architecture, design, brooks, pike-rule-5
---

# Rule 5: Data dominates

> "Data dominates. If you've chosen the right data structures and organized things well, the algorithms will almost always be self-evident. Data structures, not algorithms, are central to programming." -- Rob Pike

Fred Brooks stated this earlier in The Mythical Man-Month:

> "Show me your flowcharts and conceal your tables, and I shall continue to be mystified. Show me your tables, and I won't usually need your flowcharts; they'll be obvious."

This is often shortened to:

> "Write stupid code that uses smart objects."

## Why It Matters

When data is well-structured, operations on it become straightforward. Complex algorithms are often a symptom of poorly organized data. Investing time in data structure design pays off by:
- Making algorithms obvious and simple
- Reducing code complexity
- Making the system easier to extend
- Reducing bugs (see Rule 4)

## Incorrect Approach

Complex algorithm compensating for poor data structure:

```go
// Flat list of permissions, complex algorithm to check access
type Permission struct {
    UserID     int
    Resource   string
    Action     string
    Conditions []string
    Priority   int
    Deny       bool
}

func canAccess(perms []Permission, userID int, resource, action string) bool {
    // Sort by priority, check deny rules first, evaluate conditions,
    // handle wildcards, merge overlapping rules...
    sort.Slice(perms, func(i, j int) bool {
        return perms[i].Priority > perms[j].Priority
    })
    for _, p := range perms {
        if p.UserID != userID {
            continue
        }
        if matchResource(p.Resource, resource) {
            if p.Deny {
                return false
            }
            if matchAction(p.Action, action) {
                if evaluateConditions(p.Conditions) {
                    return true
                }
            }
        }
    }
    return false
}
```

The algorithm is complex because the data structure is flat and unorganized.

## Correct Approach

Design the data structure so the algorithm becomes trivial:

```go
// Hierarchical structure makes access checks obvious
type AccessPolicy struct {
    Allowed map[string]ActionSet // resource -> allowed actions
    Denied  map[string]ActionSet // resource -> denied actions
}

type UserAccess struct {
    policies map[int]*AccessPolicy // userID -> policy
}

func (ua *UserAccess) CanAccess(userID int, resource, action string) bool {
    policy, ok := ua.policies[userID]
    if !ok {
        return false
    }
    if policy.Denied[resource].Contains(action) {
        return false
    }
    return policy.Allowed[resource].Contains(action)
}
```

The right data structure (pre-organized by user, separated allow/deny, action sets) makes the algorithm a simple map lookup. No sorting, no scanning, no complex conditions.

## Key Takeaway

When facing a complex algorithm, ask: "Is the data structured correctly?" Reorganize data before writing clever code. The best algorithms are the ones you don't need to write because the data structure makes the answer obvious.
