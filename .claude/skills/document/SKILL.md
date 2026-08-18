---
name: document
description: Run the DOCS state from AGENTS.md — write the task doc, update the monthly README and relevant memory-bank files. Use when the user says "document it", "document this task", or after an approved task needs its documentation.
---

# Document

Execute the DOCS state (AGENTS.md §4) for the task just completed.

## Precondition

DOCS runs only after the user approved the code changes (APPROVAL state passed). If there is no approved task in this conversation, ask which completed work to document — do not document unapproved changes.

## Steps

1. **Task doc**: create `memory-bank/tasks/YYYY-MM/YYMMDD_task-name.md` using the template in AGENTS.md §DOCS (Objective, Outcome, Files Modified, Patterns Applied, Integration Points, Architectural Decisions, Artifacts). Cite `file:line` for code and `file.md#Section` for memory-bank references.
2. **Monthly README**: append the task to `memory-bank/tasks/YYYY-MM/README.md` (create the month folder + README if this is the month's first task).
3. **Conditional memory-bank updates** — only when true, per AGENTS.md §6:
   - New pattern discovered → `systemPatterns.md` and/or `projectRules.md`
   - Architectural decision made → `decisions.md` (ADR format)
   - Major feature completed → `progress.md`
   - New memory-bank file created → `toc.md`
4. **Active context**: add/refresh the entry in `activeContext.md` (newest first) so the next session picks up where this one ended.
5. Report what was written, as a list of file paths.

## Rules

- Minor bug fixes get a task doc only; skip pattern/decision updates (AGENTS.md §6 "When to Update MB").
- Filename date format is `YYMMDD` (e.g. `260818_deal-engagements.md`), matching AGENTS.md examples.
- Never invent test counts, coverage numbers, or outcomes — copy them from the actual QA output in the conversation, or omit the line.
