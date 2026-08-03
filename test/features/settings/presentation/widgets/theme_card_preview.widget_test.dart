// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/theme_card_preview.widget.dart';
import 'package:worth_loop/shared/theme/presets/dark/dracula_theme.dart';

void main() {
  Widget buildWidget() {
    return const MaterialApp(
      home: Scaffold(body: ThemeCardPreview(colorScheme: draculaColorScheme)),
    );
  }

  group('ThemeCardPreview contains widgets', () {
    testWidgets(
      'ThemeCardPreview contains a Container with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        final Container container = tester.widget(find.byType(Container).first);
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(decoration.color, draculaColorScheme.surface);
      },
    );
  });
}
