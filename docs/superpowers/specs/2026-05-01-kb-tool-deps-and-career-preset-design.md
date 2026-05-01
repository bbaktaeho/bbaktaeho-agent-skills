# knowledge-base-setup: Tool Dependency Check + Career Preset

Status: design approved, ready for implementation
Date: 2026-05-01
Branch: fix/kb-setup-skill-body (continues body-slim work)

## Goals

1. Add a tool-dependency check to both skills in the `knowledge-base-setup` plugin (`knowledge-base-setup`, `kb-validator`). Missing tools are detected, the user is shown OS-specific install commands, and tools are installed only after explicit user confirmation. Default action when in doubt is always skip.
2. Add a fifth preset, `career`, optimized for an individual using the KB to track their career history, projects, skills, achievements, learning, reviews, goals, and resumes.
3. Career preset must not push a public repo. A `pre-push` hook checks repo visibility (private / internal only) and blocks public pushes.

## Non-goals

- Building resumes (PDF/HTML render). Templates only.
- LinkedIn / GitHub Profile sync.
- Splitting career data into a "sensitive" subdirectory. The user explicitly rejected this in favor of repo-visibility enforcement.
- Auto-changing repo visibility on non-GitHub remotes. Interactive fallback is sufficient.

## 1. Tool dependency check

### 1.1 Tool matrix

Three tiers. Behavior on missing tools differs per tier.

| Tier | Tools | Purpose | If missing |
|------|-------|---------|------------|
| required | `bash`, `git`, `grep`, `sed`, `awk` | Pre-commit hook + basic flow | ERROR + manual install instructions. Not auto-installable (these are OS basics). |
| recommended | `yq` OR `python3` + `PyYAML` (one-of), `gh` (only when `preset == career` AND origin is github.com) | YAML frontmatter parsing for kb-validator; visibility check for career preset | Prompt user with install command. Default is skip. |
| optional | `ripgrep`, `gitleaks`, `trufflehog`, `lychee` | Faster secret scan, link checking | Print availability summary only. Install only on explicit user opt-in. |

### 1.2 OS detection and install commands

Detection runs once per check. First match wins:

- `command -v brew` → macOS / Linuxbrew → `brew install <pkg>`
- `command -v apt-get` → Debian / Ubuntu → `sudo apt-get install -y <pkg>`
- `command -v dnf` → Fedora / RHEL 8+ → `sudo dnf install -y <pkg>`
- `command -v pacman` → Arch → `sudo pacman -S --noconfirm <pkg>`
- otherwise → `unknown` → auto-install disabled, print package name and `https://...` link, ask user to install manually and re-run.

For `python3` + `PyYAML`: prefer `pip install --user pyyaml` after confirming `python3` is present. If neither python3 nor pip3 → recommend `yq` instead.

### 1.3 Confirmation flow

```
[kb-tools] 환경 검사 결과:
  required:    bash(ok) git(ok) grep(ok) sed(ok) awk(ok)
  recommended: yq(missing), python3+PyYAML(missing)
  optional:    ripgrep(ok) gitleaks(missing) trufflehog(missing) lychee(missing)

kb-validator 의 frontmatter 파싱에는 yq 또는 python3+PyYAML 가 필요합니다.
설치할까요?

  1) yq 설치 (brew install yq)        [권장 - 빠름]
  2) python3 PyYAML 설치 (pip install --user pyyaml)
  3) skip — 수동으로 설치 후 다시 실행

선택 [3]: _
```

Default option is always `skip`. Optional tools are asked separately and individually opt-in.

### 1.4 Safety rules

- A command containing `sudo` runs only after explicit `y` (no implicit consent).
- After install, re-run detection and print the new state.
- If install fails (non-zero exit), surface the underlying error and continue without the tool.
- Auto-install is disabled when OS = `unknown`.

### 1.5 Where the check runs

- **Phase 0.5 of `knowledge-base-setup`** — between Phase 0 (state scan) and Phase 1 (Q1 questions). Blocks setup until user resolves required tools or explicitly continues.
- **Phase 0 of `kb-validator`** — same matrix, runs before validation begins. If recommended tools are missing, validator either uses fallback (degraded) or halts with instructions.

