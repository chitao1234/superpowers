# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

In Codex, dispatch this subagent with `model: "gpt-5.4"` and `reasoning_effort: "high"`. If the review is unusually subtle or high-risk, use `reasoning_effort: "xhigh"` instead, but never `medium` or lower for this reviewer.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

In Codex, provide a unique `PROGRESS_FILE` placeholder to the reviewer. Reviewer subagents cannot stream partial progress back to the parent while they are still running, so they should append checkpoints to that shared file during the review.

```
Codex reviewer subagent:
  agent_type: "worker"
  model: "gpt-5.4"
  reasoning_effort: "high"
  message: use the filled template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from the main agent's implementation summary]
  PLAN_OR_REQUIREMENTS: [FULL TEXT of task requirements - paste it here, don't make reviewer read the plan file]
  BASE_SHA: [commit before task or other clean base for the task diff]
  HEAD_SHA: [current task diff head prepared by the main agent]
  DESCRIPTION: [task summary]
  PROGRESS_FILE: [unique shared progress file path]
```

**In addition to standard code quality concerns, the reviewer should check:**
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
