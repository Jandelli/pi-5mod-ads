import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flow/api/storage/db/database.dart';
import 'package:flow/api/storage/remote/model.dart';
import 'package:flow/api/storage/remote/service.dart';
import 'package:flow/cubits/settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flow_api/services/database.dart';
import 'package:flow_api/services/source.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../directory.dart';

class SourcesService extends ChangeNotifier {
  final SettingsCubit settingsCubit;
  late final DatabaseService local;
  final List<RemoteService> remotes = [];
  // Add a list to track additional local databases
  final List<DatabaseService> localDatabases = [];
  // Add a list to track custom names for imported databases
  final List<String> localDatabaseNames = [];
  final BehaviorSubject<SyncStatus> syncStatus =
      BehaviorSubject.seeded(SyncStatus.synced);
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  SourcesService(this.settingsCubit);

  Future<bool> shouldSync() async {
    final mode = settingsCubit.state.syncMode;
    if (mode == SyncMode.manual) {
      return false;
    }
    if (mode == SyncMode.always) {
      return true;
    }
    return !(await Connectivity().checkConnectivity())
        .contains(ConnectivityResult.mobile);
  }

  Future<void> setup() async {
    local = DatabaseService(openDatabase);
    await local.setup('local');
    remotes.clear();
    for (var storage in settingsCubit.state.remotes) {
      await _connectRemote(storage,
          await secureStorage.read(key: 'remote ${storage.toFilename()}'));
    }

    // Load existing imported databases
    await _loadExistingImportedDatabases();

    synchronize();
  }

  /// Scans the Flow directory for imported database files and loads them
  Future<void> _loadExistingImportedDatabases() async {
    try {
      final flowDirectory = await getFlowDirectory();
      final directory = Directory(flowDirectory);

      if (await directory.exists()) {
        final files = await directory.list().toList();

        // Clear existing imported databases
        localDatabases.clear();
        localDatabaseNames.clear();

        for (final file in files) {
          if (file is File && file.path.endsWith('.db')) {
            final fileName = file.path.split(Platform.pathSeparator).last;
            final dbName = fileName.replaceAll('.db', '');

            // Skip the main local database
            if (dbName == 'local') continue;

            // Only load imported databases (those that start with 'imported_')
            if (dbName.startsWith('imported_')) {
              try {
                // Create a new DatabaseService for this imported database
                final importedDb = DatabaseService(openDatabase);
                await importedDb.setup(dbName);

                // Add to the lists
                localDatabases.add(importedDb);

                // Load custom name from secure storage if it exists
                final customName =
                    await secureStorage.read(key: 'db_name_$dbName');
                localDatabaseNames.add(customName ?? dbName);
              } catch (e) {
                // Handle individual database load errors
              }
            }
          }
        }

        // Notify listeners if we loaded any databases
        if (localDatabases.isNotEmpty) {
          notifyListeners();
        }
      }
    } catch (e) {
      // Handle errors during the directory scan
    }
  }

  Future<void> synchronize([bool force = false]) async {
    if (!force && !(await shouldSync())) {
      return;
    }
    syncStatus.add(SyncStatus.syncing);
    for (final remote in remotes) {
      try {
        await remote.synchronize();
      } catch (e) {
        syncStatus.add(SyncStatus.error);
      }
    }
    if (syncStatus.value != SyncStatus.error) {
      syncStatus.add(SyncStatus.synced);
    }
  }

  Future<void> _connectRemote(RemoteStorage storage, String? password) async {
    final db = RemoteDatabaseService(openDatabase);
    await db.setup(storage.toFilename());

    remotes.add(RemoteService.fromStorage(db, storage, password));
  }

  Future<void> addRemote(RemoteStorage remoteStorage, String password) async {
    if (settingsCubit.state.remotes
        .any((element) => element.identifier == remoteStorage.identifier)) {
      return;
    }
    final key = 'remote ${remoteStorage.toFilename()}';
    if (password.isNotEmpty) {
      await secureStorage.write(key: key, value: password);
    }
    await settingsCubit.addStorage(remoteStorage);
    await _connectRemote(remoteStorage, password);
    await synchronize();
  }

  Future<void> removeRemote(String name) async {
    await settingsCubit.removeStorage(name);
    try {
      await secureStorage.delete(key: 'remote $name');
    } catch (_) {}
    remotes
        .removeWhere((element) => element.remoteStorage.toFilename() == name);
    await synchronize();
  }

  List<RemoteStorage> getRemotes() => settingsCubit.state.remotes;