Both skills load the matrix from a single shared reference file, `references/rule-tool-dependencies.md`.

## 2. Career preset

### 2.1 Top-level layout

```
{kb-root}/
├── README.md
├── .gitignore
├── .kb/
│   ├── README.md
│   ├── schema.md
│   ├── conventions.md
│   ├── preset.json                 # {"preset":"career","version":"1.0.0"}
│   └── hooks/
│       ├── pre-commit-secrets.sh
│       └── pre-push-visibility.sh   # career-only
│
├── roles/
├── resumes/
├── projects/
├── skills/
├── brag/
├── learning/
├── reviews/
└── goals/
```

Each directory ships a `README.md` derived from `template-dir-readme.md` plus a role-specific paragraph.

### 2.2 Per-directory contract

| Directory | Filename convention | Recommended tags | Notes |
|-----------|---------------------|------------------|-------|
| `roles/` | `{YYYY-MM}-{company-slug}.md` | `[role, {company}, {discipline}]` | One file per role. `status: active` while employed, `archived` after leaving. |
| `resumes/` | `master.md` + `{YYYY-MM}-{target-slug}.md`; sub `cover-letters/`, `exports/` (gitignored) | `[resume, master\|tailored, {target}]` | Use `relations` to point at supporting `roles/`, `projects/`, `brag/` entries. |
| `projects/` | `{slug}.md` or `{slug}/README.md` | `[project, side\|work, {domain}]` | Mix of side and work projects. |
| `skills/` | `{category}.md` (e.g., `backend.md`, `infra.md`, `soft-skills.md`) | `[skill, {category}]` | Per-skill body lists level, last-used date, and `relations` to projects. |
| `brag/` | `{YYYY-Q#}.md` or `{YYYY}.md` | `[brag, {quarter}]` | One bullet per accomplishment with situation / action / impact / evidence. |
| `learning/` | `{YYYY}-{topic}.md` | `[learning, book\|course\|talk\|paper, {domain}]` | Books, courses, conferences, papers. |
| `reviews/` | `reviews/self/{YYYY-Q#}.md`, `reviews/1on1/{YYYY-MM}-{initials}.md` | `[review, self\|1on1]` | Self retros plus 1:1 summaries. |
| `goals/` | `{YYYY}.md` (annual), `{YYYY-Q#}.md` (quarterly) | `[goal, {timeframe}]` | OKR or freeform plus end-of-period retro. |

### 2.3 Privacy approach

The user rejected splitting "sensitive" content into `.kb/local/career/`. Instead, the entire career KB is treated as private and the repo itself must be private/internal. Section 3 enforces this.

### 2.4 `.gitignore` additions for career

```
# Built / exported resumes
resumes/exports/
```

(No `.kb/local/career/` entry — that path is not used by this preset.)

### 2.5 Preset selection

`ask-questions.md` Q2 gains a fifth option:

```
어떤 프리셋으로 시작할까요?

  1) team-docs
  2) research
  3) product
  4) custom
  5) career     — 개인 커리어 트래킹 (이력 / 이력서 / 프로젝트 / 스킬 / 성과 / 학습 / 회고 / 목표)

선택 [1]: _
```

Selection writes `.kb/preset.json` with `{"preset": "career", "version": "1.0.0"}`.

## 3. Public-repo push protection

### 3.1 The hook

File: `{kb-root}/.kb/hooks/pre-push-visibility.sh` (chmod +x). Installed in Phase 2 only when `preset == career`. Wired into `.git/hooks/pre-push` using the same symlink-or-warn policy as the existing pre-commit hook:

- if `.git/hooks/pre-push` does not exist → symlink
- if it already points at our script → no-op
- if a different file exists → leave alone, print manual-merge instructions

The hook reads `.kb/preset.json`. When `preset != career`, it exits 0 immediately so it stays harmless if a non-career repo accidentally activates it.

### 3.2 Visibility detection precedence

Git invokes pre-push as `pre-push <remote-name> <remote-url>`. The hook checks visibility of that specific remote only:

