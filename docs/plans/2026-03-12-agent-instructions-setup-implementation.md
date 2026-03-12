# agent-instructions-setup Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** agent-instructions-setup skill을 실행 가능한 init skill로 전면 재설계한다.

**Architecture:** 기존 reference 파일 중 2개를 삭제하고, 3개를 갱신하고, 5개를 신규 생성한다. SKILL.md는 Phase 1/2/3 실행 흐름을 포함하도록 전면 재작성한다.

**Tech Stack:** Markdown, YAML frontmatter, symlink

---

### Task 1: 기존 파일 삭제

**Files:**
- Delete: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/docs-structure.md`
- Delete: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/write-agents-md.md`

**Step 1: 삭제 실행**

```bash
rm plugins/agent-instructions-setup/skills/agent-instructions-setup/references/docs-structure.md
rm plugins/agent-instructions-setup/skills/agent-instructions-setup/references/write-agents-md.md
```

**Step 2: 삭제 확인**

```bash
ls plugins/agent-instructions-setup/skills/agent-instructions-setup/references/
```

Expected: `_sections.md`, `link-symlink-strategy.md`, `map-file-paths.md` 만 존재

**Step 3: Commit**

```bash
git add -u
git commit -m "remove: docs-structure.md, write-agents-md.md (내용을 신규 파일에 흡수)"
```

---

### Task 2: _sections.md 갱신

**Files:**
- Modify: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/_sections.md`

**Step 1: 파일 재작성**

기존 4개 섹션을 새 구조에 맞게 갱신한다:

```yaml
---
sections:
  - id: file-mapping
    title: AI Tool File Path Mapping
    prefix: map
  - id: symlink-strategy
    title: Symlink Unification Strategy
    prefix: link
  - id: frontmatter
    title: Documentation Frontmatter Rules
    prefix: meta
  - id: templates
    title: Project Templates
    prefix: template
---
```

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/skills/agent-instructions-setup/references/_sections.md
git commit -m "update: _sections.md to reflect new reference structure"
```

---

### Task 3: meta-frontmatter.md 신규 생성

**Files:**
- Create: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/meta-frontmatter.md`

**Step 1: 파일 생성**

docs/ 하위 파일에 적용할 frontmatter 규칙을 정의한다.

내용:
- YAML frontmatter 필수 필드: title, description, type, created
- 6줄 이내 제한 (`---` 포함)
- agent가 head 6줄만 읽고 문서를 읽을지 판단하는 규칙
- type 값: guide, workflow, spec, reference
- description은 반드시 1줄
- 올바른 예시와 잘못된 예시 포함

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/skills/agent-instructions-setup/references/meta-frontmatter.md
git commit -m "add: meta-frontmatter.md for docs/ frontmatter rules"
```

---

### Task 4: map-file-paths.md 갱신

