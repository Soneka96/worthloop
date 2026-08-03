---
name: add-theme-preset
description: Import a named colour theme (VS Code theme JSON, a named well-known theme like Dracula/One Dark Pro/Nord/GitHub Dark, or a pasted palette) and wire it into this app's ThemeId/ColorScheme preset system. Use when the user says "add a theme", "import this theme", "add <ThemeName> as a preset", or pastes a VS Code theme JSON / palette and asks to add it.
---

# Add Theme Preset

Turns an external colour theme into a fully-mapped `ColorScheme` preset file, registered in
`ThemeId` and the presets map — following this codebase's exact conventions, not generic Flutter
boilerplate.

> Scope note: this skill does ONE thing — map a given theme onto the existing `AppTheme`
> infrastructure (`lib/shared/constants/enums.dart`, `lib/shared/theme/presets/`,
> `lib/shared/theme/app_theme_presets.dart`). It does not redesign that infrastructure, add a
> picker UI, or add persistence — if the user asks for those, that's a separate `/council` +
> `/council-plan` cycle, not this skill.

---

## Step 0 — Determine brightness

Decide if the source theme is dark or light (a VS Code theme JSON's top-level `"type"` field says
so directly; for a named theme, you'll know — Dracula/One Dark Pro/Nord/Catppuccin Mocha are dark,
GitHub Light/Solarized Light/Catppuccin Latte are light). This determines which subfolder the
preset file goes in (see Step 2) and which `ColorScheme` brightness/contrast direction to map
toward — a light theme's `surface` is its *lightest* tone and `onSurface` its darkest, the inverse
of a dark theme's mapping.

If a single named theme ships both variants (e.g. "Catppuccin" has Mocha/Macchiato dark and
Latte/Frappé light), treat each variant as its own separate preset/import — don't try to encode
both in one file.

## Step 1 — Get the source palette

Ask the user (if not already given) for one of:
- A VS Code theme JSON (paste, file path, or a well-known theme name you can map from memory if
  you're confident of its canonical palette — e.g. Dracula, One Dark Pro, Nord, GitHub Dark/Light,
  Catppuccin, Solarized)
- A raw list of named hex colours (e.g. "background #1a1a1a, accent #ff0000...")

If the source is a VS Code theme JSON, the relevant keys are usually under `"colors"`
(`editor.background`, `editor.foreground`, `activityBar.background`, etc.) and
`"tokenColors"` (syntax highlighting — useful for picking secondary/tertiary accents, not directly
needed for app UI but a good source of accent colours if the editor keys are sparse).

If you're not confident you know the theme's canonical colours precisely, say so and ask the user
to paste the source rather than guessing — a wrong hex is worse than asking.

## Step 2 — Map source colours onto every `ColorScheme` slot

Read `lib/shared/theme/presets/dark/dracula_theme.dart` first as the reference mapping — it shows every
slot Material 3's `ColorScheme` needs and a worked example of mapping an 11-colour external palette
onto it (most "container" slots reuse the nearest neutral colour, "on*" slots are the contrasting
foreground for that slot, `shadow`/`scrim` are usually pure black regardless of theme).

Mapping heuristics when the source palette has fewer colours than `ColorScheme` slots (it almost
always will):
- `surface` / `onSurface` ← the theme's editor background / foreground
- `primary` / `secondary` / `tertiary` ← the three most distinct accent colours in the palette
  (keyword, string, and function-name token colours in a VS Code theme are a good source)
- `*Container` slots ← the theme's "current line" / selection-highlight colour (a slightly lifted
  surface tone), or `surface` itself if no such colour exists
- `onSurfaceVariant` / `outline` ← the theme's comment colour (deliberately lower-contrast)
- `error` / `onError` ← the theme's red/error-indicator colour if present, otherwise a desaturated
  red consistent with the palette's saturation level
- `inverseSurface` / `onInverseSurface` ← swap `onSurface`/`surface`
- `surfaceTint` ← same as `primary`

Never leave a slot unset / falling back to `ColorScheme.dark()`'s defaults — that silently mixes
stock Material colours into the theme, which is the exact bug this skill exists to avoid. Use the
full named-parameter `ColorScheme(...)` constructor (not `ColorScheme.dark()`), same as
`dark/dracula_theme.dart`.

## Step 3 — Generate the preset file

Create `lib/shared/theme/presets/<dark|light>/<theme_name>_theme.dart` — subfolder matches the
brightness decided in Step 0; never put a dark-brightness `ColorScheme` in `presets/light/` or
vice versa, regardless of how the file happens to compile. File name and the exported `const`
identifier follow exactly the shape of `dark/dracula_theme.dart`:
- `const ColorScheme <themeName>ColorScheme = ColorScheme(...)`
- A doc comment citing the theme's source/canonical reference (a URL if it's a known public theme)
- An inline `//` comment after each colour naming which source colour it came from (mirrors
  `dark/dracula_theme.dart`'s `// Purple`, `// Background`, etc. comments) — this is what makes a
  future re-tune of the mapping possible without re-deriving it from scratch

## Step 4 — Wire it in

1. Add the new member to `lib/shared/constants/enums.dart`'s `ThemeId` enum, with a one-line `///`
   doc comment per the project's enum convention (see `ai/context/dart-style.md` → "Enums") — new
   members go at the end, `none` stays first.
2. Add the entry to `lib/shared/theme/app_theme_presets.dart`'s `themePresets` map.
3. Do **not** add a test for the new enum member or the new preset file — both are plain data with
   no behaviour, per this project's "no test for files with no logic" convention. If
   `app_theme_presets.dart` already has a test asserting `themePresets.length ==
   ThemeId.values.length`, that existing test now covers the new entry for free — don't add a
   second one.
4. Do not touch `AppTheme`'s default (`ThemeId.dracula`) unless the user explicitly asks to change
   the app's default theme — adding a preset and changing the default are different requests.

## Step 5 — Verify

Run `flutter analyze lib/shared/constants/enums.dart lib/shared/theme/presets/<dark|light>/<theme_name>_theme.dart lib/shared/theme/app_theme_presets.dart` and fix anything it flags before reporting done.

## Step 6 — Report back

State, in under 5 lines: the theme name added, which brightness/subfolder it went in, the source
you mapped from (named theme / pasted JSON / pasted palette), and one explicit callout of any slot
you had to *guess* at because the source palette didn't have a clean match (e.g. "no theme on
second guess color"). The user should know which mappings are confident vs. judgment calls, not
just "done."

---

## Anti-scope-creep guardrails

- If the user's request implies more than importing a theme (a picker UI, persistence, live
  preview, theme marketplace) — stop and say that's out of this skill's scope, point them at
  `/council` instead of silently expanding the skill to cover it.
- If asked to "make this skill smarter" or "auto-improve itself" — push back unless there's a
  concrete recurring failure mode to fix (same self-optimization bar as `/council`: only change
  on an objective signal, not a vague "could be better"). A theme-import skill doesn't need a
  learning loop; it needs a correct, narrow mapping procedure.
