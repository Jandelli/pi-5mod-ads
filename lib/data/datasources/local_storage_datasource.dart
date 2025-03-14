import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/user.dart' as app_user;

abstract class LocalStorageDataSource {
  Future<void> cacheString(String key, String value);
  Future<String?> getCachedString(String key);
  Future<void> clearCache(String key);
  Future<void> cacheUser(app_user.User user);
  Future<void> clearUser();
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final SharedPreferences sharedPreferences;
  // ignore: constant_identifier_names
  static const String USER_KEY = 'CACHED_USER';

  LocalStorageDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<void> clearCache(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<String?> getCachedString(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> cacheUser(app_user.User user) async {
    final userJson = {
      'uid': user.id,
      'email': user.email,
      'name': user.name,
      'userType': user.userType,
    };
    await cacheString(USER_KEY, jsonEncode(userJson));
  }

  @override
  Future<void> clearUser() async {
    await clearCache(USER_KEY);
  }
}
