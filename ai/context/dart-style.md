# Dart Style Rules

## Naming

- UpperCamelCase for classes, enums, typedefs, extensions, type parameters.
- lowerCamelCase for variables, parameters, functions, members, and constants (not SCREAMING_CAPS).
- lowercase_with_underscores for packages, directories, source files, import prefixes.
- Acronyms >2 letters capitalized as words (`HttpRequest`, `Uri`); 2-letter acronyms stay
  uppercase (`ID`, `IO`).
- Booleans: non-imperative verb phrases (`isCreating`, `canClose`); in named parameters consider
  omitting the verb (`paused: false`).
- Never prefix method names with `get` — use a getter or a descriptive verb (`fetch()`,
  `download()`).
- `to___()` for converting to a new object; `as___()` for a view/representation.
- No Hungarian notation or prefix letters.

### File naming suffixes

See `CLAUDE.md` → "File naming conventions" for the canonical table (widget, screen, usecase,
params, entity, model, actions, middleware, reducer, selectors, state, viewmodel, repository,
datasource). Two suffixes not yet used in this project but reserved for when they're needed:

- Value objects: `value_object_name.value-object.dart`
- DTOs: `dto_name.dto.dart`

### Class naming patterns

- Widgets: `MyWidget` — Sections: `MyWidgetSection` — Screens: `MyWidgetScreen` — ViewModels: `MyWidgetViewModel`
- Use cases: `DoThingUseCase` (e.g. `CreateProjectUseCase`)
- Repositories: `FeatureRepository` / `IFeatureRepository` (e.g. `ProjectsRepository` /
  `IProjectsRepository`)
- Entities: `MyEntityName` (e.g. `Project`) — Models: `MyEntityNameModel` (e.g. `ProjectModel`)
- Failures: `ErrorNameFailure` (e.g. `DatabaseFailure`) — Exceptions: `ErrorNameException`
- Params: `DoThingParams`, matching the use case's name minus its `UseCase` suffix (e.g.
  `CreateProjectUseCase` → `CreateProjectParams`, never `CreateProjectUseCaseParams`)
- Middleware: `XxxMiddleware extends MiddlewareClass<AppState>`, one class per feature, one
  `case XxxAction _:` per handler in its `switch (action)` (ordering rule: see `architecture.md`'s
  Redux flow section). Handler name = action name minus the `Action` suffix
  (`CreateProjectFailedAction` → `_createProjectFailed`, never `_createProjectFailedAction`).

### No magic strings for a closed set of values

If a value is one of a fixed, known set — UI category names, status labels, anything compared with
`==` against literal strings — use an enum, not a `String`/`List<String>`. A `String` typo (`'Apperance'`)
is a runtime bug; the equivalent enum member typo is a compile error. This applies even when the
set is presentation-only with no persistence or domain meaning behind it — the failure mode being
prevented (a silent typo in an `==` comparison) doesn't depend on where the value is used.

### Enums

- First declared member is always `none` — a sentinel default, not a real app value. It signals
  "something went wrong" (e.g. a value that failed to parse), not the app's actual chosen default
  (which is set explicitly wherever that enum is consumed).
- Every member, including `none`, gets a one-line `///` doc comment — see "## Documentation"
  below for the general scoping rule this follows.
