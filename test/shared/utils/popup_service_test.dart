// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/constants/enums.dart';
import 'package:worth_loop/shared/constants/layout_constants.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_config.dart';
import 'package:worth_loop/shared/snugtoast/snugtoast_manager.dart';
import 'package:worth_loop/shared/theme/app_font.dart';
import 'package:worth_loop/shared/theme/app_font_presets.dart';
import 'package:worth_loop/shared/theme/app_shape.dart';
import 'package:worth_loop/shared/theme/app_theme.dart';
import 'package:worth_loop/shared/utils/popup_service.dart';

class MockSnugToastManager extends Mock implements SnugToastManager {}

class MockAppTheme extends Mock implements AppTheme {}

class MockAppShape extends Mock implements AppShape {}

class MockAppFont extends Mock implements AppFont {}

void main() {
  late MockSnugToastManager mockManager;
  late MockAppTheme mockAppTheme;
  late MockAppShape mockAppShape;
  late MockAppFont mockAppFont;

  const ColorScheme colorScheme = ColorScheme.dark();
  const double cornerRadius = 12;
  const FontId fontId = FontId.jetBrainsMono;

  setUp(() {
    mockAppTheme = MockAppTheme();
    when(() => mockAppTheme.colorScheme).thenReturn(colorScheme);
    sl.registerLazySingleton<AppTheme>(() => mockAppTheme);

    mockAppShape = MockAppShape();
    when(() => mockAppShape.cornerRadius).thenReturn(cornerRadius);
    sl.registerLazySingleton<AppShape>(() => mockAppShape);

    mockAppFont = MockAppFont();
    when(() => mockAppFont.fontId).thenReturn(fontId);
    sl.registerLazySingleton<AppFont>(() => mockAppFont);

    mockManager = MockSnugToastManager();
    sl.registerLazySingleton<SnugToastManager>(() => mockManager);
  });
  tearDown(() => sl.reset());

  SnugToastConfig buildExpectedConfig(WidgetLocation location) {
    return SnugToastConfig(
      message: 'Not yet implemented',
      alignment: location.alignment,
      duration: const Duration(seconds: 4),
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurface,
      fontFamily: fontFamilyPresets[fontId],
      borderColor: colorScheme.outline,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
      cornerRadius: cornerRadius,
      maxWidth: PopupSizes.snackBarMaxWidth,
      maxLines: PopupSizes.snackBarMaxLines,
      textAlign: TextAlign.center,
    );
  }

  group('PopupService behaves correctly', () {
    test('Method show() calls SnugToastManager.show() with the correct '
        'SnugToastConfig when location is not given', () {
      final PopupService popupService = PopupService();

      popupService.show('Not yet implemented');

      verify(
        () =>
            mockManager.show(buildExpectedConfig(WidgetLocation.bottomCenter)),
      ).called(1);
      verifyNoMoreInteractions(mockManager);
    });

    test('Method show() calls SnugToastManager.show() with the correct '
        'SnugToastConfig when location = WidgetLocation.topRight', () {
      final PopupService popupService = PopupService();

      popupService.show(
        'Not yet implemented',
        location: WidgetLocation.topRight,
      );

      verify(
        () => mockManager.show(buildExpectedConfig(WidgetLocation.topRight)),
      ).called(1);
      verifyNoMoreInteractions(mockManager);
    });
  });
}
