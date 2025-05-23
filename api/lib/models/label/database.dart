import 'dart:async';

import 'dart:typed_data';
import 'package:flow_api/models/label/model.dart';
import 'package:flow_api/models/label/service.dart';
import 'package:flow_api/services/database.dart';
import 'package:sqflite_common/sqlite_api.dart';

class LabelDatabaseService extends LabelService with TableService {
  LabelDatabaseService();

  @override
  Future<void> create(Database db) {
    return db.execute("""
      CREATE TABLE IF NOT EXISTS labels (
        id BLOB(16) PRIMARY KEY,
        name VARCHAR(100) NOT NULL DEFAULT '',
        description TEXT,
        color INTEGER NOT NULL DEFAULT 0
      )
    """);
  }

  @override
  Future<Label?> createLabel(Label label) async {
    final id = label.id ?? createUniqueUint8List();
    label = label.copyWith(id: id);
    final row = await db?.insert('labels', label.toDatabase());
    if (row == null) return null;
    return label;
  }

  @override
  Future<Label?> getLabel(Uint8List id) async {
    final result = await db?.query(
      'labels',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result == null || result.isEmpty) return null;
    return Label.fromDatabase(result.first);
  }

  @override
  Future<bool> deleteLabel(Uint8List id) async {
    return await db?.delete(
          'labels',
          where: 'id = ?',
          whereArgs: [id],
        ) ==
        1;
  }

  @override
  Future<List<Label>> getLabels({
    int offset = 0,
    int limit = 50,
    String search = '',
  }) async {
    String? where;
    List<Object>? whereArgs;
    if (search.isNotEmpty) {
      where = 'name LIKE ?';
      whereArgs = ['%$search%'];
    }
    final result = await db?.query(
      'labels',
      where: where,
      whereArgs: whereArgs,
      offset: offset,
      limit: limit,
    );
    if (result == null) return [];
    return result.map(Label.fromDatabase).toList();
  }

  @override
  Future<bool> updateLabel(Label label) async {
    return await db?.update(
          'labels',
          label.toDatabase()..remove('id'),
          where: 'id = ?',
          whereArgs: [label.id],
        ) ==
        1;
  }

  @override
  Future<void> clear() async {
    await db?.delete('labels');
  }
}
