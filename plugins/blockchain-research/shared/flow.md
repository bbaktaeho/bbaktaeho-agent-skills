---
title: Research Procedure (chain-agnostic)
impact: CRITICAL
impactDescription: Single source of truth for the 5-phase research procedure with mode branching, on-demand init, and 24-hour update cache
tags: flow, procedure, modes, init-policy, cache, blockchain-research
---

# Research Procedure

This file is the chain-agnostic procedure for executing a research request against a chain-specific researcher skill. Each chain skill defers to this file for procedure and supplies only its Source Selection Matrix and chain-specific output paths.

All paths use `<RESEARCH_ROOT>` as a placeholder.
All chain-specific data uses `<MANIFEST>` as a placeholder for the path `plugins/blockchain-research/skills/{chain}-researcher/submodules.json`.
The chain Source Selection Matrix lives at `references/flow-research.md` of the calling skill.

## Phase 1 -- Resolution & Mode

### Step 1: Resolve research root and strategy

Look up `<RESEARCH_ROOT>` (resolved at first setup, see `shared/setup.md`). If not yet resolved for this chain, run `shared/setup.md` Steps 1 and 2 first.

Read disk strategy from `<RESEARCH_ROOT>/.cache/strategy`. Default `on-demand` if missing.

### Step 2: Determine mode (quick vs full)

Two modes:

| Mode | Behavior |
|------|----------|
| `quick` | Inline answer with `<RESEARCH_ROOT>/{repo}/{path}:{line}` citations. Skip update cache check unless stale beyond TTL. Skip MD/HTML report. Multi-level analysis not enforced. |
| `full` | Run all five phases. Emit MD + HTML report to chain-specific output path. Multi-level analysis enforced. |

Auto-detection heuristics, evaluated in order:

1. **Explicit prefix** -- if the user message starts with `quick:` or `full:`, use that mode.
2. **Strong full signals** -- if the message contains any of: `research`, `compare`, `investigate`, `report`, `deep dive`, `리서치`, `리포트`, `비교`, treat as `full`.
3. **Default** -- treat as `quick`.

After choosing `quick`, if the question turns out to be deep (>= 3 distinct submodule references gathered, or the user follows up asking for "the report"), offer once: "Promote to full mode and emit a report?". Do not nag.

### Step 3: Source routing

Read the chain Source Selection Matrix from `references/flow-research.md` of the calling skill. The matrix maps question types to manifest tags (see `shared/manifest.md`). Compute the set of submodules whose `tags` intersect the routed tags. Call this set `NEEDED`.

## Phase 2 -- Init Policy (skip-if-present, ask-on-missing)

For each submodule in `NEEDED`:

1. **Skip-if-present**: if `<RESEARCH_ROOT>/<name>/<verifyPath>` exists and is non-empty, do nothing. Continue silently.
2. **Ask-on-missing**: otherwise, ask the user once with this template:

   ```
   Submodule `<name>` (<sizeApprox if present>) is needed for this question
   (matched tags: <intersected tags>).

   Install now? (y / n / skip-and-fall-back-to-web)
   ```

   - `y`: run `git submodule add <url> <RESEARCH_ROOT>/<name>` then `git submodule update --init --recursive`.
   - `n`: stop the research request. Tell the user the question cannot be answered without this submodule and suggest changing scope.
   - `skip-and-fall-back-to-web`: drop this submodule from `NEEDED`, continue with what remains, and note the caveat in the final answer / report.

3. **Verify after install**: re-check `<verifyPath>` non-empty. If still empty, surface the failure with the submodule name and `git submodule status` output.

Never auto-install without asking. The previous "auto-initialize on first use without permission" rule is removed.

## Phase 3 -- Update with 24-hour Cache

For each submodule in `NEEDED`:

1. Read `<RESEARCH_ROOT>/.cache/last-update-<name>` if it exists. Parse it as a Unix timestamp.
2. If the timestamp is less than 24 hours old (86400 seconds), skip the update for this submodule.
3. Otherwise run:

   ```bash
   git -C <RESEARCH_ROOT>/<name> fetch --quiet
   git submodule update --remote -- <RESEARCH_ROOT>/<name>
   ```

   Then write the current timestamp:

   ```bash
   date +%s > <RESEARCH_ROOT>/.cache/last-update-<name>
   ```

4. Generate a per-submodule change summary only when an update actually ran:

   ```bash
   git -C <RESEARCH_ROOT>/<name> log --oneline -10
   ```

Force refresh: if the user's message contains `refresh`, `pull latest`, `최신화`, `업데이트` followed by `submodule`, ignore the cache and update everything in `NEEDED`.

If a network failure occurs, proceed with the locally cached version and note the caveat in the final answer / report.

## Phase 4 -- Research (local-first)

Once `NEEDED` is initialized and (where applicable) updated, prefer local file access over web fetches.

Preferred tool order:

1. `Grep` with `path` pointed at `<RESEARCH_ROOT>/<name>/` -- keyword or regex search.
2. `Glob` with `path` pointed at `<RESEARCH_ROOT>/<name>/` -- locate files by name pattern.
3. `Read` with an absolute local path -- read specific files and line ranges.
4. `WebFetch` against upstream docs / forum / blog -- only for content the submodule does not contain.

Use local for code-level questions. Use web only for forum threads, blog posts, open PRs / issues, off-repo specs, and community discussion.

Cite files with `<RESEARCH_ROOT>/<name>/<path>:<line>`.

## Phase 5 -- Output (mode-dependent)

### Quick mode

- Reply inline.
- Cite at least one local source (file:line) for every code-level claim.
- For web claims, include the URL inline.
- Do not emit a report file.
- Multi-level analysis (protocol / code / community) is **not** enforced. Cover whichever levels the question actually needs.

### Full mode

- Emit both Markdown and HTML using the shared templates at `plugins/blockchain-research/templates/report.md` and `report.html`.
- Output paths come from the calling skill's `references/flow-research.md` (chain-specific). Default convention: `docs/research/{chain}/{YYYY-MM-DD}-{slug}.md` and `.html`.
- Fill MD and HTML in lockstep. They must carry identical section ids, identical Mermaid sources, identical inline SVG sources, and identical table rows.
- Multi-level analysis (protocol / code / community) **is** enforced. If a level is irrelevant, state the reason in the report rather than omitting the section.
- Replace every `{{PLACEHOLDER}}` and `<!-- TODO: ... -->` marker before considering the report done.

## Caveats Section

Whenever Phase 2 dropped a submodule (`skip-and-fall-back-to-web`), Phase 3 hit a network failure, or the update cache was used (skip > 24h), record this in:

- Quick mode: a short bullet list at the end of the inline answer.
- Full mode: a "Caveats" subsection inside the Overview section of the report.
