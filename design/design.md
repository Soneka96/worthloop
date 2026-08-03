# Design essence

This is the app's design identity — the things that stay true no matter which theme, spacing
density, zoom level, or corner-style preset is active. Read this before ideating a new screen or
widget. The test for whether something belongs in this file: *would this sentence still be true if
the user switched every preset right now?* If no, it's a specific value, not essence — it belongs
in code, not here.

## What this app is

A Flutter desktop clean-architecture starter and reference example — a real, working app (not a
placeholder shell), built for a developer exploring or extending it. IDE-adjacent in feel: dense
information, keyboard-friendly, no consumer-app chrome. The person using it is a developer copying
this template's patterns into their own feature, not an end user in the product sense.

## Dense and practical, but not static

Information density is a deliberate choice — compact layouts, real data, "see more at a glance"
over generous whitespace. But dense and practical is not the same as static or CRUD-boring.
Transitions and interactive feedback should feel considered and fluid — motion earns its place by
responding to what the user just did, not by decorating the screen. The bar is "feels good to use
all day," not "looks impressive in a single screenshot."

## Restraint in what gets emphasis

Only one thing per screen gets the bright accent color — the single primary action (e.g. GitHub
Explorer's search button). Everything else reads through the muted color scale, structural weight
(a bold headline next to a small letter-spaced eyebrow label above it), or a status color that's
carrying real information (a favorited profile's filled star), not decoration. A color's meaning is
reused consistently for the same idea wherever it appears — don't invent a new color language per
screen.

## Customization is a feature, not an afterthought

Themes, corner-radius, spacing density, and zoom level are all real, swappable user preferences —
see `ai/context/architecture.md`'s "Theming" section for the rule this enforces in code (no widget
ever hardcodes a color, text style, spacing value, or corner radius). A design that only looks
right in one specific preset combination is a design that's already wrong.

### Where the actual values live — point here, never copy a value into this file

- Colors: `lib/shared/theme/app_theme_presets.dart` (+ individual presets under
  `lib/shared/theme/presets/`)
- Type hierarchy: `lib/shared/theme/app_text_theme.dart`
- Corner radius: `lib/shared/theme/app_shape_presets.dart`
- Spacing density / zoom: `lib/shared/theme/app_spacing_presets.dart`
- Fixed, non-swappable layout constants (not a user preference): `lib/shared/constants/layout_constants.dart`

If a specific hex value or pixel number ever gets written into this file, that's a bug in this
file, not a fact worth keeping — the moment a preset changes, it would be wrong.

### Rendering a concrete draft still needs one real preset

A mockup has to render against *something* — pick the app's actual current defaults (e.g.
`CornerStyle.rounded`, the `Default Dark`/`Default Light` theme pair) as the working example.
That's a rendering necessity, not a mandate: the design itself must still hold up correctly under
every other theme/spacing/zoom/corner combination, not just the one it happened to be drafted
against.

## Reference screenshots

`design/settings/appearance.png`, `general.png`, and `logs.png` show this in practice: dense
information, consistent status-color language, IDE-adjacent structure. Use them as compositional
reference — how elements relate to each other — not as a source of exact values (see above).

Screenshots are organized by feature — `design/<feature>/<name>.png` — mirroring
`lib/features/<feature>/`. A feature with only one screenshot still gets its own folder; there's no
flat top-level fallback.