  /// Imports a database file and adds it as a new local source
  Future<String?> importDatabase(
      List<int> bytes, String originalFileName) async {
    try {
      // Generate a unique name for the imported database
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final baseName = originalFileName.replaceAll('.db', '');
      final uniqueName = 'imported_${baseName}_$timestamp';

      // Get the Flow directory
      final flowDirectory = await getFlowDirectory();
      final dbPath = '$flowDirectory/$uniqueName.db';

      // Ensure the directory exists
      final directory = Directory(flowDirectory);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Write the imported database file
      final file = File(dbPath);
      await file.writeAsBytes(bytes);

      // Create a new DatabaseService for the imported database
      final importedDb = DatabaseService(openDatabase);
      await importedDb.setup(uniqueName);

      // Add to the list of local databases
      localDatabases.add(importedDb);
      // Add a custom name for the imported database
      localDatabaseNames.add(uniqueName);

      // Store the custom name in secure storage
      await secureStorage.write(key: 'db_name_$uniqueName', value: uniqueName);

      // Notify listeners of the change
      notifyListeners();

      return uniqueName;
    } catch (e) {
      return null;
    }
  }

  /// Removes an imported database by index
  Future<void> removeImportedDatabase(int index) async {
    if (index >= 0 && index < localDatabases.length) {
      try {
        final db = localDatabases[index];
        final dbPath = db.db.path;

        // Get the database name for secure storage cleanup
        final dbName =
            dbPath.split(Platform.pathSeparator).last.replaceAll('.db', '');

        // Close the database connection
        await db.db.close();

        // Delete the physical database file
        final file = File(dbPath);
        if (await file.exists()) {
          await file.delete();
        }

        // Remove custom name from secure storage
        await secureStorage.delete(key: 'db_name_$dbName');

        // Remove from the lists
        localDatabases.removeAt(index);
        localDatabaseNames.removeAt(index);

        // Notify listeners of the change
        notifyListeners();
      } catch (e) {
        // Handle errors during removal
      }
    }
  }

  /// Exports an imported database by index
  Future<List<int>?> exportImportedDatabase(int index) async {
    if (index >= 0 && index < localDatabases.length) {
      try {
        final db = localDatabases[index];

        // Get the database file path
        final dbPath = db.db.path;
        final file = File(dbPath);

        if (await file.exists()) {
          // Read the database file as bytes
          final bytes = await file.readAsBytes();
          return bytes;
        }
      } catch (e) {
        // Handle errors during export
      }
    }
    return null;
  }

  /// Renames an imported database by index (renames both file and display name)
  Future<bool> renameImportedDatabase(int index, String newName) async {
    if (index >= 0 && index < localDatabases.length && newName.isNotEmpty) {
      try {
        final db = localDatabases[index];
        final oldPath = db.db.path;

        final oldDbName =
            oldPath.split(Platform.pathSeparator).last.replaceAll('.db', '');

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final sanitized =
            newName.replaceAll(RegExp(r'[^\w\s-]', unicode: true), '_');
        final newDbFileName = 'imported_${sanitized}_$timestamp';

        final directory = Directory(oldPath).parent;
        final newPath =
            '${directory.path}${Platform.pathSeparator}$newDbFileName.db';

        await db.db.close();

        final oldFile = File(oldPath);
        if (await oldFile.exists()) {
          await oldFile.rename(newPath);

          final newDb = DatabaseService(openDatabase);
          await newDb.setup(newDbFileName);

          localDatabases[index] = newDb;
          localDatabaseNames[index] = newName;

          await secureStorage.delete(key: 'db_name_$oldDbName');
          await secureStorage.write(
              key: 'db_name_$newDbFileName', value: newName);

          notifyListeners();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  /// Gets all available local database names (including imported ones)
  List<String> getLocalDatabaseNames() {
    final names = <String>['local']; // The main local database

    // Add imported database display names
    names.addAll(localDatabaseNames);

    return names;
  }

  SourceService getSource(String source) {
    if (source.isEmpty || source == 'local') return local;

    // Check if it's an imported local database by its underlying filename
    for (int i = 0; i < localDatabases.length; i++) {
      final db = localDatabases[i];
      try {
        final dbFileName =
            db.db.path.split(Platform.pathSeparator).last.replaceAll('.db', '');

        if (dbFileName == source) {
          return db;
        }
      } catch (e) {
        // Handle errors during source retrieval
      }
    }

    // If not found by filename, then check remotes
    return remotes.firstWhereOrNull(
            (element) => element.remoteStorage.identifier == source) ??
        local; // Fallback to local if not found anywhere
  }

  Future<void> clearRemotes() async {
    for (final remote in remotes) {
      await removeRemote(remote.remoteStorage.identifier);
    }
  }

  RemoteStorage? getRemote(String key) => settingsCubit.getStorage(key);
}
