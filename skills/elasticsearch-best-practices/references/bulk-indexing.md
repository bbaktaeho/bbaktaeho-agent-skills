---
title: Use Bulk API for Batch Operations
impact: HIGH
impactDescription: 5-10x faster indexing throughput compared to single-document operations
tags: bulk, batch, indexing, throughput
---

## Use Bulk API for Batch Operations

Single-document indexing creates excessive network overhead and poor throughput.

**Incorrect (single document indexing in a loop):**

```json
POST /products/_doc/1
{ "name": "Product 1", "price": 99.99 }

POST /products/_doc/2
{ "name": "Product 2", "price": 149.99 }

// N network round trips for N documents
```

**Correct (bulk API):**

```json
POST _bulk
{ "index": { "_index": "products", "_id": "1" } }
{ "name": "Product 1", "price": 99.99 }
{ "index": { "_index": "products", "_id": "2" } }
{ "name": "Product 2", "price": 149.99 }
```

For maximum throughput during bulk loading:

```json
// Disable refresh before bulk
PUT /products/_settings
{ "refresh_interval": "-1" }

// ... bulk indexing ...

// Re-enable refresh after bulk
PUT /products/_settings
{ "refresh_interval": "1s" }

POST /products/_refresh
```

Bulk API guidelines:

| Guideline | Value |
|-----------|-------|
| Optimal bulk size | 5-15MB per request |
| Documents per batch | 1000-5000 |
| Disable refresh during bulk | `refresh_interval: -1` |
| Monitor for | Rejected requests (queue full) |
