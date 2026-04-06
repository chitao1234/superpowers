# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent.

In Codex, dispatch this subagent with `model: "gpt-5.4"`.

**Purpose:** Verify the main agent built what was requested (nothing more, nothing less)

```
Task tool (general-purpose):
  description: "Review spec compliance for Task N"
  prompt: |
    You are reviewing whether an implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of task requirements - paste it here, don't make reviewer read the plan file]

    ## What The Main Agent Says They Implemented

    [From the main agent's implementation summary]

    ## CRITICAL: Do Not Trust The Summary

    The main agent may be incomplete, inaccurate, or optimistic. You MUST verify
    everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention

    ## Progress Reporting in Codex

    **Progress file:** [PROGRESS_FILE_PATH]

    Codex subagents cannot stream partial progress back to the controller while still running. Append concise checkpoints to the progress file while you review so the controller can inspect your progress without interrupting you.

    Write a short update when you:
    - Start the review
    - Finish checking the requirements against the code
    - Discover a blocker or need clarification
    - Are about to return your final verdict

    Keep reviewing after each update. Put the actual verdict in your final response, not in the progress file.

    ## Your Job

    Read the implementation code and verify:

    **Missing requirements:**
    - Did the implementation include everything that was requested?
    - Are there requirements they skipped or missed?
    - Does the summary claim something works that the code does not actually implement?

    **Extra/unneeded work:**
    - Did the main agent build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?

    **Verify by reading code, not by trusting the summary.**

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
```
