# CLAUDE.md

Activate flow when user writes "startup".

## Required Reading

Before starting any task, read **AGENTS.md** in the repo root. It contains the canonical rules for:
- Memory Bank structure and the `memory-bank/` directory
- Session startup protocol (compliance statement, MB loading)
- State machine: PLAN → BUILD → DIFF → QA → APPROVAL → APPLY → DOCS
- Compaction protocol and continuous state persistence
- Task contract format, budgets, stall detection

AGENTS.md governs *how* we work. This file (CLAUDE.md) governs *how I think* while working. Both apply. If they ever conflict, AGENTS.md wins on process and gating, CLAUDE.md wins on reasoning style.

<!-- init-project: optional reporting-style rule goes here, e.g.:
**Only report to me in ASD-STE100 Simplified Technical English.**
Remove this comment after init. -->

## Workflow Orchestration

### 1. Plan Mode Default
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy
- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One task per subagent for focused execution

### 3. Self-Improvement Loop
- After ANY correction from the user: update memory-bank/lessons.md with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done
- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)
- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes -- don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fixing
- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests -- then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Write plan to memory-bank/todo.md with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to memory-bank/todo.md
6. **Capture Lessons**: Update memory-bank/lessons.md after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Only touch what's necessary. No side effects with new bugs.
