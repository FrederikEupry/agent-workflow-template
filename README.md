# Claude workflow scaffold

The project setup I use for AI-assisted development, packaged so you can drop it into any repo. It gives Claude (or Cursor, Cline, Aider — anything AGENTS.md-compatible) persistent memory across sessions and a gated process for making changes.

Three parts:

- **AGENTS.md** — the process spec. Session startup, the PLAN → BUILD → DIFF → QA → APPROVAL → APPLY → DOCS state machine, approval gates, budgets, compaction recovery.
- **CLAUDE.md** — reasoning style. Plan mode by default, subagents for research, verify before claiming done, capture lessons after corrections.
- **memory-bank/** — the agent's only persistent memory. Project brief, architecture patterns, tech context, active work, decisions, plus a monthly task log. Sessions start by reading it and end by updating it.

Skills in `.claude/skills/` travel with the repo, so anyone who clones the project gets the same commands.

## Setup

### New project

```bash
git clone https://github.com/FrederikEupry/agent-workflow-template.git my-project
cd my-project
rm -rf .git && git init
```

Open it in Claude Code and run `/init-project`. The folder is empty, so it interviews you (name, goals, users, stack, constraints) and fills the memory bank from your answers.

### Existing project

```bash
git clone https://github.com/FrederikEupry/agent-workflow-template.git
./agent-workflow-template/install.sh /path/to/your/project
```

The installer copies the workflow files and skips anything that already exists, so your current CLAUDE.md or docs are safe. Then open the project in Claude Code and run `/init-project`. With code present, it analyzes the repo instead of interviewing you: it sweeps the codebase with subagents, fills the memory bank with cited facts, and only asks you what the code can't answer (vision, users, non-goals).

## Daily use

| You type | What happens |
|---|---|
| `startup` | Activates the flow: compliance statement, memory bank loaded, lessons reviewed |
| `/init-project` | Bootstraps the structure (once per project) |
| `/document` | Runs the DOCS state: task doc, monthly README, memory-bank updates |
| `/lesson` | Captures a correction into `tasks/lessons.md` so it doesn't happen twice |

The state machine does the rest. Claude plans, you approve, it builds and tests, you approve again, then it applies and documents. Nothing is applied and nothing is documented without your explicit go-ahead.

## What's in the memory bank

See `memory-bank/toc.md` for the full table. The short version: `projectbrief.md` holds vision and goals, `systemPatterns.md` holds architecture and the trap encyclopedia, `activeContext.md` holds what's in flight right now, and `memory-bank/tasks/YYYY-MM/` holds a dated doc per completed task. Template files carry `<!-- init-project: ... -->` comments telling the init skill what belongs where; they're removed on init.

## Honest caveat

The memory bank is only as good as its upkeep. If you skip `/document` after tasks, `activeContext.md` drifts from reality and the next session starts on stale ground. The workflow front-loads that discipline; it doesn't remove the need for it.

## Reference

Structure taken from a live project (an MCP server for our data warehouse) where it has run since 2026-08. AGENTS.md is v2.2 and self-contained; everything the agent needs to follow the process is in that one file.
