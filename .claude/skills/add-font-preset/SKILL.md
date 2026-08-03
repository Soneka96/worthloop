---
name: add-font-preset
description: Add a new bundled font family to this app's FontId/font picker system — download it from Google Fonts (or use a font file the user already has), register it in pubspec.yaml, and wire it into FontId/fontFamilyPresets. Use when the user says "add a font", "add <FontName> as a font option", or names a specific font they want available in Appearance settings.
---

# Add Font Preset

Turns a font family (from Google Fonts, or a file the user already has) into a fully wired
`FontId` preset — following this codebase's exact conventions (offline-bundled assets, not a
runtime-fetch dependency), not generic Flutter font boilerplate.

> Scope note: this skill does ONE thing — bundle a font file and register it in the existing
> `AppFont`/`FontId` infrastructure (`lib/shared/constants/enums.dart`,
> `lib/shared/theme/app_font_presets.dart`, `pubspec.yaml`'s `fonts:` section, `assets/fonts/`). It
> does not redesign the picker UI, add a new sourcing mechanism (e.g. the `google_fonts` package's
> runtime-fetch model), or change the picker's cap/search behaviour — if the user asks for those,
> that's a separate `/council` + `/council-plan` cycle, not this skill.

---

## Step 0 — Determine the source

Ask (if not already given) whether the font is:
- **A Google Fonts family** — the common case; you'll look it up yourself (Step 1).
- **A font file the user already has** — they supply the `.ttf`/`.otf` file(s) directly; skip
  Step 1's lookup, but you still need the license terms confirmed as freely redistributable before
  it goes in `assets/fonts/` (this project's fonts are all free/OFL/Apache — never bundle a font
  whose license is unclear or restrictive without flagging that to the user first).

## Step 1 — Find it on Google Fonts (skip if the user supplied their own file)

`google/fonts` on GitHub is the canonical source (same one already used for Inter, JetBrains Mono,
and the 15 fonts added in this app's font-variety pass). The family's directory slug is usually the
lowercase family name with spaces removed (e.g. "Fira Code" → `firacode`), under one of:
- `ofl/<slug>` — SIL Open Font License (most common)
- `apache/<slug>` — Apache License 2.0
- `ufl/<slug>` — Ubuntu Font Licence (rare)

Check via `curl -s "https://api.github.com/repos/google/fonts/contents/ofl/<slug>"` (swap `ofl` for
`apache`/`ufl` if not found — see Permanent Marker for a real example of an `apache/`-only font).
If the API is rate-limited (`403`/`429` — a real risk after several lookups in one session; this
project's GitHub API quota is unauthenticated and shared, only 60 requests/hour), fall back to
`raw.githubusercontent.com/google/fonts/main/<license>/<slug>/<slug-or-FamilyName>...` guesses, or
just ask the user to confirm the slug via the Google Fonts website
(`fonts.google.com/specimen/<Family+Name>`).

Note whether the family ships as:
- **A single variable font** (filename contains `[wght]` or `[opsz,wght]`, e.g.
  `Oswald[wght].ttf`) — one file covers every weight via its variable axis.
- **Separate static files per weight** (e.g. `SpaceMono-Regular.ttf` / `SpaceMono-Bold.ttf`) — only
  register the weights that actually have a file; never point two different `weight:` entries at
  the same static file expecting Flutter to synthesize the other (see Step 3).

## Step 2 — Get explicit download permission

State the exact filename(s), source URL, and size before downloading anything, per this project's
download-permission norm. `curl -sIL <raw-url>` for `Content-Length` has been unreliable in this
environment (HEAD requests to `raw.githubusercontent.com` sometimes 404/429 when a GET on the same
URL succeeds) — a GET-then-verify approach (download, then `ls -la` to confirm the real size and
spot-check for a valid TrueType header) is more trustworthy than trusting a HEAD response. Also
grab the license file (`OFL.txt` / `LICENSE.txt`) from the same directory alongside the font
file(s) — same attribution pattern as every existing bundled font.

Save everything into `assets/fonts/`:
- Font file(s): `<FamilyName><suffix>.ttf` (match the upstream filename, brackets and all — e.g.
  `Oswald[wght].ttf` — no need to rename)
- License: `<FamilyName>-OFL.txt` or `<FamilyName>-LICENSE.txt`

If several requests in a row start returning a short, wrong-looking response, that's the GitHub API
or CDN rate-limiting you, not a broken URL — pause and retry with a few seconds between requests
rather than assuming the font doesn't exist.

## Step 3 — Register in `pubspec.yaml`

Add a new `- family:` block under `flutter: fonts:`, following the exact shape of the existing
entries. Variable font → one entry per weight the app's `TextTheme` actually uses (400/500/600/700,
matching every other variable font already registered), all pointing at the same asset. Static-only
font → one entry per weight you actually have a file for (usually just `400`, or `400` + `700` if a
bold static file exists) — never invent a weight you don't have a file for.

## Step 4 — Wire it in

1. Add the new member to `lib/shared/constants/enums.dart`'s `FontId` enum, with a one-line `///`
   doc comment describing the font's character (e.g. "retro-futuristic monospace") — new members go
   at the end, `none` and `systemDefault` stay first.
2. Add its `label` case to `FontIdX` (the pretty display name, e.g. `'Fira Code'`).
3. Add the entry to `lib/shared/theme/app_font_presets.dart`'s `fontFamilyPresets` map (the family
   name must exactly match the `family:` string from Step 3, case and spacing included).
4. Size-correct it: run `dart run tool/font_metrics.dart assets/fonts/<the new file>.ttf` and copy
   its printed `fontSizeFactor` value into `fontSizeFactorPresets` (same file) as the new font's
   entry. This exists because fonts with very different x-height-to-em ratios (a blocky display
   face vs. a script face) render at wildly different perceived sizes at the same nominal font
   size — this factor normalizes that, the same idea as CSS's `font-size-adjust`. If the tool
   reports "no sxHeight in OS/2 table" (an older/rarer table version), eyeball a factor by
   comparing rendered size against a couple of already-corrected fonts in
   `fontSizeFactorPresets` instead — note in your Step 6 report that this one was eyeballed, not
   measured.
5. Do **not** add a test for the new enum member, its label case, or the new preset-map entries —
   plain data with no branching logic of its own, and with this app's stated plan to keep adding
   fonts, a per-font test would never stop growing. (This app's `FontIdX` label tests already cover
   every font added before this skill existed — that's pre-existing coverage, not a pattern to keep
   extending by hand.)
6. Nothing else needs touching — `FontPickerDropdown` iterates `FontId.values` directly, so a new
   enum member appears in the picker (and is reachable via search once past the visible-10 cap)
   with zero widget changes.

## Step 5 — Verify

Run `flutter pub get` (validates the new `pubspec.yaml` asset paths), then
`flutter analyze lib/shared/constants/enums.dart lib/shared/theme/app_font_presets.dart` and fix
anything it flags. Run `flutter test test/shared/constants/enums_test.dart` and
`flutter test test/shared/theme/app_font_presets_test.dart` to confirm nothing broke (existing
tests only reference specific `FontId` members by name, so a new one shouldn't touch them — if it
does, something's wrong).

## Step 6 — Report back

State, in under 5 lines: the font name added, its style/character in one phrase, the licence
(OFL/Apache/UFL), whether it's variable or static-only, and the total download size. If you had to
guess the Google Fonts slug or fall back to asking the user to confirm it, say so explicitly.

---

## Anti-scope-creep guardrails

- If the user's request implies more than adding one font (a "search all Google Fonts" feature,
  category filters, a per-font preview redesign) — stop and say that's out of this skill's scope,
  point them at `/council` instead of silently expanding the skill to cover it.
- Never switch to the `google_fonts` package's dynamic runtime-fetch model to satisfy "just get me
  this font" — this app's fonts are bundled offline by deliberate choice. If a requested font
  somehow can't be sourced as a static/variable file, stop and flag it rather than quietly
  reversing the architecture.
- If asked to "make this skill smarter" or "auto-improve itself" — push back unless there's a
  concrete recurring failure mode to fix, same bar as `/council`'s self-optimization protocol.
