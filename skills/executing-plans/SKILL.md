---
name: executing-plans
description: Use when you have a written plan and want to execute it in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load the merged plan, review it critically, execute the tasks, and report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** This is a first-class execution path. Use it when the user chooses plan-based execution, or when they have already shown a strong preference for it. Keep using it unless the user explicitly asks to switch to `superpowers:subagent-driven-development`.

## Workspace Default

Execute the plan in the current workspace by default.

- Do NOT create, switch to, or recommend a git worktree unless the user explicitly asked for a worktree or a worktree-based isolated workspace.
- If the user explicitly requests that setup, use `superpowers:using-git-worktrees` before implementation.
- Wanting generic isolation is not enough. The user has to ask for worktrees.

## The Process

### Step 1: Load and Review Plan
1. Read the plan file
2. Review the goal, requirements, architecture, assumptions, tasks, and verification checkpoints
3. Identify any placeholders or demonstration snippets that need repo confirmation during execution
4. Treat any old "set up a worktree first" instruction as stale unless the current user explicitly asked for worktrees
5. If concerns: raise them with your human partner before starting
6. If no concerns: initialize `update_plan` tracking and proceed

### Step 2: Execute Tasks

For each task:
1. Mark it as `in_progress`
2. Use the task intent, constraints, and verification checkpoints as the source of truth
3. Resolve concrete file names, signatures, and implementation details in the codebase while staying within the plan's scope
4. Treat any plan code block as illustrative only - do not copy it blindly
5. Run the verifications the plan calls for
6. Mark the task as completed

### Step 3: Complete Development

After all tasks complete and verify:
- Report implementation complete
- Summarize the verification that passed

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- The plan has critical gaps preventing safe execution
- A placeholder or assumption turns out to hide a major design decision
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember

- Review the plan critically first
- The plan is authoritative for scope, not a substitute for reading the codebase
- Use the plan's requirements and tasks, but resolve concrete implementation details in the repo
- Stay in the current workspace unless the user explicitly asks for worktrees
- Don't skip verifications
- Reference skills when the plan says to, except that worktree setup still requires an explicit user request
- Respect the user's established execution-style preference until they explicitly change it
- Stop when blocked, don't guess

## Integration

**Required workflow skills:**
- **superpowers:writing-plans** - Creates the merged plan this skill executes
