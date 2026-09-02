---
description: Sets up ralph wiggum review loop using code-review skill
argument-hint: "[issues-level] [max-iterations]"
---
Set up ralph wiggum loop with code-review skill, review diff between the current branch and the master, run it until there are no more ${1:-P0/P1} comments, do not consider uncommitted files as issues, max ${2:-5} iteration(s)
