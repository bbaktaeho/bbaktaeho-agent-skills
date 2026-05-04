---
name: agent-instructions-setup
description: >
  AI coding agent instruction file init and retrofit across three modes: solo,
  project-team, and cross-project hub. Creates AGENTS.md as the single source
  of truth, symlinks across major AI tools (Claude Code, Cursor, Copilot,
  Windsurf, Cline, Roo Code, Gemini CLI, Codex, Zed, Antigravity, Amp, Aider,
  Continue), an AI-first agents/ content directory, and a .agents/ meta
  directory (README, schema, conventions, preset.json, hooks, local) mirroring
  the .kb/ pattern. Project-team mode adds onboarding, ADR, RFC, runbook,
  postmortem, glossary, security, CODEOWNERS. Hub mode builds a cross-project
  catalog (project registry, tech radar, shared libraries, infra, incident
  response, org-level ADRs). Use whenever the user wants to initialize a
  project, bootstrap AGENTS.md, unify instruction files, retrofit a project,
  set up a team knowledge base, create a hub, or evolve agents/ docs - even
  if they only say "AI rules" or "agent config".
license: MIT
metadata:
  author: bbaktaeho
  version: "3.3.0"
  date: May 2026
  abstract: >
    Init and retrofit skill with three modes: solo, project-team, hub. Phase
    0 scans state, Phase 1 sets up AGENTS.md and idempotent symlinks, Phase 2
    interactively generates agents/guide.md (routing index) and workflow.
    Phase 2B (project-team): onboarding, team, glossary, security, plus
    ADR/RFC/runbook/postmortem templates and CODEOWNERS. Phase 2C (hub):
    project registry, tech-radar, shared-libraries, infrastructure,
    cross-service incident-response, org-level ADR. Phase 3 verifies.
    Philosophy: AI-first. Hub is NOT a team wiki; it is a cross-project
    meta-index for AI agents to route cross-project work.
---

# Agent Instructions Setup

AGENTS.md 를 single source of truth 로 두고, `agents/` 디렉토리를 AI 탐색 최적화된 형태로 구축·유지한다.

## Core Philosophy

"AI 행동을 바꾸려 하지 말고, AI 가 잘 찾을 수 있도록 문서를 최적화한다."

AGENTS.md 와 agents/guide.md 는 행동 지시문이 아니라 **탐색 라우팅** 역할이다. 상세: references/rule-findability.md

## Directory Layout

레포 루트에 두 개 디렉토리가 셋업된다:

- `agents/` — 컨텐츠 (guide.md / workflow.md / 도메인 문서)
- `.agents/` — 메타 (AI 진입점, schema, conventions, preset.json, hooks, local). references/layout-overview.md

기존 소스에 `agents/` 디렉토리가 있으면 Phase 0 에서 충돌을 감지하고 컨텐츠 fallback 이름(`_agents/`) 을 제안한다. `.agents/` 는 항상 메타 전용으로 예약.

## Execution Flow

### Phase 0: State Scan

현재 프로젝트 상태를 스캔하여 진행 모드를 결정한다.

1. AGENTS.md, 도구별 instruction 파일, `agents/` 디렉토리 유무 확인
2. `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile` 스캔하여 스택 자동 감지
3. 모드 분기:
   - Fresh → Phase 1 부터 진행
   - Legacy files only → 병합 후 Phase 1 (references/link-symlink-strategy.md 병합 절차)
   - Already set up → 업그레이드·문서 추가 모드 (references/evolve-principles.md 원칙 적용)

### Phase 1: Structure Setup

1. AGENTS.md 생성 또는 병합 (references/template-agents.md)
2. `agents/` 컨텐츠 디렉토리 생성 (충돌 시 `_agents/` fallback)
3. `.agents/` 메타 디렉토리 생성: README/schema/conventions/preset.json + local/, local.example/, hooks/pre-commit-secrets.sh + `.git/hooks/pre-commit` 자동 연결 (references/template-meta-*.md, references/template-pre-commit-hook.md)
4. `ln -sfn` 으로 도구별 심링크 멱등 생성 (references/link-symlink-strategy.md, references/map-file-paths.md)
5. `.gitignore` 에 미사용 도구 파일 + `.agents/.tag-index` + `.agents/local/` 추가

