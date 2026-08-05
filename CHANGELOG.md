# Changelog

## Unreleased

### Phase 2 — Product source onboarding

- Added the remote price-fetching boundary for product sources.
- Added generic JSON-LD and aggregate-offer price extraction.
- Added currency validation and normalized currency codes.
- Added classified refresh failures for blocked, unsupported, invalid, and network-failed sources.
- Added a blocked-source cooldown to avoid repeated requests after access is denied.
- Preserved the last known offers when a refresh fails.
- Added refresh-status notices to the Home and Product Details screens.
- Added English and Portuguese refresh-status messages.
- Added support for products with multiple merchant source URLs in the domain and persistence layers.

## Phase 1 — Foundation

- Added local product and merchant-offer persistence.
- Added product price comparison and currency consistency rules.
- Added manual refresh flow and refresh settings.
- Added English and Portuguese interfaces with light and dark themes.
- Added reusable presentation widgets and automated tests.
