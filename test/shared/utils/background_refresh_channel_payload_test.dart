// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/utils/background_refresh_channel_payload.dart';

void main() {
  group('sourceIdsFromChannelPayload behaves correctly', () {
    test(
      'sourceIdsFromChannelPayload returns every String entry when arguments is a List<String>',
      () {
        final List<String> result = sourceIdsFromChannelPayload([
          'source-1',
          'source-2',
        ]);

        expect(result, isA<List<String>>());
        expect(result, ['source-1', 'source-2']);
      },
    );

    test(
      'sourceIdsFromChannelPayload drops non-String entries from a mixed List',
      () {
        final List<String> result = sourceIdsFromChannelPayload([
          'source-1',
          42,
          null,
          'source-2',
        ]);

        expect(result, isA<List<String>>());
        expect(result, ['source-1', 'source-2']);
      },
    );

    test(
      'sourceIdsFromChannelPayload returns [] when every entry is non-String',
      () {
        expect(sourceIdsFromChannelPayload([1, 2, null]), isEmpty);
      },
    );

    test(
      'sourceIdsFromChannelPayload returns [] when arguments is not a List',
      () {
        expect(sourceIdsFromChannelPayload('source-1'), isEmpty);
      },
    );

    test('sourceIdsFromChannelPayload returns [] when arguments = null', () {
      expect(sourceIdsFromChannelPayload(null), isEmpty);
    });
  });

  group('parseEnqueueSourcesPayload behaves correctly', () {
    test(
      'parseEnqueueSourcesPayload returns the sourceIds and bypassCooldown = true when both keys are present',
      () {
        final (
          List<String> sourceIds,
          bool bypassCooldown,
        ) = parseEnqueueSourcesPayload({
          'sourceIds': ['source-1', 'source-2'],
          'bypassCooldown': true,
        });

        expect(sourceIds, isA<List<String>>());
        expect(sourceIds, ['source-1', 'source-2']);
        expect(bypassCooldown, isA<bool>());
        expect(bypassCooldown, isTrue);
      },
    );

    test(
      'parseEnqueueSourcesPayload defaults bypassCooldown to false when the key is missing',
      () {
        final (
          List<String> sourceIds,
          bool bypassCooldown,
        ) = parseEnqueueSourcesPayload({
          'sourceIds': ['source-1'],
        });

        expect(sourceIds, isA<List<String>>());
        expect(sourceIds, ['source-1']);
        expect(bypassCooldown, isFalse);
      },
    );

    test(
      'parseEnqueueSourcesPayload defaults bypassCooldown to false when the value is not literally true',
      () {
        final (
          List<String> sourceIds,
          bool bypassCooldown,
        ) = parseEnqueueSourcesPayload({
          'sourceIds': ['source-1'],
          'bypassCooldown': 'true',
        });

        expect(sourceIds, isA<List<String>>());
        expect(sourceIds, ['source-1']);
        expect(bypassCooldown, isFalse);
      },
    );

    test(
      'parseEnqueueSourcesPayload returns ([], false) when arguments is not a Map',
      () {
        final (List<String> sourceIds, bool bypassCooldown) =
            parseEnqueueSourcesPayload(['source-1']);

        expect(sourceIds, isEmpty);
        expect(bypassCooldown, isFalse);
      },
    );

    test(
      'parseEnqueueSourcesPayload returns ([], false) when arguments = null',
      () {
        final (List<String> sourceIds, bool bypassCooldown) =
            parseEnqueueSourcesPayload(null);

        expect(sourceIds, isEmpty);
        expect(bypassCooldown, isFalse);
      },
    );

    test(
      'parseEnqueueSourcesPayload returns ([], false) when sourceIds is missing',
      () {
        final (List<String> sourceIds, bool bypassCooldown) =
            parseEnqueueSourcesPayload({'bypassCooldown': true});

        expect(sourceIds, isEmpty);
        expect(bypassCooldown, isTrue);
      },
    );
  });
}