### Phase 2: Interactive Setup

5. references/ask-questions.md 로 Q1~Q10 질문 (Q10: n / project / hub)
6. Q3 에 따라 agents/guide.md (routing index, 80줄 이내) 생성
7. Q5 에 따라 agents/workflow.md (lite / full) 생성
8. Q10=project → Phase 2B, Q10=hub → Phase 2C, Q10=n → Phase 3

### Phase 2B: Project Team Mode (Q10=project)

9. T1~T7 질문, 팀 전용 문서 생성:
   - 기본: onboarding (T1≠solo), team, glossary, security, stack
   - T3 선택 항목만: decisions / rfc / runbook / postmortem TEMPLATE.md
10. T2=y 면 `.github/CODEOWNERS` 에 `agents/ @{handle}` 추가
11. AGENTS.md 에 Ownership 섹션, guide.md 에 팀 라우팅 행 추가
12. 거버넌스 원칙: references/rule-team-governance.md

### Phase 2C: Hub Mode (Q10=hub)

9. HUB1~HUB6 질문, 허브 문서 생성:
   - AGENTS.md: template-hub-agents.md (카탈로그 루트)
   - agents/guide.md: template-hub-guide.md (프로젝트 대시보드)
   - agents/projects/{name}.md: HUB3 등록 프로젝트별 (template-project-registry.md)
   - agents/decisions/ (org-level ADR)
   - agents/team.md, glossary.md, security.md, onboarding.md (2-hop 버전)
   - HUB4 선택 항목: tech-radar / shared-libraries / infrastructure / incident-response / architecture/
10. `.github/CODEOWNERS` + HUB6=pr-template 시 PR 템플릿에 registry 체크박스 추가
11. 허브 원칙: references/rule-hub-principles.md (AI-first, registry sync, 2-hop onboarding)

### Phase 3: Verification

12. 심링크 타겟 검증: `ls -la`, `diff AGENTS.md CLAUDE.md`
13. agents/ 파일 frontmatter 6~8줄 확인
14. `.agents/` 메타 검증: README.md / schema.md / conventions.md / preset.json (`kind: "agents"`) 존재, `.git/hooks/pre-commit` symlink, `.gitignore` 라인
15. Project/Hub 모드: CODEOWNERS 동기화, security.md grep 패턴 스캔
16. Hub 모드: agents/projects/ 양방향 링크 (프로젝트 레포 ↔ 허브 registry) 확인 권고
17. 응답 마지막에 읽은·생성한 파일 나열 + 다음 단계 안내: `meta-validator` 실행

## Companion Skill

`meta-validator` — 같은 플러그인 내 별도 스킬. 셋업 후 `agents/*.md` 와 `.agents/` 의 frontmatter / relations / timestamps / tag-index / 시크릿 / 길이 (AGENTS.md 50/80/120, agents/*.md 80/100/150) 를 검증/자동수정한다.

## Reference Categories

| Priority | Category | Prefix | 대표 파일 |
|----------|----------|--------|-----------|
| CRITICAL | Findability / Team / Hub Principles | `rule-` | findability, team-governance, hub-principles |
| CRITICAL | File Mapping / Frontmatter | `map-`, `meta-` | file-paths, frontmatter |
| HIGH | Symlink / Evolve / Questions | `link-`, `evolve-`, `ask-` | symlink-strategy, principles, questions |
| HIGH | Solo Templates | `template-` | agents, dev-guide, dev-workflow, docs-guide, docs-workflow |
| HIGH | Meta / Hooks Templates | `template-`, `layout-` | meta-readme, meta-schema, meta-conventions, meta-preset, pre-commit-hook, layout-overview |
| HIGH (project-team) | Project Team Templates | `template-` | onboarding, team, glossary, security, decision, rfc, runbook, postmortem |
| HIGH (hub) | Hub Templates | `template-` | hub-agents, hub-guide, project-registry, tech-radar, shared-libraries, infrastructure, incident-response |

전체 목록은 references/_sections.md 참고.

- https://agents.md
- https://docs.cursor.com/context/rules
- https://code.visualstudio.com/docs/copilot/customization/custom-instructions
