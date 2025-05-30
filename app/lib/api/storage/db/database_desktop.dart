import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flow/api/directory.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart'; // Added import

Future<Database> openDatabase({
  String name = 'momentum',
  int? version,
  FutureOr<void> Function(Database, int, int)? onUpgrade,
  FutureOr<void> Function(Database, int)? onCreate,
}) async {
  sqfliteFfiInit();
  var factory = databaseFactoryFfi;
  var db = await factory.openDatabase(
    '${await getFlowDirectory()}/$name.db',
    options: OpenDatabaseOptions(
        version: version, onUpgrade: onUpgrade, onCreate: onCreate),
  );
  return db;
}

Future<Uint8List> exportDatabase(Database database) async {
  // Get a list of all tables
  final tables = (await database.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'android_%' AND name NOT LIKE 'sqlite_%';"))
      .map((row) => row['name'] as String)
      .where((name) => !name.startsWith('auth_'))
      .toList();

  // Create an in-memory database for export
  final factory = databaseFactoryFfi;
  // final exportDb = await factory.openDatabase(inMemoryDatabasePath); // Original in-memory approach

  // Using a temporary file-based database for export to simplify byte retrieval
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/temp_export_desktop.db';
  if (await File(tempPath).exists()) {
    await File(tempPath).delete();
  }
  final exportDb = await factory.openDatabase(tempPath);

  // Copy schema and data for allowed tables
  for (final tableName in tables) {
    // Copy schema
    final createTableResult = await database
        .rawQuery("SELECT sql FROM sqlite_master WHERE name = '$tableName'");
    if (createTableResult.isNotEmpty &&
        createTableResult.first['sql'] != null) {
      await exportDb.execute(createTableResult.first['sql'] as String);
    }

    // Copy data
    final data = await database.query(tableName);
    for (final row in data) {
      await exportDb.insert(tableName, row);
    }
  }

  await exportDb.close();

  final fileBytes = await File(tempPath).readAsBytes();
  await File(tempPath).delete();
  return fileBytes;
}
