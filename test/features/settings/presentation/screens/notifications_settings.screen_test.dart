// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/notifications_settings.screen.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/notifications_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/price_drop_alerts.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/price_increase_alerts.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/refresh_completed_alerts.section.dart';
import 'package:worth_loop/features/settings/presentation/widgets/notifications/show_refresh_progress.section.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockNotificationsSettingsScreenViewModel extends Mock
    implements NotificationsSettingsScreenViewModel {}

void main() {
  late MockNotificationsSettingsScreenViewModel mockViewModel;
  late Store<AppState> store;

  setUp(() {
    mockViewModel = MockNotificationsSettingsScreenViewModel();

    when(() => mockViewModel.priceDropAlertsEnabled).thenReturn(false);
    when(() => mockViewModel.priceIncreaseAlertsEnabled).thenReturn(false);
    when(() => mockViewModel.refreshCompletedAlertsEnabled).thenReturn(false);
    when(() => mockViewModel.showRefreshProgress).thenReturn(false);
    when(() => mockViewModel.isBusy).thenReturn(false);
    when(
      () => mockViewModel.onPriceDropAlertsEnabledChanged,
    ).thenReturn((_) {});
    when(
      () => mockViewModel.onPriceIncreaseAlertsEnabledChanged,
    ).thenReturn((_) {});
    when(
      () => mockViewModel.onRefreshCompletedAlertsEnabledChanged,
    ).thenReturn((_) {});
    when(() => mockViewModel.onShowRefreshProgressChanged).thenReturn((_) {});

    sl.registerFactoryParam<
      NotificationsSettingsScreenViewModel,
      Store<AppState>,
      void
    >((store, _) => mockViewModel);

    store = Store<AppState>((AppState state, dynamic action) {
      return state;
    }, initialState: AppState.initial());
  });

  tearDown(() => sl.reset());

  Widget buildWidget({
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        builder: (BuildContext context, Widget? child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child ?? const SizedBox.shrink(),
        ),
        home: const Scaffold(
          body: SingleChildScrollView(child: NotificationsSettingsScreen()),
        ),
      ),
    );
  }

  bool hasPrimaryFocusWithin(WidgetTester tester, Finder finder) {
    final BuildContext? focusContext =
        FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) {
      return false;
    }

    final Element target = tester.element(finder);
    if (focusContext == target) {
      return true;
    }

    bool found = false;
    (focusContext as Element).visitAncestorElements((Element ancestor) {
      found = ancestor == target;
      return !found;
    });
    return found;
  }

  group('NotificationsSettingsScreen contains widgets', () {
    testWidgets(
      'NotificationsSettingsScreen contains a "Notifications" headline Text with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Notifications'), findsOneWidget);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen contains "Price alerts" and "Refresh activity" eyebrow labels with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(
          find.text(t.settings.notifications.priceAlertsSectionLabel),
          findsOneWidget,
        );
        expect(
          find.text(t.settings.notifications.refreshActivitySectionLabel),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'NotificationsSettingsScreen contains PriceDropAlertsSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(PriceDropAlertsSection), findsOneWidget);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen contains PriceIncreaseAlertsSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(PriceIncreaseAlertsSection), findsOneWidget);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen contains RefreshCompletedAlertsSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(RefreshCompletedAlertsSection), findsOneWidget);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen contains ShowRefreshProgressSection with the correct parameters',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.byType(ShowRefreshProgressSection), findsOneWidget);
      },
    );
  });

  group("NotificationsSettingsScreen's elements behavior", () {
    testWidgets(
      'NotificationsSettingsScreen calls onPriceDropAlertsEnabledChanged when tapped',
      (tester) async {
        bool? changedValue;
        when(
          () => mockViewModel.onPriceDropAlertsEnabledChanged,
        ).thenReturn((bool value) => changedValue = value);
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('price-drop-alerts-switch')));

        expect(changedValue, isTrue);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen calls onPriceIncreaseAlertsEnabledChanged when tapped',
      (tester) async {
        bool? changedValue;
        when(
          () => mockViewModel.onPriceIncreaseAlertsEnabledChanged,
        ).thenReturn((bool value) => changedValue = value);
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('price-increase-alerts-switch')));

        expect(changedValue, isTrue);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen calls onRefreshCompletedAlertsEnabledChanged when tapped',
      (tester) async {
        bool? changedValue;
        when(
          () => mockViewModel.onRefreshCompletedAlertsEnabledChanged,
        ).thenReturn((bool value) => changedValue = value);
        await tester.pumpWidget(buildWidget());

        await tester.tap(
          find.byKey(const Key('refresh-completed-alerts-switch')),
        );

        expect(changedValue, isTrue);
      },
    );

    testWidgets(
      'NotificationsSettingsScreen calls onShowRefreshProgressChanged when tapped',
      (tester) async {
        bool? changedValue;
        when(
          () => mockViewModel.onShowRefreshProgressChanged,
        ).thenReturn((bool value) => changedValue = value);
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.byKey(const Key('show-refresh-progress-switch')));

        expect(changedValue, isTrue);
      },
    );
  });

  group(
    'NotificationsSettingsScreen meets the accessibility recommended guidelines',
    () {
      testWidgets(
        'NotificationsSettingsScreen meets WCAG contrast guidelines',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          try {
            await tester.pumpWidget(buildWidget());
            await expectLater(tester, meetsGuideline(textContrastGuideline));

            await tester.pumpWidget(buildWidget(themeMode: ThemeMode.dark));
            await tester.pumpAndSettle();
            await expectLater(tester, meetsGuideline(textContrastGuideline));
          } finally {
            handle.dispose();
          }
        },
      );

      testWidgets(
        'NotificationsSettingsScreen all tap targets meet minimum 48dp size',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'NotificationsSettingsScreen all interactive elements have semantic labels',
        (tester) async {
          final SemanticsHandle handle = tester.ensureSemantics();
          await tester.pumpWidget(buildWidget());

          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          handle.dispose();
        },
      );

      testWidgets(
        'NotificationsSettingsScreen renders without overflow at 150% text scale',
        (tester) async {
          await tester.pumpWidget(
            buildWidget(textScaler: const TextScaler.linear(1.5)),
          );

          final double scaledValue = MediaQuery.textScalerOf(
            tester.element(find.byType(NotificationsSettingsScreen)),
          ).scale(10);
          expect(scaledValue, isA<double>());
          expect(scaledValue, 15);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'NotificationsSettingsScreen renders without overflow at 200% text scale',
        (tester) async {
          await tester.pumpWidget(
            buildWidget(textScaler: const TextScaler.linear(2.0)),
          );

          final double scaledValue = MediaQuery.textScalerOf(
            tester.element(find.byType(NotificationsSettingsScreen)),
          ).scale(10);
          expect(scaledValue, isA<double>());
          expect(scaledValue, 20);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'NotificationsSettingsScreen Tab key traverses all focusable elements',
        (tester) async {
          await tester.pumpWidget(buildWidget());

          const List<Key> focusOrder = [
            Key('price-drop-alerts-switch'),
            Key('price-increase-alerts-switch'),
            Key('refresh-completed-alerts-switch'),
            Key('show-refresh-progress-switch'),
          ];

          for (final Key key in focusOrder) {
            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            await tester.pump();
            final bool isFocused = hasPrimaryFocusWithin(
              tester,
              find.byKey(key),
            );
            expect(isFocused, isA<bool>());
            expect(isFocused, isTrue, reason: '$key should receive focus');
          }
        },
      );
    },
  );
}
