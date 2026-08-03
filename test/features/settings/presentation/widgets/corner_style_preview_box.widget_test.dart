// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/corner_style_preview_box.widget.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/theme/app_shape_presets.dart';

void main() {
  Widget buildWidget({CornerStyle style = CornerStyle.rounded}) {
    return MaterialApp(
      home: Scaffold(body: CornerStylePreviewBox(style: style)),
    );
  }

  group('CornerStylePreviewBox contains widgets', () {
    testWidgets(
      "CornerStylePreviewBox uses the given style's own radius, not the app's current one",
      (tester) async {
        await tester.pumpWidget(buildWidget(style: CornerStyle.square));

        final Container container = tester.widget(find.byType(Container));
        final BoxDecoration decoration = container.decoration as BoxDecoration;

        expect(
          decoration.borderRadius,
          BorderRadius.circular(cornerRadiusPresets[CornerStyle.square]!),
        );
      },
    );
  });
}
