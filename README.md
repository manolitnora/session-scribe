# session-scribe

Every AI coding session remembers itself.

One install. Zero config. No dependencies. The knowledge compounds automatically.

## Install

```bash
git clone https://github.com/you/session-scribe.git
cd session-scribe
chmod +x install.sh && ./install.sh
```

## What it does

Your AI coding tool already has the intelligence. session-scribe just tells it to use it.

- **On session start** — surfaces relevant SOPs, past dead ends, and lessons before you begin
- **On session end** — automatically saves what was done, what failed, and what was learned
- **Over time** — knowledge compounds, sessions get faster, mistakes don't repeat

## Before and after

**Without session-scribe:**
```
You: "fix the auth bug"
AI:  "Can you tell me more? What file? What error?"
You: "uhh I fixed this last week... it was in the middleware..."

    20 min re-explaining. 45 min total.
```

**With session-scribe:**
```
You: "fix the auth bug"
AI:  "Found it. You fixed a similar issue on March 12 —
      off-by-one in the sliding window. Same file, line 42.
      Applying the same pattern now."

    5 min total.
```

## How it works

It appends one paragraph to your AI tool's config file. That paragraph tells the AI to:

1. Check its memory before starting work
2. Save what it learned before ending work
3. Merge by topic, not by session — so knowledge compounds

No app. No server. No database. The AI documents itself using its own intelligence.

## Works with

| Tool | Config file | Status |
|------|-------------|--------|
| Claude Code | `~/.claude/CLAUDE.md` | Auto-detected |
| Cursor | `.cursorrules` | Auto-detected |
| Windsurf | `.windsurfrules` | Auto-detected |
| GitHub Copilot | `.github/copilot.md` | Auto-detected |
| Cline | `.clinerules` | Auto-detected |
| Continue | `.continuerules` | Auto-detected |

The installer detects which tool you use and appends to the right file.

## Uninstall

```bash
./uninstall.sh
```

Cleanly removes the instruction block. Your config file is unchanged otherwise.

## FAQ

**Does it cost anything?**
No. It uses the AI that's already running in your terminal.

**Does it send data anywhere?**
No. Everything stays in local markdown files.

**Will it save my API keys?**
No. The instruction explicitly forbids saving secrets, keys, or credentials.

**Does it slow anything down?**
No. It's a paragraph of text, not a program.

**What if my memory files get too big?**
The instruction caps entries at 50 and replaces the least useful when adding new ones.

## Philosophy

The best tool is the one you don't have to think about. session-scribe adds one paragraph to your config and disappears. The AI does the rest.

## License

MIT
