import 'dart:async';
import 'dart:typed_data';
import 'package:flow_api/services/source.dart';
import 'model.dart';

abstract class AuthDatabaseService extends ModelService {
  // User management
  FutureOr<AuthDatabaseUser?> createUser(AuthDatabaseRegistration registration);
  FutureOr<AuthDatabaseUser?> getUserById(Uint8List id);
  FutureOr<AuthDatabaseUser?> getUserByUsername(String username);
  FutureOr<AuthDatabaseUser?> getUserByEmail(String email);
  FutureOr<bool> updateUser(AuthDatabaseUser user);
  FutureOr<bool> deleteUser(Uint8List id);
  FutureOr<List<AuthDatabaseUser>> getUsers({
    int offset = 0,
    int limit = 50,
    String search = '',
    bool? isActive,
  });

  // Authentication
  FutureOr<AuthDatabaseSession?> authenticate(
      AuthDatabaseCredentials credentials);
  FutureOr<bool> verifyPassword(String username, String password);
  FutureOr<bool> changePassword(
      Uint8List userId, String currentPassword, String newPassword);
  FutureOr<String?> generatePasswordResetToken(String email);
  FutureOr<bool> resetPassword(String token, String newPassword);

  // Session management
  FutureOr<AuthDatabaseSession?> createSession(
      AuthDatabaseUser user, AuthDatabaseCredentials credentials);
  FutureOr<AuthDatabaseSession?> getSessionByToken(String token);
  FutureOr<bool> validateSession(String token);
  FutureOr<bool> refreshSession(String token);
  FutureOr<bool> invalidateSession(String token);
  FutureOr<bool> invalidateAllUserSessions(Uint8List userId);
  FutureOr<List<AuthDatabaseSession>> getUserSessions(Uint8List userId);
  FutureOr<void> cleanupExpiredSessions();

  // Role management
  FutureOr<AuthDatabaseRole?> createRole(AuthDatabaseRole role);
  FutureOr<AuthDatabaseRole?> getRoleById(Uint8List id);
  FutureOr<AuthDatabaseRole?> getRoleByName(String name);
  FutureOr<bool> updateRole(AuthDatabaseRole role);
  FutureOr<bool> deleteRole(Uint8List id);
  FutureOr<List<AuthDatabaseRole>> getRoles();

  // User-Role assignments
  FutureOr<bool> assignRoleToUser(Uint8List userId, Uint8List roleId);
  FutureOr<bool> removeRoleFromUser(Uint8List userId, Uint8List roleId);
  FutureOr<List<AuthDatabaseRole>> getUserRoles(Uint8List userId);
  FutureOr<List<AuthDatabaseUser>> getUsersWithRole(Uint8List roleId);
  FutureOr<bool> userHasPermission(Uint8List userId, String permission);

  // Security utilities
  FutureOr<bool> lockUser(Uint8List userId, Duration lockDuration);
  FutureOr<bool> unlockUser(Uint8List userId);
  FutureOr<bool> incrementFailedLoginAttempts(Uint8List userId);
  FutureOr<bool> resetFailedLoginAttempts(Uint8List userId);
}
