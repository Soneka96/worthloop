// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/shared/window/home_window_size_service.dart';

void main() {
  group('HomeWindowSizeService behaves correctly', () {
    test('homeSize returns shippedDefault', () {
      final HomeWindowSizeService service = HomeWindowSizeService();

      expect(service.homeSize, HomeWindowSizeService.shippedDefault);
    });

    test('shippedDefault preserves the 560:420 aspect ratio', () {
      expect(
        HomeWindowSizeService.shippedDefault.width /
            HomeWindowSizeService.shippedDefault.height,
        closeTo(560 / 420, 0.001),
      );
    });
  });
}
