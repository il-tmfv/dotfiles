---
description: Runs the implement-spec skill with inline merges and hook-safe worktree setup
argument-hint: "<path-to-spec>"
---
Follow the skill instructions in @~/.claude/skills/implement-spec/SKILL.md with arguments: $ARGUMENTS

BUT with these overrides:

1. **Merging.** Merge a finished ticket branch yourself, in the main checkout, one merge at a time: `git merge --ff-only <ticket-branch>`, falling back to `git merge --no-edit <ticket-branch>`. Run the repo's check command after each merge. Spawn a merger subagent only when the merge stops on a conflict or the checks go red.
2. **Implementer worktree setup.** Tell each implementer to put its branch on the integration tip with `git checkout -B <ticket-branch> <integration-branch>` on a clean tree, since a hook blocks `git reset --hard`. Also tell it to copy gitignored build artefacts (e.g. `deps`, `_build`, `node_modules`) from the main checkout when the worktree lacks them.
3. **Exploration subagent.** Tell it to write each notes file the moment its topic is done, so implementers started mid-exploration find partial notes. Tell implementers to use the notes directory when it has files and to read primary sources themselves when it is empty.
