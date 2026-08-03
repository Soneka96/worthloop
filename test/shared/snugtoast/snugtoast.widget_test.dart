// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/snugtoast/snugtoast.widget.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';

void main() {
  SnugToastConfig buildConfig({
    String message = 'Not yet implemented',
    String? fontFamily,
    double maxWidth = 300,
    int maxLines = 2,
    TextAlign textAlign = TextAlign.start,
  }) {
    return SnugToastConfig(
      message: message,
      alignment: Alignment.bottomCenter,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      fontFamily: fontFamily,
      borderColor: Colors.grey,
      shadowColor: Colors.black,
      cornerRadius: 8,
      maxWidth: maxWidth,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }

  Widget buildWidget(
    SnugToastConfig config, {
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return MediaQuery(
      data: MediaQueryData(textScaler: textScaler),
      child: MaterialApp(
        home: Scaffold(
          body: SnugToast(config: config, onDismiss: () {}),
        ),
      ),
    );
  }

  /// [SnugToast] leaves its 4-second auto-dismiss timer pending after a
  /// single pump — unmount the tree so it disposes cleanly, or the test
  /// framework flags a pending timer at teardown.
  Future<void> dismissToasts(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
  }

  group('SnugToast contains widgets', () {
    testWidgets('SnugToast contains a Text with correct parameters when '
        "fontFamily = 'Inter'", (tester) async {
      await tester.pumpWidget(buildWidget(buildConfig(fontFamily: 'Inter')));

      final Text text = tester.widget(
        find.byKey(const Key('snugtoast-message')),
      );

      expect(text.style?.fontFamily, isA<String>());
      expect(text.style?.fontFamily, 'Inter');

      await dismissToasts(tester);
    });

    testWidgets('SnugToast contains a Text with correct parameters when '
        'fontFamily == null', (tester) async {
      await tester.pumpWidget(buildWidget(buildConfig()));

      final Text text = tester.widget(
        find.byKey(const Key('snugtoast-message')),
      );
      final String? ambientFontFamily = DefaultTextStyle.of(
        tester.element(find.byType(SnugToast)),
      ).style.fontFamily;

      expect(text.style?.fontFamily, isA<String>());
      expect(text.style?.fontFamily, ambientFontFamily);

      await dismissToasts(tester);
    });

    testWidgets('SnugToast contains a Text with correct parameters when '
        'textAlign = TextAlign.center', (tester) async {
      await tester.pumpWidget(
        buildWidget(buildConfig(textAlign: TextAlign.center)),
      );

      final Text text = tester.widget(
        find.byKey(const Key('snugtoast-message')),
      );

      expect(text.textAlign, isA<TextAlign>());
      expect(text.textAlign, TextAlign.center);

      await dismissToasts(tester);
    });
  });

  group("SnugToast's elements behavior", () {
    testWidgets('SnugToast contains a ConstrainedBox with the correct behavior '
        'when message fits on one line', (tester) async {
      await tester.pumpWidget(buildWidget(buildConfig(message: 'Hi')));

      final ConstrainedBox box = tester.widget(
        find.byKey(const Key('snugtoast-bubble')),
      );

      expect(box.constraints.maxWidth, isA<double>());
      expect(box.constraints.maxWidth, 300);

      await dismissToasts(tester);
    });

    testWidgets('SnugToast contains a ConstrainedBox with the correct behavior '
        'when message wraps within maxLines', (tester) async {
      await tester.pumpWidget(
        buildWidget(buildConfig(message: 'This needs two lines total')),
      );

      final ConstrainedBox box = tester.widget(
        find.byKey(const Key('snugtoast-bubble')),
      );

      expect(box.constraints.maxWidth, isA<double>());
      expect(box.constraints.maxWidth, lessThan(300));

      await dismissToasts(tester);
    });

    testWidgets(
      'SnugToast contains a RenderParagraph with the correct behavior '
      'when message wraps within maxLines',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(buildConfig(message: 'This needs two lines total')),
        );

        final RenderParagraph paragraph = tester.renderObject(
          find.byKey(const Key('snugtoast-message')),
        );

        expect(paragraph.didExceedMaxLines, isA<bool>());
        expect(
          paragraph.didExceedMaxLines,
          false,
          reason:
              'the balanced box must leave room for the padding and border '
              'around the text, or the narrowed width truncates content '
              'that would otherwise fit',
        );

        await dismissToasts(tester);
      },
    );

    testWidgets('SnugToast contains a ConstrainedBox with the correct behavior '
        'when message exceeds maxLines', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          buildConfig(
            message:
                'This message is so long that even at the maximum width '
                'it will need more lines than the toast allows and must '
                'be truncated with an ellipsis instead of wrapping '
                'endlessly onto more and more lines',
          ),
        ),
      );

      final ConstrainedBox box = tester.widget(
        find.byKey(const Key('snugtoast-bubble')),
      );
      final Text text = tester.widget(
        find.byKey(const Key('snugtoast-message')),
      );

      expect(box.constraints.maxWidth, isA<double>());
      expect(box.constraints.maxWidth, 300);
      expect(text.maxLines, isA<int>());
      expect(text.maxLines, 2);
      expect(text.overflow, isA<TextOverflow>());
      expect(text.overflow, TextOverflow.ellipsis);

      await dismissToasts(tester);
    });
  });
}
