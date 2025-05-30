import 'dart:async';
import 'dart:typed_data';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    show SqfliteFfiWebOptions, createDatabaseFactoryFfiWeb;
import 'package:sqlite3/common.dart'; // For Sqlite3Filename, SqlFlag, Vfs
import 'package:sqlite3/wasm.dart' show IndexedDbFileSystem;

const indexedDbName = 'sqflite_databases';

Future<Database> openDatabase({
  String name = 'momentum',
  int? version,
  FutureOr<void> Function(Database, int, int)? onUpgrade,
  FutureOr<void> Function(Database, int)? onCreate,
}) async {
  var factory = createDatabaseFactoryFfiWeb(
      options: SqfliteFfiWebOptions(
    indexedDbName: indexedDbName,
  ));
  var db = await factory.openDatabase(
    '$name.db',
    options: OpenDatabaseOptions(
      version: version,
      onUpgrade: onUpgrade,
      onCreate: onCreate,
    ),
  );
  return db;
}

Future<Uint8List> exportDatabase(Database database) async {
  // Get a list of all tables from the source database
  final tables = (await database.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'android_%' AND name NOT LIKE 'sqlite_%';"))
      .map((row) => row['name'] as String)
      .where((name) => !name.startsWith('auth_'))
      .toList();

  const tempDbName = 'temp_export_web.db';
  final factory = createDatabaseFactoryFfiWeb(
    options: SqfliteFfiWebOptions(indexedDbName: indexedDbName),
  );

  final fs = await IndexedDbFileSystem.open(dbName: indexedDbName);

  // VFS methods xAccess and xDelete take String paths.
  // SQLITE_ACCESS_EXISTS is 0.
  if (fs.xAccess(tempDbName, Vfs.SQLITE_ACCESS_EXISTS) == 0) {
    fs.xDelete(tempDbName, 0); // syncDir = 0
  }

  final Database tempDb = await factory.openDatabase(tempDbName);

  // Copy schema and data for allowed tables
  for (final tableName in tables) {
    // Copy schema
    final createTableResult = await database
        .rawQuery("SELECT sql FROM sqlite_master WHERE name = '$tableName'");
    if (createTableResult.isNotEmpty &&
        createTableResult.first['sql'] != null) {
      await tempDb.execute(createTableResult.first['sql'] as String);
    }

    // Copy data
    final data = await database.query(tableName);
    for (final row in data) {
      await tempDb.insert(tableName, row);
    }
  }

  await tempDb.close();

  // Sqlite3Filename is used with xOpen
  final sqliteFile =
      fs.xOpen(Sqlite3Filename(tempDbName), SqlFlag.SQLITE_OPEN_READONLY).file;
  final size = sqliteFile.xFileSize();
  final target = Uint8List(size);
  sqliteFile.xRead(target, 0);
  sqliteFile.xClose();

  fs.xDelete(tempDbName, 0); // syncDir = 0

  return target;
}
