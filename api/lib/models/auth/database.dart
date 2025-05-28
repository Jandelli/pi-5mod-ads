import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flow_api/services/database.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'model.dart';
import 'service.dart';

class AuthDatabaseServiceImpl extends AuthDatabaseService with TableService {
  static const int _maxFailedAttempts = 5;
  static const Duration _lockDuration = Duration(minutes: 30);
  static const Duration _sessionDuration = Duration(hours: 24);
  static const Duration _extendedSessionDuration = Duration(days: 30);
  static const Duration _resetTokenDuration = Duration(hours: 1);

  @override
  Future<void> create(Database db) async {
    // Create auth_users table
    await db.execute("""
      CREATE TABLE IF NOT EXISTS auth_users (
        id BLOB(16) PRIMARY KEY,
        username VARCHAR(100) UNIQUE NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        display_name VARCHAR(255),
        profile_image TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        email_verified INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        last_login_at INTEGER,
        reset_token TEXT,
        reset_token_expiry INTEGER,
        failed_login_attempts INTEGER NOT NULL DEFAULT 0,
        locked_until INTEGER
      )
    """);

    // Create auth_sessions table
    await db.execute("""
      CREATE TABLE IF NOT EXISTS auth_sessions (
        id BLOB(16) PRIMARY KEY,
        user_id BLOB(16) NOT NULL,
        token TEXT UNIQUE NOT NULL,
        device_info TEXT NOT NULL,
        ip_address TEXT,
        created_at INTEGER NOT NULL,
        expires_at INTEGER NOT NULL,
        last_accessed_at INTEGER,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE
      )
    """);

    // Create auth_roles table
    await db.execute("""
      CREATE TABLE IF NOT EXISTS auth_roles (
        id BLOB(16) PRIMARY KEY,
        name VARCHAR(100) UNIQUE NOT NULL,
        description TEXT,
        permissions TEXT,
        created_at INTEGER NOT NULL
      )
    """);

    // Create auth_user_roles junction table
    await db.execute("""
      CREATE TABLE IF NOT EXISTS auth_user_roles (
        user_id BLOB(16) NOT NULL,
        role_id BLOB(16) NOT NULL,
        assigned_at INTEGER NOT NULL,
        PRIMARY KEY (user_id, role_id),
        FOREIGN KEY (user_id) REFERENCES auth_users(id) ON DELETE CASCADE,
        FOREIGN KEY (role_id) REFERENCES auth_roles(id) ON DELETE CASCADE
      )
    """);

    // Create indexes for performance
    await db.execute("""
      CREATE INDEX IF NOT EXISTS idx_auth_users_username ON auth_users(username)
    """);
    await db.execute("""
      CREATE INDEX IF NOT EXISTS idx_auth_users_email ON auth_users(email)
    """);
    await db.execute("""
      CREATE INDEX IF NOT EXISTS idx_auth_sessions_token ON auth_sessions(token)
    """);
    await db.execute("""
      CREATE INDEX IF NOT EXISTS idx_auth_sessions_user_id ON auth_sessions(user_id)
    """);
    await db.execute("""
      CREATE INDEX IF NOT EXISTS idx_auth_sessions_expires_at ON auth_sessions(expires_at)
    """);

    // Create default roles
    await _createDefaultRoles(db);
  }

  Future<void> _createDefaultRoles(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Admin role
    final adminRoleId = createUniqueUint8List();
    await db.insert('auth_roles', {
      'id': adminRoleId,
      'name': 'admin',
      'description': 'Full system administrator access',
      'permissions':
          'user.create,user.read,user.update,user.delete,role.create,role.read,role.update,role.delete,system.admin',
      'created_at': now,
    });

    // User role
    final userRoleId = createUniqueUint8List();
    await db.insert('auth_roles', {
      'id': userRoleId,
      'name': 'user',
      'description': 'Standard user access',
      'permissions': 'user.read,profile.update',
      'created_at': now,
    });
  }

  // User Management
  @override
  Future<AuthDatabaseUser?> createUser(
      AuthDatabaseRegistration registration) async {
    // Validate input
    if (!_isValidEmail(registration.email)) {
      throw ArgumentError('Invalid email format');
    }
    if (!_isValidUsername(registration.username)) {
      throw ArgumentError('Invalid username format');
    }
    if (!_isValidPassword(registration.password)) {
      throw ArgumentError('Password does not meet requirements');
    }

    // Check for existing user
    final existingUser = await getUserByUsername(registration.username) ??
        await getUserByEmail(registration.email);
    if (existingUser != null) {
      throw StateError('User already exists');
    }

    final now = DateTime.now();
    final id = createUniqueUint8List();
    final passwordHash = _hashPassword(registration.password);

    final user = AuthDatabaseUser(
      id: id,
      username: registration.username,
      email: registration.email,
      passwordHash: passwordHash,
      displayName: registration.displayName,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final result = await db?.insert('auth_users', user.toDatabase());
      if (result != null) {
        // Assign default user role
        final userRole = await getRoleByName('user');
        if (userRole != null) {
          await assignRoleToUser(id, userRole.id!);
        }
        return user;
      }
    } catch (e) {
      throw StateError('Failed to create user: $e');
    }
    return null;
  }

