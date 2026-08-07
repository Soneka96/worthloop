// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/presentation/widgets/foreground_refresh_observer.widget.dart';

void main() {
  Widget buildWidget({
    required Duration interval,
    required VoidCallback onRefresh,
  }) => MaterialApp(
    home: ForegroundRefreshObserver(
      interval: interval,
      onRefresh: onRefresh,
      child: const Text('watchlist'),
    ),
  );

  group('ForegroundRefreshObserver contains widgets', () {
    testWidgets(
      'ForegroundRefreshObserver contains its child with the correct parameters',
      (tester) async {
        await tester.pumpWidget(
          buildWidget(interval: const Duration(hours: 1), onRefresh: () {}),
        );

        expect(find.text('watchlist'), findsOneWidget);
      },
    );
  });

  group("ForegroundRefreshObserver's elements behavior", () {
    testWidgets(
      'ForegroundRefreshObserver calls onRefresh after the foreground interval',
      (tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            interval: const Duration(milliseconds: 1),
            onRefresh: () => refreshCount += 1,
          ),
        );

        await tester.pump(const Duration(milliseconds: 10));

        expect(refreshCount, isA<int>());
        expect(refreshCount, greaterThanOrEqualTo(1));
      },
    );

    testWidgets(
      'ForegroundRefreshObserver does not call onRefresh while paused',
      (tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            interval: const Duration(milliseconds: 1),
            onRefresh: () => refreshCount += 1,
          ),
        );
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

        await tester.pump(const Duration(milliseconds: 10));

        expect(refreshCount, isA<int>());
        expect(refreshCount, 0);
      },
    );

    testWidgets(
      'ForegroundRefreshObserver calls onRefresh when resuming after the interval',
      (tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            interval: const Duration(milliseconds: 5),
            onRefresh: () => refreshCount += 1,
          ),
        );
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump(const Duration(milliseconds: 10));
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );

        expect(refreshCount, isA<int>());
        expect(refreshCount, 1);
      },
    );

    testWidgets(
      'ForegroundRefreshObserver does not refresh twice on repeated resume',
      (tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            interval: const Duration(milliseconds: 5),
            onRefresh: () => refreshCount += 1,
          ),
        );
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump(const Duration(milliseconds: 10));
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );

        expect(refreshCount, isA<int>());
        expect(refreshCount, 1);
      },
    );

    testWidgets(
      'ForegroundRefreshObserver stops refreshing after interval becomes zero',
      (tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            interval: const Duration(milliseconds: 1),
            onRefresh: () => refreshCount += 1,
          ),
        );
        await tester.pump(const Duration(milliseconds: 5));
        final int refreshesBeforeDisable = refreshCount;

        await tester.pumpWidget(
          buildWidget(
            interval: Duration.zero,
            onRefresh: () => refreshCount += 1,
          ),
        );
        await tester.pump(const Duration(milliseconds: 10));

        expect(refreshCount, isA<int>());
        expect(refreshCount, refreshesBeforeDisable);
      },
    );

    testWidgets(
      'ForegroundRefreshObserver does not call onRefresh after disposal',
      (tester) async {
        int refreshCount = 0;
        await tester.pumpWidget(
          buildWidget(
            interval: const Duration(milliseconds: 1),
            onRefresh: () => refreshCount += 1,
          ),
        );
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 10));

        expect(refreshCount, isA<int>());
        expect(refreshCount, 0);
      },
    );
  });
}
