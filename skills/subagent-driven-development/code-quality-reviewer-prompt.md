# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

In Codex, dispatch this subagent with `model: "gpt-5.4"`.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable)

**Only dispatch after spec compliance review passes.**

In Codex, provide a unique `PROGRESS_FILE` placeholder to the reviewer. Reviewer subagents cannot stream partial progress back to the parent while they are still running, so they should append checkpoints to that shared file during the review.

```
Task tool (superpowers:code-reviewer):
  Use template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from implementer's report]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
  DESCRIPTION: [task summary]
  PROGRESS_FILE: [unique shared progress file path]
```

**In addition to standard code quality concerns, the reviewer should check:**
- Does each file have one clear responsibility with a well-defined interface?
- Are units decomposed so they can be understood and tested independently?
- Is the implementation following the file structure from the plan?
- Did this implementation create new files that are already large, or significantly grow existing files? (Don't flag pre-existing file sizes — focus on what this change contributed.)

**Code reviewer returns:** Strengths, Issues (Critical/Important/Minor), Assessment
