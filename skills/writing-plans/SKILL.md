---
name: writing-plans
description: Use when you have approved requirements or design for a multi-step change and need a written plan artifact before implementation
---

# Writing Plans

## Overview

Write one merged `plan` artifact that combines the old spec material with the most useful part of the old implementation plan.

The `plan` should capture:
- required behavior and constraints
- architecture and data flow
- file or component shape
- task sequencing
- testing and verification strategy

The `plan` is guidance for implementation, not implementation itself.

- Demonstration code is allowed only when it clarifies an interface, data shape, or approach
- Placeholders are allowed when they are explicit, bounded, and useful
- Concrete implementation code does NOT belong in the plan
- Do not write as if the implementer is uninformed about the project. They are expected to read the codebase during execution

**Announce at start:** "I'm using the writing-plans skill to create the plan."

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)
- Follow the repo's established tracking policy for planning artifacts rather than assuming every plan should be committed

## Scope Check

If the approved design covers multiple independent subsystems, suggest splitting it into separate plans. Each plan should describe one coherent slice of work that can be implemented and verified on its own.

## Tracking Policy

Before forcing a new plan into git, inspect the repo's existing convention:

```bash
git check-ignore -v docs/superpowers/plans docs/superpowers/plans/<filename>
git ls-files 'docs/superpowers/plans/*' 'docs/superpowers/specs/*'
```

Apply these rules:

- If the repo already has several tracked planning artifacts in these folders (for example, 3 or more combined), treat that as an established convention and continue checking new plans into git
- Otherwise, if `docs/superpowers/plans/` or the target plan path is explicitly ignored by the repo, write the plan locally but do **not** force it into git
- If this is a new or unclear repo with no established convention, ask the user: "Do you want this plan kept only locally or checked into git?"
- If the user already answered that question earlier in the workflow, reuse that preference here instead of asking again

## What the Plan Must Contain

The plan should merge design intent with implementation guidance. Include:

- **Goal** - what this work delivers
- **Requirements and constraints** - the approved behavior, boundaries, and non-goals
- **Architecture** - the intended shape of the solution
- **Verification strategy** - how the work will be checked
- **Task breakdown** - the implementation slices and their order
- **Assumptions or open questions** - explicit notes for details to confirm during execution

Do not duplicate large amounts of obvious repo context or explain basics the implementer will learn by reading the code.

## File and Component Shape

Before defining tasks, map out the likely files or components involved and what each one is responsible for.

- Prefer clear boundaries and well-defined interfaces
- Use exact paths when you know them
- Do not invent line numbers or fake precision
- In existing codebases, follow established patterns unless the approved design explicitly includes a targeted restructuring

This structure informs the task decomposition. Each task should produce a coherent change that makes sense independently.

## Task Granularity

Tasks should be small enough to execute and review cleanly, but they do not need to be micro-steps with full code pasted in.

Good task shape:
- one meaningful outcome per task
- 3-6 checklist steps per task
- verification called out explicitly
- enough detail to preserve scope and sequencing

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. If the user has expressed a strong preference for one of these execution styles, keep using that style unless they explicitly ask to switch. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Plan rule:** This document is a merged design + execution artifact. Any code blocks are illustrative only. Concrete implementation code belongs in the actual code changes, not in this plan.

**Goal:** [One sentence describing what this builds]

**Requirements:**
- [Approved requirement]
- [Constraint or non-goal]

**Architecture:** [2-4 sentences about the intended approach]

**Verification Strategy:** [How the work will be checked]

**Assumptions / Open Questions:**
- [Allowed placeholder when something must be confirmed during implementation]

---
```

## Task Structure

````markdown
### Task N: [Outcome or Area]

**Intent:** [What this task accomplishes]

**Relevant files/components:**
- Likely modify: `path/to/file`
- Likely create: `path/to/new-file`
- Existing references: `path/to/reference` (optional)

**Notes / constraints:**
- [Important requirement, edge case, or boundary]
- [Allowed placeholder if exact repo detail must be confirmed during implementation]

**Verification:**
- Run: `relevant command if known`
- Expect: [what success looks like]

**Demonstration snippet (optional, illustrative only):**
```ts
// Example shape only. Do not paste production implementation here.
type ExamplePayload = {
  id: string;
  state: "pending" | "ready";
};
```

- [ ] Inspect the current implementation seam and confirm exact files or names
- [ ] Add or update the appropriate tests or verification
- [ ] Implement the task in code
- [ ] Run focused verification
- [ ] Commit
````

Adapt the checklist to the task. The plan should describe what needs to happen, not pre-write the patch.

## Placeholders and Demonstration Code

**Allowed:**
- bounded placeholders such as `[confirm existing helper name]`
- example commands when the exact command is not known yet
- interface sketches, pseudocode, schema outlines, or tiny snippets used only to demonstrate shape

**Not allowed:**
- full production-ready function bodies
- diff hunks or large copy-paste implementation blocks
- vague omissions such as "TODO", "implement later", or "handle edge cases" without context
- fake precision about files, line numbers, or APIs you have not verified

If a placeholder appears, it should tell the implementer exactly what must be confirmed during execution.

## Remember

- Preserve the approved design decisions
- Use exact file paths when known, but don't invent details
- State the testing or verification approach per task
- Prefer clarity over fake completeness
- Keep the plan DRY and YAGNI

## Self-Review

After writing the complete plan, check it with fresh eyes:

1. **Design coverage:** Does the plan capture the approved requirements, constraints, and architecture?
2. **Task clarity:** Can each task be executed without re-planning the whole feature?
3. **Placeholder discipline:** Is every placeholder intentional, bounded, and useful?
4. **No implementation dump:** Did you avoid concrete production code in the plan?
5. **Assumptions explicit:** Are the details that still need confirmation clearly named?

If you find issues, fix them inline.

## User Review Gate

Because this `plan` is now the merged design + execution artifact, ask the user to review it before implementation starts.

If the plan was checked into git, say:

> "Plan written and committed to `<path>`. Please review it and let me know if you want any changes before implementation starts."

If the plan was kept local-only, say:

> "Plan written to `<path>` and kept local-only for now. Please review it and let me know if you want any changes before implementation starts."

Wait for the user's response. If they request changes, make them and re-run the self-review. Only proceed once the user approves.

## Execution Handoff

After the user approves the plan, offer execution choice:

If the user has already expressed a strong preference for one execution style, do not reopen the choice. Use that style and mention that you'll keep using it unless they explicitly ask for the other one.

Otherwise say:

If the plan was checked into git, say:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md` and checked into git. Two execution options:**

**1. Subagent-Driven Execution** - I execute the plan in this session, with requirements review and code quality review after each task

**2. Plan-Based Execution** - I execute the plan with superpowers:executing-plans, using the plan's tasks and verification checkpoints while resolving concrete code details in the repo

**If you strongly prefer one of these styles, I'll keep using that style unless you explicitly tell me to switch. Which approach?"**

If the plan was kept local-only, say:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md` locally. Two execution options:**

**1. Subagent-Driven Execution** - I execute the plan in this session, with requirements review and code quality review after each task

**2. Plan-Based Execution** - I execute the plan with superpowers:executing-plans, using the plan's tasks and verification checkpoints while resolving concrete code details in the repo

**If you strongly prefer one of these styles, I'll keep using that style unless you explicitly tell me to switch. Which approach?"**

**If Subagent-Driven Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh reviewer subagent per task + two-stage review
- In Codex, use one shared progress file per reviewer because child agents cannot stream partial progress live

**If Plan-Based Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Use the plan's requirements, tasks, and verification checkpoints while resolving concrete implementation details in the repo
