#!/usr/bin/env bash
# Install the workflow scaffold into a target project.
# Usage: ./install.sh /path/to/project
# Copies AGENTS.md, CLAUDE.md, memory-bank/, tasks/, and .claude/skills/.
# Never overwrites: existing files in the target are skipped and reported.

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: ./install.sh /path/to/project"
  exit 1
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"

if [[ "$TARGET" == "$SRC" ]]; then
  echo "Target is the template repo itself; nothing to do."
  exit 1
fi

copied=0
skipped=0

copy_file() {
  local rel="$1"
  local dest="$TARGET/$rel"
  if [[ -e "$dest" ]]; then
    echo "skip (exists): $rel"
    skipped=$((skipped + 1))
  else
    mkdir -p "$(dirname "$dest")"
    cp "$SRC/$rel" "$dest"
    echo "copied:        $rel"
    copied=$((copied + 1))
  fi
}

copy_file "AGENTS.md"
copy_file "CLAUDE.md"

for f in "$SRC"/memory-bank/*.md; do
  copy_file "memory-bank/$(basename "$f")"
done
mkdir -p "$TARGET/memory-bank/tasks"

for f in "$SRC"/tasks/*.md; do
  copy_file "tasks/$(basename "$f")"
done

for skill in "$SRC"/.claude/skills/*/; do
  name="$(basename "$skill")"
  copy_file ".claude/skills/$name/SKILL.md"
done

echo
echo "Done: $copied copied, $skipped skipped (already existed)."
echo "Next: open the project in Claude Code and run /init-project."
