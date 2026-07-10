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

test ! -e "$REPO_ROOT/SKILL.md" || {
  printf 'Root SKILL.md triggers incomplete GitHub installs\n' >&2
  exit 1
}
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

assert_file() {
  test -f "$1" || {
    printf 'Expected installed file: %s\n' "$1" >&2
    exit 1
  }
}

assert_absent() {
  test ! -e "$1" || {
    printf 'Repository-only file was installed: %s\n' "$1" >&2
    exit 1
  }
}

assert_file "$INSTALL_DIR/SKILL.md"
assert_file "$INSTALL_DIR/scripts/tv_api.py"
assert_file "$INSTALL_DIR/references/endpoint-catalog.md"
assert_file "$INSTALL_DIR/references/openapi.json"
assert_absent "$INSTALL_DIR/README.md"
assert_absent "$INSTALL_DIR/LICENSE"

echo "skill package layout: ok"
