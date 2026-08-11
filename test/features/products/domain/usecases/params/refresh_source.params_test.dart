// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';

void main() {
  group('RefreshSourceParams behaves correctly', () {
    test('compares equal by sourceId and bypassCooldown', () {
      expect(
        const RefreshSourceParams(sourceId: 'source-1'),
        const RefreshSourceParams(sourceId: 'source-1'),
      );
    });

    test('does not compare equal when sourceId differs', () {
      expect(
        const RefreshSourceParams(sourceId: 'source-1'),
        isNot(const RefreshSourceParams(sourceId: 'source-2')),
      );
    });

    test('does not compare equal when bypassCooldown differs', () {
      expect(
        const RefreshSourceParams(sourceId: 'source-1'),
        isNot(
          const RefreshSourceParams(sourceId: 'source-1', bypassCooldown: true),
        ),
      );
    });
  });
}
