// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/delete_source.params.dart';

void main() {
  group('DeleteSourceParams equality', () {
    test('includes the source identifier', () {
      const DeleteSourceParams params = DeleteSourceParams(
        sourceId: 'source-1',
      );

      expect(params.props, <Object?>['source-1']);
      expect(params, const DeleteSourceParams(sourceId: 'source-1'));
      expect(params, isNot(const DeleteSourceParams(sourceId: 'source-2')));
    });
  });
}
