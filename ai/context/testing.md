# Testing

## Libraries

- `flutter_test` — widget and integration tests (SDK, no extra package)
- `mocktail` — mocks; no code generation needed

---

## General rules

- Prefer `mocktail` over `mockito` for mocking — no code generation, no `.mocks.dart` files.
- Never write manual stub classes (`class FooStub implements IFoo { ... }`) — use
  `class MockFoo extends Mock implements IFoo {}` for mocks and `class FakeFoo extends Fake implements IFoo {}`
  for `registerFallbackValue` only.
  - Exception: Flutter plugin `PlatformInterface` test doubles follow the plugin's documented
    platform-test shape. They are not hand-rolled interface stubs and stay as-is rather than being
    replaced by a `Mock`/`Fake`.
- For any test using `test()` (Datasources, Repositories, Usecases, Selectors, Utils, Middlewares, Reducers —
  no widget tree involved), mock every dependency the class under test calls, including a `ChangeNotifier` one
  (e.g. `SnugToastManager`, `AppTheme`) — never register a real instance. A dependency's own behaviour is
  covered by its own test file; a caller's test verifies only that it invoked the dependency correctly. This
  does not apply to `testWidgets()` tests (Widgets, Sections, Screens) — those build a real widget tree on
  purpose and register real `ChangeNotifier` theme/state holders (`AppTheme`, `AppShape`, `AppFont`, `AppZoom`)
  so the render reflects real values; only the viewmodel/service layer gets mocked there (see each layer's own
  section).
- Test file mirrors source: `lib/features/projects/data/datasources/projects_local.datasource.dart` →
  `test/features/projects/data/datasources/projects_local.datasource_test.dart`.
- Group tests by method/behaviour.
- No nested groups — a group should only contain tests, not sub-groups.
- Do not create tests outside of groups. Even a single test must be inside a group.
- `setUp()` should be defined per group, or in `main()` if there is only one group or the setup is shared
  across all groups.
- Use `setUp`/`tearDown` for `AppDatabase` (drift) test instances — open in `setUp`, `await db.close()` in
  `tearDown`.
- Import ordering: external package imports first, then internal
  (`package:worth_loop/...`) imports, each group alphabetized, separated by
  a blank line between the two groups.
- Widget-under-test variable naming follows the class name (e.g. `HomeScreen` → `homeScreen`).
- Use `async`/`await` only when necessary.
- Mock HTTP calls with Dio interceptors or `mocktail` — once a remote datasource exists, never hit a real
  endpoint in a test.
- Test JSON fixture files (remote datasource responses, etc.) live in `test/features/<feature>/` next to the
  test that uses them — once a remote datasource needs one. Local (drift) datasources don't need JSON
  fixtures; seed rows directly.

---

## Assertions

- For primitive/value-type properties (`bool`, `int`, `String`, …): two `expect` calls in order —
  `isA<T>()` first, then the exact expected value second.
- For function/callback-type properties: assert only the type (`isA<Function()>()`).
- For every test that verifies a method **is** called under a condition, a symmetric test must verify it is
  **not** called when that condition is absent.

---

## Test Naming

- In test descriptions, write "in state" when the condition is a value inside `AppState`; write "in the store"
  only when the condition is about the `Store` instance itself.
- Test descriptions for method-behaviour tests must use the actual method or action name — not a domain
  synonym (e.g. "calls `insertProject`", not "persists the project").
- Test descriptions within a group must use a consistent verb:
  - **`contains`** — structural presence of a widget node
  - **`displays`** — visible text or translatable content
  - **`calls`** / **`dispatches`** — side effects
- When a test verifies a design-system token value, use the exact token name, not an approximate description.
- When a test verifies that something exists in a specific state/configuration (not just its bare presence),
  add "with correct parameters" before "when [condition]": "[Thing] contains/is [Something] with correct
  parameters when [condition]". Any extra descriptor is optional context, not required.
- For any equality condition on a field/param, use literal Dart syntax, never prose ("is present"/"is absent"/
  "is [value]"): null checks read "when [field] == null" / "when [field] != null"; specific-value checks
  (including enums) read "when [field] = [value]" or "when [field] = [Type].[value]" (e.g.
  "when limit = 5", "when level = LogLevel.error").
  - Exception: when a constructor/param is passed `null` specifically to simulate an uninitialized dependency
    (e.g. a repository not yet wired up), prose like "when AppDatabase is not initialized" is preferred over
    "when AppDatabase == null" — it describes the dependency's lifecycle state, not a value being checked by
    the code under test.

