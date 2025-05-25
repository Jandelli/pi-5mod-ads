import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _sessionKey = 'auth_session';
  static const String _rememberMeKey = 'auth_remember_me';

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  AuthSession? _currentSession;
  final StreamController<AuthSession?> _authController =
      StreamController<AuthSession?>.broadcast();

  AuthService(this._secureStorage, this._prefs);

  Stream<AuthSession?> get authStateChanges => _authController.stream;
  AuthSession? get currentSession => _currentSession;
  AuthUser? get currentUser => _currentSession?.user;
  bool get isAuthenticated => _currentSession?.isValid ?? false;

  /// Initialize the auth service and check for existing session
  Future<void> initialize() async {
    try {
      await _loadStoredSession();
    } catch (e) {
      // If there's an error loading session, clear it
      await clearSession();
    }
  }

  /// Load session from secure storage
  Future<void> _loadStoredSession() async {
    final sessionJson = await _secureStorage.read(key: _sessionKey);
    if (sessionJson != null) {
      try {
        final session = AuthSessionMapper.fromJson(sessionJson);
        if (session.isValid) {
          _currentSession = session;
          _authController.add(_currentSession);
        } else {
          // Session expired, clear it
          await clearSession();
        }
      } catch (e) {
        // Invalid session data, clear it
        await clearSession();
      }
    }
  }

  /// Authenticate user with credentials
  Future<AuthUser?> login(LoginCredentials credentials) async {
    try {
      // Simulate API call - replace with actual authentication logic
      final user = await _authenticateUser(credentials);
      if (user != null) {
        final session = AuthSession(
          token: _generateToken(),
          user: user,
          expiresAt: DateTime.now()
              .add(Duration(days: credentials.rememberMe ? 30 : 1)),
          rememberMe: credentials.rememberMe,
        );

        await _saveSession(session);
        return user;
      }
    } catch (e) {
      // Handle authentication errors
      rethrow;
    }
    return null;
  }

  /// Mock authentication - replace with actual implementation
  Future<AuthUser?> _authenticateUser(LoginCredentials credentials) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500));

    // Mock credentials check - replace with actual API call
    if (credentials.username == 'admin' && credentials.password == 'password') {
      return AuthUser(
        id: '1',
        username: credentials.username,
        email: 'admin@example.com',
        displayName: 'Administrator',
        roles: ['admin', 'user'],
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        lastLoginAt: DateTime.now(),
      );
    } else if (credentials.username == 'user' &&
        credentials.password == 'password') {
      return AuthUser(
        id: '2',
        username: credentials.username,
        email: 'user@example.com',
        displayName: 'Regular User',
        roles: ['user'],
        createdAt: DateTime.now().subtract(Duration(days: 15)),
        lastLoginAt: DateTime.now(),
      );
    }

    // Invalid credentials
    throw Exception('Invalid username or password');
  }

  /// Generate a mock token - replace with actual token from API
  String _generateToken() {
    return 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Save session to secure storage
  Future<void> _saveSession(AuthSession session) async {
    _currentSession = session;
    await _secureStorage.write(key: _sessionKey, value: session.toJson());
    await _prefs.setBool(_rememberMeKey, session.rememberMe);
    _authController.add(_currentSession);
  }

  /// Logout user and clear session
  Future<void> logout() async {
    await clearSession();
  }

  /// Clear all stored session data
  Future<void> clearSession() async {
    _currentSession = null;
    await _secureStorage.delete(key: _sessionKey);
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _userKey);
    await _prefs.remove(_rememberMeKey);
    _authController.add(null);
  }

  /// Check if session is still valid and refresh if needed
  Future<bool> validateSession() async {
    if (_currentSession == null) return false;

    if (_currentSession!.isExpired) {
      await clearSession();
      return false;
    }

    // In a real implementation, you might validate with the server here
    return true;
  }

  /// Update user profile
  Future<void> updateUser(AuthUser updatedUser) async {
    if (_currentSession != null) {
      final updatedSession = AuthSession(
        token: _currentSession!.token,
        user: updatedUser,
        expiresAt: _currentSession!.expiresAt,
        rememberMe: _currentSession!.rememberMe,
      );
      await _saveSession(updatedSession);
    }
  }

  void dispose() {
    _authController.close();
  }
}
