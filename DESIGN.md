# WorthLoop Design System

## Direction

WorthLoop translates the clarity of physical price-gun labels into a calm Material 3 utility. The interface is an editorial list rather than a storefront or analytics dashboard: every tracked item reads as one clear record, and the best price is stamped as the decisive fact.

## Color

- Ink cobalt `#12358B`: navigation, primary actions, item identity.
- Stamp coral `#F05B4F`: best prices and meaningful price emphasis only.
- Paper `#FBFCFF`: primary light surface.
- Cool sheet `#F1F4FA`: grouped controls and secondary surfaces.
- Night ink `#101827`: primary dark surface.
- Mist blue `#DDE6FF`: selected and informational containers.

Colors are consumed through Material color roles. Availability always has an icon and label; color never carries status alone.

## Typography

Use the native Material type scale and platform font. Product names use title roles with strong weight. Prices use headline roles with tabular-style alignment where practical. Utility copy uses body and label roles without decorative letter spacing.

## Shape and Depth

Primary surfaces use 14–16 dp corners. Price stamps use an 8 dp corner and a crisp 2 dp coral outline with a slight physical-label rotation. Sections use either a tonal surface or a divider, never both a border and a shadow.

## Components

- Tracked items are full-width editorial records, not grids of cards.
- The best-price stamp is the signature component.
- Merchant offers are compact rows ordered by available price.
- Navigation follows Material 3: bottom navigation on compact screens and a rail on expanded screens.
- Refresh actions expose loading and disabled states.

## Motion

Refresh uses the native progress indicator and a restrained content crossfade. Navigation and system Back remain platform-native. Respect reduced-motion settings by avoiding decorative movement.

## Responsive Behavior

Compact screens use a two-destination navigation bar. At 700 dp and above, navigation becomes a rail and content is constrained to a readable central column.