- No test file for a plain enum with no behaviour — there's no logic to verify. Add one only once
  the enum gains real logic (e.g. a method, a `fromString` factory with branches, or an extension
  with getters like `label`/`isEnabled` — same bar as a method, since it's still logic on the enum).
- Every enum in the app lives in `lib/shared/constants/enums.dart` — no exception for
  feature-local enums. All enums are project-wide constants by this project's convention,
  regardless of which feature currently uses them.
- An extension adding behaviour to an enum (e.g. `label`/`isEnabled` getters) lives in the same
  file, directly after the enum it extends.

### Translation keys

Not applicable — this project uses `slang`, which generates typed dot-accessors from a YAML
source (e.g. `t.home.title`). There is no manual string-key format to follow; don't invent one.

### Widget keys

- Format: `const Key('name-of-key')` (kebab-case).
- Assign a `Key` to any widget a widget test needs to locate (interactive elements, or any
  container whose style/size is asserted) — this is the test's only reliable way in;
  `find.byType()` breaks as soon as a second instance of that type exists in the tree.

---

## Formatting & imports

- Use `dart format` — do not fight the formatter.
- Trailing commas for better formatting.
- Curly braces for all flow control, except a single-line `if` with no `else`.
- Import order: `dart:` imports, then `package:` imports, then relative imports — each section
  alphabetized, separated by a blank line. This project uses
  `package:worth_loop/...` imports throughout, even within the same
  feature — not relative imports.

## Variables & types

- Use `final` for local variables that don't change — **always with an explicit type**, even
  when inference would make it obvious: `final ProjectModel model = ProjectModel.fromRow(row);`,
  never `final model = ProjectModel.fromRow(row);`.
- Annotate return types and parameter types on all function declarations.
- Do not explicitly initialize variables to `null` — they are null by default.
- Use `dynamic` explicitly when intended, never accidentally.

## Null safety

- Avoid the `!` operator — prefer `??` or null-check patterns.
- Do not use `== true` or `== false` on non-nullable booleans.
- Avoid `late` unless necessary (e.g. a test's `setUp`-built variable); prefer initializer lists or
  nullable types otherwise.
- Use type promotion for nullable types.

## Strings & collections

- Prefer interpolation (`'Hello $name'`) over concatenation; omit braces for simple identifiers.
- Use collection literals (`[]`, `{}`), not constructors.
- Use `.isEmpty`/`.isNotEmpty`, never `.length == 0`.
- Avoid `Iterable.forEach()` with lambdas — use `for` loops.
- Use `whereType<T>()` to filter by type; avoid `cast()`.

## Functions & members

- Named parameters for any function or constructor with more than 2 parameters.
- Avoid positional boolean parameters — use named parameters.
- Use tear-offs instead of wrapping in a lambda (`list.map(int.parse)`).
- Use `=>` for simple one-expression members.
- Do not wrap fields in unnecessary getters/setters.
- Do not use `this.` except to disambiguate or for constructor redirection/initializing formals.
- Use `;` not `{}` for empty constructor bodies.
- Return empty collections instead of `null` for "no data".

## Error handling

- Always handle `Future` errors — no unhandled async.
- Specify exception types in `catch` clauses — avoid bare catches.
- Use `rethrow` instead of `throw e` to preserve the stack trace.
- Throw `Error` for programmatic bugs, `Exception`/`Failure` for runtime failures; do not catch
  `Error` types. See `ai/context/error-handling.md` for the `UnimplementedError` exception.

## Async

- Use `async`/`await` over `.then()` chains.
- Do not use `async` when the function has no `await`.
- Avoid `Completer` — use async/await instead.
- Use `Future<void>` for async methods with no return value.

## Constructors & classes

- Prefer making declarations private unless intentionally public.
- Make constructors `const` when all fields are final.
- `Equatable` for entities, models, value objects, viewmodels, Redux actions, and Redux state —
  exclude callbacks from `props`.
- `Equatable` already provides `==`/`hashCode` from `props` — never hand-write either on a class
  that extends it. For the rare class that doesn't (e.g. `PopupService`), always override
  `hashCode` whenever `==` is overridden.
- Use `part`/`part of` only for generated files (e.g. drift).
- **Member ordering**: the split is "does the constructor set this field?", not "is this field
  public?". Fields assigned by the constructor (`this.x`, `required this.x`, or an initializer-list
  assignment from a constructor parameter) go directly above that constructor, in any visibility —
  a private `this._gateway` field belongs there exactly like a public `this.id` field. The
  constructor follows. Static constants and any other field the constructor doesn't set come after
  the constructor, since they aren't part of what the constructor needs to be read alongside. Methods
  come last.

  Order top to bottom: construction-bound fields (any visibility) → constructor → other
  state/constants the constructor doesn't set → methods.

### `copyWith` on a nullable field — use `Option<T>`, never a boolean flag

`field ?? this.field` can't distinguish "omitted" from "explicitly cleared to null" — it can never
clear the field. Give that parameter type fpdart's `Option<T>?` instead of `T?`: a `null` parameter
means "omitted, keep the current value"; `const None()` means "explicitly clear it"; `Some(value)`
means "set it." Never add a second boolean parameter (e.g. `clearErrorMessage`) just to express
"clear" — that's what the `Option` distinction is for.

---

## Documentation

- `///` doc comments on every public class, method, and property — no exceptions.
- Keep every doc comment simple, concise, and scoped to what the symbol itself *is* — never how or
  where it's used, its relationship to other symbols, or surrounding application context. That
  belongs at the call site or in a cross-reference (see "Coupled classes cross-reference each
  other" below), not folded into the symbol's own description: a theme preset's doc describes its
  look (`/// Dracula — dark purple/grey palette with high-contrast accent colours.`), never its
  role in the app (`/// Dracula — the default dark preset used in the theme picker`).
- Check the standard doc-comment format for that exact symbol kind first (e.g. `TypedReducer`
  handlers: exactly 2 lines, "Handles X." / "Updates Y." — see "TypedReducer handlers" below). If a
  WHY explanation doesn't fit inside that format, that's a signal the WHY doesn't belong in the doc
  comment at all — not a license to lengthen the format.
- A `//` comment is only ever a stand-in for a doc comment on a private symbol — placed immediately
  above the declaration, held to the same one-or-two-line bar as a `///` comment (e.g.
  `AppZoom._persist()`'s "preference-write failures are silently ignored" note). Never a `//`
  comment between statements or widgets inside a method/build body, not even a one-line
  non-obvious-WHY note — if a body seems to need one, the WHY belongs on the enclosing symbol's doc
  comment instead, or the code should change so it isn't needed.
- Something genuinely missing (a stub, a no-op callback, a feature with no usecase/screen to call
  yet) gets `// TODO: <what's missing and why>` immediately above the declaration — the one other
  place a `//` belongs. The `TODO` prefix is what IDEs (VS Code, IntelliJ/Android Studio) pick up
  for their TODO panel/gutter marker.
- No comment needed at all when the simplicity is self-evident (a one-line stdlib call, a single
  constant).
- Never describe WHAT the code does (the name already does that) — only WHY when non-obvious, and
  only in the two places above.
- Start doc comments with a brief single-sentence summary.
- Doc comment referencing another symbol: use `[SymbolName]`, never backticks/plain text, and
  import the declaring file — plain text doesn't resolve to an IDE hover/hyperlink.
- `[SymbolName]` only resolves inside a `///` comment. A `//` comment is never parsed as
  documentation, so brackets inside one do nothing — not even on the private-symbol `//` stand-in.
  Write the symbol as plain text in a `//` comment instead.
- `[SymbolName]` immediately followed by `()` breaks the link — `]( ` is markdown link syntax, so
  `[ThemeData]()` parses as a link to an empty URL, not a symbol reference. Add a space:
  `[ThemeData] ()`.
- Never dodge a `[SymbolName]` reference by rewriting the sentence into plain prose just because
  adding the import feels like more effort than it's worth — this applies to any cross-symbol
  mention, not only the "coupled classes" pairs below (e.g. a constant's doc mentioning the method
  that consumes it still gets `[ClassName.method]`, with the import added).
- Always fully qualify member references as `[ClassName.member]`, never bare `[member]` — a bare
  property/method name won't resolve even if the class is imported.
- When a `[ClassName]` reference is the only use of that class in the file, keep the import anyway
  — `dart analyze`'s unused-import lint doesn't reliably count doc-comment references as usage;
  check for `[ClassName` in comments before removing an import flagged as unused.
- **Coupled classes cross-reference each other** via `[ClassName]` in their `///` doc comments,
  with the import present: Model → Entity, UseCase → Repository interface, Repository
  implementation → Repository interface.
  - **Exception — one direction only when it would cross the domain boundary.** Domain
    (`entities/`, `repositories/<I*>.repository.dart`) never imports the data layer, so an Entity
    never references its Model back (even though the Model `extends` it), and a Repository
    interface never references its implementation back — only the data-layer side links to the
    domain side. See `Project` (entity, no reference to `ProjectModel`) vs. `ProjectModel`
    (`/// ... domain [Project] entity. Extends [Project] directly`).
- A doc-comment-only import can be circular (file A imports B for a `[ClassName]` link, B imports A
  back the same way) — Dart allows circular imports between libraries with no compile error, so
  don't avoid the cross-reference or restructure code just to dodge the cycle.

### `AppRoutes` constants — describe destination and purpose

Every constant in `AppRoutes` documents where it navigates to and in which flow.

### Params classes — document every field

Every `Params` class passed to a use case documents what each field is for and any constraints
(nullable, optional, valid range).

### TypedReducer handlers — document what changed

Every `TypedReducer` entry and its function get the same 2-line `///` doc comment: line 1
"Handles [action/condition]."; line 2 "Updates [State.field], [State.otherField]...". Reducer
handlers are private, so the general public-member doc-comment rule above doesn't reach them —
this is the only documentation a handler gets, not a stylistic add-on.

## Logging

- Never use `print()` — use `sl<LoggerService>()` (`lib/shared/utils/logger_service.dart`),
  never the `logger` package's `Logger` directly. Caller permission follows
  `architecture.md`'s "Services — where do they live?" section.
- `.d()` debug, `.i()` info, `.w()` warnings, `.e()` errors.
- Log before returning a failure — a `catch` block that returns `Left(Failure)` without
  `.e()` first throws away the original error. Log any other unexpected state or
  recoverable issue with `.w()`.
- `.f()` (fatal) always alerts the user via a popup — reserved for failures with no existing
  Either → middleware → popup path already telling them (an uncaught exception, an isolate
  crash).
- Any level takes an optional `showPopup` (default `false`) for a message that should be logged
  *and* shown right now — e.g. `sl<LoggerService>().e(failure.message, showPopup: true)`. Same
  dedupe window as `.f()`. Never pair `showPopup: true` with a manual `PopupService.show()` call
  for the same message — that's the double-popup `.f()`'s own rule already guards against.
- `PopupService` is never called directly anywhere outside `LoggerService` — every user-facing
  message (a failure, a "not implemented yet" notice, a success confirmation) goes through
  `sl<LoggerService>()` with `showPopup: true`, picking whichever level actually fits (`.e()` for
  an `Either` failure, `.i()` for a notice or confirmation that isn't an error).

---

## Flutter-specific

- `const` constructors everywhere possible — Flutter skips rebuilds for const widgets.
- Prefer `StatelessWidget` over helper functions for reusable UI — this includes a private
  `_buildX()` method that returns a `Widget` inside a screen/widget class. Extract it into its own
  `StatelessWidget` under that feature's `presentation/widgets/` (or `shared/widgets/` if it's
  truly cross-feature) instead. A `_buildX()` method can't be const, can't be tested in isolation,
  and re-runs on every parent rebuild even when its own inputs haven't changed — a real `Widget`
  subclass gets all three for free.
- Once extracted, decide generalize vs. bespoke per `architecture.md`'s "Screens vs Sections vs
  Widgets" — a stable, identically-shaped extraction becomes a shared reusable Widget; a
  container/composer whose future content is unpredictable stays bespoke even if it currently
  looks identical to a sibling.
- Localize `setState()` to the smallest subtree that needs it.
- Avoid expensive work in `build()` — split large widgets by change boundaries.
- `ListView.builder` (lazy), never `ListView()` with concrete children, for long/data-driven lists.
- Avoid `Opacity` in animations — use `AnimatedOpacity` or a semitransparent colour.
- Avoid unnecessary clipping when `borderRadius` already suffices.
