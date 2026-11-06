---
description: Review and fix the current branch in rounds until reviewers return zero hard findings, then hand leftover judgement calls to the user
argument-hint: "[fixed-point=master] [round-cap=3]"
disable-model-invocation: true
---
Arguments: $ARGUMENTS

Each round runs two reviews side by side, each by fresh sub-agents:

- `code-review` means the two-axis Standards + Spec review in `~/.claude/skills/code-review/SKILL.md`: read that file and follow it. The built-in `/code-review` command and the official plugin are different tools.
- `code-review-expert` means the bug, security, and reliability review in `~/.claude/skills/code-review-expert/SKILL.md`.

Runs review → fix → review in **rounds**. A round ends when its hard findings are fixed and tests are green. The loop ends **clean** when a round's reviews return zero hard findings.

Reviewers always find something, so "zero findings" is never the target. The loop converges on hard findings only; judgement calls are the user's.

## Triage

Sort every finding from a round into one of two buckets. When several reviewers flag the same issue, it counts once.

- **Hard finding** (fix it): from `code-review`, a Standards breach of a documented repo rule, a Spec requirement that is missing or partial, or a Spec requirement implemented wrongly. From `code-review-expert`, every P0 and P1.
- **Judgement call** (report it): from `code-review`, every baseline smell, Spec scope creep (it may be intentional), and anything the reviewer itself labels a judgement call. From `code-review-expert`, every P2 and P3, plus removal candidates.

A hard finding you believe is a false positive becomes **rejected**: skip it, write one line of reasoning, and it counts as resolved for this round.

## Setup (once)

1. Pin the fixed point: the first argument, else `master`. Compute `BASE=$(git merge-base <fixed-point> HEAD)`.
2. Pin the round cap: the second argument, else 3.
3. Resolve the spec source per `code-review` step 2. Ask the user at most here; every round reuses the answer.

## Each round

1. Run `git add -N` on untracked files the branch created, so they appear in the diff.
2. Launch both reviews in parallel, all with the diff command `git diff $BASE` (merge-base against the working tree, so uncommitted fixes from earlier rounds are reviewed). Give reviewers only what their skill prescribes plus this diff command, and nothing from earlier rounds; a fresh reviewer is the point.
   - `code-review`: run its two sub-agents with this diff command.
   - `code-review-expert`: one sub-agent told to read its SKILL.md and follow steps 2–6 on this diff. The diff command replaces its step 1 git commands; it may still grep for related modules. It returns its step 6 report and stops there, skipping step 7.
3. Triage the findings.
4. Fix every hard finding, then run the tests covering the touched files. Done when every hard finding is fixed or rejected, and those tests are green.
5. Log the round: each finding fixed (file:line, one line), each rejected (with reasoning), each judgement call.

## Stop

Stop at the first of these and say which one fired:

- **Clean**: the round's reviews returned zero hard findings.
- **Cap**: the round cap is reached.
- **Ping-pong**: a finding fixed or rejected in an earlier round comes back. Leave the code as it is and report both sides.
- **Red**: tests stay red after two fix attempts. Leave the code in its last state and report the failing test with its first error line.

Everything stays uncommitted; the user commits.

## Report

1. The stop reason, plus hard findings fixed per round (e.g. `5 → 2 → 0`).
2. Fixed, grouped by round: file:line, source review, and one line each.
3. Rejected and ping-pong items, with reasoning.
4. Judgement calls from the final round, ranked by impact, so the user can pick which to take.
