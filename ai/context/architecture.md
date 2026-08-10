# Architecture

## Layer overview

```
lib/
  features/<feature>/
    data/
      datasources/       # I/O access only — return Models. Never schema/table definitions.
      models/            # DTOs; map to/from entities
        drift_schemas/   # drift Table classes for this feature — schema shape, not access logic
      repositories/      # implements domain interface
    domain/
      entities/          # pure Dart value objects
      repositories/      # abstract interface (I<Name>.repository.dart)
      usecases/          # one public method; pure Dart; no Flutter imports
        params/          # do_thing.params.dart — never bundled into the usecase file
    presentation/
      screens/           # sole top-level content for a context; own ViewModel — see "Screens vs
                         # Sections vs Widgets" below
      widgets/           # dumb, reusable Widgets AND bespoke Sections (own ViewModel, nested
                         # inside one Screen) — subfoldered per subsection once >1 belongs to it
      state/
        feature.actions.dart
        feature.middleware.dart   # side effects; API calls; Isolate spawning
        feature.reducer.dart      # pure function; no I/O
        feature.selectors.dart
        feature.state.dart
        viewmodels/
          name.viewmodel.dart     # fromStore(); formats data for UI
  shared/
    state/               # AppState, AppReducer, CreateStore
    navigation/          # NavigatorService, app_router.dart
    usecase/             # UseCase<T, Params> base class
    utils/
    theme/
    features/            # shared widgets (status dots, resizable panels, etc.)
  injection_container.dart
  main.dart
```

## Dependency direction

```
data → domain ← (interfaces only)
presentation → domain (use cases, entities)
presentation → shared/navigation (NavigatorService)
```

- Domain never imports Flutter, drift, dio, or any infrastructure package.

## Screens vs Sections vs Widgets

Three kinds of presentation-layer classes, decided by two independent questions — not by whether
something has a ViewModel, and not by whether it's independently routable:

- **Position**: is this the sole top-level content for its context (**Screen**), nested inside a
  Screen alongside sibling content (**Section**), or a reusable/repeatable unit (**Widget**)? A
  modal/dialog is judged by the route or overlay it belongs to, not literal widget-tree nesting.
