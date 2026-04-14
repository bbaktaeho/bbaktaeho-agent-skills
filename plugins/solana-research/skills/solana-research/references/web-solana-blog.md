---
title: Solana and Anza Blog Navigation Guide
impact: HIGH
impactDescription: Official announcements and engineering deep-dives on Solana protocol changes
tags: solana, anza, blog, announcements, engineering
---

# Solana and Anza Blog Navigation Guide

Two primary blog sources cover Solana protocol and engineering topics:

1. **Solana Blog** (`solana.com/news`) -- Official Solana Foundation announcements, protocol upgrades, ecosystem news, and technical deep-dives.
2. **Anza Blog** (`anza.xyz/blog`) -- Engineering-focused posts from the Anza team covering agave validator development, SIMD implementations, performance work, and infrastructure.

## Solana Blog

URL: `https://solana.com/news`

### Search Strategies

Use WebSearch with site restriction:

```
site:solana.com/news firedancer
site:solana.com/news local fee markets
site:solana.com/news agave validator upgrade
site:solana.com/news turbine shred propagation
```

Or use WebFetch to retrieve the news listing:

```
https://solana.com/news
```

### Coverage Areas

| Topic | What to expect |
|-------|----------------|
| Protocol upgrades | Mainnet cluster upgrade announcements, feature activation |
| Performance milestones | TPS records, hardware improvements, latency improvements |
| Ecosystem news | dApp launches, developer tooling, grant programs |
| Technical deep-dives | Architectural explanations targeting developers |

### Fetching Specific Articles

Once you identify an article slug from search results, fetch:

```
https://solana.com/news/{article-slug}
```

## Anza Blog

URL: `https://www.anza.xyz/blog`

### Search Strategies

Use WebSearch with site restriction:

```
site:anza.xyz/blog unified scheduler
site:anza.xyz/blog agave release
site:anza.xyz/blog accounts-db tiered storage
site:anza.xyz/blog SIMD implementation
```

Or fetch the blog listing directly:

```
https://www.anza.xyz/blog
```

### Coverage Areas

| Topic | What to expect |
|-------|----------------|
| Agave releases | Release notes, breaking changes, migration guidance |
| SIMD implementations | Engineering details on accepted SIMD features |
| Performance engineering | Profiling results, optimization write-ups |
| Validator operations | Node configuration, stake delegation, monitoring |
| SVM development | Transaction processor improvements, SVM isolation |

### Fetching Specific Articles

Once you identify an article slug from search results, fetch:

```
https://www.anza.xyz/blog/{article-slug}
```

## SIMD Repository

URL: `https://github.com/solana-foundation/solana-improvement-documents`

SIMDs are Solana's equivalent of EIPs. Each SIMD is a Markdown file in the `proposals/` directory.

Fetch a specific SIMD:

```
https://raw.githubusercontent.com/solana-foundation/solana-improvement-documents/main/proposals/XXXX.md
```

List all proposals:

```
https://github.com/solana-foundation/solana-improvement-documents/tree/main/proposals
```

Use WebSearch to find SIMDs by topic:

```
site:github.com/solana-foundation/solana-improvement-documents local fee markets
site:github.com/solana-foundation/solana-improvement-documents compute budget
```

## Citation Format

When citing blog posts in research output:

```
Author, "Post Title," solana.com/news, Month Year. URL: https://solana.com/news/{slug}
Author, "Post Title," anza.xyz/blog, Month Year. URL: https://www.anza.xyz/blog/{slug}
```

When citing SIMDs:

```
"SIMD-XXXX: Title," solana-foundation/solana-improvement-documents, Month Year.
URL: https://github.com/solana-foundation/solana-improvement-documents/blob/main/proposals/XXXX.md
```
