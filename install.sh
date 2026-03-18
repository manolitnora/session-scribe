#!/bin/bash
set -e

SCRIBE_BLOCK='
<!-- SESSION-SCRIBE:START -->
## Session Scribe

**On session start:** Scan memory for anything related to the current task.
If a past SOP, dead end, or lesson is relevant, surface it immediately
before beginning work.

**On session end:** Update memory files with:
- New SOPs (numbered steps to reproduce what was done)
- Dead ends (what failed first and why)
- Lessons learned (non-obvious discoveries)
- Key commands (copy-pasteable, verified working)

Rules:
- Merge into existing memory files by topic. Never create per-session files.
- Keep total entries under 50. Replace the least useful when adding new.
- Never save secrets, API keys, tokens, or credentials.
- Adding new entries: do automatically without asking.
- Modifying or removing existing entries: show what you want to change and wait for approval. Another person or session may depend on it.
- Do session-start recall automatically without asking.
<!-- SESSION-SCRIBE:END -->'

# Detect AI tool config file
TARGET=""
TOOL=""

if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  TARGET="$HOME/.claude/CLAUDE.md"
  TOOL="Claude Code (global)"
elif [ -f ".claude/CLAUDE.md" ]; then
  TARGET=".claude/CLAUDE.md"
  TOOL="Claude Code (project)"
elif [ -f ".cursorrules" ]; then
  TARGET=".cursorrules"
  TOOL="Cursor"
elif [ -f ".windsurfrules" ]; then
  TARGET=".windsurfrules"
  TOOL="Windsurf"
elif [ -f ".github/copilot.md" ]; then
  TARGET=".github/copilot.md"
  TOOL="GitHub Copilot"
elif [ -f ".clinerules" ]; then
  TARGET=".clinerules"
  TOOL="Cline"
elif [ -f ".continuerules" ]; then
  TARGET=".continuerules"
  TOOL="Continue"
else
  # Default: create Claude Code global config
  mkdir -p "$HOME/.claude"
  TARGET="$HOME/.claude/CLAUDE.md"
  TOOL="Claude Code (global, created)"
fi

# Check if already installed
if grep -q "SESSION-SCRIBE:START" "$TARGET" 2>/dev/null; then
  echo "session-scribe is already installed in $TARGET"
  exit 0
fi

# Append the instruction block
echo "$SCRIBE_BLOCK" >> "$TARGET"

echo "session-scribe installed -> $TARGET ($TOOL)"
echo ""
echo "Every AI coding session will now auto-document."
echo "Uninstall: ./uninstall.sh"
