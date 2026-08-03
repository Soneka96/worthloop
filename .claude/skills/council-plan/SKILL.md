---
name: council-plan
description: Turn a council verdict into a step-by-step implementation plan with tests, then wait for the user to commit manually. Use after /council reaches a decision.
---

# council-plan

Turn a council verdict into a numbered implementation plan with tests. Execute one step at a time. Print a commit message at the end. Never commit automatically.

**This skill is output-only at the planning stage. It must never write files or run shell commands until the user says "continue".**

---

## Invocation

`/council-plan` — reads the council verdict from the current conversation context.

**If no council verdict is visible:** ask "What decision should I plan the implementation for?" If the user declines to answer, abort — do not hallucinate a plan.

**If the verdict lacks enough implementation detail:** ask one clarifying question before building the plan — never infer ambiguous scope.

---

## Execution Protocol

### 1. Read conventions first

Before producing any plan, read `CLAUDE.md` in full, then follow every file path listed under its
"Full conventions" section and read each one. Do not hardcode specific convention file paths in
this skill — `CLAUDE.md` is the index, and indexes move; always resolve paths from it fresh each
run so this step never goes stale when conventions are reorganised.

Never embed their contents in the skill. Use the `Read` tool to read them fresh every run — do
not rely on conversational memory of these files' prior contents, even if they were discussed or
edited earlier in the same conversation. Memory can be stale the moment a file changes outside
the conversation; an actual `Read` call is the only way to guarantee the plan is built from what
is on disk right now.

### 1b. Verify referenced code with codegraph

This repo is indexed by CodeGraph (`.codegraph/`). Before naming a specific symbol, file, or
function in a step, confirm it exists with `codegraph_node`/`codegraph_explore` (or `codegraph
node <symbol>` from the shell) rather than assuming from the verdict discussion. A plan step that
names a symbol which doesn't exist yet (typo, renamed, never existed) wastes a step on execution
failure — catch that here, before the plan is shown to the user.

### 1c. Design coverage check (UI changes only)

If the verdict involves building or reshaping a screen or widget with a real aesthetic/UX
decision (new layout, a flow not seen before, anything beyond wiring an existing pattern — same
bar as `CLAUDE.md`'s "Visual design" section), check `design/` for a matching screenshot first.

- **Covered already** (a screenshot for this screen/widget exists): match it, don't re-derive or
  improvise around it.
- **Not covered, and big enough to involve multiple real aesthetic decisions** (not a single
  field tweak or pure data-wiring change): stop before producing a plan. Output exactly:

  ```
  This touches [screen/flow], which has no approved screenshot in design/ yet.
  Talk it through with the frontend-design skill first, get a screenshot approved, then
  re-run /council-plan.
  ```

  Do not produce implementation steps for an undecided aesthetic surface — without an approved
  look, the steps would just be guesses that get rebuilt once the design is actually decided.
- **Not covered, but small** (a field, a copy change, wiring an existing pattern onto a new
  screen): proceed normally, no gate needed.

### 2. Extract the decision

From the council verdict, identify:
- What is being built or changed
- Which layer(s) it touches — datasources / repositories / use cases / presentation (screens, widgets, viewmodels, Redux state)
- Any `SHIP WITH FLAGS` flags — these become **advisory notes** on the relevant step, not extra steps

### 3. Output the full plan

Print all steps **before executing anything**. The user reviews and can redirect before a file is touched.

**Step format:**

```
## Step N — <short title>

**What:** <verb> <symbol> in <file path>  (e.g. `add verifyLicense to license.repository.dart`)
**Tests:** <test file> — <specific behaviours: what inputs, what assertions, what edge cases>
  - Test type: [domain: pure unit, no Flutter/mocks beyond repo interface | redux: reducer (group by action)/selector unit | widget: flutter_test behaviour | screen: flutter_test integration-style]
  - Coverage target: [domain use case / reducer / selector: 100% | widget: 70%+ | screen: 50%+]
  - Multi-assert tests: add `reason:` to each `expect()` per ai/context/testing.md
[⚠️ Flag: <council flag if applicable>]
```

Rules:
- Order: datasources → repositories → use cases → presentation
- If the change touches 2+ features, explicitly state which files go in `lib/features/<feature>/` vs `lib/shared/`
- Mirror `lib/` under `test/`, one test file per source file (e.g. `lib/features/projects/domain/usecases/start_run.usecase.dart` → `test/features/projects/domain/usecases/start_run.usecase_test.dart`), per `ai/context/testing.md`
- **Every file introduced or modified must have at least one test step** — a modified existing function needs its existing test file updated, not just new files covered — "don't add unnecessary steps" never justifies skipping tests
- Keep steps small enough to verify independently
- Do not pad steps — a small fix may only need 1–2

### 4. Confirm before starting

After the full plan, output exactly:

```
Plan ready — N steps. Reply "continue" to proceed, or describe any changes to the plan.
```

Wait for the user.

### 5. Execute one step at a time

When the user says "continue":
- Prefix output with `[Step N / Total]`
- Implement the change described in the step
- **Write the test file as part of this step** (not after), then run it with `flutter test <path>`
- If tests fail: fix the issue before moving on. **Cap fix attempts at 2** — if the same step's tests still fail after 2 fix attempts, stop and surface it:
  ```
  [Step N / Total] blocked — tests still failing after 2 fix attempts.
  Last error: <error summary>
  How would you like to proceed? (debug together / skip this step / change approach)
  ```
  Do not retry a third time silently.
- Surface the test result inline: `✅ X tests passing` or `❌ N failed — fixing…`

Then output exactly:

```
[Step N / Total] done — ✅ tests passing.

## Commit message
# type: feat | fix | refactor | test | chore
<type>: <summary under 72 chars>

Reply "continue" for Step N+1.
```

Do not auto-proceed. Wait for "continue" each time.

The commit message appears after **every** step — not just the last one. The user commits manually after each step before continuing.

Print the commit message string only. Do not offer to run `git commit`.

---

## Constraints

- No auto-execution between steps
- No `git commit` or any git commands
- No snapshot tests (project convention, see CLAUDE.md "Never do")
- No `any` type, no `!` null assertion (project convention, see CLAUDE.md "Never do")
- Domain/use case files: zero Flutter imports (pure Dart)
- Step granularity is advisory — adapt to the size of the change
- Every new or modified file gets a test — no exceptions
- Fix-attempt cap of 2 per step before stopping to ask the user
