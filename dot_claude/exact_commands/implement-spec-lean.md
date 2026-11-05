---
description: Runs the implement-spec skill with inline merges and hook-safe worktree setup
argument-hint: "<path-to-spec>"
---
Follow the skill instructions in @~/.claude/skills/implement-spec/SKILL.md with arguments: $ARGUMENTS

BUT with these overrides:

1. **Merging.** Merge a finished ticket branch yourself, in the main checkout, one merge at a time: `git merge --ff-only <ticket-branch>`, falling back to `git merge --no-edit <ticket-branch>`. Run the repo's check command after each merge. Spawn a merger subagent only when the merge stops on a conflict or the checks go red.
2. **Implementer worktree setup.** Tell each implementer to put its branch on the integration tip with `git checkout -B <ticket-branch> <integration-branch>` on a clean tree, since a hook blocks `git reset --hard`. Also tell it to copy gitignored build artefacts (e.g. `deps`, `_build`, `node_modules`) from the main checkout when the worktree lacks them.
   - **Own ports.** Parallel test runs collide on fixed listener ports (`:eaddrinuse`). Before spawning, find the env vars the test config reads for ports (e.g. pushsms_api `config/test.exs`: `TELEMETRY_METRICS_PORT_TEST`, `MESSAGE_CENTER_PORT_TEST`) and give each implementer its own values to export in every test command. Your own post-merge runs keep the defaults.
   - **Clean tree via commits.** Implementers keep the tree clean with commits, not `git stash`: a hook blocks `stash drop`, so stashes pile up.
3. **Exploration subagent.** Tell it to write each notes file the moment its topic is done, so implementers started mid-exploration find partial notes. Tell implementers to use the notes directory when it has files and to read primary sources themselves when it is empty.
4. **Ticket updates.** A worktree can't write to the gitignored tracker directory in the main checkout. Tell each implementer to end its report with the ticket update: boxes to tick and `## Comments` text in the tracker's language. After merging its branch, apply that update yourself and set the ticket's status to done.
