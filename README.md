# WorthLoop

A production-grade **Flutter desktop** starter template — Redux state management, layered clean
architecture, real remote + local datasources, a 20-theme system, and full test coverage. Built as
a foundation to clone and build a new desktop app on top of, not a toy example.

Includes one complete, working example feature — **GitHub Explorer** — that exercises the entire
stack end to end: a real HTTP call, a real local database, offline fallback, Redux, and a tested UI.
A compact **Home** launcher screen sits in front of it, doubling as a demo of real native
window-size management.

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
- **Real native window management, not just app UI** — Home is a compact, non-resizable launcher
  (`WindowController.lockHome`/`unlockAndRestore`, `HomeWindowSizeService`); opening GitHub Explorer
  or Settings unlocks the window to full size, and going back re-locks it to Home's fixed size.
  Still being hardened: the frame-overhead measurement is taken once and reused, which can go stale
  after a multi-monitor move with a different DPI scale, and there's no visual affordance yet
  telling the user the window is intentionally non-resizable while locked.

## Getting started

```bash
git clone <this-repo>
cd worthloop
flutter pub get
dart run build_runner build -d   # generates the drift schema + i18n code
flutter run -d windows           # or -d macos / -d linux
```

## Commands

```bash
flutter analyze                          # lint — run before every commit
flutter test                             # unit + widget tests
dart run taskflare test                  # same, plus a desktop notification when it finishes
flutter pub get                          # resolve dependencies
dart format .                            # format
dart run build_runner build -d           # code generation (drift schema + slang)
flutter build windows                    # Windows release build
flutter build macos                      # macOS release build
flutter build linux                      # Linux release build
```

## Releases

Windows ships as a proper installer, not a bare `.exe` — [Inno Setup](https://jrsoftware.org/isinfo.php)
(`windows/installer/setup.iss`) wraps `flutter build windows`'s output into a single
`WorthLoopSetup.exe` that installs to Program Files, adds Start Menu/desktop
shortcuts, and registers an uninstaller. Pushing a `v*` tag (e.g. `v0.1.0`) runs
`.github/workflows/release.yml`, which builds the app, compiles the installer, and publishes it to
this repo's [Releases page](../../releases) automatically — nothing is built or uploaded by hand.
No code signing certificate (budget constraint), so Windows SmartScreen will warn on first install;
see `CLAUDE.md`'s "Windows distribution notes."

## Project structure

```
lib/
  features/
    home/                   the compact launcher screen (navigation only, no domain/data layer)
    github_explorer/       # the reference example feature — copy this shape
      domain/               entities, repository interface, usecases (+ params)
      data/                 models, drift schema, remote + local datasources, repository impl
      presentation/         Redux state/actions/reducer/selectors/middleware, viewmodel, screen, widgets
    logs/                   a second, simpler local-only feature (drift-backed log viewer)
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
| File system | `path_provider`, `path`, `file_selector` |
| Clipboard | `super_clipboard` |
| OS notifications | `local_notifier` |
| i18n | `slang` + `slang_flutter` |
| App version | `package_info_plus` |
| DI | manual `injection_container.dart` (no code generation) |
| Testing | `flutter_test` + `mocktail` |
| Test/command runner | `taskflare` |

**Platforms:** Windows, macOS, Linux. No mobile flavors, no `auto_updater`/Sparkle-style updater,
no ARB files — see `CLAUDE.md` for the full list of what's deliberately not used and why.

## License

MIT — see [LICENSE](LICENSE).
