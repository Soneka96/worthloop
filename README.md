# WorthLoop

WorthLoop is an Android app for tracking products, comparing merchant offers, and making the
lowest available price obvious. It is category-neutral: the model fits simulation hardware, car
parts, electronics, tools, household goods, and other purchases alike.

## Current capabilities

- Persist tracked products, merchant URLs, prices, availability, and checked timestamps locally.
- Model multiple merchant URLs as sources belonging to one tracked product.
- Compare available offers and sort them from lowest to highest price.
- Refresh one product or the full watchlist manually.
- Extract prices from supported JSON-LD product and aggregate-offer markup.
- Explain blocked, unsupported, invalid, and unreachable refresh results while keeping the last known price.
- Store a configurable refresh interval without scheduling background work yet.
- Display English and Portuguese interfaces with accessible light and dark themes.

The generic remote collector is a foundation for user-provided sources, not a guarantee that every
website can be read. Scheduled background refresh and an Android home-screen widget are deferred.

## Architecture

The project follows the existing layered Clean Architecture and Redux conventions:

```text
Datasource -> Repository -> Use case -> Redux middleware -> State -> ViewModel -> Screen
```

The products feature uses Drift for local persistence and has a remote datasource boundary for
generic JSON-LD price collection. Source-specific support, access permissions, and legal usage
still need to be confirmed before presenting any website as a guaranteed integration.

## Getting started

```bash
git clone https://github.com/Soneka96/worthloop.git
cd worthloop
flutter pub get
dart run build_runner build -d
flutter run -d android
```

The Android application ID is `io.github.soneka96.worthloop`.

## Commands

```bash
flutter analyze
flutter test
dart run taskflare test
dart format .
dart run build_runner build -d
flutter build apk
```

## Project structure

```text
lib/
  features/
    products/              product data, persistence, comparison, refresh, and details
    home/                  tracked-product watchlist
    settings/              appearance, language, and refresh-interval settings
  shared/
    db/                    Drift database aggregation
    failures/              typed infrastructure failures
    navigation/            GoRouter wrapper and route table
    state/                 root Redux store
    theme/                 application themes and display preferences
ai/context/                architecture, Dart, testing, and error-handling conventions
design/                    approved visual references and design direction
test/                      source-mirrored unit and widget tests
```

## Tech stack

| Concern | Package |
|---|---|
| State | `flutter_redux` + `redux` |
| Local persistence | `drift` + SQLite |
| HTTP | `dio` |
| Navigation | `go_router` through `NavigatorService` |
| Dependency injection | `get_it` with manual feature containers |
| Internationalization | `slang` + `slang_flutter` |
| Testing | `flutter_test` + `mocktail` |

## License

MIT — see [LICENSE](LICENSE).
