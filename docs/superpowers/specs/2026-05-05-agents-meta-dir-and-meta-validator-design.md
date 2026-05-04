# agent-instructions-setup: `.agents/` Meta Dir + `meta-validator`

Status: design approved
Date: 2026-05-05
Branch: feat/agents-meta-dir-and-meta-validator

## Goals

1. Add a `.agents/` meta directory mirroring `.kb/` to `agent-instructions-setup`. The meta directory holds the AI entry point (`README.md`), schema, conventions, preset.json, hooks, local, and tag-index.
2. Add a new companion skill `meta-validator` to the `agent-instructions-setup` plugin, modeled after `kb-validator` but scoped to `.agents/` and `agents/*.md` only.
3. Length recommendation thresholds for `agents/*.md` are tightened: target 80, soft 100, hard 150 (vs kb-validator's 1000/2000/4000). `AGENTS.md` itself uses 50 / 80.

## Non-goals

- Rename or modify `kb-validator`. It stays in `knowledge-base-setup` plugin and continues to validate `.kb/` only.
- Share reference files between plugins (each plugin keeps its own copies). The two validators evolve independently.
- Wrap two pre-commit hooks behind a single shim. Each plugin manages its own hook; if both meta-dirs exist, the user has two hooks (handled the same way the existing kb hook handles co-existence).

## 1. `.agents/` meta directory

```
{repo}/
├── AGENTS.md                          # Routing root. Untouched.
├── README.md
├── .gitignore                         # adds .agents/.tag-index, .agents/local/
├── .agents/                           # NEW
│   ├── README.md                      # AI entry point (mirrors .kb/README.md role)
│   ├── schema.md                      # frontmatter schema for agents/*.md
│   ├── conventions.md                 # findability + lifecycle + naming for agents/
│   ├── preset.json                    # {"kind":"agents","mode":"solo|project|hub","version":"3.3.0"}
│   ├── .tag-index                     # gitignored
│   ├── hooks/
│   │   └── pre-commit-secrets.sh      # scans agents/**/*.md + .agents/**/*.md
│   ├── local/                         # gitignored. Internal-only memos.
│   └── local.example/
│       └── README.md
└── agents/                            # Content. Mostly untouched.
    ├── guide.md
    ├── workflow.md
    └── ...
```

### Where it plugs into the existing flow

`agent-instructions-setup` Phase 1 already creates AGENTS.md and `agents/`. We add a new step in Phase 1 (or a Phase 1B) that creates `.agents/` after `agents/` is in place, plus the existing Phase 3 (verification) gains checks for `.agents/`.

### Existing `agents/` directory naming

The existing collision fallback (`.agents/`) becomes an issue: today the SKILL.md says "if `agents/` exists already, fall back to `.agents/` for the content directory." Now `.agents/` is reserved for the meta directory. The fallback is renamed to `_agents/` in this design. Updating `template-agents.md`, `link-symlink-strategy.md`, and any reference that mentions the old fallback is in scope.

## 2. `meta-validator` skill

Lives at `plugins/agent-instructions-setup/skills/meta-validator/`. Files:

```
SKILL.md
references/
  _sections.md
  flow-modes.md                      # quick / full / dry-run (same shape as kb-validator)
  rule-required-checks.md            # frontmatter / status / tags / relations / timestamps / dir README / tag-index / preset.json / .gitignore / AI entry / secret scan
  rule-recommended-checks.md         # length, deprecated refs, orphans, tag over/under, summary, moved, README stale summary
  rule-git-timestamp-sync.md
  rule-tag-index-rebuild.md
  rule-secret-scan.md
```

### Differences vs `kb-validator`

- Targets `.agents/` and `agents/**/*.md`. Preset.json `kind` field must be `"agents"`. If `.agents/` is missing, halt with "agent-instructions-setup 을 먼저 실행하세요".
- All "kb" / "knowledge base" / `.kb/` mentions removed. References speak of "agents docs" / "instruction docs" / `.agents/`.
- No mention of kb presets (team-docs / research / product / custom / career).
- Length thresholds (recommended check) are tightened:
  | Path | Target | Soft warn | Hard warn |
  |------|--------|-----------|-----------|
  | `AGENTS.md` | 50 | 80 | 120 |
  | `agents/guide.md` | 80 | 100 | 150 |
  | `agents/*.md` (other) | 80 | 100 | 150 |
  | tag includes `length-exempt` | exempt | - | - |
- Soft warn → standard confirm prompt. Hard warn → stronger split-recommendation prompt (similar to kb's research-strong path).
- README presence check applies to `agents/` subdirectories (`agents/decisions/`, `agents/projects/`, etc.). `.agents/` itself also requires `README.md`.

### `meta-validator` SKILL.md description (draft)

`description` mentions: validates `.agents/` and `agents/*.md`, frontmatter / relations / timestamps / tag-index / secrets / length (80/100/150 vs AGENTS.md 50/80/120), companion to `agent-instructions-setup`. Triggers when user says "validate agents docs", "check AGENTS.md", "scan secrets in agents", etc.

### Phase order

Same shape as kb-validator: Phase 0 (setup scan + tool check) → Phase 1 (required, auto-fix) → Phase 2 (tag index rebuild, only if no secret) → Phase 3 (recommended, full mode only) → Phase 4 (report). The Phase 0 tool check reuses the matrix from `agent-instructions-setup` (TBD - either inline a copy under `meta-validator/references/` or import from `agent-instructions-setup/references/`. Decision: inline the matrix at meta-validator/references/rule-tool-dependencies.md to keep the skill self-contained).

## 3. Hook separation

`.agents/hooks/pre-commit-secrets.sh` is created during agent-instructions-setup Phase 1. It is a copy of the kb hook with these differences:

- Scans `agents/**/*.md` and `.agents/**/*.md` (excluding `.agents/.tag-index` and `.agents/local/`).
- Bypass env: `AGENTS_SKIP_SECRET_SCAN=1` (mirrors `KB_SKIP_SECRET_SCAN=1`).
- Same secret pattern set as kb's hook (no career-specific patterns; agents docs do not handle compensation data).

`.git/hooks/pre-commit` wiring:

- If `.git/hooks/pre-commit` does not exist → symlink to `.agents/hooks/pre-commit-secrets.sh`.
- If it points at our hook → no-op.
- If it points at a different file (including `.kb/hooks/pre-commit-secrets.sh` from kb setup) → leave alone, print manual-merge instructions. This is the same policy kb-setup already uses.

For users who want both hooks active, the manual merge instructions in both setup skills include a wrapper snippet:

```bash
#!/usr/bin/env bash
set -e
[ -x .kb/hooks/pre-commit-secrets.sh ] && .kb/hooks/pre-commit-secrets.sh
[ -x .agents/hooks/pre-commit-secrets.sh ] && .agents/hooks/pre-commit-secrets.sh
```

## 4. File changes

### New files (agent-instructions-setup)

```
plugins/agent-instructions-setup/skills/agent-instructions-setup/references/
  layout-overview.md                        # tree showing AGENTS.md + .agents/ + agents/
  template-meta-readme.md                   # .agents/README.md
  template-meta-schema.md                   # .agents/schema.md
  template-meta-conventions.md              # .agents/conventions.md
  template-meta-preset.md                   # preset.json shape
  template-pre-commit-hook.md               # .agents/hooks/pre-commit-secrets.sh

plugins/agent-instructions-setup/skills/meta-validator/
  SKILL.md
  references/
    _sections.md
    flow-modes.md
    rule-required-checks.md
    rule-recommended-checks.md
    rule-git-timestamp-sync.md
    rule-tag-index-rebuild.md
    rule-secret-scan.md
    rule-tool-dependencies.md               # inlined matrix (yq / python+PyYAML)
```

### Modified files (agent-instructions-setup)

```
plugins/agent-instructions-setup/.claude-plugin/plugin.json    # 3.2.0 -> 3.3.0
plugins/agent-instructions-setup/skills/agent-instructions-setup/SKILL.md
plugins/agent-instructions-setup/skills/agent-instructions-setup/references/_sections.md
plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-agents.md
plugins/agent-instructions-setup/skills/agent-instructions-setup/references/link-symlink-strategy.md   # rename .agents/ fallback to _agents/
plugins/agent-instructions-setup/skills/agent-instructions-setup/references/ask-questions.md           # mention companion meta-validator
.claude-plugin/marketplace.json              # plugin description gains "+ meta-validator companion"
```

### Untouched

- `plugins/knowledge-base-setup/` entire plugin
- All other plugins

## 5. Validation

- `bash .github/scripts/validate-skills.sh` passes for `agent-instructions-setup` plugin (description ≤ 1024 chars, body ≤ 100 lines, name format, marketplace mapping). Both skills (`agent-instructions-setup`, new `meta-validator`) validated.
- Local pre-commit hook (`.githooks/pre-commit`) re-runs the same validator before each commit.
- No runtime smoke test (skills are reference-driven; user invocation runs the actual setup).

## 6. Open questions / future

- Once both `meta-validator` and `kb-validator` exist with significant duplication, an extraction into a shared library plugin may be worthwhile. Punted - duplication is acceptable while we observe how the two skills diverge.
- A future `unified-validator` could detect both meta-dirs and validate whichever exists. Not needed now: each plugin self-documents its own validator.
