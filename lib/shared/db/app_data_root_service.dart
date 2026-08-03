// Package imports:
import 'package:file/file.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/injection_container.dart';
import 'package:worth_loop/shared/db/app_database.dart';
import 'package:worth_loop/shared/failures/failures.dart';
import 'package:worth_loop/shared/preferences/app_preferences_store.dart';
import 'package:worth_loop/shared/preferences/general_settings_snapshot.dart';
import 'package:worth_loop/shared/utils/logger_service.dart';

/// Resolves and relocates the folder holding [AppDatabase]'s sqlite file —
/// the app's data root — to a user-chosen location.
class AppDataRootService {
  final AppPreferencesStore _preferencesStore;
  final FileSystem _fileSystem;

  AppDataRootService(this._preferencesStore, this._fileSystem);

  /// Name of this app's own subfolder under the platform's documents
  /// directory. [resolveCurrentDataDirectory] never resolves to the
  /// documents directory itself — that folder holds the user's own
  /// unrelated files, and [applyPendingMoveIfNeeded] would try to move all
  /// of them alongside the app's data.
  static const String _defaultFolderName = 'Clean Architecture Starter';

  /// The folder [AppDatabase] currently reads its sqlite file from — the
  /// persisted [GeneralSettingsSnapshot.defaultSaveLocation] if one was set,
  /// otherwise [_defaultFolderName] under the platform's default documents
  /// directory, created now if it doesn't exist yet.
  Future<Directory> resolveCurrentDataDirectory() async {
    final GeneralSettingsSnapshot settings = await _preferencesStore
        .readGeneralSettings();
    final String? location = settings.defaultSaveLocation;
    if (location != null) {
      return _fileSystem.directory(location);
    }
    final String documentsPath =
        (await getApplicationDocumentsDirectory()).path;
    final Directory defaultDirectory = _fileSystem.directory(
      p.join(documentsPath, _defaultFolderName),
    );
    if (!await defaultDirectory.exists()) {
      await defaultDirectory.create(recursive: true);
    }
    return defaultDirectory;
  }

  /// Whether directory has no entries, or doesn't exist yet.
  Future<bool> isEmptyDirectory(Directory directory) async {
    if (!await directory.exists()) {
      return true;
    }
    return directory.list().isEmpty;
  }

  /// Validates path as a destination for the data root and, if valid,
  /// persists it as pending — the physical move happens on next launch via
  /// [applyPendingMoveIfNeeded]. Returns a [Left] with a [FileSystemFailure]
  /// if path isn't empty; a [Right] otherwise, including when path already is
  /// the current data directory — that case also clears any previously
  /// pending move, so re-selecting the current folder acts as a cancel.
  Future<Either<Failure, Unit>> requestMove(String path) async {
    final Directory current = await resolveCurrentDataDirectory();
    if (p.normalize(current.path) == p.normalize(path)) {
      await _preferencesStore.clearPendingDataRoot();
      return const Right(unit);
    }
    if (!await isEmptyDirectory(_fileSystem.directory(path))) {
      return Left(
        FileSystemFailure(
          t.settings.general.defaultSaveLocation.notEmptyFolder,
        ),
      );
    }
    await _preferencesStore.writePendingDataRoot(path);
    return const Right(unit);
  }

