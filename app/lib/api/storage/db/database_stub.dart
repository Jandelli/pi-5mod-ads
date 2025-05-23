import 'dart:async';
import 'dart:typed_data';

import 'package:sqflite_common/sqlite_api.dart';

Future<Database> openDatabase({
  String name = 'momentum',
  int? version,
  FutureOr<void> Function(Database, int, int)? onUpgrade,
  FutureOr<void> Function(Database, int)? onCreate,
}) {
  throw UnsupportedError('Cannot open database on this platform');
}

Future<Uint8List> exportDatabase(Database database) {
  throw UnsupportedError('Cannot export database on this platform');
}
