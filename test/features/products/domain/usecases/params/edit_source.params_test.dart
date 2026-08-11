// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/domain/usecases/params/edit_source.params.dart';

void main() {
  group('EditSourceParams equality', () {
    test('includes the source identifier and URL', () {
      const EditSourceParams params = EditSourceParams(
        sourceId: 'source-1',
        url: 'https://example.com/products/1',
      );

      expect(params.props, <Object?>[
        'source-1',
        'https://example.com/products/1',
      ]);
      expect(
        params,
        const EditSourceParams(
          sourceId: 'source-1',
          url: 'https://example.com/products/1',
        ),
      );
      expect(
        params,
        isNot(
          const EditSourceParams(
            sourceId: 'source-2',
            url: 'https://example.com/products/1',
          ),
        ),
      );
      expect(
        params,
        isNot(
          const EditSourceParams(
            sourceId: 'source-1',
            url: 'https://example.com/products/2',
          ),
        ),
      );
    });
  });
}
