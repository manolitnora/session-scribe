#!/bin/bash
set -e

SCRIBE_BLOCK='
<!-- SESSION-SCRIBE:START -->
## Session Scribe (ALWAYS ACTIVE)

This is not optional. Follow these rules on EVERY turn, not just at session start or end.

**On first message:** Scan memory for anything related to the current task.
If a past SOP, dead end, or lesson is relevant, surface it immediately
before beginning work.

**On every turn:** When any of these happen, save to memory immediately — do not wait:
- You discover a fix or working solution → save as SOP
- Something fails or a wrong approach is tried → save as dead end
- You learn something non-obvious → save as lesson
- A command works and is worth reusing → save as key command
- The user corrects you → save as feedback

**What to save:**
- SOPs (numbered steps to reproduce what was done)
- Dead ends (what failed first and why)
- Lessons learned (non-obvious discoveries)
- Key commands (copy-pasteable, verified working)

**Memory decay:**
- When saving, add a `last_used: YYYY-MM-DD` date to each entry.
- When recalling a memory, update its `last_used` to today.
- When adding a new entry and at the 50 cap, replace the entry with the oldest `last_used` date. Knowledge that keeps getting used survives. Knowledge that never gets recalled again fades out naturally.

**Rules:**
- Merge into existing memory files by topic. Never create per-session files.
- Keep total entries under 50. Evict by oldest `last_used` when full.
- Never save secrets, API keys, tokens, or credentials.
- Adding new entries: do automatically without asking.
- Modifying or removing existing entries: show what you want to change and wait for approval. Another person or session may depend on it.
<!-- SESSION-SCRIBE:END -->'

# Detect Claude Code config file
TARGET=""
TOOL=""

if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  TARGET="$HOME/.claude/CLAUDE.md"
  TOOL="Claude Code (global)"
elif [ -f ".claude/CLAUDE.md" ]; then
  TARGET=".claude/CLAUDE.md"
  TOOL="Claude Code (project)"
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
echo "Every Claude Code session will now auto-document."
echo "Uninstall: ./uninstall.sh"
