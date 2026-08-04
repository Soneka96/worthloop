# WorthLoop Roadmap

This roadmap targets a genuinely usable first MVP, not only a polished demo.

## MVP definition

A user can add something they want to track, see trustworthy merchant offers, compare
available prices, refresh the data manually, understand failures, and use the app reliably
on an Android device.

## Current status

- [x] Phase 1 foundation PR completed on `phase-1-price-tracking-foundation`
- [x] Local product storage and migrations
- [x] Product and merchant-offer domain model
- [x] Available-price comparison and currency consistency
- [x] Manual refresh flow in the current fake-data loop
- [x] English and Portuguese UI
- [x] Light and dark themes
- [x] Reusable presentation widgets and screen composition
- [x] Automated tests and static analysis
- [ ] Real Android-device validation
- [ ] Product creation and management
- [ ] Real merchant price data
- [ ] Honest loading, empty, offline, and failure states for real data

## Phase 1 — Price-tracking foundation ✅

- [x] Establish the local-first product and offer model.
- [x] Add persistence, comparison, refresh, currency, and failure foundations.
- [x] Build the initial Home, Product Details, and Settings flows.
- [x] Apply architecture, dependency-injection, widget, and testing conventions.
- [x] Remove the deleted GitHub Explorer reference feature.

**Exit condition:** the app has a coherent, tested foundation for the real MVP.

## Phase 2 — Choose the real data path

- [ ] Choose the first supported source or sources.
- [ ] Confirm the source permits the intended access and usage.
- [ ] Define what a refresh can reliably return: price, currency, availability, URL,
      merchant, and checked time.
- [ ] Decide the fallback when automatic collection is unavailable.

**Exit condition:** the app has one concrete, legally usable path to obtain real offers.

## Phase 3 — Complete the product lifecycle

- [ ] Add a product from the UI.
- [ ] Validate product name and offer URL input.
- [ ] Edit and delete tracked products.
- [ ] Confirm destructive actions.
- [ ] Persist products across app restarts.
- [ ] Remove the assumption that the first run always uses bundled fake products.

**Exit condition:** a user can create and manage their own watchlist without developer
code or seeded data.

## Phase 4 — Build the real offer loop

- [ ] Implement the first real datasource.
- [ ] Map source responses into `StorePrice` safely.
- [ ] Handle currency, unavailable offers, stale data, rate limits, and malformed responses.
- [ ] Refresh one product and the full watchlist using real data.
- [ ] Show the last successful refresh separately from a failed attempt.
- [ ] Keep old trustworthy data when a refresh fails.

**Exit condition:** the core promise works with real merchant data and does not silently
replace good data with bad or empty data.

## Phase 5 — Make failure and offline behavior trustworthy

- [ ] Add clear first-load, refresh, offline, partial-failure, and empty states.
- [ ] Explain whether displayed prices are live, cached, stale, or illustrative.
- [ ] Add retry actions where recovery is possible.
- [ ] Test database failure, network failure, invalid source data, and mixed results.
- [ ] Verify app restart and migration behavior with real user-created data.

**Exit condition:** users can tell what happened and what they can do next.

## Phase 6 — Android MVP readiness

- [ ] Test on a physical Android device and a small-screen emulator.
- [ ] Test system font scaling, dark mode, back navigation, rotation, and offline mode.
- [ ] Verify release signing and the final application ID.
- [ ] Add privacy wording for stored product and merchant data.
- [ ] Add crash/error reporting suitable for the MVP.
- [ ] Build and install a release APK.
- [ ] Run a manual acceptance pass from a clean install.

**Exit condition:** a new user can install the release build and complete the full product
tracking journey without developer help.

## Explicitly after MVP

- [ ] Background scheduled refresh.
- [ ] Home-screen widget.
- [ ] Many merchant/source integrations.
- [ ] Price history charts and alerts.
- [ ] Accounts and cloud synchronization.

## Working rule

When choosing the next task, prefer the item that moves the app closest to the MVP exit
condition. Architecture cleanup is valuable only when it unblocks one of these phases or
prevents a real user-facing bug.