### Group naming by layer

Every test groups by what kind of thing is being verified:

| Shape | Group template | Test template | Verb(s) | Layers |
|---|---|---|---|---|
| **Identity check** — structural contract, once, no condition | `"[ClassName] <extends/implements> the appropriate <parent>"` | `"[ClassName] is a(n) <subclass/implementation> of [Parent]"` | — | Models (extends Entity), Repositories (implements I*Repository) |
| **Behavior check** — output depends on input/state | one group per method/action — literal template per layer, see table below | `"[verb] [literal expected value] when [condition]"` | `returns` (datasources/usecases/selectors/utils/repositories), `modifies` (reducers), `calls`/`dispatches` (middlewares) | Datasources, Usecases, Repositories (2nd group), Selectors, Utils, Middlewares, Reducers |
| **Presence check** — does the UI contain the right children | `"[Name] contains widgets"` | `"[Name] contains [Child] with the correct parameters"` | `contains` | Screens, Sections, Widgets — all three start here, then diverge (see per-layer additions below) |
| **Structural/setup check** — a class/file's own setup, not a per-condition behavior | `"[Name] — <aspect>"` (e.g. `"ProjectsState — initial"`, `"ProjectsState — copyWith"`, `"injection_container — shared registrations"`, `"ProjectTable — round trip"`) | plain sentence naming what's verified — no fixed "when [condition]" template | — | Redux `*.state.dart` classes, `*.injection_container.dart` files, drift `*.table.dart` schema classes |
| **Fixed one-off** — Routes | `"GoRouter instantiates the correct screen"` | `"GoRouter navigates to the [ScreenName]"` | — | Routes |

Repositories appear in **both** tables — the Identity-check row above (once, confirms it implements
its interface) and the Behavior-check table below (once per method) — both groups are required, not
alternatives.

Behavior-check group templates, one per layer:

| Layer | Group template |
|---|---|
| Datasources | `"Method insertProject() returns the correct value"` |
| Usecases | `"Usecase CreateProjectUseCase returns the correct value"` |
| Repositories (2nd group, per method — the class also gets an Identity-check group above) | `"[RepositoryName] implements [method]() correctly"` |
| Selectors | `"Method [selectorName]() returns a/an [ReturnType] instance"` |
| Utils | `"[ClassName] behaves correctly"` |
| Middlewares | `"[MiddlewareName] processes [ActionName]"` |
| Reducers | `"[ReducerName] processes [ActionName] correctly"` |

Repositories' per-method group also gets a second test template:
`"Method [method]() calls [DataSource].[method]() when [Something]"`

### Per-layer additions — don't fit a shared shape, kept as-is

- **Models**: a second group, `"[ModelName]'s methods return the correct value"`, test
  `"Method fromRow() should return a [ModelName]"` (or `fromJson()`/`toJson()` once a
  remote-datasource DTO needs serialization) — distinct from the Identity-check group above.
- **Repositories**: no fixed closing test pair for a `NetworkConnectivity`/`ExceptionMapper` layer —
  this project has no such layer. Add the equivalent two tests only if one is introduced later.
- **Reducers**: a second group for actions it doesn't handle, `"[ReducerName] processes unhandled
  actions correctly"`, test `"[ActionName] modifies nothing"`.
- **Viewmodels**: everything lives in ONE group per viewmodel — `"[ViewmodelName] constructor
  initializes all parameters correctly"` — not one group per method like the other Behavior-check
  layers. It holds the construction test (`"Method fromStore() constructs [ViewModelName]
  correctly"`) and every other `fromStore()`-derived behaviour test (`"Method [MethodName] [effect]
  when [condition]"`).
- **Widgets** (beyond the shared Presence-check group): a behaviour group,
  `"[WidgetName]'s elements behavior"` (test `"[WidgetName] contains a [SubWidgetName] with the
  correct behavior"`); a `StoreConnector` dispatch test, `"[WidgetName]'s StoreConnector dispatches
  [ActionName] on init"`; a translations group, `"[WidgetName]'s translations"` (test `"[WidgetName]
  displays the [language] translations"`, once `slang` locales beyond the default exist).
