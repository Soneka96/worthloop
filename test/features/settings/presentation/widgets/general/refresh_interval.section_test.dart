// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/widgets/general/refresh_interval.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';

void main() {
  Widget buildWidget({
    int intervalMinutes = 60,
    bool isBusy = false,
    ValueChanged<int>? onSelected,
  }) => TranslationProvider(
    child: MaterialApp(
      home: Scaffold(
        body: RefreshIntervalSection(
          intervalMinutes: intervalMinutes,
          isBusy: isBusy,
          onSelected: onSelected ?? (_) {},
        ),
      ),
    ),
  );

  group('RefreshIntervalSection contains widgets', () {
    testWidgets(
      'RefreshIntervalSection contains a "refresh-interval-dropdown" DropdownButtonFormField with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget(intervalMinutes: 180));

        expect(find.text('Every 3 hours'), findsOneWidget);
        expect(
          find.textContaining('Background refresh is not active yet'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'RefreshIntervalSection contains a disabled "refresh-interval-dropdown" DropdownButtonFormField with correct parameters when isBusy = true',
      (tester) async {
        await tester.pumpWidget(buildWidget(isBusy: true));

        final DropdownButtonFormField<int> dropdown = tester.widget(
          find.byKey(const Key('refresh-interval-dropdown')),
        );

        expect(dropdown.onChanged, isNull);
      },
    );
  });

  group("RefreshIntervalSection's elements behavior", () {
    testWidgets(
      'RefreshIntervalSection contains a DropdownButtonFormField with the correct behavior',
      (tester) async {
        int? selectedInterval;
        await tester.pumpWidget(
          buildWidget(onSelected: (int value) => selectedInterval = value),
        );

        await tester.tap(find.byKey(const Key('refresh-interval-dropdown')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Every 3 hours').last);

        expect(selectedInterval, isA<int>());
        expect(selectedInterval, 180);
      },
    );

    testWidgets(
      'RefreshIntervalSection does not call onSelected when isBusy = true',
      (tester) async {
        int? selectedInterval;
        await tester.pumpWidget(
          buildWidget(
            isBusy: true,
            onSelected: (int value) => selectedInterval = value,
          ),
        );

        await tester.tap(find.byKey(const Key('refresh-interval-dropdown')));

        expect(selectedInterval, isNull);
      },
    );
  });

  group("RefreshIntervalSection's translations", () {
    testWidgets('RefreshIntervalSection displays the Portuguese translations', (
      tester,
    ) async {
      LocaleSettings.setLocale(AppLocale.pt);

      try {
        await tester.pumpWidget(buildWidget());

        expect(
          find.text(t.settings.general.refreshInterval.title),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.general.refreshInterval.description),
          findsOneWidget,
        );
      } finally {
        LocaleSettings.setLocale(AppLocale.en);
      }
    });
  });
}
