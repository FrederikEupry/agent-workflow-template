# WORKFLOW.md

**Version**: 3.0 (2026-08-20) | **Status**: Canonical process spec for AI-assisted development

This file is tool-agnostic and is never read directly by any tool. The tool's entry file points here:
- **Claude Code** reads `CLAUDE.md`.
- **Codex / Cursor / Cline / Aider** read `AGENTS.md` — an identical copy of `CLAUDE.md`.

Both entry files say "read WORKFLOW.md first". An edit to one entry file must be mirrored in the other.

---

## Table of Contents

1. [Compliance & Core Rules](#1-compliance--core-rules)
2. [Session Startup](#2-session-startup)
3. [Memory Bank](#3-memory-bank)
4. [State Machine](#4-state-machine)
5. [Task Contract & Stall Detection](#5-task-contract--stall-detection)
6. [Quality & Documentation](#6-quality--documentation)

---

## 1. Compliance & Core Rules

### Startup Confirmation (Output Every Session)

One line, nothing more:

```
WORKFLOW v3 LOADED: reuse over creation | mode: fast|standard|deep
```

### The Four Sacred Rules

| Rule | Requirement | Validation |
|------|-------------|------------|
| ❌ **No new files without reuse analysis** | Search codebase, reference files that cannot be extended, provide exhaustive justification | Before creating: "Analyzed X, Y, Z. Cannot extend because [technical reason]" |
| ❌ **No rewrites when refactoring possible** | Prefer incremental improvements, justify why refactoring won't work | "Refactoring X impossible because [specific limitation]" |
| ❌ **No generic advice** | Cite `file:line`, show concrete integration points, include migration strategies | Every suggestion includes `file:line` citation |
| ❌ **No ignoring existing architecture** | Load patterns before changes, extend existing services/components, consolidate duplicates | "Extends existing pattern at `file:line`" |

### Reuse Validation Checklist (Before Creating Files)

```markdown
- [ ] Searched: [search terms] → found: [list files]
- [ ] Analyzed extension:
  - [ ] `existing/file1.ext` - Cannot extend: [specific technical reason]
  - [ ] `existing/file2.ext` - Cannot extend: [specific technical reason]
- [ ] Checked patterns: `systemPatterns.md#[section]`
- [ ] Justification: New file needed because [exhaustive reasoning]
```

### Non-Negotiables

- **Approval Gates**: No file changes applied without explicit user approval (Fast Track skips the PLAN gate only — never APPROVAL; see Section 4)
- **Citations**: Always `file:line` for code, `file.md#Section` for Memory Bank
- **Sandbox First**: All edits in branch/temp clone, never main
- **MCP Preferred**: Use MCP servers for memory, repo ops, QA over brute-force context
- **No Mock Data**: Never fake/simulated data in production; never stub functions
- **Context Engineering**: Keep working context focused on current task

---

## 2. Session Startup

### Load Priority (Choose Based on Task Complexity)

**Every Session** (mandatory):
1. Output startup confirmation (Section 1)
2. Attach MCP servers: Read `.mcp.json` if present
3. Load Memory Bank per mode below

**Fast Track** (bug fixes, small changes):
```
- [ ] Load current month README: `memory-bank/tasks/YYYY-MM/README.md`
- [ ] Check recent achievements and next priorities
- [ ] Load `lessons.md` and `quick-start.md` if needed
```

**Standard Discovery** (features, tests, quality-critical work):
```
- [ ] Current month README
- [ ] Core files: projectbrief.md, systemPatterns.md, techContext.md, activeContext.md, progress.md
- [ ] lessons.md
- [ ] Scan docs/ for recent updates
- [ ] Verify toc.md and activeContext.md current
```

**Deep Dive** (architecture, legacy investigation):
```
- [ ] Standard Discovery files
- [ ] Specific month README when investigating legacy
- [ ] decisions.md for architectural context
- [ ] Cross-reference with current work patterns
```

### Compaction Protocol (Mid-Session Context Preservation)

Compaction (context compression) can happen at any time — triggered by the system, by the user via `/compact`, or by platform-level context management. **The agent does not control compaction timing and gets no advance notice.** Therefore state persistence must be continuous, not deferred to a pre-compaction moment.

#### Continuous State Persistence (At Every State Transition)

At each state transition (`PLAN → BUILD → DIFF → QA → APPROVAL → APPLY → DOCS`), persist to the Memory Bank:

1. **State machine position**: Update `activeContext.md` with current state, cycle count, and working context
2. **Task progress**: Append current status to `tasks/YYYY-MM/README.md` with `[IN-PROGRESS]` tag
3. **Decisions**: Append any new architectural decisions to `decisions.md`
4. **Loose context**: Capture anything that exists only in conversation (user preferences, verbal requirements, pending questions) into `activeContext.md`

This ensures that when compaction occurs — without warning — the Memory Bank already reflects the latest state.

#### After Compaction (Recovery)

When context has been compressed (detected by loss of earlier conversation detail, or after `/compact`):

1. Re-enter **Session Startup** using **Fast Track** mode — the Memory Bank was just updated via continuous persistence, so full discovery is unnecessary
2. Confirm state machine position and cycle count from `activeContext.md`
3. Resume from saved state — do not restart the current task from scratch
4. Output recovery confirmation:
   ```
   COMPACTION RECOVERY: Resumed [STATE] for [task name]
   Context restored from: activeContext.md, tasks/YYYY-MM/README.md
   ```

#### Rules

- Persistence happens at every transition, not "before compaction" — you cannot rely on advance notice
- After detecting compaction, always re-read the Memory Bank before taking any action
- If the current state is `APPROVAL` or `DIFF`, the diff summary should already be in `activeContext.md` from the transition save
- Compaction does not reset the cycle count — carry it forward from `activeContext.md`

---

## 3. Memory Bank

### Structure

```
memory-bank/
├── toc.md                    # Index (update after new files/tasks)
├── projectbrief.md           # Vision, goals (rarely change)
├── productContext.md         # User goals, market (quarterly)
├── systemPatterns.md         # Architecture (pattern discovery)
├── techContext.md            # Tech stack (new tech adoption)
├── activeContext.md          # Current sprint (weekly/milestone)
├── progress.md               # Status, blockers (major features)
├── projectRules.md           # Coding standards (new patterns)
├── decisions.md              # ADRs (architectural decisions)
├── quick-start.md            # Common patterns, session data
├── database-schema.md        # Data models (if applicable)
├── build-deployment.md       # Build/deploy procedures
├── testing-patterns.md       # Test strategies
├── todo.md                   # Current plan, checkable items (per task)
├── lessons.md                # Rules learned from corrections (after corrections)
└── tasks/
    ├── YYYY-MM/
    │   ├── README.md         # Monthly summary (month end)
    │   └── DDMMDD_*.md       # Task docs (after approval)
    └── YYYY-MM/README.md
```

### File Reference Table

| File | Purpose | Load When | Update When |
|------|---------|-----------|-------------|
| `toc.md` | Index/navigation | After adding files | After new files/tasks |
| `projectbrief.md` | Core requirements | Complex tasks | Major pivots |
| `productContext.md` | User goals, market | Complex tasks | Quarterly/strategy shifts |
| `systemPatterns.md` | Architecture patterns | Before arch changes | Pattern discovery |
| `techContext.md` | Tech stack decisions | Session start | New tech adoption |
| `activeContext.md` | Current focus | Every session | Weekly/milestones |
| `progress.md` | Current state | Session start | Major features done |
| `projectRules.md` | Coding standards | When uncertain | New patterns emerge |
| `decisions.md` | Why X over Y | Arch decisions | Arch decisions made |
| `todo.md` | Current plan (checkable items) | Every task | Plan written / steps done |
| `lessons.md` | Rules from corrections | Session start | After any correction |
| `tasks/*/README.md` | Monthly summary | Month-specific work | Month end/milestone |
| `tasks/*/*.md` | Task documentation | Investigating issues | After approval only |

### Read vs Write Paths

**Read** (frequent): Session startup, before arch decisions, when uncertain, investigating issues
**Write** (infrequent, requires approval): After major features, pattern discovery, arch decisions, milestone completion, user requests

---

## 4. State Machine

### Overview

**States**: `PLAN → BUILD → DIFF → QA → APPROVAL → APPLY → DOCS`

```
PLAN [approve] → BUILD → DIFF → QA [pass] → APPROVAL [approve] → APPLY → DOCS → END
  ↑               ↑______↓______↓_____[fail/changes]______________↓
  └───────────────────────────────────[major changes needed]─────┘
```

### Fast Track (Small Fixes)

The one sanctioned shortcut. Use it for bug fixes where **all** of these hold:

- A concrete signal exists: failing test, error log, stack trace, or reproduction
- The fix touches ≤ 2 files
- No new files, no architectural change, no schema/API change

**Rules**:
1. Skip the PLAN approval gate. State the diagnosis and intended fix in one short message, then build — do not wait for a reply
2. BUILD → DIFF → QA run autonomously
3. **APPROVAL still applies in full**: present the diff and QA results; do not apply without explicit approval
4. Documentation: task doc only (per Section 6)
5. The moment the fix outgrows any condition above — third file, new file, design question — stop and enter full PLAN

### PLAN

**In**: Task contract + MB context | **Out**: Implementation plan | **Exit**: User approves ("approved", "proceed", "looks good")

**Required Content**:
```markdown
## Plan: [Task Name]

**Analyzed**:
- `path/file.ext:50-100` - Current implementation of X
- `memory-bank/systemPatterns.md#Pattern` - Established pattern for Y

**Reuse Strategy**:
- Extend `file.ext` - Add method for [functionality]
- Cannot reuse [component] because: [specific technical reason]

**Steps**:
1. [Action] - extends pattern at `file:line`
2. [Action] - integrates with [component]
3. [Action] - adds tests mirroring `test.ext`

**Integration**: [Component A] calls via [method] | [Service B] update at `file:line`
**Risks**: [Risk] → mitigation: [approach]
**Tests**: Unit: [scenarios] | Integration: [flows] | Manual: [paths]
```

**Failures**: Insufficient reuse → load more MB | Ambiguous → ask user | Rejected → iterate

### BUILD

**In**: Approved plan (or Fast Track diagnosis) | **Out**: Proposed diff (NOT APPLIED) | **Exit**: All changes complete, diff generated

**Actions**:
1. Work in branch/temp clone (never main)
2. Implement minimal changes achieving the objective, following `projectRules.md`
3. Add tests alongside implementation
4. Generate unified diff — **DO NOT APPLY**

**Context Management**: Keep only task-relevant files in working context. Reference MB as needed. Parallelize independent file operations.

**Failures**: Compilation errors → fix, stay in BUILD | Pattern violations → review `projectRules.md` | Two identical diffs → STALL DETECTED (Section 5)

### DIFF

**In**: BUILD complete | **Out**: Rationale + diff | **Exit**: Ready for QA

**Present**: file stat table, unified diff, rationale per file (with MB references), integration points, new-file justification if any.

**Failures**: Cannot justify new file → return to BUILD, refactor | Missing MB refs → add them

### QA

**In**: DIFF complete | **Out**: Structured test results | **Exit**: Tests pass OR user waiver

**Execute**: test suite, linters, coverage, build verification.

**Report Format**:
```markdown
## QA Results

**Tests**: ✅ PASS | ❌ FAIL | Total: 145 | Passed: 145 | Failed: 0
**Linter**: ✅ PASS | Errors: 0 | Warnings: 2 (non-blocking)
**Coverage**: Overall: 87.3% (+2.1%) | New code: 95.2%
**Build**: ✅ SUCCESS

**Verdict**: ✅ Ready for APPROVAL | ❌ Return to BUILD
```

**Retry Protocol**: 1st fail → minimal fix, re-test. 2nd fail → re-analyze approach, fix, re-test. 3rd fail → **STALL DETECTED** (Section 5).

### APPROVAL (HUMAN GATE)

**In**: QA passed | **Out**: User decision | **Exit**: User approves explicitly

**Present**:
```markdown
## Ready for Approval

**Files modified**: [list with +/- line counts]
**Test Results**: [one-line QA summary]
**Review Gates**: ✅ Tests | ✅ Security (Section 6 checklist) | ✅ Linter | ✅ Documentation plan

**Please review. Reply with**:
- "approved" | "looks good" | "document it" → APPLY
- "change X" | "fix Y" → Return to BUILD
- "revert" → Discard all changes
```

**Failures**: Ambiguous response → ask for explicit approval | Gates not passing → warn, request waiver | Long wait → do not proceed

### APPLY

**In**: User approved | **Out**: Changes applied or rollback | **Exit**: Applied successfully OR rolled back

**Actions**: Apply to sandbox branch → verify → optional smoke test → report. On failure: roll back to previous state, diagnose, return to BUILD. If rollback itself fails: **CRITICAL** → user intervention.

### DOCS

**In**: APPLY succeeded + user approved code | **Out**: Task docs, MB updates | **Exit**: All docs complete

**CRITICAL**: Only enter after user approved code changes (from APPROVAL state).

**Create**:
1. Task doc: `memory-bank/tasks/YYYY-MM/DDMMDD_task-name.md`
2. Update monthly README: `memory-bank/tasks/YYYY-MM/README.md`
3. Update `projectRules.md` if new patterns
4. Update `decisions.md` if arch decisions
5. Update `toc.md` if new MB files

**Task Doc Template**:
```markdown
# YYMMDD_task-name

## Objective
[What was accomplished]

## Outcome
- ✅ Tests: 145 passing (+10 new)
- ✅ Coverage: 87.3% (+2.1%)
- ✅ Review: Approved

## Files Modified
- `file1.ext` - Added [functionality]

## Patterns Applied
- `systemPatterns.md#Pattern`

## Integration Points
- `component.ext:45` via new method

## Architectural Decisions
- Decision: [what] | Rationale: [why] | Trade-offs: [costs/benefits]

## Artifacts
- PR: [link] | Diff: [link]
```

**Monthly README entry**:
```markdown
### YYYY-MM-DD: [Task Name]
- Implemented [brief description]
- Files: `file1.ext`, `file2.ext`
- See: [DDMMDD_task-name.md](./DDMMDD_task-name.md)
```

**decisions.md entry**:
```markdown
### YYYY-MM-DD: [Decision]
**Status**: Approved
**Context**: [why needed]
**Decision**: [what decided]
**Alternatives**: [other options, why not]
**Consequences**: [positive/negative outcomes]
**References**: `tasks/YYYY-MM/DDMMDD_task-name.md`
```

---

## 5. Task Contract & Stall Detection

### Task Contract Format

```markdown
## Task: [Clear, specific objective]

### Context
- **Repository**: [path or monorepo location]
- **Related Work**: [prior tasks, MB entries]
- **Constraints**: [arch rules, security, performance]

### Expected Outcomes
- **Acceptance Criteria**: [specific, testable criteria]
- **Definition of Done**: [when truly complete]

### Architectural Constraints
- **Must Follow**: [patterns from MB] | **Must Extend**: [existing files] | **Must Not**: [anti-patterns]

### Instructions
Create outline for approval. After approval, do work. Do not document until I approve completion.
```

### Cycle Limit

Max **3** BUILD → QA iterations per task. Track the count in `activeContext.md` at each transition. Exceeding it is a stall.

### Stall Detection

**Conditions**: Two consecutive identical diffs (same files, same changes) OR 3 failed BUILD → QA cycles.

**Response**: Halt all BUILD attempts and report:
```markdown
## STALL DETECTED

**Diagnosis**: [specific technical cause]
**Attempted**: [what was tried]
**Blocker**: [what prevents progress]

**Recommendations**:
1. More Context: Load [specific MB files/codebase areas]
2. Alternative: [different technical strategy]
3. Agent Swap: Switch to [specialized agent] for subtask

**Request**: Provide direction or choose a recommendation
```

### Context Management

**Zones**: Core (task contract, relevant MB, current state — always) | Task (files being modified — current task only) | Reference (patterns, history — on demand).

**Rotation**: After each state transition, drop Task context and reload only what the next state needs. State is persisted at every transition per Section 2, so compaction recovery is automatic.

**Parallel Execution**: Decompose into independent subtasks, spawn parallel agents with focused context, then integrate.

---

## 6. Quality & Documentation

### Absolute Prohibitions

| Prohibition | Consequence |
|-------------|-------------|
| ❌ No fake/simulated/mock data in production code | Rollback + restart |
| ❌ No stubbed functions marked complete | Rollback + restart |
| ❌ No ignoring test failures | Rollback + restart |
| ❌ No "defensive programming" (fix root cause) | Rollback + restart |
| ❌ No applying changes without approval | Rollback + restart |

Test fixtures and test mocks are acceptable. Production fake data is never acceptable.

### Code Reuse Enforcement

Before creating any new file: search the codebase, check `systemPatterns.md`, review extension points, and document why extension is impossible. Validation checklist in Section 1.

### Security Review (Part of APPROVAL State)

- [ ] **Auth/Authz**: No hardcoded creds | Auth checked before sensitive ops | Authz at boundaries
- [ ] **Data Handling**: Input validation on external data | Output encoding prevents injection | Sensitive data encrypted where applicable
- [ ] **Error Handling**: No sensitive data in errors | Errors logged appropriately | Graceful degradation
- [ ] **Dependencies**: No known vulnerabilities | Versions pinned | Licenses compatible

If any item fails, address before APPROVAL.

### Linting & Testing

**Linting**: Zero errors before APPROVAL. Warnings OK with justification. Follow project rules.
**Testing**: Unit tests for new functions, integration tests for workflows, edge cases for critical paths. Deterministic, independent, fast, readable.

### Documentation Standards

**Files Requiring Approval Before Creation**:
- Any `memory-bank/tasks/*/` files (task docs)
- Updates to `memory-bank/tasks/*/README.md` (monthly summaries)
- Updates to `memory-bank/decisions.md` (ADRs)
- Updates to `memory-bank/projectRules.md` (patterns)
- Any commits to version control

**Files NOT Requiring Approval**: App code, tests, config updates (they still pass through APPROVAL before being applied).

**Citation Formats**:
- Code: `path/file.ext:42` | `path/file.ext:42-58` | `path/file.ext:functionName()`
- MB: `memory-bank/systemPatterns.md#Section` | `memory-bank/decisions.md#2025-10-15-decision`
- Always include context: ✅ "Extended `services/auth.ext:45` following `systemPatterns.md#Service Extension Pattern`" | ❌ "Updated service per systemPatterns.md"

**When to Update MB**:
- ✅ Completing major features (`progress.md`)
- ✅ Discovering new patterns (`systemPatterns.md`, `projectRules.md`)
- ✅ Making arch decisions (`decisions.md`)
- ✅ User explicitly requests: "update memory bank"
- ✅ Milestone completion (monthly README)
- ❌ Minor bug fixes, formatting, dependency updates, routine maintenance (task doc only, or none)

### Versioning & Rollback

Do not invent release/milestone IDs — propose, let the user assign. Rollback triggers: APPLY fails, user requests revert, critical error, security vulnerability. Rollback protocol: restore last known good state → verify → report reason, reverted changes, current state, recommendation.

---

## Quick Reference

### State Transitions

`PLAN [user approves] → BUILD → DIFF → QA [pass] → APPROVAL [user approves] → APPLY → DOCS`

Fast Track (small fixes, Section 4): skip PLAN gate only — APPROVAL always applies.
Iterations on failure: `BUILD ← DIFF ← QA ← APPROVAL` | Major changes: return to `PLAN`

### Critical Rules

1. 🚫 No new files without exhaustive reuse analysis
2. 🚫 No applying changes without user approval
3. 🚫 No documentation until code approved
4. 🚫 No fake/mock data in production
5. ✅ Always cite `file:line` for code, `file.md#Section` for MB
6. ✅ Always work in sandbox (never main)
7. ✅ Always validate reuse opportunities first

### When Stuck

1. Check cycle count (≥3 = stall) and check for identical diffs
2. Load more MB context
3. Break into smaller subtasks
4. Request user intervention or agent swap

---

**Each session starts fresh. Memory Bank is your only persistent memory. Maintain it with precision.**

**Mission**: Build software respecting existing architecture, following established patterns, improving incrementally. Reuse over creation. Quality over speed. Approval over assumption.
