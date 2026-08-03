// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/home/home.injection_container.dart';
import 'package:worth_loop/features/home/presentation/state/viewmodels/home_screen.viewmodel.dart';
import 'package:worth_loop/injection_container.dart';

void main() {
  setUp(() {
    initHomeDependencies();
  });

  tearDown(() async => sl.reset());

  group('home.injection_container — home feature registrations', () {
    test('viewmodels are registered', () {
      expect(
        sl.isRegistered<HomeScreenViewModel>(),
        isTrue,
        reason: 'HomeScreenViewModel should be registered',
      );
    });
  });
}