  @override
  Future<AuthDatabaseUser?> getUserById(Uint8List id) async {
    final result = await db?.query(
      'auth_users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result?.isNotEmpty == true) {
      return AuthDatabaseUser.fromDatabase(result!.first);
    }
    return null;
  }

  @override
  Future<AuthDatabaseUser?> getUserByUsername(String username) async {
    final result = await db?.query(
      'auth_users',
      where: 'username = ? AND is_active = 1',
      whereArgs: [username],
    );

    if (result?.isNotEmpty == true) {
      return AuthDatabaseUser.fromDatabase(result!.first);
    }
    return null;
  }

  @override
  Future<AuthDatabaseUser?> getUserByEmail(String email) async {
    final result = await db?.query(
      'auth_users',
      where: 'email = ? AND is_active = 1',
      whereArgs: [email],
    );

    if (result?.isNotEmpty == true) {
      return AuthDatabaseUser.fromDatabase(result!.first);
    }
    return null;
  }

  @override
  Future<bool> updateUser(AuthDatabaseUser user) async {
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    final result = await db?.update(
      'auth_users',
      updatedUser.toDatabase()..remove('id'),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return result == 1;
  }

  @override
  Future<bool> deleteUser(Uint8List id) async {
    // Soft delete by marking as inactive
    final result = await db?.update(
      'auth_users',
      {'is_active': 0, 'updated_at': DateTime.now().millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [id],
    );
    return result == 1;
  }

  @override
  Future<List<AuthDatabaseUser>> getUsers({
    int offset = 0,
    int limit = 50,
    String search = '',
    bool? isActive,
  }) async {
    String where = '';
    List<Object> whereArgs = [];

    if (search.isNotEmpty) {
      where = '(username LIKE ? OR email LIKE ? OR display_name LIKE ?)';
      whereArgs = ['%$search%', '%$search%', '%$search%'];
    }

    if (isActive != null) {
      final activeCondition = 'is_active = ?';
      where = where.isEmpty ? activeCondition : '$where AND $activeCondition';
      whereArgs.add(isActive ? 1 : 0);
    }

    final result = await db?.query(
      'auth_users',
      where: where.isEmpty ? null : where,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'created_at DESC',
      limit: limit,
      offset: offset,
    );

    return result?.map(AuthDatabaseUser.fromDatabase).toList() ?? [];
  }

  // Authentication
  @override
  Future<AuthDatabaseSession?> authenticate(
      AuthDatabaseCredentials credentials) async {
    final user = await getUserByUsername(credentials.username);
    if (user == null) {
      throw StateError('Invalid credentials');
    }

    // Check if user is locked
    if (user.isLocked) {
      throw StateError('Account is locked. Try again later.');
    }

    // Verify password
    if (!_verifyPassword(credentials.password, user.passwordHash)) {
      await incrementFailedLoginAttempts(user.id!);

      // Check if user should be locked after this attempt
      final updatedUser = await getUserById(user.id!);
      if (updatedUser != null &&
          updatedUser.failedLoginAttempts >= _maxFailedAttempts) {
        await lockUser(user.id!, _lockDuration);
      }

      throw StateError('Invalid credentials');
    }

    // Reset failed attempts on successful login
    await resetFailedLoginAttempts(user.id!);

    // Update last login
    await updateUser(user.copyWith(lastLoginAt: DateTime.now()));

    // Create session
    return await createSession(user, credentials);
  }

  @override
  Future<bool> verifyPassword(String username, String password) async {
    final user = await getUserByUsername(username);
    if (user == null) return false;
    return _verifyPassword(password, user.passwordHash);
  }

  @override
  Future<bool> changePassword(
      Uint8List userId, String currentPassword, String newPassword) async {
    final user = await getUserById(userId);
    if (user == null) return false;

    if (!_verifyPassword(currentPassword, user.passwordHash)) {
      return false;
    }

    if (!_isValidPassword(newPassword)) {
      throw ArgumentError('New password does not meet requirements');
    }

    final newPasswordHash = _hashPassword(newPassword);
    return await updateUser(user.copyWith(passwordHash: newPasswordHash));
  }

  @override
  Future<String?> generatePasswordResetToken(String email) async {
    final user = await getUserByEmail(email);
    if (user == null) return null;

    final token = _generateSecureToken();
    final expiry = DateTime.now().add(_resetTokenDuration);

    final success = await updateUser(user.copyWith(
      resetToken: token,
      resetTokenExpiry: expiry,
    ));

    return success ? token : null;
  }

  @override
  Future<bool> resetPassword(String token, String newPassword) async {
    if (!_isValidPassword(newPassword)) {
      throw ArgumentError('Password does not meet requirements');
    }

    final result = await db?.query(
      'auth_users',
      where: 'reset_token = ? AND reset_token_expiry > ? AND is_active = 1',
      whereArgs: [token, DateTime.now().millisecondsSinceEpoch],
    );

    if (result?.isEmpty != false) return false;

    final user = AuthDatabaseUser.fromDatabase(result!.first);
    final newPasswordHash = _hashPassword(newPassword);

    return await updateUser(user.copyWith(
      passwordHash: newPasswordHash,
      resetToken: null,
      resetTokenExpiry: null,
      failedLoginAttempts: 0,
      lockedUntil: null,
    ));
  }

  // Session Management
  @override
  Future<AuthDatabaseSession?> createSession(
      AuthDatabaseUser user, AuthDatabaseCredentials credentials) async {
    final sessionId = createUniqueUint8List();
    final token = _generateSecureToken();
    final now = DateTime.now();
    final expiresAt = credentials.rememberMe
        ? now.add(_extendedSessionDuration)
        : now.add(_sessionDuration);

    final session = AuthDatabaseSession(
      id: sessionId,
      userId: user.id!,
      token: token,
      deviceInfo: credentials.deviceInfo,
      ipAddress: credentials.ipAddress,
      createdAt: now,
      expiresAt: expiresAt,
      lastAccessedAt: now,
    );

    try {
      final result = await db?.insert('auth_sessions', session.toDatabase());
      return result != null ? session : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthDatabaseSession?> getSessionByToken(String token) async {
    final result = await db?.query(
      'auth_sessions',
      where: 'token = ? AND is_active = 1',
      whereArgs: [token],
    );

    if (result?.isNotEmpty == true) {
      final session = AuthDatabaseSession.fromDatabase(result!.first);

      // Update last accessed time
      if (session.isValid) {
        await db?.update(
          'auth_sessions',
          {'last_accessed_at': DateTime.now().millisecondsSinceEpoch},
          where: 'id = ?',
          whereArgs: [session.id],
        );
      }

      return session;
    }
    return null;
  }

  @override
  Future<bool> validateSession(String token) async {
    final session = await getSessionByToken(token);
    return session?.isValid ?? false;
  }

  @override
  Future<bool> refreshSession(String token) async {
    final session = await getSessionByToken(token);
    if (session == null || !session.isValid) return false;

    final newExpiresAt = DateTime.now().add(_sessionDuration);
    final result = await db?.update(
      'auth_sessions',
      {'expires_at': newExpiresAt.millisecondsSinceEpoch},
      where: 'id = ?',
      whereArgs: [session.id],
    );
    return result == 1;
  }

  @override
  Future<bool> invalidateSession(String token) async {
    final result = await db?.update(
      'auth_sessions',
      {'is_active': 0},
      where: 'token = ?',
      whereArgs: [token],
    );
    return result == 1;
  }

  @override
  Future<bool> invalidateAllUserSessions(Uint8List userId) async {
    final result = await db?.update(
      'auth_sessions',
      {'is_active': 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result != null && result > 0;
  }

  @override
  Future<List<AuthDatabaseSession>> getUserSessions(Uint8List userId) async {
    final result = await db?.query(
      'auth_sessions',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      orderBy: 'last_accessed_at DESC',
    );

    return result?.map(AuthDatabaseSession.fromDatabase).toList() ?? [];
  }

  @override
  Future<void> cleanupExpiredSessions() async {
    await db?.delete(
      'auth_sessions',
      where: 'expires_at < ? OR is_active = 0',
      whereArgs: [DateTime.now().millisecondsSinceEpoch],
    );
  }

  // Role Management
  @override
  Future<AuthDatabaseRole?> createRole(AuthDatabaseRole role) async {
    final id = role.id ?? createUniqueUint8List();
    final newRole = role.copyWith(id: id);

    try {
      final result = await db?.insert('auth_roles', newRole.toDatabase());
      return result != null ? newRole : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthDatabaseRole?> getRoleById(Uint8List id) async {
    final result = await db?.query(
      'auth_roles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result?.isNotEmpty == true) {
      return AuthDatabaseRole.fromDatabase(result!.first);
    }
    return null;
  }

  @override
  Future<AuthDatabaseRole?> getRoleByName(String name) async {
    final result = await db?.query(
      'auth_roles',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (result?.isNotEmpty == true) {
      return AuthDatabaseRole.fromDatabase(result!.first);
    }
    return null;
  }

  @override
  Future<bool> updateRole(AuthDatabaseRole role) async {
    final result = await db?.update(
      'auth_roles',
      role.toDatabase()..remove('id'),
      where: 'id = ?',
      whereArgs: [role.id],
    );
    return result == 1;
  }

  @override
  Future<bool> deleteRole(Uint8List id) async {
    final result = await db?.delete(
      'auth_roles',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result == 1;
  }

  @override
  Future<List<AuthDatabaseRole>> getRoles() async {
    final result = await db?.query('auth_roles', orderBy: 'name');
    return result?.map(AuthDatabaseRole.fromDatabase).toList() ?? [];
  }

  // User-Role Assignments
  @override
  Future<bool> assignRoleToUser(Uint8List userId, Uint8List roleId) async {
    try {
      final result = await db?.insert('auth_user_roles', {
        'user_id': userId,
        'role_id': roleId,
        'assigned_at': DateTime.now().millisecondsSinceEpoch,
      });
      return result != null;
    } catch (e) {
      return false; // Role already assigned
    }
  }

  @override
  Future<bool> removeRoleFromUser(Uint8List userId, Uint8List roleId) async {
    final result = await db?.delete(
      'auth_user_roles',
      where: 'user_id = ? AND role_id = ?',
      whereArgs: [userId, roleId],
    );
    return result == 1;
  }

  @override
  Future<List<AuthDatabaseRole>> getUserRoles(Uint8List userId) async {
    final result = await db?.query(
      'auth_roles JOIN auth_user_roles ON auth_roles.id = auth_user_roles.role_id',
      where: 'auth_user_roles.user_id = ?',
      whereArgs: [userId],
    );

    return result?.map(AuthDatabaseRole.fromDatabase).toList() ?? [];
  }

  @override
  Future<List<AuthDatabaseUser>> getUsersWithRole(Uint8List roleId) async {
    final result = await db?.query(
      'auth_users JOIN auth_user_roles ON auth_users.id = auth_user_roles.user_id',
      where: 'auth_user_roles.role_id = ? AND auth_users.is_active = 1',
      whereArgs: [roleId],
    );

    return result?.map(AuthDatabaseUser.fromDatabase).toList() ?? [];
  }

  @override
  Future<bool> userHasPermission(Uint8List userId, String permission) async {
    final result = await db?.query(
      '''
      SELECT COUNT(*) as count FROM auth_roles 
      JOIN auth_user_roles ON auth_roles.id = auth_user_roles.role_id 
      WHERE auth_user_roles.user_id = ? AND auth_roles.permissions LIKE ?
      ''',
      whereArgs: [userId, '%$permission%'],
    );

    final count = result?.first['count'] as int? ?? 0;
    return count > 0;
  }

  // Security Utilities
  @override
  Future<bool> lockUser(Uint8List userId, Duration lockDuration) async {
    final lockUntil = DateTime.now().add(lockDuration);
    final result = await db?.update(
      'auth_users',
      {
        'locked_until': lockUntil.millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result == 1;
  }

  @override
  Future<bool> unlockUser(Uint8List userId) async {
    final result = await db?.update(
      'auth_users',
      {
        'locked_until': null,
        'failed_login_attempts': 0,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result == 1;
  }

  @override
  Future<bool> incrementFailedLoginAttempts(Uint8List userId) async {
    final result = await db?.update(
      'auth_users',
      {
        'failed_login_attempts': 'failed_login_attempts + 1',
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result == 1;
  }

  @override
  Future<bool> resetFailedLoginAttempts(Uint8List userId) async {
    final result = await db?.update(
      'auth_users',
      {
        'failed_login_attempts': 0,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
    return result == 1;
  }

  @override
  Future<void> clear() async {
    await db?.delete('auth_user_roles');
    await db?.delete('auth_sessions');
    await db?.delete('auth_roles');
    await db?.delete('auth_users');
  }

  // Security Helper Methods
  String _hashPassword(String password) {
    final salt = _generateSalt();
    final combined = '$password$salt';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    return '$salt:${digest.toString()}';
  }

  bool _verifyPassword(String password, String storedHash) {
    final parts = storedHash.split(':');
    if (parts.length != 2) return false;

    final salt = parts[0];
    final hash = parts[1];

    final combined = '$password$salt';
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);

    return digest.toString() == hash;
  }

  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  String _generateSecureToken() {
    final random = Random.secure();
    final tokenBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(tokenBytes);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  bool _isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(username);
  }

  bool _isValidPassword(String password) {
    // At least 8 characters, one uppercase, one lowercase, one digit
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }
}
