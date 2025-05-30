import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sqflite
    show openDatabase, databaseExists, deleteDatabase;
import 'package:path_provider/path_provider.dart'; // Added import

import '../../directory.dart';

Future<Database> openDatabase({
  String name = 'momentum',
  int? version,
  FutureOr<void> Function(Database, int, int)? onUpgrade,
  FutureOr<void> Function(Database, int)? onCreate,
}) async {
  var db = await sqflite.openDatabase(
    '${await getFlowDirectory()}/$name.db',
    version: version,
    onUpgrade: onUpgrade,
    onCreate: onCreate,
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

  // Create a temporary database for export
  final tempDir = await getTemporaryDirectory(); // Added await
  final tempPath = '${tempDir.path}/temp_export_mobile.db';
  if (await sqflite.databaseExists(tempPath)) {
    // Used sqflite.databaseExists
    await sqflite.deleteDatabase(tempPath); // Used sqflite.deleteDatabase
  }
  final exportDb = await sqflite.openDatabase(tempPath);

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
