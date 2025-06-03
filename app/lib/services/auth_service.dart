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

  /// Authenticate user with credentials - Enhanced error handling
  Future<AuthUser?> login(LoginCredentials credentials) async {
    try {
      // Input validation
      if (credentials.username.trim().isEmpty) {
        throw Exception('Por favor, digite seu usuário');
      }
      if (credentials.password.isEmpty) {
        throw Exception('Por favor, digite sua senha');
      }

      final session = await _authDatabaseService.authenticate(credentials);
      if (session != null) {
        _currentSession = session;
        await _prefs.setBool(_rememberMeKey, session.rememberMe);
        _authController.add(_currentSession);
        return session.user;
      } else {
        throw Exception('invalid_credentials');
      }
    } on StateError catch (e) {
      // Handle specific database errors
      final message = e.message.toLowerCase();
      // Explicit invalid credentials case
      if (message == 'invalid_credentials') {
        throw Exception('invalid_credentials');
      } else if (message.contains('invalid credentials')) {
        throw Exception('invalid_credentials');
      } else if (message.contains('locked')) {
        throw Exception('account_locked');
      } else if (message.contains('disabled') || message.contains('inactive')) {
        throw Exception('account_disabled');
      } else {
        // Propagate other auth errors directly
        throw Exception(message);
      }
    } on ArgumentError {
      // Handle validation errors
      throw Exception('invalid_input');
    } catch (e) {
      // Handle network and other errors
      if (e.toString().contains('connection') ||
          e.toString().contains('network')) {
        throw Exception('network_error');
      } else if (e.toString().contains('timeout')) {
        throw Exception('timeout_error');
      } else if (e.toString().contains('database')) {
        throw Exception('database_error');
      } else {
        // Re-throw the exception as-is if it's already a user-friendly message
        if (e.toString().startsWith('Por favor,')) {
          rethrow;
        }
        throw Exception('server_error');
      }
    }
  }

  /// Register a new user - Enhanced error handling
  Future<AuthUser?> register(RegistrationCredentials credentials) async {
    try {
      // Enhanced input validation
      if (credentials.username.trim().isEmpty) {
        throw Exception('Por favor, digite um nome de usuário');
      }
      if (credentials.username.trim().length < 3) {
        throw Exception('O nome de usuário deve ter pelo menos 3 caracteres');
      }
      if (credentials.email.trim().isEmpty) {
        throw Exception('Por favor, digite seu e-mail');
      }
      if (credentials.password.isEmpty) {
        throw Exception('Por favor, digite uma senha');
      }
      if (credentials.password.length < 6) {
        throw Exception('password_too_short');
      }

      // Additional username format validation
      if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$')
          .hasMatch(credentials.username.trim())) {
        throw Exception('invalid_username_format');
      }

      // Additional email format validation
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(credentials.email.trim())) {
        throw Exception('invalid_email_format');
      }

      final user = await _authDatabaseService.register(
        username: credentials.username.trim(),
        email: credentials.email.trim(),
        password: credentials.password,
        displayName: credentials.displayName?.trim(),
      );

      if (user != null) {
        // Auto-login after successful registration
        final loginCredentials = LoginCredentials(
          username: credentials.username,
          password: credentials.password,
          rememberMe: false,
        );
        return await login(loginCredentials);
      } else {
        throw Exception('Registration failed');
      }
    } on StateError catch (e) {
      // Handle specific database errors
      final message = e.message.toLowerCase();
      if (message.contains('user already exists')) {
        throw Exception('user_already_exists');
      } else if (message.contains('username') && message.contains('exists')) {
        throw Exception('username_taken');
      } else if (message.contains('email') && message.contains('exists')) {
        throw Exception('email_taken');
      } else {
        throw Exception('Erro no registro: ${e.message}');
      }
    } on ArgumentError {
      // Handle validation errors - removed unused variable
      throw Exception('invalid_input');
    } catch (e) {
      // Handle network and other errors
      if (e.toString().contains('connection') ||
          e.toString().contains('network')) {
        throw Exception('network_error');
      } else if (e.toString().contains('timeout')) {
        throw Exception('timeout_error');
      } else if (e.toString().contains('database')) {
        throw Exception('database_error');
      } else {
        // Re-throw the exception as-is if it's already a user-friendly message
        if (e.toString().startsWith('Por favor,') ||
            e.toString().startsWith('O nome')) {
          rethrow;
        }
        throw Exception('server_error');
      }
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _authDatabaseService.logout();
      await clearSession();
    } catch (e) {
      // Even if logout fails on server, clear local session
      await clearSession();
      rethrow;
    }
  }

  /// Clear local session data
  Future<void> clearSession() async {
    _currentSession = null;
    _authController.add(null);
    await _prefs.remove(_rememberMeKey);
    // AuthDatabaseService handles its own session clearing in logout()
  }

  /// Validate current session
  Future<bool> validateSession() async {
    try {
      if (_currentSession == null) return false;

      if (!_currentSession!.isValid) {
        await clearSession();
        return false;
      }

      // Check session validity with database service
      final currentSession = await _authDatabaseService.getCurrentSession();
      if (currentSession == null || !currentSession.isValid) {
        await clearSession();
        return false;
      }

      return true;
    } catch (e) {
      await clearSession();
      return false;
    }
  }

  /// Refresh current session
  Future<bool> refreshSession() async {
    try {
      if (_currentSession == null) return false;

      final refreshed = await _authDatabaseService.refreshSession();
      if (!refreshed) {
        await clearSession();
        return false;
      }

      // Reload session to get updated expiry
      await _loadStoredSession();
      return true;
    } catch (e) {
      await clearSession();
      return false;
    }
  }

  /// Get stored remember me preference
  bool get rememberMePreference => _prefs.getBool(_rememberMeKey) ?? false;

  /// Dispose resources
  void dispose() {
    _authController.close();
  }
}