1. **`gh` CLI present** + remote URL matches `github.com` (SSH or HTTPS):
   ```
   visibility=$(gh api "repos/{owner}/{repo}" --jq .visibility 2>/dev/null)
   # public | private | internal
   ```
   Empty / non-zero → fall through.
2. **GitHub origin but `gh` missing**, or **non-GitHub remote**:
   - If `KB_REPO_VISIBILITY` is set in env, use it (values: `public`, `private`, `internal`).
   - Otherwise, prompt:
     ```
     [kb-visibility] 원격 'origin' 의 visibility 를 자동 확인할 수 없습니다.
     이 레포는 private 또는 internal 인가요?

       1) yes — 진행
       2) no  — push 차단
     선택 [2]: _
     ```
   - Default = `2` (block) — safest.
3. **No remote** → print warning, exit 0 (no push possible).

### 3.3 Blocking message

```
[kb-visibility] 푸시 차단됨.

원격 'origin' 의 visibility: public
career 프리셋 KB 는 public 레포로 푸시할 수 없습니다.

해결 옵션:
  1. 레포를 private 또는 internal 로 변경:
       gh repo edit {owner}/{repo} --visibility private
  2. 의도적인 public push 가 필요하면:
       KB_ALLOW_PUBLIC_PUSH=1 git push ...
     단 발송 전 어떤 파일이 노출될지 확인하세요:
       git diff origin/main..HEAD --stat
  3. 다른 원격으로 푸시:
       git push <other-remote> <branch>
```

### 3.4 Bypass and CI

- `KB_ALLOW_PUBLIC_PUSH=1` — single-shot bypass. Useful for intentional public CV repos.
- `KB_REPO_VISIBILITY=private|internal|public` — non-interactive override (CI, scripted setups). When set, skips both `gh` lookup and the prompt.

### 3.5 One-time check at setup

Phase 4 verification of `knowledge-base-setup` runs the same detection once. If `origin` exists and visibility resolves to `public`, the setup prints a warning and recommends `gh repo edit ... --visibility private`. Setup does not fail — the hook will block the actual push.

## 4. File changes

### 4.1 New files

```
plugins/knowledge-base-setup/skills/knowledge-base-setup/references/
  rule-tool-dependencies.md
  flow-tool-check.md
  preset-career.md
  template-pre-push-visibility-hook.md
```

### 4.2 Modified files

```
plugins/knowledge-base-setup/skills/knowledge-base-setup/
  SKILL.md                              # description + abstract + reference table; keep body <= 100 lines
  references/_sections.md               # index the 4 new references
  references/flow-execution.md          # Phase 0.5; Phase 2 pre-push hook (career only); Phase 4 visibility check
  references/ask-questions.md           # Q2 gains 5) career

plugins/knowledge-base-setup/skills/kb-validator/
  SKILL.md                              # Phase 0 tool check note
```

### 4.3 Untouched

- `template-pre-commit-hook.md` (no career-specific patterns added)
- `rule-frontmatter-schema.md`, `rule-relations.md`, `rule-lifecycle.md`, `rule-secrets-handling.md`, `rule-length-guideline.md`
- Existing presets: team-docs, research, product, custom
- All `kb-validator/references/rule-*.md`

## 5. Validation

- `bash .github/scripts/validate-skills.sh` passes for both `knowledge-base-setup` and `kb-validator` after changes (description ≤ 1024 chars, body ≤ 100 lines, name format, marketplace mapping).
- Local pre-commit hook (`.githooks/pre-commit`) automatically runs the same validator on staged plugin files.
- Manual smoke test: dry-walk the new flow on a scratch directory to confirm the question is asked, the preset directories appear, and the pre-push hook is wired (without actually pushing).

## 6. Open questions / future

- Should `kb-validator` learn a `career`-specific length rule (e.g., a `roles/{company}.md` longer than 1500 lines is a smell)? Punted — current 1000/2000/2500 line rule applies.
- Should an `agent-instructions-setup` integration be offered for personal AGENTS.md (so AI tools indexing the career KB get a helpful entry point)? Punted — the existing AGENTS.md merge step already covers this.