- **Content cohesion**: is its content one specific, unified purpose no matter how internally
  complex (stays a **Widget** — e.g. a repeating list item with its own ViewModel and several
  same-item action buttons), or a bundle of otherwise-unrelated concerns (graduates to
  **Section**/**Screen**)?

Not the test, explicitly:
- **Routability.** A Screen may be selected via a parent's local `setState` (e.g.
  `AppSettingsScreen`'s category switcher) rather than pushed via `NavigatorService`, and still
  counts as a Screen.
- **Having a ViewModel/`StoreConnector`.** Widgets, Sections, and Screens can all have one.
  Rejected idea: "any widget with its own `StoreConnector` is screen-level" — wrong, disproven by
  a repeating list item with its own item-scoped ViewModel that's still a Widget.
- A Section reused inside more than one Screen is still a Section — the test is whether it appears
  alongside siblings inside a Screen, not how many Screens use it.

Corollaries:
- Generalize a stable, identically-shaped, reusable Widget (`SettingsToggleRow`, `DropdownMenu`).
  Keep a Section/Screen bespoke per instance even if several currently look identical — future
  content is unpredictable, and forcing a shared shape fights that growth instead of accommodating
  it.
- A Section/Screen owns resolution of every DI-registered dependency it needs itself — a
  ViewModel+`StoreConnector` for Redux-backed state, or direct `ChangeNotifier` singleton access —
  never receives one as a constructor prop from whatever composed it.

File suffix: `name.section.dart` — see `CLAUDE.md`'s "File naming conventions" table.

## Navigation

- `NavigatorService` wraps GoRouter — see "Services — where do they live?" below for how it's called.
- Verbs: `go`, `push`, `replace`, `pop` (mirrors GoRouter's own API).
- Route paths only via `AppRoutes` constants — never inline strings.

## Theming — data via props, styling via `Theme`

No widget hardcodes a color, text style, spacing/icon-size value, or corner radius — every one of
those comes from `Theme.of(context)` (or, for one-off cross-cutting numbers with no `ThemeData`
slot of their own, a constants file). A value a widget needs to *function* (a callback, the data
it renders) is a constructor prop; a value that's purely *how it looks* is read from `Theme`,
never threaded through constructor params and never fetched via `sl<X>()` inside the widget
itself. This is a stricter version of "widgets are dumb" — `sl` calls belong at the screen/section
level, where instances are already being resolved for other reasons.

- **Colors** — `Theme.of(context).colorScheme`, sourced from `AppTheme` (`shared/theme/app_theme.dart`,
  presets in `app_theme_presets.dart`).
- **Text styles** — `Theme.of(context).textTheme`, built by `buildAppTextTheme()`
  (`shared/theme/app_text_theme.dart`) — the one place `headlineSmall`/`labelSmall` overrides
  (bold headline, muted letter-spaced eyebrow label) are defined; never `.copyWith()` them inline
  in a widget.
- **Spacing / icon sizes** — `Spacing`/`IconSizes` (`shared/constants/layout_constants.dart`).
  These have no `ThemeData` slot, so they're plain `static const double` constants, not read via
  `Theme.of(context)` — still never an inline literal in a widget.
- **Corner radius** — two-layer, mirroring how buttons vs. everything else gets shape in Flutter:
  - Buttons: `ThemeData.filledButtonTheme`/`outlinedButtonTheme` (set once in `main.dart` from
    `AppShape.cornerRadius`) — `FilledButton`/`OutlinedButton` pick this up automatically, no
    per-widget code needed.
  - Everything else (a `Container`'s `BoxDecoration`, a `DropdownButton`'s `borderRadius`) —
    `Theme.of(context).extension<AppShapeThemeExtension>()?.cornerRadius`
    (`shared/theme/app_shape_theme_extension.dart`), with a fallback to
    `cornerRadiusPresets[CornerStyle.rounded]` if the extension isn't present (e.g. a widget test
    with a bare `ThemeData()`).
  - The selected preset itself lives in `AppShape` (`shared/theme/app_shape.dart`, mirrors
    `AppTheme`/`AppZoom`'s persisted-`ChangeNotifier` shape) + `CornerStyle` enum
    (`shared/constants/enums.dart`) + `cornerRadiusPresets` map (`shared/theme/app_shape_presets.dart`).
    No picker UI exists yet — this is the swappable-preset plumbing only. See the `// TODO` on
    `AppShape.setCornerStyle()` (`shared/theme/app_shape.dart`).

## Redux flow

- **Redux vs local `State`**: the test is "does anything outside this screen read, react to, or
  need this value to persist?" If yes (shared across screens, drives a usecase, must survive the
  widget being rebuilt elsewhere) → Redux. If it's purely how one screen presents itself right now
  — a selected tab/category, an expanded/collapsed flag, scroll position — it stays as plain
  widget `State` (`setState`), even inside a feature whose *other* state genuinely is in Redux.
  Routing a value through an action/reducer/`StoreConnector` that nothing else ever reads doesn't
  make it more correct, just slower to change. See `dart-style.md`'s "Flutter-specific" section.
- `Screen/Section (onPressed) → ViewModel method → dispatch(Action) → Middleware → dispatch(ResultAction) → Reducer → AppState → StoreConnector(distinct: true)` —
  see "Screens vs Sections vs Widgets" above for why a plain Widget never appears in this chain.
- Screens/Sections never call `store.dispatch`, a use case, a repository, or a service directly —
  see "Services — where do they live?" below for what actually calls what.
- **ViewModels are resolved via DI, not called directly.** Register each with
  `sl.registerFactoryParam<XxxViewModel, Store<AppState>, void>((store, _) => XxxViewModel.fromStore(store))`
  in the feature's injection container. The screen's `StoreConnector.converter` calls
  `(store) => sl<XxxViewModel>(param1: store)` — never `XxxViewModel.fromStore` directly. This is
  what makes the viewmodel mockable in screen tests (see `ai/context/testing.md`'s Screens section)
  without needing real selectors/state.
- **ViewModels are thin connectors, not logic owners.** `fromStore()` reads already-computed values
  via selectors and builds callbacks around `store.dispatch` — it doesn't re-derive, filter, or
  branch on state itself. A callback that conditionally dispatches is the one exception, since that
  decision only exists inside the closure the viewmodel builds; any other branching belongs in a
  selector, reducer, or middleware instead.
- **Reducers**: `combineReducers` + `TypedReducer` per action, never an `if (action is X)` chain.
  Unhandled actions pass through unchanged automatically. Doc-comment format for `TypedReducer`
  handlers: see `dart-style.md`'s "TypedReducer handlers" section.
- **Middleware**: `call()` calls `next(action)` *before* the `switch (action)` that dispatches to
  handlers — getting this order backwards means a handler reads stale `store.state`, since the
  reducer hasn't run yet. Every feature's middleware and the reducer's "unhandled actions pass
  through" contract assume this ordering. Class/handler naming conventions: see `dart-style.md`'s
  "Class naming patterns" section.
- Handlers: `Future<void> _handlerName(Store<AppState> store, XxxAction action)` only — no raw
  domain objects, primitives, or `BuildContext` params. Two load-bearing reasons: a `BuildContext`
  captured inside an `async` handler can be used after the widget unmounts (crashes on a
  deactivated widget's ancestor lookup), and requiring everything to come from `action` is what
  makes "dispatch a dedicated action to share logic between handlers" (below) actually enforceable
  — a raw-parameter helper would bypass it silently.
- Use cases and services are resolved via `sl<X>()` inside each handler — never injected as a
  constructor or factory parameter.
- To share logic between handlers, dispatch a dedicated action — never a raw-parameter helper.
- The `Store` is built exactly once, via `CreateStore` (`lib/shared/state/create_store.dart`).
  `distinct: true` always. Each feature's middleware is added to its `middleware` list as that
  feature is built.

## Feature call chain

- For feature business logic: `Middleware → UseCase → Repository → Datasource` — no skipping a
  layer. This governs feature-owned operations only; cross-cutting plumbing with no business rule
  behind it (`PopupService`, `NavigatorService`, etc.) isn't part of this
  chain — see "Services — where do they live?" below for how each is actually called.
- One-off I/O (file picker, parser, API client wrapper) belongs to that feature's own datasource —
  never a generic "service" file.
- A feature commonly needs both `feature_local.datasource.dart` (drift/local I/O) and
  `feature_remote.datasource.dart` (dio/HTTP). The repository is the only thing holding both and
  deciding which to call — a usecase never picks between them; that's a data-coordination concern.

## Feature vs shared — deciding which

If new code clearly belongs to an existing named feature — its name/domain maps directly to a
`features/<name>/` folder (e.g. `ProjectModel` → `features/projects/`) — place it there without
asking.

If it's not obvious — a new screen/widget/class that doesn't map cleanly to an existing feature,
or could plausibly be its own new feature vs. shared infrastructure — stop and ask the user before
creating the folder/file. Don't guess.

If no user is reachable to ask (an unattended/autonomous run), halt — do not create the
file/folder. Leave the ambiguous placement for a human to decide; a stalled task is recoverable, a
wrongly-placed file is exactly the rework this rule exists to avoid.

The ask-first rule isn't one-shot at initial file creation — it re-fires the first time a
`datasource`/`repository`/`usecase` file (or a drift table) is about to be added for something
nested inside another feature's folder. A nested screen gaining its own data layer is itself
evidence it may deserve `features/<name>/`, even if the original screen placement was reasonable
when it was UI-only.

`lib/shared/` is for plumbing with no feature identity of its own (`NavigatorService`, `AppTheme`) —
not a parking spot for "a screen that happens to be thin right now." Don't
pre-build the empty `data/`/`domain/` folders before a category needs them, though — that's the
same speculative-scaffolding mistake as pre-building a `Failure` hierarchy (see
`error-handling.md`); add `domain/usecases/` etc. when a feature's business logic is actually
implemented, not now. Entities/Models/DTOs are exempt — they're typed data shapes, not logic; add
one as soon as presentation needs a typed shape, even with no repository/usecase behind it yet.

## Services — where do they live?

- No generic "service layer" inside a feature.
- App-wide plumbing with no business rule behind it → `lib/shared/utils/`, DI-registered — never
  wrapped in a usecase.
- **Who can call a service**: middleware, usecases, repositories, datasources, and other services
  may call a service directly. Presentation (a widget, Section, Screen, or ViewModel) may never
  call a service directly — no exceptions beyond the one documented below (`ChangeNotifier`-based
  services). If the caller isn't one of the layers just listed, it can't call a service.
- Where it's *called from*, among the allowed layers, depends on what triggers it:
  - **Extends `ChangeNotifier`** (holds its own observable state, e.g. `AppTheme`, `AppShape`,
    `AppZoom`) — there's no "when should this run" decision to centralize; reading its current
    value and calling a setter are the only two operations it has. This is presentation's one
    documented exception — consumed directly wherever needed (a Screen, a Section, a widget via
    `AnimatedBuilder`).
  - **Triggered by a dispatched Redux action** (e.g. `PopupService`, `NavigatorService`) — the
    "when" is a business/orchestration decision, called by whichever layer already owns it
    (usually middleware).
  - Services may call other services directly. A service must never dispatch a
    Redux action itself — only middleware dispatches Redux actions on their behalf.
- Test: feature-specific logic → datasource (see Feature call chain). App-wide plumbing with no
  owning feature → `shared/utils/`.
- `lib/shared/constants/` holds cross-cutting constants, split by kind — create each file only when
  it's actually needed, not upfront:
  - `app_constants.dart` — cross-cutting business constants (e.g. a list cap), not inlined magic numbers.
  - `enums.dart` — every enum in the app, no matter which feature currently uses it. All enums are
    project-wide constants by convention — see `dart-style.md`'s "Enums" section.
  - `layout_constants.dart` — paddings, spacing, sizing. Never mixed into `app_constants.dart`.
  - Within a constants file, one class per feature/concern — never one flat catch-all class.
- Example: `PopupService` (`lib/shared/utils/popup_service.dart`) — never wrapped in a usecase,
  since showing a popup isn't a business rule. Never called directly outside `LoggerService`
  either — see `dart-style.md`'s Logging section for why every user-facing message routes
  through `LoggerService`'s `showPopup` param instead.
- When a control's backing logic isn't implemented yet (a no-op button, or a value that persists but
  nothing consumes it), its handler still does whatever real work exists (e.g. persist the value) and
  calls `PopupService.show('<Feature> is not implemented yet.')`, with a `// TODO` on the action
  stating what's missing.

## Database (drift)

- Table classes (`extends Table`) live under that feature's `data/models/drift_schemas/`, one
  table per file — never in `datasources/` (I/O access only, not schema) and never in
  `lib/shared/db/`.
- `lib/shared/db/app_database.dart` only aggregates every feature's tables into one
  `@DriftDatabase` — it never defines a table itself.
- Migrations: increment version, add an idempotent `MigrationStrategy` step.
- Local datasources own DB access; domain never touches drift directly.
- Entity and Model are always separate files. Model `extends` Entity directly (e.g. `ProjectModel
  extends Project`) — no `toEntity()` mapping method; a `fromRow()` factory builds the Model
  straight from a drift row, and the Model satisfies any signature expecting the Entity.

## Background refresh

Product-source fetching runs in a second Flutter engine hosted by an Android foreground service
(`BackgroundRefreshService.kt`), independent of whether the app is foregrounded — this is
deliberate: exiting the app must not interrupt an in-progress refresh.

- **Two isolates, two DI containers.** The main app engine and the background engine each call
  `initDependencies()` separately, so a singleton (e.g. `ProductsRepository`) in one isolate is a
  *different object* from the one in the other. They never share Dart state directly — only
  through the drift database (one SQLite file both isolates open) and a `MethodChannel` between
  the native service and whichever engine it's driving.
- **Entrypoint resolution**: the background isolate's entrypoint
  (`lib/shared/background_refresh_entrypoint.dart`, `@pragma('vm:entry-point')`) is resolved via a
  `CallbackHandle` registered from `main.dart` and stored natively — never a hardcoded
  library-path string, which breaks silently across Dart AOT builds.
- **The database is the single source of truth for live refresh state** — not Redux, not a
  SharedPreferences/JSON-blob side channel. `ProductSourceTable.liveStatus` holds a source's
  in-progress state (`queued`/`fetching`) and clears to `null` once terminal.
  `productsUpdatedFromDatabaseReducer` derives `sourceRefreshStatuses`/`isRefreshingAll`/
  `refreshingProductIds` fresh from each `watchProducts()` stream emission — it never merges with
  the reducer's previous state. Redux is a read-only projection of DB state for anything
  refresh-related; nothing dispatches a "refresh started/progressed/finished" action to drive it.
- **Entry point**: `IProductsRepository.enqueueSourceRefresh(sourceIds, {bypassCooldown})` is the
  only way to trigger a fetch. It queues each source onto a queue keyed by merchant domain and
  starts (or wakes) a bounded pool of worker loops — never two concurrent fetches to the same
  merchant, several different merchants at once. A source can be enqueued mid-run (e.g. retrying
  one failed source) and lands in its own merchant's queue without waiting for anything else in
  flight.
- Middleware calls `AndroidBackgroundRefreshService.enqueueSources()` and returns immediately — it
  never awaits a fetch result. The UI updates when the DB stream reflects the change, not when the
  dispatch call returns.
- CRUD (create/edit/delete a product or source) always stays synchronous and foreground — never
  routed through the background engine. Only fetching does.
- `resetStaleSourceStatuses()` runs once at background-isolate startup to clear any `queued`/
  `fetching` row left behind by a process that was killed mid-refresh.

## Route conventions

- Paths: kebab-case (`/projects/new`, `/runner/run-history`).
- Routes defined in `app_routes.dart`, router in `app_router.dart`.
- `StatefulShellRoute` for persistent shell / sidebar navigation.
