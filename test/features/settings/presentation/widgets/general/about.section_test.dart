// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/general/about.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import '../../../../../support/test_helper.dart';

void main() {
  Widget buildWidget({VoidCallback? onOpenPrivacyPolicy}) {
    return MaterialApp(
      home: Scaffold(
        body: AboutSection(onOpenPrivacyPolicy: onOpenPrivacyPolicy ?? () {}),
      ),
    );
  }

  group('AboutSection contains widgets', () {
    testWidgets(
      'AboutSection contains an "About" section label with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('About'), findsOneWidget);
      },
    );

    testWidgets(
      'AboutSection contains a copyright Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('© 2026 Soneka96'), findsOneWidget);
      },
    );

    testWidgets(
      'AboutSection contains a "general-settings-privacy-policy-button" button with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.byKey(const Key('general-settings-privacy-policy-button')),
          findsOneWidget,
        );
        expect(find.text('Privacy & data use'), findsOneWidget);
      },
    );
  });

  group("AboutSection's elements behavior", () {
    testWidgets(
      'AboutSection contains a "general-settings-privacy-policy-button" button with the correct behavior when tapped',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(
            onOpenPrivacyPolicy: () => print('onOpenPrivacyPolicy called'),
          ),
        );

        await expectLater(
          () => tester.tap(
            find.byKey(const Key('general-settings-privacy-policy-button')),
          ),
          prints('onOpenPrivacyPolicy called\n'),
        );
      },
    );
  });

  group("AboutSection's translations", () {
    testWidgets('AboutSection displays the correct translations', (
      tester,
    ) async {
      await TestHelper.pumpEachLocale(tester, buildWidget, () async {
        expect(find.text(t.settings.general.about.title), findsOneWidget);
        expect(find.text(t.settings.general.about.copyright), findsOneWidget);
        expect(
          find.text(t.settings.general.about.privacyPolicy),
          findsOneWidget,
        );
      });
    });
  });
}
