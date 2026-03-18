# session-scribe

**Every AI coding session remembers itself.**

One install. Zero config. No dependencies. No app to run. The knowledge compounds automatically across every session, every terminal, every project.

---

## The Problem

Your AI coding tool forgets everything when the session ends.

Monday morning, you start a new session:

```
You: "fix the auth bug"
AI:  "Can you tell me more? What file? What error? What have you tried?"
You: "uhh... I fixed this last week... it was in the middleware I think..."

    20 min re-explaining context you already gave last week.
    AI re-discovers the same fix.
    45 min total.
```

You've done this before. The AI has done this before. Neither of you remembers.

## The Fix

Install session-scribe. Same Monday morning:

```
You: "fix the auth bug"
AI:  "Found it. You fixed a similar issue on March 12 —
      off-by-one in the sliding window. Same file, line 42.
      Applying the same pattern now."

    5 min total.
```

The AI remembered because session-scribe told it to.

---

## Install

```bash
git clone https://github.com/manolitnora/session-scribe.git
cd session-scribe
chmod +x install.sh && ./install.sh
```

That's it. Every session from now on auto-documents.

### What the installer does

1. Detects which AI coding tool you use (Claude Code, Cursor, Windsurf, etc.)
2. Appends one paragraph of instructions to your tool's config file
3. Done. No background process. No server. No account.

### Verify it's working

Open a new terminal, start your AI tool, and ask:

```
"What do you know about session-scribe?"
```

If it describes the session-scribe protocol, it's active.

---

## How It Works

session-scribe adds one paragraph to your AI tool's config file. That paragraph creates a closed loop:

```
     START SESSION
          |
          v
     RECALL -----> checks memory for anything related
          |        to what you're working on. Surfaces
          |        past SOPs, dead ends, lessons.
          v
     WORK -------> you work normally, nothing changes
          |
          v
     DOCUMENT ---> AI automatically saves:
          |        - SOPs (steps to reproduce what was done)
          |        - Dead ends (what failed and why)
          |        - Lessons learned (non-obvious discoveries)
          |        - Key commands (copy-pasteable, verified)
          v
     MERGE ------> updates existing memory by topic,
          |        never creates per-session files
          |
          +------> loops back to RECALL next session
```

Each session makes the next one faster. The knowledge compounds. You do nothing.

---

## What It Saves (and Why)

session-scribe captures 4 types of knowledge:

### SOPs (Standard Operating Procedures)
**"How do I redo this?"**

Numbered steps someone could follow to reproduce the work. Next time you or a teammate needs to do the same thing, the AI gives you the exact steps instead of figuring it out from scratch.

```
SOP: Deploy to staging
1. npm run build
2. docker push registry/app:latest
3. kubectl rollout restart deployment/app
4. Verify: curl https://staging.example.com/health
```

### Dead Ends
**"What should I NOT try?"**

Things that were attempted and failed, with the reason why. This is the highest-value memory — it prevents you from wasting time walking into the same trap twice.

```
Dead end: Don't use middleware for CORS on this project.
The route handler needs OPTIONS directly because the
middleware runs after auth, which rejects preflight requests.
```

### Lessons Learned
**"What's non-obvious here?"**

Discoveries that aren't in the docs, aren't in Stack Overflow, and you'd only know from experience. The kind of thing a senior dev tells you over coffee.

```
Lesson: The payments API has maintenance windows on Thursdays
7-9pm UTC. Requests don't fail — they return stale data.
Always check the response timestamp.
```

### Key Commands
**"Give me the copy-paste."**

The exact commands that worked, ready to run again. No googling the same flags, no trying to remember the syntax. Your personal, tested, proven command library.

```
Key commands:
$ lsof -ti :8085 | xargs kill -9        # kill stale daemon
$ npm run test -- --grep "rate"          # run rate limiter tests only
$ curl -s localhost:8085/api/status | jq '.'  # check daemon health
```

---

## Safety

### What it will NOT do

- **Never saves secrets, API keys, tokens, or credentials.** This is explicitly forbidden in the instruction.
- **Never silently modifies or deletes existing memories.** If the AI thinks a past memory should change, it shows you the proposed change and waits for your approval. This protects you and any teammates sharing the same workspace.
- **Never creates per-session files.** Memory is merged by topic so it stays organized and doesn't bloat.
- **Never sends data anywhere.** Everything stays in local markdown files on your machine.

### Memory limits

The instruction caps total entries at 50. When a new entry is added, the least useful existing entry is replaced. This prevents unbounded growth — your memory stays lean and relevant.

---

## Works With

| Tool | Config file | Auto-detected |
|------|-------------|:---:|
| Claude Code (global) | `~/.claude/CLAUDE.md` | Yes |
| Claude Code (project) | `.claude/CLAUDE.md` | Yes |
| Cursor | `.cursorrules` | Yes |
| Windsurf | `.windsurfrules` | Yes |
| GitHub Copilot | `.github/copilot.md` | Yes |
| Cline | `.clinerules` | Yes |
| Continue | `.continuerules` | Yes |

The installer checks for these config files in order and appends to the first one it finds. If none exist, it creates `~/.claude/CLAUDE.md` (Claude Code global config).

**One install covers all terminals.** Global config files (like `~/.claude/CLAUDE.md`) are read by every instance of the tool, across every terminal window, every project, automatically.

---

## Multiple Terminals

session-scribe works across all your terminal windows simultaneously. If you have 5 tabs running Claude Code, all 5 have session-scribe active. No per-tab setup.

```
Tab 1 (fixing auth)     — session-scribe active
Tab 2 (writing tests)   — session-scribe active
Tab 3 (debugging deploy) — session-scribe active
```

