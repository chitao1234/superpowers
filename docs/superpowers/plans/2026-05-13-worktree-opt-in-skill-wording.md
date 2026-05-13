# Worktree Opt-In Skill Wording Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. If the user has expressed a strong preference for one of these execution styles, keep using that style unless they explicitly ask to switch. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> **Plan rule:** This document is a merged design + execution artifact. Any code blocks are illustrative only. Concrete implementation code belongs in the actual code changes, not in this plan.

**Goal:** Make worktree usage opt-in across the superpowers workflow so agents do not create or require worktrees unless the user explicitly asks for them.

**Requirements:**
- Remove default-workflow language that requires or assumes git worktree setup before implementation.
- Update execution skills to say the current workspace is the default and worktrees require explicit user request.
- Keep the `using-git-worktrees` skill available only as an explicit opt-in path for user-requested worktree setup.
- Update tightly coupled docs and tests so they describe and verify the new default behavior.

**Architecture:** The workflow change is documentation-driven. The primary behavior lives in the skill text for `subagent-driven-development`, `executing-plans`, and `using-git-worktrees`. Supporting documentation and the focused regression test should be updated to match so discovery, expectations, and verification stay aligned.

**Verification Strategy:** Re-read the edited files, search the touched surfaces for stale "required worktree" wording, and run the focused subagent-driven-development test script if the local Claude CLI test harness is available.

**Assumptions / Open Questions:**
- Historical release notes may still mention earlier worktree behavior, so a newer superseding note is enough.

---

### Task 1: Update execution-skill behavior

**Intent:** Remove any implied worktree prerequisite from the execution workflows.

**Relevant files/components:**
- Likely modify: `skills/subagent-driven-development/SKILL.md`
- Likely modify: `skills/executing-plans/SKILL.md`

**Notes / constraints:**
- Say plainly that execution happens in the current workspace by default.
- If worktrees are mentioned, they must be framed as explicit user opt-in only.

**Verification:**
- Run: `rg -n -i "worktree|using-git-worktrees" skills/subagent-driven-development/SKILL.md skills/executing-plans/SKILL.md`
- Expect: no wording that makes worktrees required or default

- [ ] Inspect the current workflow wording
- [ ] Update the default-workspace guidance
- [ ] Keep any worktree references opt-in only
- [ ] Re-read the result for ambiguity

### Task 2: Re-scope the worktree skill itself

**Intent:** Keep the worktree skill as a reference for explicit user requests, not a default setup step.

**Relevant files/components:**
- Likely modify: `skills/using-git-worktrees/SKILL.md`

**Notes / constraints:**
- The trigger should require an explicit user request for a git worktree or worktree-based isolated workspace.
- The skill should instruct agents not to use it when the user has not asked for worktrees.

**Verification:**
- Run: `rg -n -i "explicit|user.*ask|unless.*user" skills/using-git-worktrees/SKILL.md`
- Expect: clear opt-in wording near the top and in integration notes

- [ ] Rewrite the trigger and overview
- [ ] Add an explicit hard gate against unrequested worktrees
- [ ] Remove references that say other workflows require this skill
- [ ] Re-read the quick reference and integration sections

### Task 3: Align docs and regression test

**Intent:** Update user-facing docs and the focused subagent workflow test to describe the new default.

**Relevant files/components:**
- Likely modify: `README.md`
- Likely modify: `tests/claude-code/test-subagent-driven-development.sh`
- Likely modify: `RELEASE-NOTES.md`

**Notes / constraints:**
- The README should no longer list worktree setup as a standard workflow phase.
- The focused test should assert that worktrees are not required by default and are only used on explicit request.
- Release notes should preserve chronology while making the current behavior discoverable.

**Verification:**
- Run: `rg -n -i "using-git-worktrees|worktree requirement|required before implementation" README.md tests/claude-code/test-subagent-driven-development.sh RELEASE-NOTES.md`
- Expect: only opt-in or historical wording remains

- [ ] Update the basic workflow and skill list in the README
- [ ] Rewrite the focused test expectations
- [ ] Add a new release-note entry for the behavior change
- [ ] Re-read all touched text for consistency
