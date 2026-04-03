---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. Use TDD where the task has a clear behavior seam. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)
- Follow the repo's established tracking policy for specs/plans rather than assuming every plan should be committed

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## Spec and Plan Tracking Policy

Before forcing a new plan into git, inspect the repo's existing convention:

```bash
git check-ignore -v docs/superpowers/plans docs/superpowers/plans/<filename> docs/superpowers/specs docs/superpowers/specs/<related-spec>
git ls-files 'docs/superpowers/specs/*' 'docs/superpowers/plans/*'
```

Apply these rules:

- If the repo already has several tracked specs/plans in these folders (for example, 3 or more combined), treat that as an established convention and continue checking new plans into git.
- Otherwise, if `docs/superpowers/plans/` or the target plan path is explicitly ignored by the repo, write the plan locally but do **not** force it into git.
- If this is a new or unclear repo with no established convention, ask the user: "Do you want these planning artifacts kept only locally or checked into git?"
- If the user already answered that question during brainstorming, reuse that preference here instead of asking again.
- Treat the user's answer as applying to both specs and plans in this repo unless they explicitly change it.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step, when the task supports TDD
- "Run it to make sure it fails" - step, when the task supports TDD
- "Implement the minimal code to make the test pass" - step, when the task supports TDD
- "Run the focused verification for the task" - step
- "Update docs / rename files / perform structural change" - step, when the task is not a TDD task
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. If the user has expressed a strong preference for one of these execution styles, keep using that style unless they explicitly ask to switch. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test/Verify: `tests/exact/path/to/test.py` or `command / output / rendered artifact to inspect`

**Testing approach:** [`TDD` | `characterization/integration test` | `existing tests + targeted verification` | `no new tests needed`]
Reason: [Why this level of testing fits this task]

- [ ] **Step 1: [Write the failing test OR capture current behavior OR make the docs/structural change]**

```python
# Fill with the real code or commands for this step.
```

- [ ] **Step 2: [Run the focused verification for this step]**

Run: `exact command`
Expected: [FAIL first for TDD, or PASS / diff / lint / build output as appropriate]

- [ ] **Step 3: [Implement the change]**

```python
# Fill with the real code or commands for this step.
```

- [ ] **Step 4: [Run the post-change verification]**

Run: `exact command`
Expected: [PASS / clean diff / successful build / expected rendered output]

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Use TDD" (without stating why TDD fits this specific task)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- State the testing approach per task instead of assuming TDD everywhere
- DRY, YAGNI, task-appropriate testing, frequent commits

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, offer execution choice:

If the user has already expressed a strong preference for one execution style, do not reopen the choice. Use that style and mention that you'll keep using it unless they explicitly ask for the other one.

Otherwise say:

If the plan was checked into git, say:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md` and checked into git. Two execution options:**

**1. Subagent-Driven Execution** - I dispatch a fresh subagent per task, with review between tasks

**2. Plan-Based Execution** - I execute the plan with superpowers:executing-plans, following the written steps directly

**If you strongly prefer one of these styles, I'll keep using that style unless you explicitly tell me to switch. Which approach?"**

If the plan was kept local-only, say:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md` locally. Two execution options:**

**1. Subagent-Driven Execution** - I dispatch a fresh subagent per task, with review between tasks

**2. Plan-Based Execution** - I execute the plan with superpowers:executing-plans, following the written steps directly

**If you strongly prefer one of these styles, I'll keep using that style unless you explicitly tell me to switch. Which approach?"**

**If Subagent-Driven Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Plan-Based Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Follow the written plan directly with the checkpoints it specifies
