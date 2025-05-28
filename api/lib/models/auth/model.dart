import 'dart:typed_data';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flow_api/models/model.dart';

part 'model.mapper.dart';

@MappableClass()
class AuthDatabaseUser with AuthDatabaseUserMappable, IdentifiedModel {
  @override
  final Uint8List? id;
  final String username;
  final String email;
  final String passwordHash;
  final String? displayName;
  final String? profileImage;
  final bool isActive;
  final bool emailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final String? resetToken;
  final DateTime? resetTokenExpiry;
  final int failedLoginAttempts;
  final DateTime? lockedUntil;

  const AuthDatabaseUser({
    this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.displayName,
    this.profileImage,
    this.isActive = true,
    this.emailVerified = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.resetToken,
    this.resetTokenExpiry,
    this.failedLoginAttempts = 0,
    this.lockedUntil,
  });

  factory AuthDatabaseUser.fromDatabase(Map<String, dynamic> row) =>
      AuthDatabaseUserMapper.fromMap({
        'id': row['id'],
        'username': row['username'],
        'email': row['email'],
        'passwordHash': row['password_hash'],
        'displayName': row['display_name'],
        'profileImage': row['profile_image'],
        // Convert integer fields back to booleans
        'isActive': (row['is_active'] ?? 1) == 1,
        'emailVerified': (row['email_verified'] ?? 0) == 1,
        // Convert timestamp fields back to DateTime
        'createdAt':
            DateTime.fromMillisecondsSinceEpoch(row['created_at'] ?? 0),
        'updatedAt':
            DateTime.fromMillisecondsSinceEpoch(row['updated_at'] ?? 0),
        'lastLoginAt': row['last_login_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['last_login_at'])
            : null,
        'resetToken': row['reset_token'],
        'resetTokenExpiry': row['reset_token_expiry'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['reset_token_expiry'])
            : null,
        'failedLoginAttempts': row['failed_login_attempts'] ?? 0,
        'lockedUntil': row['locked_until'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['locked_until'])
            : null,
      });

  Map<String, dynamic> toDatabase() => {
        'id': id,
        'username': username,
        'email': email,
        'password_hash': passwordHash,
        'display_name': displayName,
        'profile_image': profileImage,
        'is_active': isActive ? 1 : 0,
        'email_verified': emailVerified ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
        'updated_at': updatedAt.millisecondsSinceEpoch,
        'last_login_at': lastLoginAt?.millisecondsSinceEpoch,
        'reset_token': resetToken,
        'reset_token_expiry': resetTokenExpiry?.millisecondsSinceEpoch,
        'failed_login_attempts': failedLoginAttempts,
        'locked_until': lockedUntil?.millisecondsSinceEpoch,
      };

  bool get isLocked =>
      lockedUntil != null && DateTime.now().isBefore(lockedUntil!);
  bool get isResetTokenValid =>
      resetToken != null &&
      resetTokenExpiry != null &&
      DateTime.now().isBefore(resetTokenExpiry!);
}

@MappableClass()
class AuthDatabaseSession with AuthDatabaseSessionMappable, IdentifiedModel {
  @override
  final Uint8List? id;
  final Uint8List userId;
  final String token;
  final String deviceInfo;
  final String? ipAddress;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? lastAccessedAt;
  final bool isActive;

  const AuthDatabaseSession({
    this.id,
    required this.userId,
    required this.token,
    required this.deviceInfo,
    this.ipAddress,
    required this.createdAt,
    required this.expiresAt,
    this.lastAccessedAt,
    this.isActive = true,
  });

  factory AuthDatabaseSession.fromDatabase(Map<String, dynamic> row) =>
      AuthDatabaseSessionMapper.fromMap({
        'id': row['id'],
        'userId': row['user_id'],
        'token': row['token'],
        'deviceInfo': row['device_info'],
        'ipAddress': row['ip_address'],
        // Convert integer field back to boolean
        'isActive': (row['is_active'] ?? 1) == 1,
        // Convert timestamp fields back to DateTime
        'createdAt':
            DateTime.fromMillisecondsSinceEpoch(row['created_at'] ?? 0),
        'expiresAt':
            DateTime.fromMillisecondsSinceEpoch(row['expires_at'] ?? 0),
        'lastAccessedAt': row['last_accessed_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['last_accessed_at'])
            : null,
      });

  Map<String, dynamic> toDatabase() => {
        'id': id,
        'user_id': userId,
        'token': token,
        'device_info': deviceInfo,
        'ip_address': ipAddress,
        'is_active': isActive ? 1 : 0,
        'created_at': createdAt.millisecondsSinceEpoch,
        'expires_at': expiresAt.millisecondsSinceEpoch,
        'last_accessed_at': lastAccessedAt?.millisecondsSinceEpoch,
      };

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => isActive && !isExpired;
}

@MappableClass()
class AuthDatabaseRole with AuthDatabaseRoleMappable, IdentifiedModel {
  @override
  final Uint8List? id;
  final String name;
  final String? description;
  final List<String> permissions;
  final DateTime createdAt;

  const AuthDatabaseRole({
    this.id,
    required this.name,
    this.description,
    this.permissions = const [],
    required this.createdAt,
  });

  factory AuthDatabaseRole.fromDatabase(Map<String, dynamic> row) =>
      AuthDatabaseRoleMapper.fromMap({
        'id': row['id'],
        'name': row['name'],
        'description': row['description'],
        'permissions': (row['permissions'] as String?)?.split(',') ?? [],
        'createdAt':
            DateTime.fromMillisecondsSinceEpoch(row['created_at'] ?? 0),
      });

  Map<String, dynamic> toDatabase() => {
        'id': id,
        'name': name,
        'description': description,
        'permissions': permissions.join(','),
        'created_at': createdAt.millisecondsSinceEpoch,
      };
}

@MappableClass()
class AuthDatabaseCredentials with AuthDatabaseCredentialsMappable {
  final String username;
  final String password;
  final bool rememberMe;
  final String deviceInfo;
  final String? ipAddress;

  const AuthDatabaseCredentials({
    required this.username,
    required this.password,
    this.rememberMe = false,
    required this.deviceInfo,
    this.ipAddress,
  });
}

@MappableClass()
class AuthDatabaseRegistration with AuthDatabaseRegistrationMappable {
  final String username;
  final String email;
  final String password;
  final String? displayName;

  const AuthDatabaseRegistration({
    required this.username,
    required this.email,
    required this.password,
    this.displayName,
  });
}
