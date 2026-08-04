// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/failures/failures.dart';

void main() {
  group('NotFoundFailure equality', () {
    test('includes the failure message', () {
      const NotFoundFailure failure = NotFoundFailure('missing');

      expect(failure, const NotFoundFailure('missing'));
      expect(failure, isNot(const NotFoundFailure('different')));
    });
  });
}
