// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:worth_loop/features/products/presentation/state/products.actions.dart';
import 'package:worth_loop/features/settings/presentation/state/general_settings.actions.dart';
import 'package:worth_loop/shared/state/app.reducer.dart';
import 'package:worth_loop/shared/state/app.state.dart';

void main() {

  group('AppReducer processes LoadProductsAction correctly', () {
    test('appReducer delegates LoadProductsAction to the feature reducer', () {
      final AppState state = AppState.initial();

      final AppState reducedState = appReducer(
        state,
        const LoadProductsAction(),
      );

      expect(state.products.isLoading, isA<bool>());
      expect(state.products.isLoading, isFalse, reason: 'previous value');
      expect(reducedState.products.isLoading, isA<bool>());
      expect(reducedState.products.isLoading, isTrue, reason: 'new value');
      expect(
        reducedState.refreshSettings,
        state.refreshSettings,
        reason: 'refresh settings state is preserved',
      );
    });
  });

  group('AppReducer processes LoadRefreshSettingsAction correctly', () {
    test(
      'appReducer delegates LoadRefreshSettingsAction to the feature reducer',
      () {
        final AppState state = AppState.initial();

        final AppState reducedState = appReducer(
          state,
          const LoadRefreshSettingsAction(),
        );

        expect(state.refreshSettings.isLoading, isA<bool>());
        expect(
          state.refreshSettings.isLoading,
          isFalse,
          reason: 'previous value',
        );
        expect(reducedState.refreshSettings.isLoading, isA<bool>());
        expect(
          reducedState.refreshSettings.isLoading,
          isTrue,
          reason: 'new value',
        );
        expect(
          reducedState.products,
          state.products,
          reason: 'product state is preserved',
        );
      },
    );
  });
}
