---
title: forum.solana.com Navigation Guide
impact: HIGH
impactDescription: Community research forum navigation for Solana protocol discussions
tags: forum, solana, community, research, simd
---

# forum.solana.com Navigation Guide

forum.solana.com is the Discourse-based Solana developer and research forum where validators, core developers, and community members discuss protocol proposals, SIMD implementations, validator operations, and ecosystem topics. It is the primary venue for SIMD pre-discussions, validator coordination, and protocol research sharing in the Solana ecosystem.

## URL Patterns

- Main page: `https://forum.solana.com/`
- Category listing: `https://forum.solana.com/c/{category-slug}/{id}`
- Topic thread: `https://forum.solana.com/t/{topic-slug}/{id}`
- Search: `https://forum.solana.com/search?q={query}`

## Key Categories

| Category | Description |
|----------|-------------|
| Protocol | Core protocol changes, SIMD discussions, consensus |
| Validator | Validator operations, staking, performance |
| Development | SDK, program development, tooling |
| Economics | Fee markets, MEV, staking rewards |
| Governance | Foundation proposals, community decisions |

## Search Strategies

### Using WebSearch

Use the `site:forum.solana.com` operator to restrict results to the forum:

```
site:forum.solana.com SIMD-83 unified scheduler
site:forum.solana.com local fee markets priority fees
site:forum.solana.com turbine shred propagation
site:forum.solana.com Tower BFT fork choice
```

### Using WebFetch on Search URLs

Fetch the search URL directly to retrieve the Discourse JSON response:

```
https://forum.solana.com/search?q=compute+budget
https://forum.solana.com/search?q=accounts+compression
```

Discourse search returns topic titles, authors, and excerpt snippets that can guide further fetches.

### Fetching a Specific Topic

Once you identify a topic ID, fetch the full thread:

```
https://forum.solana.com/t/{topic-slug}/{id}
```

Discourse renders the full post content in the HTML body. Read the opening post and top replies for the core argument.

## SIMD Discussion Threads

SIMDs (Solana Improvement Documents) typically have corresponding discussion threads on the forum. To find them:

```
site:forum.solana.com SIMD-{number}
```

Or search the SIMD repository directly for the linked discussion:

```
https://github.com/solana-foundation/solana-improvement-documents/blob/main/proposals/
```

Each SIMD document often links back to a forum discussion thread in its header.

## Extracting Useful Information from Threads

1. Opening post: Contains the main proposal or research question. Read first.
2. Author metadata: Author name and post date appear near the top. Note them for citation.
3. Replies: Discourse threads often contain critical refinements, objections, and counter-proposals. Scan reply authors for known engineers (trent.solana, anatoly, brooksprumo, etc.).
4. Linked posts: Threads frequently cross-link to related discussions.
5. Last activity date: Check the topic's last reply date to assess currency.

## Citation Format

When citing a forum post in research output:

```
Author, "Post Title," forum.solana.com, Month Year. URL: https://forum.solana.com/t/{slug}/{id}
```
