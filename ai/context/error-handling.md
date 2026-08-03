# Error Handling

## Failure hierarchy

Datasources catch source-specific exceptions and return `Either<Failure, T>` (via the `fpdart`
package) — `Left(failure)` or `Right(value)`. Repositories and use cases propagate the same
`Either` unchanged; they don't unwrap it. Domain never catches raw exceptions from dio, drift,
or dart:io.

**`Either` flows from datasource → repository → use case, and stops at middleware.** Middleware
is the one place that calls `.fold(onLeft, onRight)` (or pattern-matches) to turn the `Either`
into a plain success or failure Redux action. The reducer, the Redux state, and the UI never see
an `Either` — only middleware does.

All `Failure` subclasses live in one file, `lib/shared/failures/failures.dart` — they're small,
tightly related value types, and grouping them keeps the whole hierarchy visible at a glance.
This is a deliberate exception to one-class-per-file. An abstract `Failure` base class
(`extends Equatable`, one `final String message` field set via its constructor) is extended by
one concrete subclass per error category (e.g. `NetworkFailure`, `DatabaseFailure`,
`FileSystemFailure`) — add only the subclasses a feature actually needs, never the full set
speculatively.

## Datasource rules

- Catch source-specific exceptions (DioException, SqliteException, FileSystemException)
- Wrap them in domain Failures before re-throwing or returning
- Never let raw infrastructure exceptions escape into use cases or presentation
- A datasource method for a feature that isn't built yet (e.g. parsing an opened project file
  before the parser exists) throws `UnimplementedError`, not a typed `Failure` — a `Failure`
  implies a real runtime/user-facing error path exists. `UnimplementedError` signals the feature
  genuinely doesn't exist yet and should surface loudly during development, not be caught and
  displayed to the user as if it were a recoverable error.

## Fail-open vs fail-closed

Decide per feature, not globally: a remote check whose failure should never block the user from
using cached/local data (e.g. a background sync check) fails open — the repository falls back to
the last-known-good local value and returns `Right`, only surfacing the network `Failure` when
there's nothing local to fall back to. A check where an unverifiable state must never be treated
as valid (e.g. an action with real consequences that depends on a fresh server confirmation) fails
closed — any `Left` from the remote call propagates as-is, no fallback. State the choice and the
reasoning in the repository method's own doc comment; don't leave it to be inferred from the code.

## UI error surfaces

- Inline field errors (a failed validation, a rejected input): the widget's own native error
  affordance (a `TextField`'s `errorText`, a form field's built-in error state) — never a popup for
  something the user needs to fix without losing their place.
- Blocking or unexpected failures the user didn't directly cause (a background sync failing, a
  usecase erroring outside of a form submission): a popup via `LoggerService`'s `showPopup` param —
  never a raw `Failure.message` string; log/display through the one service, per `dart-style.md`'s
  Logging section.
- A background check whose failure shouldn't interrupt anything (e.g. an optional startup
  check): silently ignored — never block the app on it.
