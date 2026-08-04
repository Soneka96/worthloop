# WorthLoop

WorthLoop is an Android app for tracking products, comparing merchant offers, and making the
lowest available price obvious. It is category-neutral: simulation hardware is the initial sample
data, but the model also fits car parts, electronics, tools, household goods, and other purchases.

## Current capabilities

- Persist tracked products, merchant URLs, prices, availability, and checked timestamps locally.
- Compare available offers and sort them from lowest to highest price.
- Refresh one product or the full watchlist manually.
- Store a configurable refresh interval without scheduling background work yet.
- Display English and Portuguese interfaces with accessible light and dark themes.

The bundled products and prices are illustrative local data, not live merchant offers. Real price
collection, scheduled background refresh, and an Android home-screen widget are deferred.

## Architecture

The project follows the existing layered Clean Architecture and Redux conventions:

```text
Datasource -> Repository -> Use case -> Redux middleware -> State -> ViewModel -> Screen
```

The products feature currently uses Drift for local persistence. A remote datasource contract
defines the future price-collection boundary but is intentionally not wired until a real collector
exists. The retained GitHub Explorer feature is the starter's complete remote-and-local reference
implementation.

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
    github_explorer/       retained reference implementation of the full remote/local chain
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
