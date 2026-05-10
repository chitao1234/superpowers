# Codex Tool Mapping

If a skill still contains legacy terminology, translate it to Codex using this table:

| Skill references | Codex equivalent |
|-----------------|------------------|
| `Task` tool (dispatch subagent) | `spawn_agent(model="gpt-5.4", reasoning_effort="high", ...)` (see [Named agent dispatch](#named-agent-dispatch)) |
| Multiple `Task` calls (parallel) | Multiple `spawn_agent(model="gpt-5.4", reasoning_effort="high", ...)` calls |
| Task returns result | `wait_agent` |
| Task completes automatically | `close_agent` to free the slot when you no longer need it |
| `TodoWrite` (task tracking) | `update_plan` |
| `Skill` tool (invoke a skill) | Open the skill's `SKILL.md` from the listed path and follow it |
| `Read`, `Write`, `Edit` (files) | Use your native file tools |
| `Bash` (run commands) | Use your native shell tools |

## Subagent dispatch requires multi-agent support

Add to your Codex config (`~/.codex/config.toml`):

```toml
[features]
multi_agent = true
```

This enables `spawn_agent`, `wait_agent`, and `close_agent` for skills like `dispatching-parallel-agents` and `subagent-driven-development`.

## Named agent dispatch

Some older skills reference named agent types like `superpowers:code-reviewer`.
Codex does not have a named agent registry — `spawn_agent` creates generic agents
from built-in roles (`default`, `explorer`, `worker`).

For GPT subagent dispatch in Codex, explicitly set `model="gpt-5.4"` (latest GPT model) and set `reasoning_effort` to `"high"` or `"xhigh"`.

Use `"high"` by default and raise to `"xhigh"` for especially difficult synthesis, review, or planning work. Do not use `"medium"` or lower unless the subagent is purely exploratory, such as the built-in `explorer` role.

## Progress visibility for subagents

Codex subagents do not stream partial progress back to the parent while they are still running. The parent only gets the normal agent response after the child stops.

When you need visibility into in-flight work:
1. Create one unique shared progress file per subagent.
2. Include that file path in the subagent message and tell the subagent to append short checkpoints while it works.
3. Inspect that file from the main session while the subagent continues running.
4. Treat the file as advisory status; the final result still comes from the subagent's returned message.

Do not share one progress file across multiple subagents.

When a skill says to dispatch a named agent type:

1. Find the agent's prompt file (e.g., `agents/code-reviewer.md` or the skill's
   local prompt template like `code-quality-reviewer-prompt.md`)
2. Read the prompt content
3. Fill any template placeholders (`{BASE_SHA}`, `{WHAT_WAS_IMPLEMENTED}`, etc.)
4. Spawn a `worker` agent with `model="gpt-5.4"` and `reasoning_effort="high"` (or `"xhigh"` when warranted) and the filled content as the `message`

| Skill instruction | Codex equivalent |
|-------------------|------------------|
| `Task tool (superpowers:code-reviewer)` | `spawn_agent(agent_type="worker", model="gpt-5.4", reasoning_effort="high", message=...)` with `code-reviewer.md` content |
| `Task tool (general-purpose)` with inline prompt | `spawn_agent(model="gpt-5.4", reasoning_effort="high", message=...)` with the same prompt |

### Message framing

The `message` parameter is user-level input, not a system prompt. Structure it
for maximum instruction adherence:

```
Your task is to perform the following. Follow the instructions below exactly.

<agent-instructions>
[filled prompt content from the agent's .md file]
</agent-instructions>

Execute this now. Output ONLY the structured response following the format
specified in the instructions above.
```

- Use task-delegation framing ("Your task is...") rather than persona framing ("You are...")
- Wrap instructions in XML tags — the model treats tagged blocks as authoritative
- End with an explicit execution directive to prevent summarization of the instructions

### When this workaround can be removed

This approach compensates for Codex's plugin system not yet supporting an `agents`
field in `plugin.json`. When `RawPluginManifest` gains an `agents` field, the
plugin can symlink to `agents/` (mirroring the existing `skills/` symlink) and
skills can dispatch named agent types directly.
