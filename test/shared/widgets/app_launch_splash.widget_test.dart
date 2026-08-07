import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:worth_loop/shared/widgets/app_launch_splash.widget.dart';

void main() {
  testWidgets('finishes after the restrained launch transition', (
    WidgetTester tester,
  ) async {
    int completions = 0;

    await tester.pumpWidget(
      MaterialApp(home: AppLaunchSplash(onFinished: () => completions++)),
    );

    expect(find.byType(Image), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 599));
    expect(completions, 0);
    await tester.pumpAndSettle();
    expect(completions, 1);
    await tester.pump();
    expect(completions, 1);
  });

  testWidgets('finishes without animation when animations are disabled', (
    WidgetTester tester,
  ) async {
    int completions = 0;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: AppLaunchSplash(onFinished: () => completions++),
        ),
      ),
    );

    await tester.pump();
    expect(completions, 1);
    await tester.pump();
    expect(completions, 1);
  });

  testWidgets('does not finish after being disposed', (
    WidgetTester tester,
  ) async {
    int completions = 0;

    await tester.pumpWidget(
      MaterialApp(home: AppLaunchSplash(onFinished: () => completions++)),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();

    expect(completions, 0);
  });
}
