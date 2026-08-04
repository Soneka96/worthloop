# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Users

WorthLoop is for people who repeatedly check the price and availability of things they may buy. The first user tracks simulation hardware, but the product must work equally well for car parts, electronics, tools, household goods, and other items.

## Product Purpose

WorthLoop keeps a personal list of items, compares offers from multiple merchants, identifies the lowest available price, and shows when each offer was last checked. Success means a user can open the app and understand the best current offer without revisiting every merchant manually.

## Positioning

WorthLoop is category-neutral and local-first: a tracked item is defined by its offers rather than by a retail category or marketplace.

## Operating Context

Users primarily scan a compact Android home screen, open an item to compare merchants, and manually refresh one item or the full list. Hourly and configurable refresh are future capabilities; background work is explicitly out of scope for the first release.

## Capabilities and Constraints

- Clean Architecture with small domain, data, and presentation classes.
- Local fake data in the first release, persisted on device.
- Repository and data-source boundaries must allow future remote price collection without implementing scraping now.
- Track item identity, optional image, merchant offers, availability, prices, URLs, and checked timestamps.
- Compare available offers and sort them from lowest to highest.
- Manual refresh for one item and for all items.
- Persist tracked items, offer prices, and refresh settings.
- Native Android home-screen widget integration is deferred until it has a real persistent data bridge.
- Refresh interval settings are stored and shown, but do not schedule work yet.
- Initial illustrative data includes Moza R12 V2 and Next Level Racing Wheel Stand 2.0.
- Currency is attached to monetary values; the initial data uses EUR.
- The final Android application ID owner prefix is undecided.

## Brand Commitments

- Product name: WorthLoop.
- Tagline: “Watch what it costs. Know when it’s worth it.”
- Voice: direct, practical, and category-neutral.
- Simulation racing may appear in sample data but not in core naming or product identity.

## Evidence on Hand

No production price feed, customer claims, benchmarks, product photography, or brand assets exist yet. Initial products and prices are illustrative local data and must not be presented as live market information.

## Product Principles

- Make the best available offer obvious.
- Preserve the source and freshness of every price.
- Keep category assumptions out of the core model.
- Prefer local, understandable behavior before automation.
- Add infrastructure only when a working feature needs it.

## Accessibility & Inclusion

Use native Android interaction conventions, scalable text, semantic labels, clear loading and error states, and color-independent availability cues.
