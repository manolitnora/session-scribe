# Instruction Architecture

## Why session-scribe has no code

session-scribe is a paragraph, not a program. It works because of a paradigm shift that most developers haven't internalized yet:

**You don't need to code behaviors that an LLM can infer from instructions.**

## Code vs Instructions

| | Code | Instructions |
|---|---|---|
| **What you define** | Every behavior, every edge case | The goal and the rules |
| **Edge cases** | You write if/else for each one | The LLM handles them |
| **When something unexpected happens** | It breaks | It adapts |
| **Maintenance** | You maintain it | It maintains itself |
| **What it does** | Exactly what you wrote | What you meant |
| **Effort** | 100 lines for 1 behavior | 1 sentence for 10 behaviors |

### Example: Memory cleanup

**As code:**
```typescript
interface DecayableKnowledge {
    content: string;
    type: 'dead-end' | 'lesson' | 'sop' | 'command';
    gravity: number;
    createdAt: number;
    lastReinforced: number;
    reinforcements: number;
    decayRate: number;
}

function effectiveGravity(k: DecayableKnowledge): number {
    const daysSinceReinforced = (Date.now() - k.lastReinforced) / 86400000;
    return k.gravity * Math.pow(k.decayRate, daysSinceReinforced);
}

function evict(entries: DecayableKnowledge[], cap: number): DecayableKnowledge[] {
    if (entries.length <= cap) return entries;
    return entries
        .sort((a, b) => effectiveGravity(b) - effectiveGravity(a))
        .slice(0, cap);
}
```
20+ lines. Needs a runtime. Needs tests. Needs maintenance. Breaks when requirements change.

**As an instruction:**
```
Keep total entries under 50. When adding a new entry, replace the
one with the oldest last_used date.
```
Two sentences. Claude invents the audit, the compliance check, the slot counter, and the cleanup process on its own. You never coded any of that. You didn't even ask for it.

## The pattern

Building with instructions follows a simple pattern:

```
1. What can the LLM already do?
   (read files, write files, search, reason, remember)

2. What doesn't it do automatically?
   (remember across sessions, document its work, prune old knowledge)

3. Write the instruction that bridges the gap.
   (one paragraph in a config file)

4. The LLM fills in everything you didn't say.
   (auditing, self-healing, compliance, edge case handling)
```

## What happened with session-scribe

We wrote this instruction:

```
On every turn: save SOPs, dead ends, lessons, and key commands.
Add last_used dates. Keep under 50 entries. Replace oldest when full.
```

Without being asked, Claude then:
- Audited all memory files for missing `last_used` fields
- Found 11/11 files non-compliant
- Fixed all 11 files
- Found the memory index was bloated with code-derivable content
- Pruned it from 180 lines to a slim index
- Reported remaining capacity (39/50 slots)
- Offered to continue maintaining compliance

None of that was coded. None of it was requested. The instruction set a standard, and the LLM figured out what compliance looks like and enforced it.

## When to use instructions vs code

**Use instructions when:**
- The LLM already has the capability (read, write, search, reason)
- The behavior needs to adapt to context
- Edge cases are hard to enumerate
- The "logic" is really just judgment
- You want the system to self-improve

**Use code when:**
- You need deterministic, exact behavior (cryptography, math)
- The LLM doesn't have the capability (GPU compute, network calls)
- Performance matters (sub-millisecond operations)
- You need auditability (regulatory compliance)
- The behavior must be identical every time regardless of context

## The bigger idea

Most "AI agent" frameworks are code that orchestrates an LLM. They wrap intelligence in rigid structure:

```
Code Framework:
  Python → LangChain → Prompt Template → LLM → Output Parser → Code

  You're writing code to talk to intelligence.
```

Instruction Architecture removes the wrapper:

```
Instruction:
  English → LLM → Action

  You're talking directly to intelligence.
```

The framework, the parser, the orchestrator — the LLM can be all of those if you let it. The only thing it can't be is the config file that holds the instruction. That's what session-scribe is. A config file. One paragraph. The LLM does the rest.

## How to apply this

If you're building a tool for an LLM-powered environment:

1. **Start with an instruction, not code.** Write what you want in plain English.
2. **Test it.** Does the LLM follow it? Does it fill in the gaps?
3. **Strengthen the wording if needed.** "Do this" is weaker than "This is not optional. Do this on every turn."
4. **Only write code for what the instruction can't cover.** Deterministic operations, external integrations, performance-critical paths.
5. **Let the LLM surprise you.** It will do things you didn't ask for but obviously needed. That's not a bug. That's the point.

The question isn't "how do I build this agent." The question is "can I just tell it what to do instead?"

Usually, yes.
