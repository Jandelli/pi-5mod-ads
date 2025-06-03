import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flow_api/models/auth/model.dart';
import 'package:flow_api/services/database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth/user.dart';

class AuthDatabaseService {
  final DatabaseService _databaseService;
  final FlutterSecureStorage _secureStorage;
  static const String _sessionTokenKey = 'session_token';

  AuthDatabaseService(this._databaseService, this._secureStorage);

  // Convert between app models and database models
  AuthUser _convertToAppUser(AuthDatabaseUser dbUser, List<String> roles) {
    return AuthUser(
      id: _uint8ListToString(dbUser.id!),
      username: dbUser.username,
      email: dbUser.email,
      displayName: dbUser.displayName,
      profileImage: dbUser.profileImage,
      roles: roles,
      createdAt: dbUser.createdAt,
      lastLoginAt: dbUser.lastLoginAt ?? dbUser.createdAt,
    );
  }

  AuthDatabaseCredentials _convertToDbCredentials(
      LoginCredentials credentials) {
    return AuthDatabaseCredentials(
      username: credentials.username,
      password: credentials.password,
      rememberMe: credentials.rememberMe,
      deviceInfo: _getDeviceInfo(),
      ipAddress: _getLocalIpAddress(),
    );
  }

  String _uint8ListToString(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Uint8List _stringToUint8List(String str) {
    final List<int> bytes = [];
    for (int i = 0; i < str.length; i += 2) {
      bytes.add(int.parse(str.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }

  String _getDeviceInfo() {
    // This would be populated with actual device info
    return 'Flutter App ${Platform.operatingSystem}';
  }

  String? _getLocalIpAddress() {
    // This would be populated with actual IP address if needed
    return null;
  }

  // Authentication methods
  Future<AuthSession?> authenticate(LoginCredentials credentials) async {
    // Attempt authentication, propagate errors for UI handling
    final dbCredentials = _convertToDbCredentials(credentials);
    final dbSession = await _databaseService.auth.authenticate(dbCredentials);
    if (dbSession == null) {
      // No session returned means invalid credentials
      throw StateError('invalid_credentials');
    }

    // Get user details with roles
    final dbUser = await _databaseService.auth.getUserById(dbSession.userId);
    if (dbUser == null) return null;

    final roles = await _databaseService.auth.getUserRoles(dbSession.userId);
    final roleNames = roles.map((r) => r.name).toList();

    final appUser = _convertToAppUser(dbUser, roleNames);

    // Store session token securely
    await _secureStorage.write(key: _sessionTokenKey, value: dbSession.token);

    return AuthSession(
      token: dbSession.token,
      user: appUser,
      expiresAt: dbSession.expiresAt,
      rememberMe: credentials.rememberMe,
    );
  }

  Future<AuthUser?> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    final registration = AuthDatabaseRegistration(
      username: username,
      email: email,
      password: password,
      displayName: displayName,
    );

    final dbUser = await _databaseService.auth.createUser(registration);
    if (dbUser == null) return null;

    final roles = await _databaseService.auth.getUserRoles(dbUser.id!);
    final roleNames = roles.map((r) => r.name).toList();

    return _convertToAppUser(dbUser, roleNames);
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final session = await getCurrentSession();
    if (session == null) return false;

    try {
      final userId = _stringToUint8List(session.user.id);
      return await _databaseService.auth.changePassword(
        userId,
        currentPassword,
        newPassword,
      );
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  Future<String?> requestPasswordReset(String email) async {
    try {
      return await _databaseService.auth.generatePasswordResetToken(email);
    } catch (e) {
      print('Password reset request error: $e');
      return null;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _databaseService.auth.resetPassword(token, newPassword);
    } catch (e) {
      print('Password reset error: $e');
      return false;
    }
  }

  // Session management
  Future<AuthSession?> getCurrentSession() async {
    try {
      final token = await _secureStorage.read(key: _sessionTokenKey);
      if (token == null) return null;

      final dbSession = await _databaseService.auth.getSessionByToken(token);
      if (dbSession == null || !dbSession.isValid) {
        await logout();
        return null;
      }

      final dbUser = await _databaseService.auth.getUserById(dbSession.userId);
      if (dbUser == null) return null;

      final roles = await _databaseService.auth.getUserRoles(dbSession.userId);
      final roleNames = roles.map((r) => r.name).toList();

      final appUser = _convertToAppUser(dbUser, roleNames);

      return AuthSession(
        token: dbSession.token,
        user: appUser,
        expiresAt: dbSession.expiresAt,
        rememberMe: true, // Assume true if session exists
      );
    } catch (e) {
      print('Get current session error: $e');
      return null;
    }
  }

  Future<bool> refreshSession() async {
    try {
      final token = await _secureStorage.read(key: _sessionTokenKey);
      if (token == null) return false;

      return await _databaseService.auth.refreshSession(token);
    } catch (e) {
      print('Refresh session error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final token = await _secureStorage.read(key: _sessionTokenKey);
      if (token != null) {
        await _databaseService.auth.invalidateSession(token);
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      await _secureStorage.delete(key: _sessionTokenKey);
    }
  }

  Future<void> logoutFromAllDevices() async {
    try {
      final session = await getCurrentSession();
      if (session != null) {
        final userId = _stringToUint8List(session.user.id);
        await _databaseService.auth.invalidateAllUserSessions(userId);
      }
    } catch (e) {
      print('Logout from all devices error: $e');
    } finally {
      await _secureStorage.delete(key: _sessionTokenKey);
    }
  }

  // User management
  Future<AuthUser?> getCurrentUser() async {
    final session = await getCurrentSession();
    return session?.user;
  }

  Future<bool> updateProfile({
    String? displayName,
    String? profileImage,
  }) async {
    try {
      final session = await getCurrentSession();
      if (session == null) return false;

      final userId = _stringToUint8List(session.user.id);
      final dbUser = await _databaseService.auth.getUserById(userId);
      if (dbUser == null) return false;

      // Create updated user with new values
      final updatedUser = AuthDatabaseUser(
        id: dbUser.id,
        username: dbUser.username,
        email: dbUser.email,
        passwordHash: dbUser.passwordHash,
        displayName: displayName ?? dbUser.displayName,
        profileImage: profileImage ?? dbUser.profileImage,
        emailVerified: dbUser.emailVerified,
        isActive: dbUser.isActive,
        lastLoginAt: dbUser.lastLoginAt,
        createdAt: dbUser.createdAt,
        updatedAt: DateTime.now(),
        failedLoginAttempts: dbUser.failedLoginAttempts,
        lockedUntil: dbUser.lockedUntil,
      );

      return await _databaseService.auth.updateUser(updatedUser);
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  Future<bool> verifyEmail() async {
    try {
      final session = await getCurrentSession();
      if (session == null) return false;

      final userId = _stringToUint8List(session.user.id);
      final dbUser = await _databaseService.auth.getUserById(userId);
      if (dbUser == null) return false;

      final updatedUser = AuthDatabaseUser(
        id: dbUser.id,
        username: dbUser.username,
        email: dbUser.email,
        passwordHash: dbUser.passwordHash,
        displayName: dbUser.displayName,
        profileImage: dbUser.profileImage,
        emailVerified: true,
        isActive: dbUser.isActive,
        lastLoginAt: dbUser.lastLoginAt,
        createdAt: dbUser.createdAt,
        updatedAt: DateTime.now(),
        failedLoginAttempts: dbUser.failedLoginAttempts,
        lockedUntil: dbUser.lockedUntil,
      );

      return await _databaseService.auth.updateUser(updatedUser);
    } catch (e) {
      print('Verify email error: $e');
      return false;
    }
  }

  // Permission checking
  Future<bool> hasPermission(String permission) async {
    try {
      final session = await getCurrentSession();
      if (session == null) return false;

      final userId = _stringToUint8List(session.user.id);
      return await _databaseService.auth.userHasPermission(userId, permission);
    } catch (e) {
      print('Check permission error: $e');
      return false;
    }
  }

  Future<bool> hasRole(String roleName) async {
    final session = await getCurrentSession();
    return session?.user.hasRole(roleName) ?? false;
  }

  // Admin functions
  Future<List<AuthUser>> getAllUsers({
    int offset = 0,
    int limit = 50,
    String search = '',
    bool? isActive,
  }) async {
    try {
      if (!await hasPermission('user.read')) return [];

      final dbUsers = await _databaseService.auth.getUsers(
        offset: offset,
        limit: limit,
        search: search,
        isActive: isActive,
      );

      final List<AuthUser> appUsers = [];
      for (final dbUser in dbUsers) {
        final roles = await _databaseService.auth.getUserRoles(dbUser.id!);
        final roleNames = roles.map((r) => r.name).toList();
        appUsers.add(_convertToAppUser(dbUser, roleNames));
      }

      return appUsers;
    } catch (e) {
      print('Get all users error: $e');
      return [];
    }
  }

  Future<bool> deactivateUser(String userId) async {
    try {
      if (!await hasPermission('user.delete')) return false;

      final userIdBytes = _stringToUint8List(userId);
      return await _databaseService.auth.deleteUser(userIdBytes);
    } catch (e) {
      print('Deactivate user error: $e');
      return false;
    }
  }

  Future<bool> assignRole(String userId, String roleName) async {
    try {
      if (!await hasPermission('role.update')) return false;

      final userIdBytes = _stringToUint8List(userId);
      final role = await _databaseService.auth.getRoleByName(roleName);
      if (role?.id == null) return false;

      return await _databaseService.auth
          .assignRoleToUser(userIdBytes, role!.id!);
    } catch (e) {
      print('Assign role error: $e');
      return false;
    }
  }

  Future<bool> removeRole(String userId, String roleName) async {
    try {
      if (!await hasPermission('role.update')) return false;

      final userIdBytes = _stringToUint8List(userId);
      final role = await _databaseService.auth.getRoleByName(roleName);
      if (role?.id == null) return false;

      return await _databaseService.auth
          .removeRoleFromUser(userIdBytes, role!.id!);
    } catch (e) {
      print('Remove role error: $e');
      return false;
    }
  }

  // Maintenance
  Future<void> cleanupExpiredSessions() async {
    try {
      await _databaseService.auth.cleanupExpiredSessions();
    } catch (e) {
      print('Cleanup expired sessions error: $e');
    }
  }

  Future<void> initialize() async {
    // Perform any initialization tasks
    await cleanupExpiredSessions();

    // Check if we need to create a default admin user
    await _createDefaultAdminIfNeeded();
  }

  Future<void> _createDefaultAdminIfNeeded() async {
    try {
      final adminRole = await _databaseService.auth.getRoleByName('admin');
      if (adminRole == null) return;

      final admins =
          await _databaseService.auth.getUsersWithRole(adminRole.id!);
      if (admins.isNotEmpty) return;

      // Create default admin user (you should change these credentials)
      final registration = AuthDatabaseRegistration(
        username: 'admin',
        email: 'admin@example.com',
        password: 'password',
        displayName: 'Administrator',
      );

      final adminUser = await _databaseService.auth.createUser(registration);
      if (adminUser?.id != null) {
        await _databaseService.auth
            .assignRoleToUser(adminUser!.id!, adminRole.id!);
      }
    } catch (e) {
      print('Create default admin error: $e');
    }
  }
}