- **Sections** (beyond the shared Presence-check group): same behaviour/`StoreConnector`/translations
  groups as Widgets above — a Section resolves its own ViewModel the same way a Screen does, but it
  is **not** a Screen (see `architecture.md`'s "Screens vs Sections vs Widgets"), so it does **not**
  get the accessibility-recommended-guidelines group below. That belongs solely to the Screen a
  Section is nested inside, since the Section's own subtree in isolation doesn't reflect the real
  composed tab order/contrast a user actually experiences.
- **Screens** (beyond the shared Presence-check group): a fixed group, `"[ScreenName] meets the
  accessibility recommended guidelines"` — see "Screen accessibility checks" below for its 5 fixed
  sub-checks. Applies to any class architecture.md classifies as a Screen, even one selected via a
  parent's local `setState` rather than pushed via `NavigatorService`.

---

## Datasources

- Create `.json` fixture files in the test feature folder to simulate key-value pairs for remote datasource
  responses, once a remote datasource exists.
- Read the full method body before writing its tests and enumerate every distinct error branch (each `catch`
  clause, each early-return guard, each explicit `throw`) — write one test per branch that actually drives
  execution into that specific branch, not just one test per thrown type. Two branches that throw the same
  `Failure` subclass are still two branches if they're reached by different inputs (e.g. a missing table vs.
  a locked database), and each needs its own test.
- This applies to every method-under-test, not only the one you were just asked about — when adding a test
  for one method, check sibling methods in the same file for a branch they're missing too.

---

## Models

- Create `.json` fixture files in the test feature folder to simulate key-value pairs for model
  serialization, once a model needs JSON (de)serialization.

---

## Repositories

- We have no `NetworkConnectivity`/`ExceptionMapper` layer (no centralized connectivity check or generic
  exception-to-failure mapper exists in this project), so there is no fixed-wording pair of tests ending each
  method's group the way there would be in a project that has one. If such a layer is introduced later, add
  the equivalent two fixed tests then.

---

## Usecases

- One group, `"Usecase [UseCaseName] returns the correct value"`. Mock the repository interface —
  never the concrete repository (see "What to mock" below).
- Test the success (`Right`) pass-through and every relevant failure (`Left`) pass-through — a
  usecase's only job is to delegate, so its tests exist to prove it delegates correctly, not to
  re-test the repository's own logic.
- Assert the repository method was called with the exact expected arguments via
  `verify(() => mockRepo.method(expectedArgs)).called(1)`, then `verifyNoMoreInteractions(mockRepo)`
  — this proves the usecase does nothing beyond that one delegating call.

---

## Screens

