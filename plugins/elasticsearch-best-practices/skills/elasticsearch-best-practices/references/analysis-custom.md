---
title: Build Custom Analyzers for Domain-Specific Search
impact: HIGH
impactDescription: 2-5x better search relevance with domain-tuned analysis chains
tags: analyzer, tokenizer, filter, stemmer, stopwords
---

## Build Custom Analyzers for Domain-Specific Search

Default analyzers miss domain-specific requirements like synonyms and stemming.

**Incorrect (default analyzer for product search):**

```json
PUT /products
{
  "mappings": {
    "properties": {
      "name": { "type": "text" }
    }
  }
}
// "running shoes" won't match "run shoe"
// "laptop" won't match "notebook"
```

**Correct (custom analyzer with stemming and synonyms):**

```json
PUT /products
{
  "settings": {
    "analysis": {
      "analyzer": {
        "product_analyzer": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": [
            "lowercase",
            "asciifolding",
            "english_stop",
            "english_stemmer"
          ]
        },
        "autocomplete_analyzer": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "edge_ngram_filter"]
        }
      },
      "filter": {
        "english_stop": { "type": "stop", "stopwords": "_english_" },
        "english_stemmer": { "type": "stemmer", "language": "english" },
        "edge_ngram_filter": {
          "type": "edge_ngram",
          "min_gram": 2,
          "max_gram": 15
        }
      }
    }
  }
}
```

Test analyzers before deploying:

```json
POST /products/_analyze
{
  "analyzer": "product_analyzer",
  "text": "Wireless Bluetooth Headphones"
}
```

Common filter chain:

| Filter | Purpose |
|--------|---------|
| `lowercase` | Case-insensitive matching |
| `asciifolding` | Accent-insensitive (café → cafe) |
| `stop` | Remove common words (the, is, at) |
| `stemmer` | Reduce to root form (running → run) |
| `synonym` | Expand synonyms (laptop → notebook) |
| `edge_ngram` | Prefix matching for autocomplete |
