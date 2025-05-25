import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class AuthUser with AuthUserMappable {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? profileImage;
  final List<String> roles;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.profileImage,
    this.roles = const ['user'],
    required this.createdAt,
    required this.lastLoginAt,
  });

  String get name => displayName ?? username;

  bool hasRole(String role) => roles.contains(role);
  bool get isAdmin => hasRole('admin');
}

@MappableClass()
class LoginCredentials with LoginCredentialsMappable {
  final String username;
  final String password;
  final bool rememberMe;

  const LoginCredentials({
    required this.username,
    required this.password,
    this.rememberMe = false,
  });
}

@MappableClass()
class AuthSession with AuthSessionMappable {
  final String token;
  final AuthUser user;
  final DateTime expiresAt;
  final bool rememberMe;

  const AuthSession({
    required this.token,
    required this.user,
    required this.expiresAt,
    this.rememberMe = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isExpired;
}