**Files:**
- Modify: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/map-file-paths.md`

**Step 1: 파일 재작성**

갱신 내용:
- Cursor: `.cursorrules` (legacy) + `.cursor/rules/*.mdc` 추가
- Copilot: `.github/instructions/*.instructions.md` 패턴 추가
- Claude Code: 계층 구조 설명 (`~/.claude/CLAUDE.md`, 서브디렉토리 `CLAUDE.md`)
- Aider: 제거
- 나머지 도구(Windsurf, Cline, Gemini CLI, Google Antigravity, Zed) 유지
- AGENTS.md 지원 현황 테이블 갱신

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/skills/agent-instructions-setup/references/map-file-paths.md
git commit -m "update: map-file-paths.md with latest tool file paths"
```

---

### Task 5: link-symlink-strategy.md 갱신

**Files:**
- Modify: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/link-symlink-strategy.md`

**Step 1: 파일 재작성**

갱신 내용:
- 8개 도구 전체 symlink 명령 (최신 경로 반영)
- 기존 파일 병합 절차를 구체적으로 기술 (발견 -> 내용 읽기 -> AGENTS.md에 병합 -> 삭제 -> symlink 생성)
- Windows 대안 (mklink, Git for Windows core.symlinks=true)
- 검증 명령어
- Google Antigravity 디렉토리 구조

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/skills/agent-instructions-setup/references/link-symlink-strategy.md
git commit -m "update: link-symlink-strategy.md with merge procedure and platform notes"
```

---

### Task 6: template-agents.md 신규 생성

**Files:**
- Create: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-agents.md`

**Step 1: 파일 생성**

AGENTS.md 공통 템플릿. 설계 문서의 AGENTS.md Template 섹션 내용을 그대로 반영한다.

포함 내용:
- `{Project Name}`, `{프로젝트 1줄 설명}` placeholder
- Rules 8개 항목
- Documentation 섹션 (guide.md, workflow.md 링크)
- agent가 placeholder를 사용자 답변으로 치환하라는 안내

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-agents.md
git commit -m "add: template-agents.md for AGENTS.md common template"
```

---

### Task 7: template-dev-guide.md 신규 생성 (사용자와 함께)

**Files:**
- Create: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-dev-guide.md`

**Step 1: 사용자와 함께 내용 확정**

개발용 guide.md 템플릿. 최소 뼈대 + agent가 사용자 답변으로 채울 부분.

포함할 섹션 (초안):
- frontmatter (meta-frontmatter.md 규칙 준수)
- Tech Stack (placeholder)
- Project Structure (placeholder)
- Key Modules (placeholder)
- Development 섹션에서 docs/workflow.md 참조 안내

**Step 2: 사용자 피드백 반영 후 Commit**

---

### Task 8: template-dev-workflow.md 신규 생성 (사용자와 함께)

**Files:**
- Create: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-dev-workflow.md`

**Step 1: 사용자와 함께 내용 확정**

개발용 workflow.md 템플릿.

포함할 섹션 (초안):
- frontmatter
- Branch Strategy
- Commit Convention
- PR Process
- Build & Test 명령어
- 배포 절차 (placeholder)

**Step 2: 사용자 피드백 반영 후 Commit**

---

### Task 9: template-docs-guide.md 신규 생성 (사용자와 함께)

**Files:**
- Create: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-docs-guide.md`

**Step 1: 사용자와 함께 내용 확정**

문서용 guide.md 템플릿.

포함할 섹션 (초안):
- frontmatter
- 문서 목적/대상 독자
- 문서 구조 (디렉토리 레이아웃)
- 문서 작성 규칙 (톤, 스타일, 포맷)
- docs/workflow.md 참조 안내

**Step 2: 사용자 피드백 반영 후 Commit**

---

### Task 10: template-docs-workflow.md 신규 생성 (사용자와 함께)

**Files:**
- Create: `plugins/agent-instructions-setup/skills/agent-instructions-setup/references/template-docs-workflow.md`

**Step 1: 사용자와 함께 내용 확정**

문서용 workflow.md 템플릿.

포함할 섹션 (초안):
- frontmatter
- 문서 작성 프로세스 (기획 -> 초안 -> 리뷰 -> 발행)
- 파일 네이밍 규칙
- 버전 관리 / 변경 이력
- 빌드/배포 (정적 사이트 등, placeholder)

**Step 2: 사용자 피드백 반영 후 Commit**

---

### Task 11: SKILL.md 전면 재작성

**Files:**
- Modify: `plugins/agent-instructions-setup/skills/agent-instructions-setup/SKILL.md`

**Step 1: 파일 재작성**

변경 내용:
- frontmatter: description 갱신 (실행형 init skill임을 명시)
- body: Phase 1/2/3 실행 흐름 포함
- Rule Categories by Priority 테이블 갱신 (새 파일 구조 반영)
- How to Use 섹션에서 references/ 파일 목록 갱신
- 100줄 이하 유지

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/skills/agent-instructions-setup/SKILL.md
git commit -m "rewrite: SKILL.md with Phase 1/2/3 execution flow"
```

---

### Task 12: plugin.json 갱신

**Files:**
- Modify: `plugins/agent-instructions-setup/.claude-plugin/plugin.json`

**Step 1: description 갱신**

실행형 init skill임을 반영하도록 description 수정.

**Step 2: Commit**

```bash
git add plugins/agent-instructions-setup/.claude-plugin/plugin.json
git commit -m "update: plugin.json description"
```

---

### Task 13: 최종 검증

**Step 1: 전체 파일 구조 확인**

```bash
find plugins/agent-instructions-setup -type f | sort
```

Expected: SKILL.md + plugin.json + references/ 8파일 = 총 10파일

**Step 2: 삭제된 파일 확인**

docs-structure.md, write-agents-md.md가 없는지 확인.

**Step 3: 내용 일관성 확인**

- SKILL.md의 references 목록과 실제 파일이 일치하는지
- _sections.md의 prefix가 실제 파일명과 일치하는지
- template-agents.md의 Rules가 설계 문서와 일치하는지
