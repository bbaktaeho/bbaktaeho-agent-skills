---
title: Use Highlighting for Search Result Snippets
impact: MEDIUM
impactDescription: Improves user experience by showing matched terms in context
tags: highlighting, snippets, search-results
---

## Use Highlighting for Search Result Snippets

Returning raw text without highlighting makes it hard to see why a result matched.

**Correct (highlighting with configuration):**

```json
{
  "query": {
    "match": { "description": "wireless bluetooth" }
  },
  "highlight": {
    "fields": {
      "description": {
        "pre_tags": ["<em>"],
        "post_tags": ["</em>"],
        "fragment_size": 150,
        "number_of_fragments": 3
      }
    }
  },
  "_source": ["name", "price"]
}
```

Highlighter types:

| Type | Speed | Accuracy | Use Case |
|------|-------|----------|----------|
| `unified` (default) | Fast | Good | General purpose |
| `plain` | Slow | Exact | Small fields |
| `fvh` | Fastest | Good | Large fields (requires `term_vector`) |
