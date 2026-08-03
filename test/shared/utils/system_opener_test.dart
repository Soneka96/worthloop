// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:worth_loop/shared/utils/logger_service.dart';
import 'package:worth_loop/shared/utils/system_opener.dart';

class MockDirectory extends Mock implements Directory {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockDirectory mockDirectory;
  late MockLoggerService mockLoggerService;

  setUp(() {
    mockDirectory = MockDirectory();
    mockLoggerService = MockLoggerService();
    when(() => mockDirectory.exists()).thenAnswer((_) async => true);
  });

  group('SystemOpener behaves correctly', () {
    test(
      'openFolder() runs explorer with the path when operatingSystem = windows',
      () async {
        String? calledExecutable;
        List<String>? calledArguments;
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'windows',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async {
            calledExecutable = executable;
            calledArguments = arguments;
            return ProcessResult(0, 0, '', '');
          },
        );

        await opener.openFolder(r'C:\App\logs');

        expect(calledExecutable, 'explorer');
        expect(calledArguments, [r'C:\App\logs']);
      },
    );

    test(
      'openFolder() runs open with the path when operatingSystem = macos',
      () async {
        String? calledExecutable;
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'macos',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async {
            calledExecutable = executable;
            return ProcessResult(0, 0, '', '');
          },
        );

        await opener.openFolder('/Users/me/App/logs');

        expect(calledExecutable, 'open');
      },
    );

    test(
      'openFolder() runs xdg-open with the path when operatingSystem = linux',
      () async {
        String? calledExecutable;
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'linux',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async {
            calledExecutable = executable;
            return ProcessResult(0, 0, '', '');
          },
        );

        await opener.openFolder('/home/me/App/logs');

        expect(calledExecutable, 'xdg-open');
      },
    );

    test('openFolder() creates the directory when it does not exist', () async {
      when(() => mockDirectory.exists()).thenAnswer((_) async => false);
      when(
        () => mockDirectory.create(recursive: true),
      ).thenAnswer((_) async => mockDirectory);
      final SystemOpener opener = SystemOpener(
        mockLoggerService,
        operatingSystem: 'windows',
        directoryFactory: (_) => mockDirectory,
        runProcess: (executable, arguments) async =>
            ProcessResult(0, 0, '', ''),
      );

      await opener.openFolder(r'C:\App\logs');

      verify(() => mockDirectory.exists()).called(1);
      verify(() => mockDirectory.create(recursive: true)).called(1);
      verifyNoMoreInteractions(mockDirectory);
    });

    test(
      'openFolder() does not create the directory when it already exists',
      () async {
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'windows',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async =>
              ProcessResult(0, 0, '', ''),
        );

        await opener.openFolder(r'C:\App\logs');

        verifyNever(() => mockDirectory.create(recursive: true));
      },
    );

    test(
      'openFolder() calls LoggerService.w() when a ProcessException is thrown',
      () async {
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'windows',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async {
            throw const ProcessException('explorer', []);
          },
        );

        await opener.openFolder(r'C:\App\logs');

        verify(
          () => mockLoggerService.w(
            'SystemOpener could not open folder: C:\\App\\logs',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );

    test(
      'openFolder() does not call LoggerService.w() when no exception is thrown',
      () async {
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'windows',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async =>
              ProcessResult(0, 0, '', ''),
        );

        await opener.openFolder(r'C:\App\logs');

        verifyNever(() => mockLoggerService.w(any()));
      },
    );

    test(
      'openFolder() calls LoggerService.w() when a FileSystemException is thrown',
      () async {
        when(() => mockDirectory.exists()).thenAnswer((_) async => false);
        when(
          () => mockDirectory.create(recursive: true),
        ).thenThrow(const FileSystemException('create failed'));
        final SystemOpener opener = SystemOpener(
          mockLoggerService,
          operatingSystem: 'windows',
          directoryFactory: (_) => mockDirectory,
          runProcess: (executable, arguments) async =>
              ProcessResult(0, 0, '', ''),
        );

        await opener.openFolder(r'C:\App\logs');

        verify(() => mockDirectory.exists()).called(1);
        verify(() => mockDirectory.create(recursive: true)).called(1);
        verifyNoMoreInteractions(mockDirectory);
        verify(
          () => mockLoggerService.w(
            'SystemOpener could not create folder: C:\\App\\logs',
          ),
        ).called(1);
        verifyNoMoreInteractions(mockLoggerService);
      },
    );
  });
}
