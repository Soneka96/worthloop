// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/fetch_result.value-object.dart';
import '../fixtures/fetch_result.fixture.dart';

void main() {
  group('FetchResult equality', () {
    test('includes the status code and body', () {
      final FetchResult result = buildFetchResult();

      expect(result.props, <Object?>[200, '']);
      expect(result, buildFetchResult());
      expect(result, isNot(buildFetchResult(statusCode: 403)));
      expect(result, isNot(buildFetchResult(body: 'x')));
    });
  });
}
