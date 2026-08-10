// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:worth_loop/features/settings/data/datasources/refresh_settings_local.datasource.dart';
import 'package:worth_loop/features/settings/domain/repositories/Irefresh_settings.repository.dart';
import 'package:worth_loop/features/settings/domain/usecases/load_refresh_settings.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_browser_refresh_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_drop_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_price_increase_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_completed_alerts_enabled.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_refresh_interval.usecase.dart';
import 'package:worth_loop/features/settings/domain/usecases/save_show_refresh_progress.usecase.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/general_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/presentation/state/viewmodels/notifications_settings_screen.viewmodel.dart';
import 'package:worth_loop/features/settings/settings.injection_container.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/state/app.state.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  setUp(() {
    sl.registerSingleton<AppDatabase>(MockAppDatabase());
    initSettingsDependencies();
  });

  tearDown(() async => sl.reset());

  group('settings.injection_container — settings feature registrations', () {
    test('datasource, repository, and usecases are registered', () {
      expect(sl.isRegistered<RefreshSettingsLocalDatasource>(), isA<bool>());
      expect(sl.isRegistered<RefreshSettingsLocalDatasource>(), isTrue);
      expect(sl.isRegistered<IRefreshSettingsRepository>(), isA<bool>());
      expect(sl.isRegistered<IRefreshSettingsRepository>(), isTrue);
      expect(sl.isRegistered<LoadRefreshSettingsUseCase>(), isA<bool>());
      expect(sl.isRegistered<LoadRefreshSettingsUseCase>(), isTrue);
      expect(sl.isRegistered<SaveRefreshIntervalUseCase>(), isA<bool>());
      expect(sl.isRegistered<SaveRefreshIntervalUseCase>(), isTrue);
      expect(sl.isRegistered<SaveBrowserRefreshEnabledUseCase>(), isA<bool>());
      expect(sl.isRegistered<SaveBrowserRefreshEnabledUseCase>(), isTrue);
      expect(sl.isRegistered<SavePriceDropAlertsEnabledUseCase>(), isA<bool>());
      expect(sl.isRegistered<SavePriceDropAlertsEnabledUseCase>(), isTrue);
      expect(
        sl.isRegistered<SavePriceIncreaseAlertsEnabledUseCase>(),
        isA<bool>(),
      );
      expect(sl.isRegistered<SavePriceIncreaseAlertsEnabledUseCase>(), isTrue);
      expect(
        sl.isRegistered<SaveRefreshCompletedAlertsEnabledUseCase>(),
        isA<bool>(),
      );
      expect(
        sl.isRegistered<SaveRefreshCompletedAlertsEnabledUseCase>(),
        isTrue,
      );
      expect(sl.isRegistered<SaveShowRefreshProgressUseCase>(), isA<bool>());
      expect(sl.isRegistered<SaveShowRefreshProgressUseCase>(), isTrue);
      expect(
        sl<RefreshSettingsLocalDatasource>(),
        isA<RefreshSettingsLocalDatasource>(),
      );
      expect(
        sl<IRefreshSettingsRepository>(),
        isA<IRefreshSettingsRepository>(),
      );
      expect(
        sl<LoadRefreshSettingsUseCase>(),
        isA<LoadRefreshSettingsUseCase>(),
      );
      expect(
        sl<SaveRefreshIntervalUseCase>(),
        isA<SaveRefreshIntervalUseCase>(),
      );
      expect(
        sl<SaveBrowserRefreshEnabledUseCase>(),
        isA<SaveBrowserRefreshEnabledUseCase>(),
      );
      expect(
        sl<SavePriceDropAlertsEnabledUseCase>(),
        isA<SavePriceDropAlertsEnabledUseCase>(),
      );
      expect(
        sl<SavePriceIncreaseAlertsEnabledUseCase>(),
        isA<SavePriceIncreaseAlertsEnabledUseCase>(),
      );
      expect(
        sl<SaveRefreshCompletedAlertsEnabledUseCase>(),
        isA<SaveRefreshCompletedAlertsEnabledUseCase>(),
      );
      expect(
        sl<SaveShowRefreshProgressUseCase>(),
        isA<SaveShowRefreshProgressUseCase>(),
      );
    });

    test('viewmodel is registered', () {
      final Store<AppState> store = Store<AppState>(
        (AppState state, dynamic action) => state,
        initialState: AppState.initial(),
      );

      expect(sl.isRegistered<GeneralSettingsScreenViewModel>(), isA<bool>());
      expect(sl.isRegistered<GeneralSettingsScreenViewModel>(), isTrue);
      expect(
        sl<GeneralSettingsScreenViewModel>(param1: store),
        isA<GeneralSettingsScreenViewModel>(),
      );
      expect(
        sl.isRegistered<NotificationsSettingsScreenViewModel>(),
        isA<bool>(),
      );
      expect(sl.isRegistered<NotificationsSettingsScreenViewModel>(), isTrue);
      expect(
        sl<NotificationsSettingsScreenViewModel>(param1: store),
        isA<NotificationsSettingsScreenViewModel>(),
      );
    });
  });
}