  /// Moves every file found anywhere under the current data directory —
  /// [AppDatabase.fileName], its journal/wal/shm sidecars, the `logs`
  /// subfolder, and anything else, at any nesting depth — to the folder
  /// requested via [requestMove], preserving each file's relative path, then
  /// updates [GeneralSettingsSnapshot.defaultSaveLocation] to point at it.
  /// No-op if nothing is pending. There's no per-file allowlist — the data
  /// root is this app's own exclusive folder, so anything found there belongs
  /// to it and moves with it. Once every file has moved, the subfolders left
  /// behind (now empty) are deleted too, best-effort — leaving one behind
  /// doesn't undo an otherwise-successful move.
  ///
  /// The per-file move is all-or-nothing: if any file can't be copied or
  /// deleted (most likely because another instance of the app still has it
  /// open), every file already moved earlier in this run is rolled back to
  /// its original location, [GeneralSettingsSnapshot.pendingDataRoot] is left
  /// set so the move retries on next launch, and
  /// [GeneralSettingsSnapshot.defaultSaveLocation] is left untouched —
  /// trusting the original files, since we can't know whether whatever's
  /// holding one of them open is still writing to it. Destination-creation
  /// failures are a different, unrecoverable case (a broken path, not a
  /// transient lock) and still clear the pending request. If the rollback
  /// itself also fails, the original failure is still returned regardless —
  /// there's nothing more to safely automate at that point.
  Future<Either<Failure, Unit>> applyPendingMoveIfNeeded() async {
    final String? pending = await _preferencesStore.readPendingDataRoot();
    if (pending == null) {
      return const Right(unit);
    }
    try {
      final Directory current = await resolveCurrentDataDirectory();
      final Directory destination = _fileSystem.directory(pending);
      if (!await destination.exists()) {
        await destination.create(recursive: true);
      }

      final List<FileSystemEntity> currentEntries = await current
          .list(recursive: true)
          .toList();
      final List<File> sourceFiles = currentEntries.whereType<File>().toList();
      final List<(File source, String destinationPath)> filesToMove = [
        for (final file in sourceFiles)
          (
            file,
            p.join(destination.path, p.relative(file.path, from: current.path)),
          ),
      ];

      final List<(File source, String destinationPath)> movedFiles = [];
      for (final (source, destinationPath) in filesToMove) {
        final File copiedFile = _fileSystem.file(destinationPath);
        try {
          final Directory copiedFileParent = _fileSystem.directory(
            p.dirname(destinationPath),
          );
          if (!await copiedFileParent.exists()) {
            await copiedFileParent.create(recursive: true);
          }
          await source.copy(copiedFile.path);
          await _deleteWithRetry(source);
          movedFiles.add((source, destinationPath));
        } on FileSystemException catch (e) {
          try {
            if (await copiedFile.exists()) {
              await copiedFile.delete();
            }
            for (final (movedSource, movedDestinationPath) in movedFiles) {
              final File itsCopy = _fileSystem.file(movedDestinationPath);
              await itsCopy.copy(movedSource.path);
              await itsCopy.delete();
            }
          } on FileSystemException {
            // The outer catch below logs and returns the original failure
            // regardless — nothing more to safely automate here.
          }
          sl<LoggerService>().e(e.toString());
          return Left(FileSystemFailure(e.toString()));
        }
      }

      await _deleteEmptiedDirectories(currentEntries);
      await _preferencesStore.writeDefaultSaveLocation(pending);
      await _preferencesStore.clearPendingDataRoot();
      return const Right(unit);
    } on FileSystemException catch (e) {
      sl<LoggerService>().e(e.toString());
      await _preferencesStore.clearPendingDataRoot();
      return Left(FileSystemFailure(e.toString()));
    }
  }

  /// Deletes every subdirectory in [entries], deepest first, so a child
  /// folder is gone before its parent is deleted. Best-effort: every file
  /// has already moved successfully by the time this runs, so a folder that
  /// can't be deleted (still holding something unexpected) is just logged
  /// and left behind rather than failing the move that already succeeded.
  Future<void> _deleteEmptiedDirectories(List<FileSystemEntity> entries) async {
    final List<Directory> directories = entries.whereType<Directory>().toList()
      ..sort((a, b) => b.path.length.compareTo(a.path.length));
    for (final Directory directory in directories) {
      try {
        await directory.delete();
      } on FileSystemException {
        sl<LoggerService>().w(
          'AppDataRootService could not delete emptied folder: '
          '${directory.path}',
        );
      }
    }
  }

  /// Deletes file, retrying twice more (~150ms apart) on
  /// [FileSystemException] before giving up — covers Windows briefly
  /// lagging in releasing a handle a just-exited process held, distinct
  /// from a genuinely still-running process holding it open.
  Future<void> _deleteWithRetry(File file) async {
    for (int attempt = 0; ; attempt++) {
      try {
        await file.delete();
        return;
      } on FileSystemException {
        if (attempt == 2) rethrow;
        await Future<void>.delayed(const Duration(milliseconds: 150));
      }
    }
  }
}
