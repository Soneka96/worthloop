// Package imports:
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

// Project imports:
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_data_root_service.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/preferences/general_settings_snapshot.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

class MockAppPreferencesStore extends Mock implements AppPreferencesStore {}

class MockFileSystem extends Mock implements FileSystem {}

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

class MockLoggerService extends Mock implements LoggerService {}

class FakePathProviderPlatform extends PathProviderPlatform {
  FakePathProviderPlatform(this.documentsPath);

  final String documentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String documentsPath = r'C:\Documents';
  final String defaultDataPath = p.join(
    documentsPath,
    'Clean Architecture Starter',
  );

  late MockAppPreferencesStore preferencesStore;
  late MockFileSystem fileSystem;
  late MockLoggerService mockLoggerService;
  late AppDataRootService service;

  MockFile mockFile(String path) {
    final MockFile file = MockFile();
    when(() => file.path).thenReturn(path);
    return file;
  }

  MockDirectory mockDirectory(String path) {
    final MockDirectory directory = MockDirectory();
    when(() => directory.path).thenReturn(path);
    return directory;
  }

  /// Stubs [AppPreferencesStore.readGeneralSettings] and [FileSystem.directory]
  /// so [AppDataRootService.resolveCurrentDataDirectory] resolves to the
  /// given directory — a null defaultSaveLocation falls back to this app's
  /// dedicated subfolder under the (faked) platform documents path, which is
  /// stubbed as already existing.
  void stubCurrentDirectory(
    MockDirectory directory, {
    String? defaultSaveLocation,
  }) {
    when(() => preferencesStore.readGeneralSettings()).thenAnswer(
      (_) async => GeneralSettingsSnapshot(
        defaultSaveLocation: defaultSaveLocation,
        pendingDataRoot: null,
      ),
    );
    when(
      () => fileSystem.directory(defaultSaveLocation ?? defaultDataPath),
    ).thenReturn(directory);
    if (defaultSaveLocation == null) {
      when(() => directory.exists()).thenAnswer((_) async => true);
    }
  }

  setUp(() {
    preferencesStore = MockAppPreferencesStore();
    fileSystem = MockFileSystem();
    mockLoggerService = MockLoggerService();
    sl.registerLazySingleton<LoggerService>(() => mockLoggerService);
    PathProviderPlatform.instance = FakePathProviderPlatform(documentsPath);
    service = AppDataRootService(preferencesStore, fileSystem);
  });

  tearDown(() => sl.reset());

