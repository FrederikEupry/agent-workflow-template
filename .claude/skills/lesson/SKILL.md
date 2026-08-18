---
name: lesson
description: Capture a correction or hard-won rule into tasks/lessons.md. Use after the user corrects the agent, or when the user says "lesson", "remember this", or "never do that again".
---

# Lesson

Append one entry to `tasks/lessons.md` capturing a pattern that prevents a repeat mistake.

## Steps

1. Identify the correction: what did the agent do, what did the user correct it to, and what general rule prevents the same class of mistake (not just this instance).
2. Append to `tasks/lessons.md`, newest first, in the established format:
   ```
   - **YYYY-MM-DD — [Rule in one bold sentence.]** [One or two sentences: what went wrong and what the rule prevents.]
   ```
   Use `**Standing — [Rule]**` for always-on principles rather than dated incidents.
3. If the lesson is architectural or codified as a hard project rule, also add it to `memory-bank/projectRules.md` under "Hard rules (incident-backed)" — with the user's approval, since that file is approval-gated per AGENTS.md §6.
4. Read the entry back to the user in one line.

## Rules

- One lesson per entry. If the correction contains two rules, write two entries.
- The rule must be actionable by a future session with zero conversation context.
- Do not editorialize or soften: state the rule the way the user enforced it.
