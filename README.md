# WorthLoop

A Flutter Android application for tracking and comparing product prices, built with Redux,
layered clean architecture, Drift persistence, and the starter's existing theme system.

Includes one complete, working example feature — **GitHub Explorer** — that exercises the entire
stack end to end: a real HTTP call, a real local database, offline fallback, Redux, and a tested UI.
A temporary **Home** launcher remains while the WorthLoop experience is built incrementally.

## Why this exists

Most Flutter starters give you a folder structure and a "Hello World" screen. This one gives you
a real feature built the way the rest of your app is expected to be built — so the first feature
you add has an actual pattern to copy, not just documentation describing one in the abstract.

## What it demonstrates

- **Layered architecture**, enforced in both directions: `Datasources → Repositories → Use cases →
  Presentation`. Domain code never imports `dio`/`drift`/Flutter widgets directly; each layer only
  knows about the one below it.
- **A real remote + local datasource pair**, not a mocked stand-in: `GithubRemoteDatasource` hits
  GitHub's public REST API via `dio`; `GithubLocalDatasource` caches results in a `drift` (SQLite)
  table. The repository is **fail-open** — a network failure falls back to the last cached copy
  instead of breaking the UI, and only surfaces an error when there's nothing to fall back to.
- **Redux done properly**: typed actions, `combineReducers` with per-action `TypedReducer`s,
  middleware as the only layer that ever unwraps an `Either<Failure, T>`, and a `ViewModel` layer
  so screens never touch the store directly.
- **A 20-preset theming system** — two hand-designed, unbranded defaults (`Default Dark`/`Default
  Light`, generated via `ColorScheme.fromSeed` deliberately, so they stay replaceable) plus 18 real,
  hand-authored ports of recognized community palettes (Dracula, Nord, Solarized, Catppuccin,
  Gruvbox, Monokai, Rosé Pine, and more). Every widget reads color/spacing/corner-radius from
  `Theme.of(context)` — nothing is hardcoded.
- **Full test coverage on the example feature** — 122 tests across the entity, model, drift table,
  both datasources, the repository, every usecase, the full Redux layer, every widget, and the
  screen (including a fixed WCAG accessibility-guideline check group: contrast, tap-target size,
  semantic labels, text-scaling overflow, and keyboard tab order).
- **Documented conventions that are actually enforced** — `ai/context/*.md` defines the
  architecture, Dart style, error-handling, and testing rules this codebase itself follows; a
  `.claude/skills/add-theme-preset` skill exists to add another theme preset correctly on the
  first try.

## Getting started

```bash
git clone <this-repo>
cd worthloop
flutter pub get
dart run build_runner build -d   # generates the drift schema + i18n code
flutter run -d android
```

## Commands

```bash
flutter analyze                          # lint — run before every commit
flutter test                             # unit + widget tests
dart run taskflare test                  # same, with completion feedback
flutter pub get                          # resolve dependencies
dart format .                            # format
dart run build_runner build -d           # code generation (drift schema + slang)
flutter build apk                        # Android APK
```

## Project structure

```
lib/
  features/
    home/                   temporary launcher, replaced during WorthLoop Phase 1
    github_explorer/       # the reference example feature — copy this shape
      domain/               entities, repository interface, usecases (+ params)
      data/                 models, drift schema, remote + local datasources, repository impl
      presentation/         Redux state/actions/reducer/selectors/middleware, viewmodel, screen, widgets
    settings/               appearance/theme/general settings screens
  shared/
    theme/                  the 20-preset theming system
    state/                  root AppState, reducer, Redux store construction
    navigation/             GoRouter wrapper (NavigatorService) + route table
    db/                     the single drift AppDatabase aggregating every feature's tables
    failures/               the Failure hierarchy (NetworkFailure, DatabaseFailure, FileSystemFailure)
ai/context/                 architecture, Dart style, testing, and error-handling conventions
design/                     approved-look screenshots + the app's design-essence doc
test/                       mirrors lib/ exactly, one test file per source file
```

## Tech stack

| Concern | Package |
|---|---|
| State | `flutter_redux` + `redux` |
| Local DB | `drift` + `sqlite3_flutter_libs` |
| HTTP | `dio` |
| Navigation | `go_router` (via `NavigatorService`) |
| File system | `path_provider`, `path` |
| i18n | `slang` + `slang_flutter` |
| App version | `package_info_plus` |
| DI | manual `injection_container.dart` (no code generation) |
| Testing | `flutter_test` + `mocktail` |
| Test/command runner | `taskflare` |

**Platform:** Android. Background refresh and native home-screen widgets are deferred.

## License

MIT — see [LICENSE](LICENSE).