  group('AppDataRootService behaves correctly', () {
    test(
      'Method resolveCurrentDataDirectory() returns this app\'s dedicated subfolder under the platform documents directory when no defaultSaveLocation was persisted',
      () async {
        final MockDirectory expected = mockDirectory(defaultDataPath);
        stubCurrentDirectory(expected);

        final Directory result = await service.resolveCurrentDataDirectory();

        expect(result, isA<Directory>());
        expect(result, same(expected));
      },
    );

    test(
      'Method resolveCurrentDataDirectory() creates the dedicated subfolder when it does not exist yet, e.g. on a fresh install',
      () async {
        final MockDirectory expected = mockDirectory(defaultDataPath);
        when(() => preferencesStore.readGeneralSettings()).thenAnswer(
          (_) async => const GeneralSettingsSnapshot(
            defaultSaveLocation: null,
            pendingDataRoot: null,
          ),
        );
        when(
          () => fileSystem.directory(defaultDataPath),
        ).thenReturn(expected);
        when(() => expected.exists()).thenAnswer((_) async => false);
        when(
          () => expected.create(recursive: true),
        ).thenAnswer((_) async => expected);

        final Directory result = await service.resolveCurrentDataDirectory();

        expect(result, same(expected));
        verify(() => expected.create(recursive: true)).called(1);
      },
    );

    test(
      'Method resolveCurrentDataDirectory() returns the persisted defaultSaveLocation when one was written',
      () async {
        final MockDirectory expected = mockDirectory(r'C:\Custom Root');
        stubCurrentDirectory(expected, defaultSaveLocation: r'C:\Custom Root');

        final Directory result = await service.resolveCurrentDataDirectory();

        expect(result, isA<Directory>());
        expect(result, same(expected));
      },
    );

    test(
      'Method isEmptyDirectory() returns true when the directory does not exist yet',
      () async {
        final MockDirectory directory = mockDirectory(r'C:\Missing');
        when(() => directory.exists()).thenAnswer((_) async => false);

        final bool result = await service.isEmptyDirectory(directory);

        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );

    test(
      'Method isEmptyDirectory() returns true when the directory exists with zero entries',
      () async {
        final MockDirectory directory = mockDirectory(documentsPath);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(
          () => directory.list(),
        ).thenAnswer((_) => const Stream<FileSystemEntity>.empty());

        final bool result = await service.isEmptyDirectory(directory);

        expect(result, isA<bool>());
        expect(result, isTrue);
      },
    );

    test(
      'Method isEmptyDirectory() returns false when the directory contains a file',
      () async {
        final MockDirectory directory = mockDirectory(documentsPath);
        when(() => directory.exists()).thenAnswer((_) async => true);
        when(() => directory.list()).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([
            mockFile(r'C:\Documents\existing.txt'),
          ]),
        );

        final bool result = await service.isEmptyDirectory(directory);

        expect(result, isA<bool>());
        expect(result, isFalse);
      },
    );

    test(
      'Method requestMove() clears pendingDataRoot and returns Right(unit) without persisting when path already equals the current data directory',
      () async {
        stubCurrentDirectory(
          mockDirectory(r'C:\Current'),
          defaultSaveLocation: r'C:\Current',
        );
        when(
          () => preferencesStore.clearPendingDataRoot(),
        ).thenAnswer((_) async {});

        final Either<Failure, Unit> result = await service.requestMove(
          r'C:\Current',
        );

        expect(result.isRight(), isTrue);
        verify(() => preferencesStore.clearPendingDataRoot()).called(1);
        verifyNever(() => preferencesStore.writePendingDataRoot(any()));
      },
    );

    test(
      'Method requestMove() returns Left(FileSystemFailure) when path is not empty',
      () async {
        stubCurrentDirectory(
          mockDirectory(r'C:\Current'),
          defaultSaveLocation: r'C:\Current',
        );
        final MockDirectory destination = mockDirectory(r'C:\NotEmpty');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(() => destination.list()).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([
            mockFile(r'C:\NotEmpty\existing.txt'),
          ]),
        );
        when(
          () => fileSystem.directory(r'C:\NotEmpty'),
        ).thenReturn(destination);

        final Either<Failure, Unit> result = await service.requestMove(
          r'C:\NotEmpty',
        );

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<FileSystemFailure>()),
          (_) => fail('expected Left, got Right'),
        );
        verifyNever(() => preferencesStore.writePendingDataRoot(any()));
        verifyNever(() => preferencesStore.clearPendingDataRoot());
      },
    );

    test(
      'Method requestMove() persists path as pendingDataRoot and returns Right(unit) when path is empty and different from the current data directory',
      () async {
        stubCurrentDirectory(
          mockDirectory(r'C:\Current'),
          defaultSaveLocation: r'C:\Current',
        );
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => false);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);
        when(
          () => preferencesStore.writePendingDataRoot(any()),
        ).thenAnswer((_) async {});

        final Either<Failure, Unit> result = await service.requestMove(
          r'C:\Destination',
        );

        expect(result.isRight(), isTrue);
        verify(
          () => preferencesStore.writePendingDataRoot(r'C:\Destination'),
        ).called(1);
        verifyNever(() => preferencesStore.clearPendingDataRoot());
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() returns Right(unit) without touching any file when nothing is pending',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => null);

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isRight(), isTrue);
        verifyNever(() => fileSystem.directory(any()));
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() moves every file from the current data directory to the pending one',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        final MockFile dbFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}',
        );
        when(
          () => current.list(recursive: true),
        ).thenAnswer((_) => Stream<FileSystemEntity>.fromIterable([dbFile]));
        const String copiedDbPath = 'C:\\Destination\\${AppDatabase.fileName}';
        final MockFile copiedDbFile = mockFile(copiedDbPath);
        when(() => fileSystem.file(copiedDbPath)).thenReturn(copiedDbFile);
        when(
          () => dbFile.copy(copiedDbPath),
        ).thenAnswer((_) async => copiedDbFile);
        when(() => dbFile.delete()).thenAnswer((_) async => dbFile);
        when(
          () => preferencesStore.writeDefaultSaveLocation(any()),
        ).thenAnswer((_) async {});
        when(
          () => preferencesStore.clearPendingDataRoot(),
        ).thenAnswer((_) async {});

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isRight(), isTrue);
        verify(() => dbFile.copy(copiedDbPath)).called(1);
        verify(() => dbFile.delete()).called(1);
        verify(
          () => preferencesStore.writeDefaultSaveLocation(r'C:\Destination'),
        ).called(1);
        verify(() => preferencesStore.clearPendingDataRoot()).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() moves a file nested inside a subfolder, preserving its relative path and creating the destination subfolder',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        final MockFile logFile = mockFile(r'C:\Current\logs\app.log');
        final MockDirectory sourceLogsFolder = mockDirectory(
          r'C:\Current\logs',
        );
        when(
          () => sourceLogsFolder.delete(),
        ).thenAnswer((_) async => sourceLogsFolder);
        when(() => current.list(recursive: true)).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([
            logFile,
            sourceLogsFolder,
          ]),
        );

        const String copiedLogPath = r'C:\Destination\logs\app.log';
        final MockFile copiedLogFile = mockFile(copiedLogPath);
        when(() => fileSystem.file(copiedLogPath)).thenReturn(copiedLogFile);

        final MockDirectory destinationLogsFolder = mockDirectory(
          r'C:\Destination\logs',
        );
        when(
          () => destinationLogsFolder.exists(),
        ).thenAnswer((_) async => false);
        when(
          () => destinationLogsFolder.create(recursive: true),
        ).thenAnswer((_) async => destinationLogsFolder);
        when(
          () => fileSystem.directory(r'C:\Destination\logs'),
        ).thenReturn(destinationLogsFolder);

        when(
          () => logFile.copy(copiedLogPath),
        ).thenAnswer((_) async => copiedLogFile);
        when(() => logFile.delete()).thenAnswer((_) async => logFile);
        when(
          () => preferencesStore.writeDefaultSaveLocation(any()),
        ).thenAnswer((_) async {});
        when(
          () => preferencesStore.clearPendingDataRoot(),
        ).thenAnswer((_) async {});

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isRight(), isTrue);
        verify(() => destinationLogsFolder.create(recursive: true)).called(1);
        verify(() => logFile.copy(copiedLogPath)).called(1);
        verify(() => logFile.delete()).called(1);
        verify(() => sourceLogsFolder.delete()).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() logs a warning and still returns Right(unit) when an emptied folder cannot be deleted',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        final MockFile logFile = mockFile(r'C:\Current\logs\app.log');
        final MockDirectory sourceLogsFolder = mockDirectory(
          r'C:\Current\logs',
        );
        when(
          () => sourceLogsFolder.delete(),
        ).thenThrow(const FileSystemException('folder still in use'));
        when(() => current.list(recursive: true)).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([
            logFile,
            sourceLogsFolder,
          ]),
        );

        const String copiedLogPath = r'C:\Destination\logs\app.log';
        final MockFile copiedLogFile = mockFile(copiedLogPath);
        when(() => fileSystem.file(copiedLogPath)).thenReturn(copiedLogFile);

        final MockDirectory destinationLogsFolder = mockDirectory(
          r'C:\Destination\logs',
        );
        when(
          () => destinationLogsFolder.exists(),
        ).thenAnswer((_) async => false);
        when(
          () => destinationLogsFolder.create(recursive: true),
        ).thenAnswer((_) async => destinationLogsFolder);
        when(
          () => fileSystem.directory(r'C:\Destination\logs'),
        ).thenReturn(destinationLogsFolder);

        when(
          () => logFile.copy(copiedLogPath),
        ).thenAnswer((_) async => copiedLogFile);
        when(() => logFile.delete()).thenAnswer((_) async => logFile);
        when(
          () => preferencesStore.writeDefaultSaveLocation(any()),
        ).thenAnswer((_) async {});
        when(
          () => preferencesStore.clearPendingDataRoot(),
        ).thenAnswer((_) async {});

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isRight(), isTrue);
        verify(() => sourceLogsFolder.delete()).called(1);
        verify(() => mockLoggerService.w(any())).called(1);
        verify(
          () => preferencesStore.writeDefaultSaveLocation(r'C:\Destination'),
        ).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() moves a stray -wal sidecar file alongside AppDatabase.fileName',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        final MockFile dbFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}',
        );
        final MockFile walFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}-wal',
        );
        when(() => current.list(recursive: true)).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([dbFile, walFile]),
        );

        const String copiedDbPath = 'C:\\Destination\\${AppDatabase.fileName}';
        final MockFile copiedDbFile = mockFile(copiedDbPath);
        when(() => fileSystem.file(copiedDbPath)).thenReturn(copiedDbFile);
        when(
          () => dbFile.copy(copiedDbPath),
        ).thenAnswer((_) async => copiedDbFile);
        when(() => dbFile.delete()).thenAnswer((_) async => dbFile);

        const String copiedWalPath =
            'C:\\Destination\\${AppDatabase.fileName}-wal';
        final MockFile copiedWalFile = mockFile(copiedWalPath);
        when(() => fileSystem.file(copiedWalPath)).thenReturn(copiedWalFile);
        when(
          () => walFile.copy(copiedWalPath),
        ).thenAnswer((_) async => copiedWalFile);
        when(() => walFile.delete()).thenAnswer((_) async => walFile);

        when(
          () => preferencesStore.writeDefaultSaveLocation(any()),
        ).thenAnswer((_) async {});
        when(
          () => preferencesStore.clearPendingDataRoot(),
        ).thenAnswer((_) async {});

        await service.applyPendingMoveIfNeeded();

        verify(() => walFile.copy(copiedWalPath)).called(1);
        verify(() => walFile.delete()).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() returns Left(FileSystemFailure) and clears the pending root when the destination cannot be created',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Blocked');
        stubCurrentDirectory(
          mockDirectory(r'C:\Current'),
          defaultSaveLocation: r'C:\Current',
        );
        final MockDirectory destination = mockDirectory(r'C:\Blocked');
        when(() => destination.exists()).thenAnswer((_) async => false);
        when(
          () => destination.create(recursive: true),
        ).thenThrow(const FileSystemException('destination path is a file'));
        when(() => fileSystem.directory(r'C:\Blocked')).thenReturn(destination);
        when(
          () => preferencesStore.clearPendingDataRoot(),
        ).thenAnswer((_) async {});

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<FileSystemFailure>()),
          (_) => fail('expected Left, got Right'),
        );
        verifyNever(() => preferencesStore.writeDefaultSaveLocation(any()));
        verify(() => preferencesStore.clearPendingDataRoot()).called(1);
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() rolls back the partial copy and keeps the pending root when a file cannot be deleted',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        final MockFile dbFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}',
        );
        when(
          () => current.list(recursive: true),
        ).thenAnswer((_) => Stream<FileSystemEntity>.fromIterable([dbFile]));
        const String copiedDbPath = 'C:\\Destination\\${AppDatabase.fileName}';
        final MockFile copiedDbFile = mockFile(copiedDbPath);
        when(() => fileSystem.file(copiedDbPath)).thenReturn(copiedDbFile);
        when(
          () => dbFile.copy(copiedDbPath),
        ).thenAnswer((_) async => copiedDbFile);
        when(
          () => dbFile.delete(),
        ).thenThrow(const FileSystemException('being used by another process'));
        when(() => copiedDbFile.exists()).thenAnswer((_) async => true);
        when(() => copiedDbFile.delete()).thenAnswer((_) async => copiedDbFile);

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isLeft(), isTrue);
        result.match(
          (failure) => expect(failure, isA<FileSystemFailure>()),
          (_) => fail('expected Left, got Right'),
        );
        verify(() => dbFile.delete()).called(3);
        verify(() => copiedDbFile.delete()).called(1);
        verifyNever(() => preferencesStore.clearPendingDataRoot());
        verifyNever(() => preferencesStore.writeDefaultSaveLocation(any()));
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() rolls back every already-moved file when a later file cannot be deleted',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        const String dbSourcePath = 'C:\\Current\\${AppDatabase.fileName}';
        final MockFile dbFile = mockFile(dbSourcePath);
        final MockFile walFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}-wal',
        );
        when(() => current.list(recursive: true)).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([dbFile, walFile]),
        );

        const String copiedDbPath = 'C:\\Destination\\${AppDatabase.fileName}';
        final MockFile copiedDbFile = mockFile(copiedDbPath);
        when(() => fileSystem.file(copiedDbPath)).thenReturn(copiedDbFile);
        when(
          () => dbFile.copy(copiedDbPath),
        ).thenAnswer((_) async => copiedDbFile);
        when(() => dbFile.delete()).thenAnswer((_) async => dbFile);
        when(
          () => copiedDbFile.copy(dbSourcePath),
        ).thenAnswer((_) async => dbFile);
        when(() => copiedDbFile.delete()).thenAnswer((_) async => copiedDbFile);

        const String copiedWalPath =
            'C:\\Destination\\${AppDatabase.fileName}-wal';
        final MockFile copiedWalFile = mockFile(copiedWalPath);
        when(() => fileSystem.file(copiedWalPath)).thenReturn(copiedWalFile);
        when(
          () => walFile.copy(copiedWalPath),
        ).thenAnswer((_) async => copiedWalFile);
        when(
          () => walFile.delete(),
        ).thenThrow(const FileSystemException('being used by another process'));
        when(() => copiedWalFile.exists()).thenAnswer((_) async => true);
        when(
          () => copiedWalFile.delete(),
        ).thenAnswer((_) async => copiedWalFile);

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isLeft(), isTrue);
        verify(() => copiedDbFile.copy(dbSourcePath)).called(1);
        verify(() => copiedDbFile.delete()).called(1);
        verify(() => copiedWalFile.delete()).called(1);
        verifyNever(() => preferencesStore.clearPendingDataRoot());
        verifyNever(() => preferencesStore.writeDefaultSaveLocation(any()));
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );

    test(
      'Method applyPendingMoveIfNeeded() never touches a file listed after the one that fails',
      () async {
        when(
          () => preferencesStore.readPendingDataRoot(),
        ).thenAnswer((_) async => r'C:\Destination');
        final MockDirectory current = mockDirectory(r'C:\Current');
        stubCurrentDirectory(current, defaultSaveLocation: r'C:\Current');
        final MockDirectory destination = mockDirectory(r'C:\Destination');
        when(() => destination.exists()).thenAnswer((_) async => true);
        when(
          () => fileSystem.directory(r'C:\Destination'),
        ).thenReturn(destination);

        final MockFile walFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}-wal',
        );
        final MockFile shmFile = mockFile(
          'C:\\Current\\${AppDatabase.fileName}-shm',
        );
        when(() => current.list(recursive: true)).thenAnswer(
          (_) => Stream<FileSystemEntity>.fromIterable([walFile, shmFile]),
        );

        const String copiedWalPath =
            'C:\\Destination\\${AppDatabase.fileName}-wal';
        final MockFile copiedWalFile = mockFile(copiedWalPath);
        when(() => fileSystem.file(copiedWalPath)).thenReturn(copiedWalFile);
        when(
          () => walFile.copy(copiedWalPath),
        ).thenAnswer((_) async => copiedWalFile);
        when(
          () => walFile.delete(),
        ).thenThrow(const FileSystemException('being used by another process'));
        when(() => copiedWalFile.exists()).thenAnswer((_) async => true);
        when(
          () => copiedWalFile.delete(),
        ).thenAnswer((_) async => copiedWalFile);

        final Either<Failure, Unit> result = await service
            .applyPendingMoveIfNeeded();

        expect(result.isLeft(), isTrue);
        verifyNever(() => shmFile.copy(any()));
        verifyNever(() => shmFile.delete());
        verify(() => mockLoggerService.e(any())).called(1);
      },
    );
  });
}