This works because the config file is global — every instance reads the same file on every message.

---

## Teams

If your team shares a project workspace, session-scribe works across team members:

- One person figures out a tricky deploy process and their AI saves the SOP
- Next person on the team asks about deploying — their AI surfaces the SOP immediately
- The modify/delete approval rule prevents one person's AI from silently overwriting another person's memories

To share memories across a team, commit the memory folder to your repo:

```bash
git add .claude/projects/*/memory/
git commit -m "shared session-scribe memories"
```

Now everyone's AI learns from everyone's sessions.

---

## Integrations

session-scribe saves knowledge as plain markdown files in a folder. Any tool that reads files can use them.

| Tool | How |
|------|-----|
| **Obsidian** | Point your vault at the memory folder. Browse SOPs with backlinks and graph view. |
| **n8n / Make.com** | Watch the memory folder for changes. Trigger automations when new SOPs are saved. |
| **Slack** | Use n8n to post new SOPs to an engineering channel automatically. |
| **Telegram** | Get a notification on your phone when a new lesson is saved. |
| **Notion** | Sync the memory folder to a Notion database via API. |
| **Git** | Commit the memory folder. Team shares knowledge through version control. |

No plugins or integrations needed. It's just markdown files in a folder — the most universal format there is.

---

## More Examples

### Connecting tools and services
```
You: "connect the Slack MCP server"
AI:  "You set this up on March 10. Here's the SOP:
      1. npm install @slack/mcp-server
      2. Add config to settings.json
      3. Set SLACK_TOKEN in .env
      4. Restart Claude Code
      The gotcha: token needs chat:write AND channels:read
      scopes. You missed channels:read the first time.
      Want me to run through these steps?"
```

### Recurring problems
```
You: "the daemon won't start"
AI:  "This matches a known pattern from your dead ends —
      stale process on port 8085. Running:
      lsof -ti :8085 | xargs kill -9
      Fixed. This is the 3rd time — consider adding it
      to the preflight check."
```

### Onboarding a teammate
```
Teammate: "how do I set up the dev environment?"
AI:       "Found an SOP for this. Here are the steps:
           1. Clone the repo
           2. cp .env.example .env
           3. Fill in API keys (see 1Password vault)
           4. npm install && npm run dev:daemon
           5. Verify: curl localhost:8085/api/status
           Known gotcha: run 'brew install jq' first,
           the status check needs it."
```

### Remembering decisions
```
You: "should we use Redis or in-memory cache?"
AI:  "You evaluated this on Feb 20. Lesson learned:
      in-memory was chosen because the dataset fits in
      RAM and Redis added 3ms latency per call. The
      tradeoff: cache is lost on restart, but the cold
      start rebuild takes <5 seconds from the vault."
```

---

## FAQ

**Do I need to do anything during a session?**
No. session-scribe is fully autonomous. Just work normally. The AI recalls at the start and documents at the end without being asked.

**Does it cost anything?**
No. It uses the AI that's already running in your terminal. No extra API calls, no subscriptions.

**Does it slow anything down?**
No. It's a paragraph of text in a config file, not a running program.

**Does it send data anywhere?**
No. Everything stays in local markdown files on your machine.

**Will it save my passwords or API keys?**
No. The instruction explicitly forbids saving secrets, keys, tokens, or credentials.

**Can it accidentally delete my notes?**
No. The instruction requires approval before modifying or removing any existing memory entry.

**What if my memory files get too big?**
The instruction caps entries at 50 and replaces the least useful when adding new ones.

**Does it work if I use multiple AI tools?**
The installer appends to the first config file it finds. If you use multiple tools, run the installer from different project directories or manually append the instruction block to each tool's config file.

**Does it work across terminal windows?**
Yes. Global config files are read by every instance of the tool. All terminals share the same session-scribe instruction and the same memory.

**How do I know it's working?**
Start a new session and ask: "What do you know about session-scribe?" If the AI describes the protocol, it's active.

**Can I see what it saved?**
Yes. Memory files are plain markdown. For Claude Code, check `~/.claude/projects/*/memory/`. Open them in any text editor, Obsidian, or VS Code.

**Does my team need to install it separately?**
Each person installs once on their machine. To share memories, commit the memory folder to your shared repo.

---

## How is this different from...

| Approach | Problem session-scribe solves |
|----------|-------------------------------|
| **RAG / Vector databases** | RAG retrieves similar text. session-scribe retrieves knowledge that matters — SOPs, dead ends, lessons. No infrastructure needed. |
| **Agent memory frameworks** (LangChain, MemGPT) | Hundreds of lines of code that need maintenance. session-scribe is one paragraph that works forever. |
| **Shell history** | History shows commands with no context. session-scribe shows commands with *why they worked* and *what failed first*. |
| **Taking notes manually** | Requires discipline and adds cognitive load. session-scribe is fully autonomous — you don't think about it. |
| **Long context windows** | Context dies when the session ends. session-scribe persists knowledge across sessions permanently. |

---

## Uninstall

```bash
cd session-scribe
./uninstall.sh
```

Cleanly removes the session-scribe instruction block from your config file. Everything else in the file is untouched. Your existing memory files are preserved.

---

## Philosophy

The AI already has intelligence. It already has memory. It already has context. Nobody thought to just ask it to use them together.

The entire product is one paragraph of English. Not code — instructions. The AI interprets them, follows them, and gets smarter every session.

The best tool is the one you never think about. session-scribe installs in 10 seconds and disappears. The AI does the rest.

---

## License

MIT
