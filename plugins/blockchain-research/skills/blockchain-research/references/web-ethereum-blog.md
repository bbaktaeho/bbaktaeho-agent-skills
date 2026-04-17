---
title: Ethereum Blog Navigation Guide
impact: MEDIUM
impactDescription: Official blog access for announcements
tags: blog, ethereum, official
---

# Ethereum Blog Navigation Guide

`blog.ethereum.org` is the official Ethereum Foundation blog. It publishes authoritative announcements about protocol upgrades, network hardforks, ecosystem initiatives, and foundation operations. Content here reflects the official position of the Ethereum Foundation and is the canonical source for upgrade timelines and release notes.

## URL Patterns

- Main listing: `https://blog.ethereum.org/`
- Category pages: `https://blog.ethereum.org/category/{category}`

Common category slugs:

| Category | URL |
|----------|-----|
| Protocol announcements | `https://blog.ethereum.org/category/protocol` |
| Research | `https://blog.ethereum.org/category/research` |
| Ecosystem | `https://blog.ethereum.org/category/ecosystem` |
| Security | `https://blog.ethereum.org/category/security` |
| General | `https://blog.ethereum.org/category/general` |

Individual posts follow the pattern:

```
https://blog.ethereum.org/{YYYY}/{MM}/{DD}/{slug}
```

## Key Content Types

- Protocol upgrade announcements: Scheduled hardfork dates, included EIPs, client release requirements.
- Hardfork post-mortems: Analysis of upgrade execution, any issues encountered, lessons learned.
- Ecosystem reports: Devcon summaries, grant round results, community statistics.
- Security disclosures: Vulnerability reports and patch advisories (after fixes are deployed).
- Foundation operations: Funding decisions, team updates, strategic direction.

## Search Strategy

### Using WebSearch

Use the `site:blog.ethereum.org` operator combined with topic keywords:

```
site:blog.ethereum.org Cancun Deneb upgrade
site:blog.ethereum.org EIP-4844 launch
site:blog.ethereum.org merge announcement
```

For time-bounded searches, add a year:

```
site:blog.ethereum.org Shanghai upgrade 2023
```

### Using WebFetch

Fetch the main page or a category page to scan recent post titles and dates before drilling into a specific article:

```
https://blog.ethereum.org/
https://blog.ethereum.org/category/protocol
```

Once you identify the correct post URL, fetch the full article for detailed content.

## When to Use This Source

Use `blog.ethereum.org` when you need:

- Official hardfork activation dates and included EIP lists.
- The foundation's public rationale for protocol decisions.
- Post-upgrade status reports.
- Ecosystem grant program results.
- Any content that requires citing an authoritative Ethereum Foundation position.

Do not use this source for informal research proposals or community opinions. For those, use ethresear.ch.

## Citation Format

```
Ethereum Foundation, "Post Title," Ethereum Blog, Month Year. URL: https://blog.ethereum.org/...
```
