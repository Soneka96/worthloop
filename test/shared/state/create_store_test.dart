// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/shared/state/app.state.dart';
import 'package:worth_loop/shared/state/create_store.dart';

void main() {
  group('CreateStore behaves correctly', () {
    late Store<AppState> store;

    setUp(() {
      store = CreateStore()();
    });

    test('CreateStore returns a Store with the initial AppState', () {
      expect(store.state, AppState.initial());
    });
  });
}
