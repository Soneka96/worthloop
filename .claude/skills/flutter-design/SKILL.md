# Flutter Design

Turns a design idea into real Flutter code for this project, in two deliberately separate stages —
**Ideate** and **Translate** — never blended into one reasoning pass. Ideation is aesthetic
judgment (contrast, hierarchy, restraint); translation is Flutter-specific correctness (widgets,
`Theme`, this project's conventions). Mixing them produces code that reads as confidently correct
but is quietly wrong — keep them apart.

> Never invoked automatically. The user picks one of the three flows below explicitly.

---

## Step 0 — always read `design/design.md` first

Before any ideation, read `design/design.md` in full. It states this app's essence — what stays
true across every theme/spacing/zoom/corner-style preset — so ideation stays grounded in the
established identity instead of drifting toward a generic default. Never skip this step, even for
a small screen.

---

## The three flows

### Flow 1 — `idea -> html -> end`

Given a description with no HTML yet:

1. Read `design/design.md` (Step 0).
2. **Ideate**: reason about the request the way `frontend-design` would — contrast, hierarchy,
   restraint, one deliberate choice per screen — informed by `design.md`'s essence, not generic
   defaults. Produce a disposable HTML/CSS draft. This is a cheap sketch, not production code —
   its only job is to be looked at.
3. Stop. Do not proceed to Translate. Tell the user the draft is ready for review.

The user reviews the HTML themselves, decides when it's good enough, and screenshots it manually
when they approve it — there is no automated approval gate. A bad idea should never reach the
Translate stage and become confidently-wrong Flutter code; the human review step is what prevents
that, so it stays manual, not automated away.

### Flow 2 — `html -> mock widget -> end`

Given existing (already-approved) HTML/CSS, with no ideation needed:

1. Read `design/design.md` (Step 0) — still needed, since translation choices (which widget, which
   Theme lookup) should stay consistent with the app's essence too.
2. **Translate**: read the HTML's exact structure and values (colors, spacing, layout direction) —
   never re-derive them from a screenshot; HTML gives exact values, a screenshot only gives pixels
   to guess from, and the HTML is normally still available at this point. Build a real Flutter mock
   widget under `lib/design_sandbox/`, following this project's actual conventions:
   - Dumb widget, no business logic — matches `ai/context/architecture.md`'s widget rules.
   - Every color, text style, spacing value, and corner radius comes from `Theme.of(context)` or
     the shared constants files `design/design.md` points to — never a hardcoded value copied from
     the HTML draft. The HTML gave you the *values*; the *mechanism* for expressing them must still
     be this project's Theme system, not inline literals.
   - Standard file naming (`name.widget.dart` / `name.screen.dart` per
     `CLAUDE.md`'s "File naming conventions").
   - A `// TODO: <status>` header at the top of the file stating why it exists and what happens
     when it's ported (e.g. `// TODO: draft for a Home screen redesign, not yet ported`). This is
     required.
3. Run the mock widget and screenshot the real render (via the `marionette` MCP tool) into
   `design/<feature>/<name>.png` — the permanent visual record. The `<feature>` folder mirrors
   `lib/features/<feature>/` (e.g. `design/settings/license_valid.png`); a feature with only one
   screenshot still gets its own folder, no flat top-level fallback. Never screenshot the HTML
   draft itself; only the real Flutter render, so the permanent record can't drift from what
   Flutter actually produces.
4. Tell the user the mock is ready, where it lives, and that it stays there — tracked in git,
   visible via its TODO header — until its design is ported into the real app, at which point it
   must be deleted (not archived, not left "just in case"). Nothing under `lib/features/` may ever
   import from `lib/design_sandbox/` — enforced by the same CI check.

### Flow 3 — `idea -> html -> mock widget -> end`

Both flows chained: run Flow 1's steps 1-2, stop for the same manual review/approval described in
Flow 1, and only continue into Flow 2's steps 2-4 once the user has approved the HTML and asked to
continue. Never skip the manual gate just because both stages were requested together.

---

## What this skill does not do

- Does not auto-approve a draft and continue to Flutter code on its own — the human gate in Flow 1
  is load-bearing, not a formality.
- Does not port a mock into the real app, and does not delete a mock — that's a separate, deliberate
  task once the user decides a design is final.
- Does not invent theme values — every color/spacing/corner-radius decision routes through the
  project's actual `Theme`/constants system, never a literal copied from the HTML draft.