- Mock the viewmodel, don't build real state. Register a `class MockXxxViewModel extends Mock
  implements XxxViewModel {}` via `sl.registerFactoryParam<XxxViewModel, Store<AppState>, void>((store, _) => mockViewModel)`
  in `setUp()`; `tearDown(() => sl.reset())`. Stub every field the widget reads in `setUp()`
  (`when(() => mockViewModel.xxx).thenReturn(...)`) — the screen always reads them during build, so
  an unstubbed field throws `MissingStubError` even in tests that don't assert on it.
- Still provide a real, minimal `Store<AppState>` via `StoreProvider` — `StoreConnector` requires one
  from context regardless of what `converter` does with it. Use a plain recording reducer
  (`(state, action) { dispatchedActions.add(action); return state; }`) only to verify `onInit`
  dispatches — the mocked viewmodel makes everything else state-independent.
- For a button/callback field (e.g. `onOpenExisting`), stub it to return a closure that
  `print()`s a marker, then tap and assert via `expectLater(() => tester.tap(find.byKey(...)), prints('marker called\n'))`
  — same print-marker rule as Widgets, applied through a real tap instead of a direct call.

---

## Viewmodels

- Assert every field per the "Assertions" section's primitive/function rules above.
- Name only the effects the test actually asserts — never claim an action/call that isn't verified, and never
  pad the name with what *didn't* happen once a positive effect is already named.
- When a method has both a direct call and a dispatched action, split the verbs: "calls [method] and
  dispatches [Action]".
- When naming a call or dispatch, use the bare method/action name (e.g. "calls `show`", "dispatches
  `CreateProjectAction`") — not the qualifying service/class name.

---

## Middlewares

- Call `middleware.call(store, action, next)` directly — never dispatch through a real `Store`.
  `store` is a mocked `Store<AppState>` (`class MockStore extends Mock implements Store<AppState> {}`);
  `next` is a plain top-level function in `main()` that appends to an `actionLog` list; mock
  `store.dispatch` to also append to `actionLog`. Assert on `actionLog` by index — index 0 is always
  the original action (`next` records it), later indices are whatever the handler dispatched.
- When a middleware calls `PopupService.show()` (or any future logging service's `.error()`/`.warning()`),
  assert the exact arguments via `verify(...).called(1)` — not `any()`/`anyNamed(...)` — and add the symmetric
  `verifyNever` test for the branch where it shouldn't be called.
- When a handler constructs a new action to dispatch — especially a Fail/Error action assembled from a usecase
  failure plus fields forwarded from the original action — assert every one of those properties on the
  dispatched action, not just `isA<ActionType>()`. A bare type check would still pass if a property were
  dropped, hardcoded, or mapped from the wrong source field; cast the dispatched action and check each value
  individually.
- When a default parameter feeds a mocked dependency's exact-argument `verify()`, write two tests: the
  omitted case (pins the default value) and one overridden case (proves it's forwarded, not hardcoded).

---

## Reducers

- Assert both the previous value (on `state`) and the new value (on `reducedState`) for a handled action,
  each labelled with `reason:` — a reducer test is fundamentally about a before/after transition.

---

## Widgets

- Use a `buildWidget({...})` helper that wraps the widget under test in `StoreProvider<AppState>` +
  `MaterialApp`; accept optional parameters (e.g. `Locale locale`) for variations needed by translation tests.
- Register dependencies (services, the view model) on `GetIt.instance` (`sl`) inside `setUp()`; tear them down
  with `sl.reset()` and `reset(mock)` per mock inside `tearDown()`.
- A widget that a test needs to locate (an interactive element, or a container whose style is asserted) must
  declare a `Key('kebab-case-name')` in production code — this is the test's way in; locate it with
  `find.byKey(const Key('kebab-case-name'))` rather than `find.byType()`, which breaks once more than one
  instance of that type exists.
- For tap/callback behaviour, stub the view model callback to return a function that `print()`s a marker
  string, then assert with `expectLater(() => widget.onTap!(), prints('marker was called\n'))` — do not assert
  call counts on a returned-function callback when the print-based check already proves invocation.
- When the same widget/key is asserted under multiple conditions (e.g. a container's colour depending on a
  flag), name each test "[WidgetName] contains a "[key]" [WidgetType] with the correct parameters when
  [condition]" — reuse the literal key in quotes, don't encode the asserted values themselves into the title.
- Reviewer corrections to a test's name win over restating implementation detail values; when one test in a
  true/false (or similar) pair gets renamed, rename its sibling to match the same structure.

Screen-level WCAG guideline checks (contrast, tab order, text scaling, focus traversal) live in an
"accessibility recommended guidelines" group inside that screen's own `*.screen_test.dart` (see below) —
never in a separate global file, and never duplicated inside a widget's or Section's own test group.

---

## Routes

- One group, `"GoRouter instantiates the correct screen"`, one test per route: build the real
  router (the app's actual router-config function, not a hand-rolled one), wrap it in
  `MaterialApp.router(routerConfig: router)`, navigate with `router.go(AppRoutes.x)` where the
  route isn't the initial one, and assert `find.byType(ScreenClass)` finds exactly one.

---

## Utils

- One group, `"[ClassName] behaves correctly"`.
- No integration tests — mocking rule is in "General rules" above. Do not build a real widget tree,
  do not render anything to assert on.
- Use `test()`, not `testWidgets()`, unless the util itself directly builds a `Widget` return value
  that must be inspected — a util that only calls out to a dependency needs no widget pump.
- Assert delegation with `verify(() => mock.method(exactArgs)).called(1)` +
  `verifyNoMoreInteractions(mock)`. Exact arguments always. Never `any()`/`anyNamed(...)`.
- When a default parameter feeds the mocked dependency's exact-argument `verify()`, write two tests: the
  omitted case (pins the default value) and one overridden case (proves it's forwarded, not hardcoded).

---

## Coverage targets

| Layer | Target | Test type |
|---|---|---|
| Domain use cases | 100% | Pure unit — no Flutter, no DB imports |
| Redux reducers | 100% | Pure unit — input state + action → output state |
| Redux selectors | 100% | Pure unit — input state → derived value |
| Widgets, Sections | 70%+ | `flutter_test` behaviour tests |
| Screens | 50%+ | `flutter_test` integration-style |

---

## File structure

Mirror `lib/` under `test/` exactly, same relative path, one test file per source file, with
`_test` inserted before the final `.dart` (e.g. `foo.widget.dart` → `foo.widget_test.dart`).

---

## Fixtures

Mirrors the "File structure" mirror rule above, one level more specific: each data-carrier class
gets its own factory function, in its own file, named after the class.

### Scope — what gets a fixture

Entities, Models, and any drift-generated row/companion — types with a growing list of required
fields that get constructed directly, with every field, across many unrelated test files.

**Not** ViewModels or Redux Actions:
- ViewModels are built via `fromStore()` in exactly one test (the "constructor initializes all
  parameters correctly" test) and *mocked* everywhere else — there's no fan-out of inline
  constructions to protect against.
- Actions are typically zero- or one-field, often wrapping an already-fixtured entity
  (`CreateProjectSucceededAction(project)`) — the fan-out risk this pattern solves doesn't exist here.

### One file per class, one verb always

- `test/features/<feature>/fixtures/<class_name>.fixture.dart` — one file per class, never bundled
  (mirrors this project's own Entity/Model file split — see `architecture.md`'s "Database (drift)"
  section: coupled classes still get separate files).
- Every fixture function is named `build<ClassName>()` — always, with no exception for async or
  DB-backed construction. A plain Dart constructor call never needs `Future`; even a drift
  `ProjectRow`/`ProjectTableCompanion` is a synchronous value object. The only place `Future`/`await`
  belongs is the real `db.into(...).insert(...)` call at the actual test call site — that's the I/O
  under test, not the fixture.
- Every field gets a named, optional parameter with a fixed, arbitrary default. Adding a new
  required field to the entity/model means updating one factory's signature and body, not every
  test file that constructs it.
- Keep default values boring — a test that cares about a specific field's value states it
  explicitly via the named param, never relies on the fixture's default silently matching.

### Does a fixture need its own test file?

Same bar as `dart-style.md`'s enum rule: no test file for a fixture with no logic to verify. This
includes a fixture that branches purely on whether a param was passed (`value ?? default`, or
picking between two constructors based on `id == null`) — that's mechanical routing, not a
decision, and every migrated call site using the fixture is the real coverage. A fixture only
earns a test once its outcome depends on something beyond presence/absence of its own params — a
computed/derived value, a real business rule, a case where two valid outputs both look reasonable
and only one is correct.

### Drift `Companion` fixtures — branch, don't duplicate

A fixture for a drift `Companion` may need both insert- and update-shaped construction (drift
itself generates two constructors for this: the plain constructor for an update, `.insert()` for
a new row). Branch on whatever signal distinguishes them — an `id` parameter being non-null means
"this is an update," so build the plain constructor; `id == null` means a new row, so build via
`.insert()` — rather than writing two separate factory functions for the same class.

---

## What to mock

The split is "does a separate interface exist for this?", not "is mocking a concrete class ever
allowed?". When a class has a separate interface (repositories: `I*Repository`), mock the
interface — that's the actual seam domain code depends on, and mocking the implementation instead
bypasses it: name the mock after the interface (`MockIProjectsRepository implements
IProjectsRepository`), never after the concrete class (`MockProjectsRepository` is wrong when
`IProjectsRepository` exists). When a class has no separate interface (use cases, viewmodels, the
Redux `Store`, shared services like `PopupService`/`NavigatorService`/`AppPreferencesStore`),
mock the concrete class directly and name the mock after it
(`MockPopupService implements PopupService`) — there's nothing else to mock, so that's still
mocking the real seam, not a shortcut.

---

## Screen accessibility checks

No global semantics file — it grows unbounded as screens are added. Instead, every
`*.screen_test.dart` gets one extra group, `"[ScreenName] meets the accessibility recommended
guidelines"`, alongside its widget/behaviour groups, reusing that file's existing
`buildWidget()`/`setUp()`. All matchers are in `flutter_test` — no extra package. Five fixed
sub-checks, each its own `testWidgets`:

- WCAG contrast (`textContrastGuideline`) — 4.5:1 normal text, 3:1 large text. Both themes per
  screen, once the app has a dark theme.
- Tap targets ≥48×48dp (`androidTapTargetGuideline`).
- Every interactive element has a semantic label (`labeledTapTargetGuideline`).
- No overflow at 150% and 200% text scale (`TextScaler.linear`).
- Tab key reaches every focusable element in order (`FocusManager.instance.primaryFocus`).

### Maintenance rule

Add all five concern checks to every screen's own test file as that screen is built. Failures in
this group are blocking — treat them as bugs.

i18n completeness (every slang key exists in every supported locale) stays global — add a
`test/i18n_test.dart` once the first non-default slang locale is introduced.

---

## What not to test

- Snapshot tests — banned
- Generated drift or slang code — not our code
- `main.dart` wiring — covered by the smoke widget test
- Contrast inside individual widget test groups — belongs in the screen test's accessibility group
