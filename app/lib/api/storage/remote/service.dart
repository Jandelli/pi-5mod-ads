import 'package:flow/api/storage/remote/caldav.dart';
import 'package:flow/api/storage/remote/model.dart';
import 'package:flow/api/storage/remote/sia.dart';
import 'package:flow/models/request.dart';
import 'package:http/http.dart';
import 'package:flow_api/models/cached.dart';
import 'package:flow_api/models/model.dart';
import 'package:flow_api/services/database.dart';
import 'package:flow_api/services/source.dart';
import 'package:sqflite_common/sqlite_api.dart' show Database;

import 'ical.dart';

class RequestDatabaseService extends ModelService with TableService {
  @override
  Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS request (
        id BLOB(16) PRIMARY KEY,
        created INTEGER NOT NULL,
        data TEXT NOT NULL
      )
    ''');
  }

  Future<int?> createRequest(APIRequest request) async {
    return db?.insert('request', {
      'created': DateTime.now().millisecondsSinceEpoch,
      'data': request.toJson(),
    });
  }

  Future<List<ConnectedModel<DateTime, APIRequest>>> getRequests(
      {int offset = 0, int limit = 50}) async {
    final result = await db?.query(
      'request',
      limit: limit,
      offset: offset,
      orderBy: 'created DESC',
    );
    if (result == null) return [];
    return result
        .map((e) => ConnectedModel(
              DateTime.fromMillisecondsSinceEpoch(e['created'] as int),
              APIRequestMapper.fromJson(e['data'] as String),
            ))
        .toList();
  }

  Future<bool> deleteRequest(int id) async {
    return await db?.delete(
          'request',
          where: 'id = ?',
          whereArgs: [id],
        ) ==
        1;
  }
}

class RemoteDatabaseService extends DatabaseService {
  late final RequestDatabaseService request;

  @override
  List<ModelService> get models => [
        ...super.models,
        request,
      ];

  RemoteDatabaseService(super.databaseFactory);

  @override
  Future<void> setup(String name) {
    request = RequestDatabaseService();
    return super.setup(name);
  }
}

abstract class RemoteService<T extends RemoteStorage> extends SourceService {
  final RemoteDatabaseService local;
  final T remoteStorage;
  final String? password;
  bool _enableRequests = true;

  RemoteService(this.remoteStorage, this.local, this.password);

  factory RemoteService.fromStorage(
      RemoteDatabaseService local, T storage, String? password) {
    return switch (storage) {
      CalDavStorage() =>
        CalDavRemoteService(storage, local, password) as RemoteService<T>,
      ICalStorage() =>
        IcalRemoteService(storage, local, password) as RemoteService<T>,
      WebDavStorage() => throw UnimplementedError(),
      SiaStorage() =>
        SiaRemoteService(storage, local, password) as RemoteService<T>,
    };
  }

  Future<void> synchronize() async {
    final requests = await local.request.getRequests();
    for (final request in requests) {
      try {
        await request.model
            .send()
            .then((value) => local.request.deleteRequest(request.model.id));
      } catch (_) {}
    }
  }

  Future<Response?> addRequest(APIRequest apiRequest) async {
    if (!_enableRequests) return null;
    try {
      final response = await apiRequest.send();
      return response;
    } catch (_) {
      local.request.createRequest(apiRequest);
    }
    return null;
  }

  @override
  Future<void> import(CachedData data, [bool clear = true]) async {
    _enableRequests = false;
    await super.import(data, clear);
    _enableRequests = true;
  }
}
