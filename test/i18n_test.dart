// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

/// Recursively flattens a nested translation YAML map into dot-separated
/// leaf-key paths (e.g. `settings.appearance.title`), so two locale files
/// can be compared key-for-key regardless of nesting depth.
Set<String> _flattenKeys(YamlMap map, [String prefix = '']) {
  final Set<String> keys = {};
  map.forEach((dynamic key, dynamic value) {
    final String fullKey = prefix.isEmpty ? '$key' : '$prefix.$key';
    if (value is YamlMap) {
      keys.addAll(_flattenKeys(value, fullKey));
    } else {
      keys.add(fullKey);
    }
  });
  return keys;
}

void main() {
  group('i18n behaves correctly', () {
    test(
      'Every key in strings.i18n.yaml exists in strings_pt.i18n.yaml and vice versa',
      () {
        final YamlMap en =
            loadYaml(File('lib/i18n/strings.i18n.yaml').readAsStringSync())
                as YamlMap;
        final YamlMap pt =
            loadYaml(File('lib/i18n/strings_pt.i18n.yaml').readAsStringSync())
                as YamlMap;

        final Set<String> enKeys = _flattenKeys(en);
        final Set<String> ptKeys = _flattenKeys(pt);

        expect(
          enKeys.difference(ptKeys),
          isEmpty,
          reason:
              'Keys present in strings.i18n.yaml but missing from strings_pt.i18n.yaml',
        );
        expect(
          ptKeys.difference(enKeys),
          isEmpty,
          reason:
              'Keys present in strings_pt.i18n.yaml but missing from strings.i18n.yaml',
        );
      },
    );
  });
}
