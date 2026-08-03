---
name: convention-review
description: Slow, careful, one-group-at-a-time audit of existing code against this project's conventions (CLAUDE.md + ai/context/*.md). Use when the user gives a group of files/a directory and asks to review or audit it for convention violations, fix what's found, and commit — one group per invocation, never the whole codebase at once.
---

# Convention Review

Audits one group of existing files against this project's full conventions, fixes every
violation found, then stops. No need for speed — thoroughness over pace. One group per
invocation; never chain into the next group on your own initiative.

## Invocation

`/convention-review <group>` — `<group>` is a directory or an explicit file list the user
supplies (e.g. `lib/shared/theme/` or "app_font.dart, app_font_presets.dart, app_zoom.dart").

If no group is given, ask which group to review. Do not guess a scope.

## Process

### 1. Read conventions fresh — every time, no exceptions

Read `CLAUDE.md` in full, then every file listed under its "Full conventions" section
(`architecture.md`, `dart-style.md`, `testing.md`, `error-handling.md`) in full. Do not rely on
memory from a prior group or a prior session — read them fresh this run. This mirrors
`CLAUDE.md`'s own "Convention audits" section: never substitute a checklist, a summary, or a
subset of rules for the full text. A fixed list of "things to check" is how real violations get
missed — whatever isn't on the list quietly stops getting checked.

If the group touches a feature with its own dedicated doc under `ai/context/features/`, read that
too.

### 2. lib files first, entirely, before touching any test file

Read every lib file in the group. Check each one against everything just read — not a subset,
not whatever rule happens to be top-of-mind. This includes (non-exhaustively — the docs just read
are the actual source of truth, this is not a substitute checklist):

- Doc comments present and correctly scoped; `[SymbolName]` brackets, never backticks, with the
  import added even for a Flutter SDK class
- No magic numbers — literals route through `context.spacing`/`resolvedCornerRadius`/
  `layout_constants.dart`
- No hardcoded color/`TextStyle`/corner radius — sourced from `Theme.of(context)`
- Correct Screen vs Section vs Widget classification
- Correct Services categorization (`ChangeNotifier` vs middleware-only vs listener-wired)
- Explicit types on `final` locals; no `!`; no bare `catch`; no `any`/accidental `dynamic`
- Correct field/constructor member ordering
- No fact/rule duplicated across two files or two sections — restating the same rule in two
  places is how they silently drift apart later

Fix every violation found. Do not restructure, rename, or reclassify anything a real violation
doesn't require — fixing conventions is not licence for a drive-by refactor. Run `flutter
analyze` once the group's lib files are fixed — it must be clean (only pre-existing, unrelated
infos allowed) before moving to test files.

### 3. Then test files for the same group

Read every test file for the group (mirror path under `test/`, per `testing.md`'s "File
structure" rule). Check against `testing.md` in full: group naming/templates for that layer,
symmetric not-called tests, error-branch completeness, fixture usage, what-to-mock rules. If a
lib file in this group has no test file at all, or has an obvious coverage gap testing.md would
flag (a missing branch, a missing symmetric test), add it now rather than deferring — but do not
invent new test scope beyond what the file's own behavior calls for.

Fix every violation found. Run `flutter test <affected paths>` — must pass before continuing.

### 4. Commit

Stage exactly the files touched in this group — never `git add -A`/`git add .`. Write a real
commit message in this repo's normal style (see recent `git log` for tone/format): a concise
summary line, plus a body explaining what was wrong and why, when the fix isn't self-evident from
the summary alone.

### 5. Stop

Report the commit made in one line. Then wait — do not start another group, and do not re-run
`flutter test` broadly, until the user says "continue" or gives a new group.

## What this skill does NOT do

- Does not decide the group boundaries itself — the user supplies the group each time.
- Does not chain multiple groups into one invocation or one commit.
- Does not treat "no violations found" as a reason to skip the report — say so plainly, make no
  commit, and still stop and wait.
