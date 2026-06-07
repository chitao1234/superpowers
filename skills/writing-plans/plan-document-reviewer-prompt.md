# Plan Reviewer Prompt Template

Use this template when dispatching a reviewer for the written plan.

In Codex, dispatch this subagent with `model: "gpt-5.5"` and `reasoning_effort: "high"`. If the review is unusually subtle or high-risk, use `reasoning_effort: "xhigh"` instead, but never `medium` or lower for this reviewer.

**Purpose:** Verify the merged `plan` is coherent, complete enough to execute, and faithful to the approved design.

**Dispatch after:** The complete plan is written.

```
Codex subagent dispatch:
  agent_type: "worker"
  model: "gpt-5.5"
  reasoning_effort: "high"
  message: |
    You are a plan document reviewer. Verify this merged plan is ready for implementation.

    **Plan to review:** [PLAN_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Coverage | Goal, requirements, constraints, architecture, and verification are all present |
    | Consistency | No contradictions between requirements, architecture, and tasks |
    | Task Decomposition | Tasks are actionable, sequenced sensibly, and scoped cleanly |
    | Placeholder Discipline | Placeholders are deliberate and bounded, not vague omissions |
    | Demonstration Code | Any snippets are clearly illustrative and not concrete implementation code |
    | Buildability | Could an informed implementer execute this without having to redesign the feature first? |

    ## Calibration

    **Only flag issues that would cause real problems during implementation.**
    This workflow intentionally allows bounded placeholders and small demonstration snippets.
    Do NOT flag those unless they hide a required decision, introduce ambiguity, or pretend to be production code.

    Approve unless there are serious gaps - missing requirements, contradictory tasks,
    vague placeholders, or the plan smuggling in concrete implementation code where
    execution work should happen instead.

    ## Progress Reporting in Codex

    **Progress file:** [PROGRESS_FILE_PATH]

    Codex subagents cannot stream partial progress back to the controller while still running. Append concise checkpoints to the progress file while you review so the controller can inspect your status without stopping you.

    Keep reviewing after each update. Put the actual verdict in your final response, not in the progress file.

    ## Output Format

    ## Plan Review

    **Status:** Approved | Issues Found

    **Issues (if any):**
    - [Section or Task]: [specific issue] - [why it matters for implementation]

    **Recommendations (advisory, do not block approval):**
    - [suggestions for improvement]
```

**Reviewer returns:** Status, Issues (if any), Recommendations
