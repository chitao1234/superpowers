#!/usr/bin/env bash
# Test: subagent-driven-development skill
# Verifies that the skill is loaded and follows correct workflow
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: subagent-driven-development skill ==="
echo ""

# Test 1: Verify skill can be loaded
echo "Test 1: Skill loading..."

output=$(run_claude "What is the subagent-driven-development skill? Describe its key steps briefly." 30)

if assert_contains "$output" "subagent-driven-development\|Subagent-Driven Development\|Subagent Driven" "Skill is recognized"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Load Plan\|read.*plan\|extract.*tasks" "Mentions loading plan"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Verify skill describes correct workflow order
echo "Test 2: Workflow ordering..."

output=$(run_claude "In the subagent-driven-development skill, what comes first: spec compliance review or code quality review? Be specific about the order." 30)

if assert_order "$output" "spec.*compliance" "code.*quality" "Spec compliance before code quality"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Verify self-review is mentioned
echo "Test 3: Self-review requirement..."

output=$(run_claude "Does the subagent-driven-development skill require the main agent to do self-review before dispatching reviewers? What should they check?" 30)

if assert_contains "$output" "self-review\|self review" "Mentions self-review"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "completeness\|Completeness" "Checks completeness"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 4: Verify plan is read once
echo "Test 4: Plan reading efficiency..."

output=$(run_claude "In subagent-driven-development, how many times should the controller read the plan file? When does this happen?" 30)

if assert_contains "$output" "once\|one time\|single" "Read plan once"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Step 1\|beginning\|start\|Load Plan" "Read at beginning"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 5: Verify spec compliance reviewer is skeptical
echo "Test 5: Spec compliance reviewer mindset..."

output=$(run_claude "What is the spec compliance reviewer's attitude toward the main agent's implementation summary in subagent-driven-development?" 30)

if assert_contains "$output" "not trust\|don't trust\|skeptical\|verify.*independently\|suspiciously" "Reviewer is skeptical"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "read.*code\|inspect.*code\|verify.*code" "Reviewer reads code"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 6: Verify review loops
echo "Test 6: Review loop requirements..."

output=$(run_claude "In subagent-driven-development, what happens if a reviewer finds issues? Is it a one-time review or a loop?" 30)

if assert_contains "$output" "loop\|again\|repeat\|until.*approved\|until.*compliant" "Review loops mentioned"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "main agent.*fix\|fix.*issues" "Main agent fixes issues"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 7: Verify implementation stays in main session
echo "Test 7: Implementation ownership..."

output=$(run_claude "In subagent-driven-development, who does the implementation work: the main agent or an implementer subagent?" 30)

if assert_contains "$output" "main agent\|main session" "Main agent implements"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "not.*implementer subagent\|rather than.*implementer subagent\|instead of.*implementer subagent" "Implementation stays out of subagent role"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 8: Verify full task text is provided to reviewers
echo "Test 8: Reviewer context provision..."

output=$(run_claude "In subagent-driven-development, how should the main agent provide task information to reviewer subagents? Does it make them read a plan file or provide the task text directly?" 30)

if assert_contains "$output" "provide.*directly\|full.*text\|paste\|include.*prompt" "Provides task text directly"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "not.*read.*plan file\|don't.*read.*plan file\|rather than.*read.*plan file\|instead of.*read.*plan file" "Doesn't make reviewer read plan file"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 9: Verify no default worktree requirement
echo "Test 9: No default worktree requirement..."

output=$(run_claude "In subagent-driven-development, is using-git-worktrees required before implementation? Answer yes or no, then describe the real prerequisites." 30)

if assert_contains "$output" "no\|not required\|isn't required" "Says worktrees are not required"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "written plan\|have.*plan\|plan.*required" "Mentions plan prerequisite"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 10: Verify worktrees are opt-in only
echo "Test 10: Worktree opt-in only..."

output=$(run_claude "In subagent-driven-development, should the agent create or switch to a git worktree before implementation if the user did not ask for one?" 30)

if assert_contains "$output" "do not\|should not\|no" "Says not to create a worktree by default"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "current workspace\|same workspace\|current session" "Keeps default execution in current workspace"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "only.*explicitly.*ask\|unless.*user.*ask\|if the user explicitly requests" "Allows worktrees only on explicit request"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All subagent-driven-development skill tests passed ==="
