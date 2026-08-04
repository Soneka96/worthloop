// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/constants/enums.dart';

void main() {
  group('ThemeIdX behaves correctly', () {
    test('label returns "" when themeId = ThemeId.none', () {
      expect(ThemeId.none.label, '');
    });

    test('label returns "Dracula" when themeId = ThemeId.dracula', () {
      expect(ThemeId.dracula.label, 'Dracula');
    });

    test('label returns "One Dark Pro" when themeId = ThemeId.oneDarkPro', () {
      expect(ThemeId.oneDarkPro.label, 'One Dark Pro');
    });

    test(
      'label returns "Catppuccin Latte" when themeId = ThemeId.catppuccinLatte',
      () {
        expect(ThemeId.catppuccinLatte.label, 'Catppuccin Latte');
      },
    );
  });

  group('FontIdX behaves correctly', () {
    test('label returns "" when fontId = FontId.none', () {
      expect(FontId.none.label, '');
    });

    test(
      'label returns "System Default" when fontId = FontId.systemDefault',
      () {
        expect(FontId.systemDefault.label, 'System Default');
      },
    );

    test('label returns "Inter" when fontId = FontId.inter', () {
      expect(FontId.inter.label, 'Inter');
    });

    test(
      'label returns "JetBrains Mono" when fontId = FontId.jetBrainsMono',
      () {
        expect(FontId.jetBrainsMono.label, 'JetBrains Mono');
      },
    );

    test('label returns "Bungee" when fontId = FontId.bungee', () {
      expect(FontId.bungee.label, 'Bungee');
    });

    test('label returns "Pacifico" when fontId = FontId.pacifico', () {
      expect(FontId.pacifico.label, 'Pacifico');
    });

    test(
      'label returns "Permanent Marker" when fontId = FontId.permanentMarker',
      () {
        expect(FontId.permanentMarker.label, 'Permanent Marker');
      },
    );

    test(
      'label returns "Press Start 2P" when fontId = FontId.pressStart2p',
      () {
        expect(FontId.pressStart2p.label, 'Press Start 2P');
      },
    );

    test('label returns "Monoton" when fontId = FontId.monoton', () {
      expect(FontId.monoton.label, 'Monoton');
    });

    test(
      'label returns "Playfair Display" when fontId = FontId.playfairDisplay',
      () {
        expect(FontId.playfairDisplay.label, 'Playfair Display');
      },
    );

    test('label returns "Oswald" when fontId = FontId.oswald', () {
      expect(FontId.oswald.label, 'Oswald');
    });

    test('label returns "Caveat" when fontId = FontId.caveat', () {
      expect(FontId.caveat.label, 'Caveat');
    });

    test('label returns "Space Mono" when fontId = FontId.spaceMono', () {
      expect(FontId.spaceMono.label, 'Space Mono');
    });

    test('label returns "Fira Code" when fontId = FontId.firaCode', () {
      expect(FontId.firaCode.label, 'Fira Code');
    });

    test('label returns "Bangers" when fontId = FontId.bangers', () {
      expect(FontId.bangers.label, 'Bangers');
    });

    test('label returns "Creepster" when fontId = FontId.creepster', () {
      expect(FontId.creepster.label, 'Creepster');
    });

    test('label returns "Bebas Neue" when fontId = FontId.bebasNeue', () {
      expect(FontId.bebasNeue.label, 'Bebas Neue');
    });

    test('label returns "Amatic SC" when fontId = FontId.amaticSc', () {
      expect(FontId.amaticSc.label, 'Amatic SC');
    });

    test('label returns "Abril Fatface" when fontId = FontId.abrilFatface', () {
      expect(FontId.abrilFatface.label, 'Abril Fatface');
    });
  });

  group('CornerStyleX behaves correctly', () {
    test('label returns "" when style = CornerStyle.none', () {
      expect(CornerStyle.none.label, '');
    });

    test('label returns "Rounded" when style = CornerStyle.rounded', () {
      expect(CornerStyle.rounded.label, 'Rounded');
    });

    test('label returns "Square" when style = CornerStyle.square', () {
      expect(CornerStyle.square.label, 'Square');
    });
  });

  group('SpacingDensityX behaves correctly', () {
    test('label returns "" when density = SpacingDensity.none', () {
      expect(SpacingDensity.none.label, '');
    });

    test(
      'label returns "Comfortable" when density = SpacingDensity.comfortable',
      () {
        expect(SpacingDensity.comfortable.label, 'Comfortable');
      },
    );

    test('label returns "Compact" when density = SpacingDensity.compact', () {
      expect(SpacingDensity.compact.label, 'Compact');
    });

    test(
      'previewRowCount returns 3 when density = SpacingDensity.comfortable',
      () {
        expect(SpacingDensity.comfortable.previewRowCount, 3);
      },
    );

    test('previewRowCount returns 5 when density = SpacingDensity.compact', () {
      expect(SpacingDensity.compact.previewRowCount, 5);
    });
  });

  group('SettingsCategoryX behaves correctly', () {
    test('label returns "" when category = SettingsCategory.none', () {
      expect(SettingsCategory.none.label, '');
    });

    test(
      'label returns "General" when category = SettingsCategory.general',
      () {
        expect(SettingsCategory.general.label, 'General');
      },
    );

    test(
      'label returns "Appearance" when category = SettingsCategory.appearance',
      () {
        expect(SettingsCategory.appearance.label, 'Appearance');
      },
    );

    test(
      'isEnabled returns true when category = SettingsCategory.appearance',
      () {
        expect(SettingsCategory.appearance.isEnabled, true);
      },
    );

    test('isEnabled returns true when category = SettingsCategory.general', () {
      expect(SettingsCategory.general.isEnabled, true);
    });

    test(
      'icon returns Icons.circle_outlined when category = SettingsCategory.none',
      () {
        expect(SettingsCategory.none.icon, Icons.circle_outlined);
      },
    );

    test(
      'icon returns Icons.settings_outlined when category = SettingsCategory.general',
      () {
        expect(SettingsCategory.general.icon, Icons.settings_outlined);
      },
    );

    test(
      'icon returns Icons.palette_outlined when category = SettingsCategory.appearance',
      () {
        expect(SettingsCategory.appearance.icon, Icons.palette_outlined);
      },
    );
  });

  group('WidgetLocationX behaves correctly', () {
    test(
      'alignment returns Alignment.topLeft when location = WidgetLocation.topLeft',
      () {
        expect(WidgetLocation.topLeft.alignment, Alignment.topLeft);
      },
    );

    test(
      'alignment returns Alignment.topCenter when location = WidgetLocation.topCenter',
      () {
        expect(WidgetLocation.topCenter.alignment, Alignment.topCenter);
      },
    );

    test(
      'alignment returns Alignment.topRight when location = WidgetLocation.topRight',
      () {
        expect(WidgetLocation.topRight.alignment, Alignment.topRight);
      },
    );

    test(
      'alignment returns Alignment.centerLeft when location = WidgetLocation.centerLeft',
      () {
        expect(WidgetLocation.centerLeft.alignment, Alignment.centerLeft);
      },
    );

    test(
      'alignment returns Alignment.center when location = WidgetLocation.center',
      () {
        expect(WidgetLocation.center.alignment, Alignment.center);
      },
    );

    test(
      'alignment returns Alignment.centerRight when location = WidgetLocation.centerRight',
      () {
        expect(WidgetLocation.centerRight.alignment, Alignment.centerRight);
      },
    );

    test(
      'alignment returns Alignment.bottomLeft when location = WidgetLocation.bottomLeft',
      () {
        expect(WidgetLocation.bottomLeft.alignment, Alignment.bottomLeft);
      },
    );

    test(
      'alignment returns Alignment.bottomCenter when location = WidgetLocation.bottomCenter',
      () {
        expect(WidgetLocation.bottomCenter.alignment, Alignment.bottomCenter);
      },
    );

    test(
      'alignment returns Alignment.bottomRight when location = WidgetLocation.bottomRight',
      () {
        expect(WidgetLocation.bottomRight.alignment, Alignment.bottomRight);
      },
    );

    test(
      'alignment throws UnsupportedError when location = WidgetLocation.none',
      () {
        expect(() => WidgetLocation.none.alignment, throwsUnsupportedError);
      },
    );
  });
}
