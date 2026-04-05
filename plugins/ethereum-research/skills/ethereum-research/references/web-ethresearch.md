---
title: ethresear.ch Navigation Guide
impact: HIGH
impactDescription: Community research forum navigation
tags: ethresear.ch, forum, research
---

# ethresear.ch Navigation Guide

ethresear.ch is a Discourse-based Ethereum research forum where researchers, core developers, and community members publish and discuss protocol proposals, technical ideas, and in-depth analyses. It is the primary venue for pre-EIP discussions and informal research sharing in the Ethereum ecosystem.

## URL Patterns

- Main page: `https://ethresear.ch/`
- Category listing: `https://ethresear.ch/c/{category-slug}/{id}`
- Topic thread: `https://ethresear.ch/t/{topic-slug}/{id}`
- Search: `https://ethresear.ch/search?q={query}`

## Key Categories

| Category | Slug | Description |
|----------|------|-------------|
| Sharding | `sharding` | Data availability, danksharding, blob research |
| Layer 2 | `layer-2` | Rollups, state channels, plasma |
| Cryptography | `cryptography` | ZK proofs, BLS signatures, VDFs |
| Economics | `economics` | Fee markets, MEV, validator incentives |
| Consensus | `consensus` | LMD-GHOST, Casper, fork choice |
| Execution | `execution` | EVM, state growth, gas repricing |
| Staking | `staking` | Validator operations, withdrawals, slashing |

Example category URL: `https://ethresear.ch/c/sharding/6`

## Search Strategies

### Using WebSearch

Use the `site:ethresear.ch` operator to restrict results to the forum:

```
site:ethresear.ch danksharding data availability sampling
site:ethresear.ch EIP-4844 blob transactions
site:ethresear.ch PBS proposer builder separation
```

### Using WebFetch on Search URLs

Fetch the search URL directly to retrieve the Discourse JSON response:

```
https://ethresear.ch/search?q=verkle+trees
https://ethresear.ch/search?q=maxEB+validator+consolidation
```

Discourse search returns topic titles, authors, and excerpt snippets that can guide further fetches.

### Fetching a Specific Topic

Once you identify a topic ID, fetch the full thread:

```
https://ethresear.ch/t/proto-danksharding-faq/10987
```

Discourse renders the full post content in the HTML body. Read the opening post and top replies for the core argument.

## Extracting Useful Information from Threads

1. Opening post: Contains the main proposal or research question. Read first.
2. Author metadata: Author name and post date appear near the top. Note them for citation.
3. Replies: Discourse threads often contain critical refinements, objections, and counter-proposals in the first 10-20 replies. Fetch the topic URL and scan reply authors for known researchers (vbuterin, dankrad, protolambda, etc.).
4. Linked posts: Threads frequently cross-link to related discussions. Follow `ethresear.ch/t/...` links to build a comprehensive picture.
5. Last activity date: Check the topic's last reply date to assess whether the discussion is current or superseded.

## Citation Format

When citing a forum post in research output:

```
Author, "Post Title," ethresear.ch, Month Year. URL: https://ethresear.ch/t/{slug}/{id}
```
