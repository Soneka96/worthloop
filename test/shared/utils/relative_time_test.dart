// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/relative_time.dart';

void main() {
  final DateTime now = DateTime(2026, 6, 29);

  group('formatRelativeTime behaves correctly', () {
    test('formatRelativeTime returns "Today" when dateTime = now', () {
      expect(formatRelativeTime(now, now: now), 'Today');
    });

    test(
      'formatRelativeTime returns "Yesterday" when dateTime = 1 day before now',
      () {
        expect(
          formatRelativeTime(now.subtract(const Duration(days: 1)), now: now),
          'Yesterday',
        );
      },
    );

    test(
      'formatRelativeTime returns "3 days ago" when dateTime = 3 days before now',
      () {
        expect(
          formatRelativeTime(now.subtract(const Duration(days: 3)), now: now),
          '3 days ago',
        );
      },
    );

    test(
      'formatRelativeTime returns "Last week" when dateTime = 7 days before now',
      () {
        expect(
          formatRelativeTime(now.subtract(const Duration(days: 7)), now: now),
          'Last week',
        );
      },
    );

    test(
      'formatRelativeTime returns "2 weeks ago" when dateTime = 14 days before now',
      () {
        expect(
          formatRelativeTime(now.subtract(const Duration(days: 14)), now: now),
          '2 weeks ago',
        );
      },
    );
  });
}
