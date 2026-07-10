# TradingView Skill Packaging Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Package the TradingView skill in a named child directory so GitHub installs include every required script and reference file without changing the public install command.

**Architecture:** The repository root remains the project and documentation boundary. `skills/tradingview-api-integration/` becomes the complete, self-contained skill boundary consumed by the `skills` CLI.

**Tech Stack:** Agent Skills Markdown, Bash integration test, Python 3 helper, `npx skills` 1.5.x.

## Global Constraints

- Keep `npx skills add hypier/tradingview-api-integration-skill -y` unchanged.
- Keep the skill name `tradingview-api-integration` unchanged.
- Do not change TradingView API behavior or reference content.
- Keep paths inside `SKILL.md` relative to the installed skill root.

---

### Task 1: Make the skill directory self-contained

**Files:**
- Create: `tests/test_skill_package.sh`
- Move: `SKILL.md` to `skills/tradingview-api-integration/SKILL.md`
- Move: `scripts/tv_api.py` to `skills/tradingview-api-integration/scripts/tv_api.py`
- Move: `references/` to `skills/tradingview-api-integration/references/`

**Interfaces:**
- Consumes: local repository path and the cached `npx skills` CLI.
- Produces: a project install at `.agents/skills/tradingview-api-integration` containing only the self-contained skill directory.

- [x] **Step 1: Add the failing packaging regression test**

Create `tests/test_skill_package.sh` to assert the source uses a nested skill boundary, then install it into a temporary Git project and assert the installed files:

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SOURCE_SKILL="$REPO_ROOT/skills/tradingview-api-integration"
TEMP_ROOT=${TMPDIR:-/tmp}
TEMP_ROOT=${TEMP_ROOT%/}
TEMP_PROJECT=$(mktemp -d)

cleanup() {
  case "$TEMP_PROJECT" in
    "$TEMP_ROOT"/tmp.*) rm -rf -- "$TEMP_PROJECT" ;;
    *) printf 'Refusing to remove unexpected path: %s\n' "$TEMP_PROJECT" >&2 ;;
  esac
}
trap cleanup EXIT

test ! -e "$REPO_ROOT/SKILL.md"
test -f "$SOURCE_SKILL/SKILL.md"
test -f "$SOURCE_SKILL/scripts/tv_api.py"
test -f "$SOURCE_SKILL/references/endpoint-catalog.md"
test -f "$SOURCE_SKILL/references/openapi.json"

git -C "$TEMP_PROJECT" init -q
(
  cd "$TEMP_PROJECT"
  npx --no-install skills add "$REPO_ROOT" --agent codex --copy -y >/dev/null
)

INSTALL_DIR="$TEMP_PROJECT/.agents/skills/tradingview-api-integration"
test -f "$INSTALL_DIR/SKILL.md"
test -f "$INSTALL_DIR/scripts/tv_api.py"
test -f "$INSTALL_DIR/references/endpoint-catalog.md"
test -f "$INSTALL_DIR/references/openapi.json"
test ! -f "$INSTALL_DIR/README.md"
test ! -f "$INSTALL_DIR/LICENSE"

echo "skill package layout: ok"
```

- [x] **Step 2: Run the test to verify it fails**

Run: `bash tests/test_skill_package.sh`

Expected: FAIL because the repository currently has a root `SKILL.md` and local installation includes repository-only files.

- [x] **Step 3: Move the complete skill into its named directory**

Run:

```bash
mkdir -p skills/tradingview-api-integration
git mv SKILL.md scripts references skills/tradingview-api-integration/
```

- [x] **Step 4: Run the packaging test to verify it passes**

Run: `bash tests/test_skill_package.sh`

Expected: PASS with no output beyond the success message.

- [x] **Step 5: Commit the package layout**

```bash
git add tests/test_skill_package.sh skills/tradingview-api-integration docs/superpowers/plans/2026-07-10-skill-packaging.md
git commit -m "fix: package supporting skill files"
```

### Task 2: Update source-checkout documentation and validate the skill

**Files:**
- Modify: `README.md`
- Validate: `skills/tradingview-api-integration/SKILL.md`
- Validate: `skills/tradingview-api-integration/scripts/tv_api.py`

**Interfaces:**
- Consumes: the nested skill directory from Task 1.
- Produces: correct GitHub links and commands for both installed use and direct source-checkout use.

- [x] **Step 1: Update README paths**

Keep the public `npx skills add` commands unchanged. Change source-checkout Python examples to `python3 skills/tradingview-api-integration/scripts/tv_api.py ...`, update the included-file table to show the nested paths, and link documentation to `skills/tradingview-api-integration/SKILL.md` and its reference catalog.

- [x] **Step 2: Check documentation targets**

Run:

```bash
test -f skills/tradingview-api-integration/SKILL.md
test -f skills/tradingview-api-integration/scripts/tv_api.py
test -f skills/tradingview-api-integration/references/endpoint-catalog.md
```

Expected: all commands exit 0.

- [x] **Step 3: Validate skill metadata and helper behavior**

Run:

```bash
python3 /Users/barry/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/tradingview-api-integration
python3 skills/tradingview-api-integration/scripts/tv_api.py --help
env -u RAPIDAPI_KEY python3 skills/tradingview-api-integration/scripts/tv_api.py GET /api/metadata/markets
```

Expected: validator reports success; `--help` exits 0; the missing-key invocation exits 2 without making a network request.

- [x] **Step 4: Run final repository checks**

Run:

```bash
bash tests/test_skill_package.sh
git diff --check
git status --short
```

Expected: packaging test passes, `git diff --check` emits no errors, and status contains only intended README changes.

- [x] **Step 5: Commit documentation**

```bash
git add README.md
git commit -m "docs: update nested skill paths"
```
