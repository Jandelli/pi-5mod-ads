import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sqflite show openDatabase;

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

Future<Uint8List> exportDatabase(Database database) {
  final path = database.path;
  final file = File(path);
  return file.readAsBytes();
}
