#!/bin/bash
set -e

FILES=(
  "$HOME/.claude/CLAUDE.md"
  ".claude/CLAUDE.md"
  ".cursorrules"
  ".windsurfrules"
  ".github/copilot.md"
  ".clinerules"
  ".continuerules"
)

FOUND=0

for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ] && grep -q "SESSION-SCRIBE:START" "$FILE" 2>/dev/null; then
    # Remove everything between START and END markers (inclusive)
    sed -i '' '/<!-- SESSION-SCRIBE:START -->/,/<!-- SESSION-SCRIBE:END -->/d' "$FILE"
    echo "session-scribe removed from $FILE"
    FOUND=1
  fi
done

if [ "$FOUND" -eq 0 ]; then
  echo "session-scribe is not installed."
  exit 0
fi

echo ""
echo "Done. Session Scribe has been uninstalled."
