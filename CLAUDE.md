# WorthLoop — Claude Instructions

A production-grade Flutter **Android** application — Redux state management, layered clean
architecture, drift local persistence, dio-backed remote datasources, a 20-theme system, and full
test coverage. Includes one worked example feature,
GitHub Explorer (`lib/features/github_explorer/`), demonstrating the full
remote+local-datasource → repository → usecase → Redux → screen chain — copy its shape when
adding your own feature.

## Never do

- Put more than one class in a file — one class, one file, always. **Exception:** a `StatefulWidget`
  and its paired `State<T>` class live in the same file — that's the framework's own pairing, and
  splitting them buys nothing. No other exceptions.
- Call GoRouter directly from widgets — always go through `NavigatorService`
- Put console log entries in Redux state — use `StreamController` or `ValueNotifier` ring-buffer outside the store
- Use `StoreConnector` without `distinct: true` — every global dispatch rebuilds the widget otherwise
- Use eager `ListView` with concrete children for data-driven lists — always `ListView.builder`
- Watch an unbounded drift table during an active operation — paginate or debounce the stream
- Use `print()` — use the `logger` package
- Use `!` null assertion operator — prefer `??` or explicit null checks
- Use `any` type
- Write snapshot tests

## Visual design

`design/` holds approved-look screenshots (PNG), organized by feature to mirror
`lib/features/<feature>/` (e.g. `design/settings/appearance.png`). Check there before designing or
implementing a screen — if a screenshot exists, match it rather than re-deriving a decision.
`design/design.md` covers the app's essence; the screenshots are the source of truth for a
specific screen's look.

Before building or reshaping a screen or widget that involves a real aesthetic decision (new
layout, colour/typography choice, empty/error state, anything beyond wiring an existing pattern) —
invoke the `frontend-design` skill for direction before writing the widget. Adapt its guidance to
Flutter: tokens live in `ThemeData`/`TextTheme`, not CSS; layout via `Row`/`Column`/`ConstrainedBox`,
not flexbox/grid. Its principles still apply directly — avoid templated defaults, make one
deliberate choice per screen, keep restraint, respect the accessibility floor (contrast, focus,
text scaling — see `ai/context/testing.md`'s "Screen accessibility checks" section), write
empty/error-state copy in the interface's voice. Skip it for pure data-wiring changes (a new field
on an existing layout, a Redux dispatch) — it's for decisions, not plumbing.

## Architecture

See `ai/context/architecture.md` for the full layer rules — not restated here.

```
Datasources → Repositories → Use cases → Presentation (screens / widgets / viewmodels / Redux state)
```

## Theming

20 hand-authored theme presets under `lib/shared/theme/presets/` (`Default Dark`/`Default Light`
are this template's own unbranded default, generated via `ColorScheme.fromSeed` deliberately — a
starter's default should be replaceable, not a designed identity; the other 18 are real,
recognized, hand-authored community palettes such as Dracula, Nord, Solarized, Catppuccin, and
Gruvbox). Use `.claude/skills/add-theme-preset/SKILL.md` to add another one.

## Tech stack

| Concern | Package |
|---|---|
| State | `flutter_redux` + `redux` |
| Local DB | `drift` + `sqlite3_flutter_libs` |
| HTTP | `dio` |
| Navigation | `go_router` (via `NavigatorService`) |
| File system | `path_provider`, `path` |
| i18n | `slang` + `slang_flutter` for app text; SDK `flutter_localizations` for Material/Cupertino's own built-in strings once a non-English locale is supported |
| App version | `package_info_plus` |
| DI | manual `injection_container.dart` |
| Testing | `flutter_test` + `mocktail` |
| Test/command runner | `taskflare` |

**Not used:** background workers, native home-screen widgets, ARB files, FCM, or mobile flavors.

## File naming conventions

| Type | Suffix |
|---|---|
| Widget | `name.widget.dart` |
| Section | `name.section.dart` |
| Screen | `name.screen.dart` |
| Use case | `do_thing.usecase.dart` |
| Use case params | `do_thing.params.dart` — in `usecases/params/`, never bundled in the usecase file |
| Entity | `name.entity.dart` |
| Model | `name.model.dart` |
| Actions | `feature.actions.dart` |
| Middleware | `feature.middleware.dart` |
| Reducer | `feature.reducer.dart` |
| Selectors | `feature.selectors.dart` |
| State | `feature.state.dart` |
| ViewModel | `name.viewmodel.dart` |
| Repository | `feature.repository.dart` / `Ifeature.repository.dart` |
| Datasource | `feature_remote.datasource.dart` / `feature_local.datasource.dart` |

## Commands

```bash
flutter analyze                          # lint — run before every commit
flutter test                             # unit + widget tests
dart run taskflare test                  # same, with a completion notification
flutter pub get                          # resolve dependencies
dart format .                            # format
dart run build_runner build -d           # code generation (drift schema + slang)
flutter run -d android                   # run on Android
flutter build apk                        # build an Android APK
```

## Full conventions

- Architecture + patterns: `ai/context/architecture.md`
- Dart style rules: `ai/context/dart-style.md`
- Error handling: `ai/context/error-handling.md`
- Testing patterns: `ai/context/testing.md`

## Convention audits

When asked to review, audit, or "make this file follow the conventions": re-read the full text of
`dart-style.md`, `testing.md`, `architecture.md`, and `error-handling.md` against the file, every
time. Never substitute a checklist, a summary, or a subset of rules for the full text.

## Reviewing these docs

- Rules in `ai/context/architecture.md` — judge by "does this prevent a bug/regression."
- Rules in `ai/context/dart-style.md` — judge by "does the user want this," full stop.
  Cost, verbosity, or "no bug results if removed" are not valid grounds to cut a style rule.
