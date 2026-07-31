For file search or grep in git-indexed directory, use fff tools.

# Domain Docs

How engineering skills consume repo domain docs when explore codebase.

## Before exploring, read these

- **`CONTEXT.md`** at repo root, or
- **`CONTEXT-MAP.md`** at repo root if exists — points at one `CONTEXT.md` per context. Read each relevant to topic.
- **`docs/adr/`** — read ADRs that touch area. Multi-context repos: also check `src/<context>/docs/adr/` for context-scoped decisions.

If files missing, **proceed silently**. Don't flag absence; don't suggest create upfront. `/domain-modeling` skill (via `/grill-with-docs` + `/improve-codebase-architecture`) create lazily when terms or decisions resolve.

## File structure

Single-context repo (most repos):

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Multi-context repo (presence of `CONTEXT-MAP.md` at the root):

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← system-wide decisions
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← context-specific decisions
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use the glossary's vocabulary

When output name domain concept (issue title, refactor proposal, hypothesis, test name), use term defined in `CONTEXT.md`. Don't drift to synonyms glossary avoid.

If concept not in glossary yet — signal: invent language project don't use (reconsider), or real gap (note for `/domain-modeling`).

## Flag ADR conflicts

If output contradict existing ADR, surface explicitly — don't silent override:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_

# Issue tracker: Local Markdown

Issues + specs (spec aka PRD) live as markdown in `.scratch/`.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- Spec: `.scratch/<feature-slug>/spec.md`
- Implementation issues: one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` — never single combined tickets file
- Triage state: `Status:` line near top of each issue file (see `triage-labels.md` for role strings)
- Comments + conversation history append bottom under `## Comments` heading

## When a skill says "publish to the issue tracker"

Create new file under `.scratch/<feature-slug>/` (create directory if needed).

## When a skill says "fetch the relevant ticket"

Read file at referenced path. User normally pass path or issue number directly.

## Wayfinding operations

Used by `/wayfinder`. **map** = file with one **child** file per ticket.

- **Map**: `.scratch/<effort>/map.md` — Notes / Decisions-so-far / Fog body.
- **Child ticket**: `.scratch/<effort>/issues/NN-<slug>.md`, numbered from `01`, question in body. `Type:` line = ticket type (`research`/`prototype`/`grilling`/`task`); `Status:` line = `claimed`/`resolved`.
- **Blocking**: `Blocked by: NN, NN` line near top. Ticket unblocked when every listed file is `resolved`.
- **Frontier**: scan `.scratch/<effort>/issues/` for open, unblocked, unclaimed; first by number wins.
- **Claim**: set `Status: claimed` and save before work.
- **Resolve**: append answer under `## Answer` heading, set `Status: resolved`, then append context pointer (gist + link) to map Decisions-so-far in `map.md`.
