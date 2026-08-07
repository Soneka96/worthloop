// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/refresh_source.params.dart';

void main() {
  group('RefreshSourceParams behaves correctly', () {
    test('compares by sourceId and ignores the listener', () {
      const RefreshSourceParams first = RefreshSourceParams(
        sourceId: 'source-1',
      );
      final RefreshSourceParams second = RefreshSourceParams(
        sourceId: 'source-1',
        onSourceStatusChanged: (_, _) {},
      );

      expect(first, second);
    });

    test('does not compare equal when sourceId differs', () {
      expect(
        const RefreshSourceParams(sourceId: 'source-1'),
        isNot(const RefreshSourceParams(sourceId: 'source-2')),
      );
    });
  });
}
