import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/user.dart';
import 'auth_database_service.dart';

class AuthService {
  static const String _rememberMeKey = 'auth_remember_me';

  final AuthDatabaseService _authDatabaseService;
  final SharedPreferences _prefs;

  AuthSession? _currentSession;
  final StreamController<AuthSession?> _authController =
      StreamController<AuthSession?>.broadcast();

  AuthService(this._authDatabaseService, this._prefs);

  Stream<AuthSession?> get authStateChanges => _authController.stream;
  AuthSession? get currentSession => _currentSession;
  AuthUser? get currentUser => _currentSession?.user;
  bool get isAuthenticated => _currentSession?.isValid ?? false;

  /// Initialize the auth service and check for existing session
  Future<void> initialize() async {
    try {
      await _authDatabaseService.initialize();
      await _loadStoredSession();
    } catch (e) {
      // If there's an error loading session, clear it
      await clearSession();
    }
  }

  /// Load session from secure storage
  Future<void> _loadStoredSession() async {
    try {
      final session = await _authDatabaseService.getCurrentSession();
      if (session != null && session.isValid) {
        _currentSession = session;
        _authController.add(_currentSession);
      } else {
        // Session expired or invalid, clear it
        await clearSession();
      }
    } catch (e) {
      // Invalid session data, clear it
      await clearSession();
    }
  }

  /// Authenticate user with credentials
  Future<AuthUser?> login(LoginCredentials credentials) async {
    try {
      final session = await _authDatabaseService.authenticate(credentials);
      if (session != null) {
        _currentSession = session;
        await _prefs.setBool(_rememberMeKey, session.rememberMe);
        _authController.add(_currentSession);
        return session.user;
      }
    } catch (e) {
      // Handle authentication errors
      rethrow;
    }
    return null;
  }

  /// Register a new user
  Future<AuthUser?> register(RegistrationCredentials credentials) async {
    try {
      final user = await _authDatabaseService.register(
        username: credentials.username,
        email: credentials.email,
        password: credentials.password,
        displayName: credentials.displayName,
      );

      if (user != null) {
        // Auto-login after successful registration
        final loginCredentials = LoginCredentials(
          username: credentials.username,
          password: credentials.password,
          rememberMe: false,
        );

        final session =
            await _authDatabaseService.authenticate(loginCredentials);
        if (session != null) {
          _currentSession = session;
          _authController.add(_currentSession);
          return session.user;
        }
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new user (legacy method for compatibility)
  Future<AuthUser?> registerLegacy({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      return await _authDatabaseService.register(
        username: username,
        email: email,
        password: password,
        displayName: displayName,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Change user password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      return await _authDatabaseService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      return false;
    }
  }

  /// Request password reset
  Future<String?> requestPasswordReset(String email) async {
    try {
      return await _authDatabaseService.requestPasswordReset(email);
    } catch (e) {
      return null;
    }
  }

  /// Reset password with token
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      return await _authDatabaseService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
    } catch (e) {
      return false;
    }
  }

  /// Logout user and clear session
  Future<void> logout() async {
    try {
      await _authDatabaseService.logout();
    } catch (e) {
      // Log error but continue with clearing local session
    }
    await clearSession();
  }

  /// Logout from all devices
  Future<void> logoutFromAllDevices() async {
    try {
      await _authDatabaseService.logoutFromAllDevices();
    } catch (e) {
      // Log error but continue with clearing local session
    }
    await clearSession();
  }

  /// Clear all stored session data
  Future<void> clearSession() async {
    _currentSession = null;
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

    // Validate with database
    try {
      final isValid = await _authDatabaseService.refreshSession();
      if (!isValid) {
        await clearSession();
        return false;
      }

      // Reload session if validation succeeded
      await _loadStoredSession();
      return true;
    } catch (e) {
      await clearSession();
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? profileImage,
  }) async {
    try {
      final success = await _authDatabaseService.updateProfile(
        displayName: displayName,
        profileImage: profileImage,
      );

      if (success) {
        // Reload session to get updated user data
        await _loadStoredSession();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Check if user has specific permission
  Future<bool> hasPermission(String permission) async {
    try {
      return await _authDatabaseService.hasPermission(permission);
    } catch (e) {
      return false;
    }
  }

  /// Check if user has specific role
  Future<bool> hasRole(String roleName) async {
    try {
      return await _authDatabaseService.hasRole(roleName);
    } catch (e) {
      return false;
    }
  }

  /// Update user (for compatibility with existing code)
  Future<void> updateUser(AuthUser updatedUser) async {
    if (_currentSession != null) {
      final updatedSession = AuthSession(
        token: _currentSession!.token,
        user: updatedUser,
        expiresAt: _currentSession!.expiresAt,
        rememberMe: _currentSession!.rememberMe,
      );
      _currentSession = updatedSession;
      _authController.add(_currentSession);
    }
  }

  /// Verify email address
  Future<bool> verifyEmail() async {
    try {
      return await _authDatabaseService.verifyEmail();
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _authController.close();
  }
}
