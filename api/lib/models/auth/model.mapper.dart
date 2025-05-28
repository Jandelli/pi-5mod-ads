// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'model.dart';

class AuthDatabaseUserMapper extends ClassMapperBase<AuthDatabaseUser> {
  AuthDatabaseUserMapper._();

  static AuthDatabaseUserMapper? _instance;
  static AuthDatabaseUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthDatabaseUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthDatabaseUser';

  static Uint8List? _$id(AuthDatabaseUser v) => v.id;
  static const Field<AuthDatabaseUser, Uint8List> _f$id =
      Field('id', _$id, opt: true);
  static String _$username(AuthDatabaseUser v) => v.username;
  static const Field<AuthDatabaseUser, String> _f$username =
      Field('username', _$username);
  static String _$email(AuthDatabaseUser v) => v.email;
  static const Field<AuthDatabaseUser, String> _f$email =
      Field('email', _$email);
  static String _$passwordHash(AuthDatabaseUser v) => v.passwordHash;
  static const Field<AuthDatabaseUser, String> _f$passwordHash =
      Field('passwordHash', _$passwordHash);
  static String? _$displayName(AuthDatabaseUser v) => v.displayName;
  static const Field<AuthDatabaseUser, String> _f$displayName =
      Field('displayName', _$displayName, opt: true);
  static String? _$profileImage(AuthDatabaseUser v) => v.profileImage;
  static const Field<AuthDatabaseUser, String> _f$profileImage =
      Field('profileImage', _$profileImage, opt: true);
  static bool _$isActive(AuthDatabaseUser v) => v.isActive;
  static const Field<AuthDatabaseUser, bool> _f$isActive =
      Field('isActive', _$isActive, opt: true, def: true);
  static bool _$emailVerified(AuthDatabaseUser v) => v.emailVerified;
  static const Field<AuthDatabaseUser, bool> _f$emailVerified =
      Field('emailVerified', _$emailVerified, opt: true, def: false);
  static DateTime _$createdAt(AuthDatabaseUser v) => v.createdAt;
  static const Field<AuthDatabaseUser, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$updatedAt(AuthDatabaseUser v) => v.updatedAt;
  static const Field<AuthDatabaseUser, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt);
  static DateTime? _$lastLoginAt(AuthDatabaseUser v) => v.lastLoginAt;
  static const Field<AuthDatabaseUser, DateTime> _f$lastLoginAt =
      Field('lastLoginAt', _$lastLoginAt, opt: true);
  static String? _$resetToken(AuthDatabaseUser v) => v.resetToken;
  static const Field<AuthDatabaseUser, String> _f$resetToken =
      Field('resetToken', _$resetToken, opt: true);
  static DateTime? _$resetTokenExpiry(AuthDatabaseUser v) => v.resetTokenExpiry;
  static const Field<AuthDatabaseUser, DateTime> _f$resetTokenExpiry =
      Field('resetTokenExpiry', _$resetTokenExpiry, opt: true);
  static int _$failedLoginAttempts(AuthDatabaseUser v) => v.failedLoginAttempts;
  static const Field<AuthDatabaseUser, int> _f$failedLoginAttempts =
      Field('failedLoginAttempts', _$failedLoginAttempts, opt: true, def: 0);
  static DateTime? _$lockedUntil(AuthDatabaseUser v) => v.lockedUntil;
  static const Field<AuthDatabaseUser, DateTime> _f$lockedUntil =
      Field('lockedUntil', _$lockedUntil, opt: true);

  @override
  final MappableFields<AuthDatabaseUser> fields = const {
    #id: _f$id,
    #username: _f$username,
    #email: _f$email,
    #passwordHash: _f$passwordHash,
    #displayName: _f$displayName,
    #profileImage: _f$profileImage,
    #isActive: _f$isActive,
    #emailVerified: _f$emailVerified,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #lastLoginAt: _f$lastLoginAt,
    #resetToken: _f$resetToken,
    #resetTokenExpiry: _f$resetTokenExpiry,
    #failedLoginAttempts: _f$failedLoginAttempts,
    #lockedUntil: _f$lockedUntil,
  };

  static AuthDatabaseUser _instantiate(DecodingData data) {
    return AuthDatabaseUser(
        id: data.dec(_f$id),
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        passwordHash: data.dec(_f$passwordHash),
        displayName: data.dec(_f$displayName),
        profileImage: data.dec(_f$profileImage),
        isActive: data.dec(_f$isActive),
        emailVerified: data.dec(_f$emailVerified),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        lastLoginAt: data.dec(_f$lastLoginAt),
        resetToken: data.dec(_f$resetToken),
        resetTokenExpiry: data.dec(_f$resetTokenExpiry),
        failedLoginAttempts: data.dec(_f$failedLoginAttempts),
        lockedUntil: data.dec(_f$lockedUntil));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthDatabaseUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthDatabaseUser>(map);
  }

  static AuthDatabaseUser fromJson(String json) {
    return ensureInitialized().decodeJson<AuthDatabaseUser>(json);
  }
}

mixin AuthDatabaseUserMappable {
  String toJson() {
    return AuthDatabaseUserMapper.ensureInitialized()
        .encodeJson<AuthDatabaseUser>(this as AuthDatabaseUser);
  }

  Map<String, dynamic> toMap() {
    return AuthDatabaseUserMapper.ensureInitialized()
        .encodeMap<AuthDatabaseUser>(this as AuthDatabaseUser);
  }

  AuthDatabaseUserCopyWith<AuthDatabaseUser, AuthDatabaseUser, AuthDatabaseUser>
      get copyWith =>
          _AuthDatabaseUserCopyWithImpl<AuthDatabaseUser, AuthDatabaseUser>(
              this as AuthDatabaseUser, $identity, $identity);
  @override
  String toString() {
    return AuthDatabaseUserMapper.ensureInitialized()
        .stringifyValue(this as AuthDatabaseUser);
  }

  @override
  bool operator ==(Object other) {
    return AuthDatabaseUserMapper.ensureInitialized()
        .equalsValue(this as AuthDatabaseUser, other);
  }

  @override
  int get hashCode {
    return AuthDatabaseUserMapper.ensureInitialized()
        .hashValue(this as AuthDatabaseUser);
  }
}

extension AuthDatabaseUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthDatabaseUser, $Out> {
  AuthDatabaseUserCopyWith<$R, AuthDatabaseUser, $Out>
      get $asAuthDatabaseUser => $base
          .as((v, t, t2) => _AuthDatabaseUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthDatabaseUserCopyWith<$R, $In extends AuthDatabaseUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {Uint8List? id,
      String? username,
      String? email,
      String? passwordHash,
      String? displayName,
      String? profileImage,
      bool? isActive,
      bool? emailVerified,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastLoginAt,
      String? resetToken,
      DateTime? resetTokenExpiry,
      int? failedLoginAttempts,
      DateTime? lockedUntil});
  AuthDatabaseUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthDatabaseUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthDatabaseUser, $Out>
    implements AuthDatabaseUserCopyWith<$R, AuthDatabaseUser, $Out> {
  _AuthDatabaseUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthDatabaseUser> $mapper =
      AuthDatabaseUserMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          String? username,
          String? email,
          String? passwordHash,
          Object? displayName = $none,
          Object? profileImage = $none,
          bool? isActive,
          bool? emailVerified,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? lastLoginAt = $none,
          Object? resetToken = $none,
          Object? resetTokenExpiry = $none,
          int? failedLoginAttempts,
          Object? lockedUntil = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (username != null) #username: username,
        if (email != null) #email: email,
        if (passwordHash != null) #passwordHash: passwordHash,
        if (displayName != $none) #displayName: displayName,
        if (profileImage != $none) #profileImage: profileImage,
        if (isActive != null) #isActive: isActive,
        if (emailVerified != null) #emailVerified: emailVerified,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (lastLoginAt != $none) #lastLoginAt: lastLoginAt,
        if (resetToken != $none) #resetToken: resetToken,
        if (resetTokenExpiry != $none) #resetTokenExpiry: resetTokenExpiry,
        if (failedLoginAttempts != null)
          #failedLoginAttempts: failedLoginAttempts,
        if (lockedUntil != $none) #lockedUntil: lockedUntil
      }));
  @override
  AuthDatabaseUser $make(CopyWithData data) => AuthDatabaseUser(
      id: data.get(#id, or: $value.id),
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      passwordHash: data.get(#passwordHash, or: $value.passwordHash),
      displayName: data.get(#displayName, or: $value.displayName),
      profileImage: data.get(#profileImage, or: $value.profileImage),
      isActive: data.get(#isActive, or: $value.isActive),
      emailVerified: data.get(#emailVerified, or: $value.emailVerified),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      lastLoginAt: data.get(#lastLoginAt, or: $value.lastLoginAt),
      resetToken: data.get(#resetToken, or: $value.resetToken),
      resetTokenExpiry:
          data.get(#resetTokenExpiry, or: $value.resetTokenExpiry),
      failedLoginAttempts:
          data.get(#failedLoginAttempts, or: $value.failedLoginAttempts),
      lockedUntil: data.get(#lockedUntil, or: $value.lockedUntil));

  @override
  AuthDatabaseUserCopyWith<$R2, AuthDatabaseUser, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthDatabaseUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthDatabaseSessionMapper extends ClassMapperBase<AuthDatabaseSession> {
  AuthDatabaseSessionMapper._();

  static AuthDatabaseSessionMapper? _instance;
  static AuthDatabaseSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthDatabaseSessionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthDatabaseSession';

  static Uint8List? _$id(AuthDatabaseSession v) => v.id;
  static const Field<AuthDatabaseSession, Uint8List> _f$id =
      Field('id', _$id, opt: true);
  static Uint8List _$userId(AuthDatabaseSession v) => v.userId;
  static const Field<AuthDatabaseSession, Uint8List> _f$userId =
      Field('userId', _$userId);
  static String _$token(AuthDatabaseSession v) => v.token;
  static const Field<AuthDatabaseSession, String> _f$token =
      Field('token', _$token);
  static String _$deviceInfo(AuthDatabaseSession v) => v.deviceInfo;
  static const Field<AuthDatabaseSession, String> _f$deviceInfo =
      Field('deviceInfo', _$deviceInfo);
  static String? _$ipAddress(AuthDatabaseSession v) => v.ipAddress;
  static const Field<AuthDatabaseSession, String> _f$ipAddress =
      Field('ipAddress', _$ipAddress, opt: true);
  static DateTime _$createdAt(AuthDatabaseSession v) => v.createdAt;
  static const Field<AuthDatabaseSession, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$expiresAt(AuthDatabaseSession v) => v.expiresAt;
  static const Field<AuthDatabaseSession, DateTime> _f$expiresAt =
      Field('expiresAt', _$expiresAt);
  static DateTime? _$lastAccessedAt(AuthDatabaseSession v) => v.lastAccessedAt;
  static const Field<AuthDatabaseSession, DateTime> _f$lastAccessedAt =
      Field('lastAccessedAt', _$lastAccessedAt, opt: true);
  static bool _$isActive(AuthDatabaseSession v) => v.isActive;
  static const Field<AuthDatabaseSession, bool> _f$isActive =
      Field('isActive', _$isActive, opt: true, def: true);

  @override
  final MappableFields<AuthDatabaseSession> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #token: _f$token,
    #deviceInfo: _f$deviceInfo,
    #ipAddress: _f$ipAddress,
    #createdAt: _f$createdAt,
    #expiresAt: _f$expiresAt,
    #lastAccessedAt: _f$lastAccessedAt,
    #isActive: _f$isActive,
  };

  static AuthDatabaseSession _instantiate(DecodingData data) {
    return AuthDatabaseSession(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        token: data.dec(_f$token),
        deviceInfo: data.dec(_f$deviceInfo),
        ipAddress: data.dec(_f$ipAddress),
        createdAt: data.dec(_f$createdAt),
        expiresAt: data.dec(_f$expiresAt),
        lastAccessedAt: data.dec(_f$lastAccessedAt),
        isActive: data.dec(_f$isActive));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthDatabaseSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthDatabaseSession>(map);
  }

  static AuthDatabaseSession fromJson(String json) {
    return ensureInitialized().decodeJson<AuthDatabaseSession>(json);
  }
}

mixin AuthDatabaseSessionMappable {
  String toJson() {
    return AuthDatabaseSessionMapper.ensureInitialized()
        .encodeJson<AuthDatabaseSession>(this as AuthDatabaseSession);
  }

  Map<String, dynamic> toMap() {
    return AuthDatabaseSessionMapper.ensureInitialized()
        .encodeMap<AuthDatabaseSession>(this as AuthDatabaseSession);
  }

  AuthDatabaseSessionCopyWith<AuthDatabaseSession, AuthDatabaseSession,
      AuthDatabaseSession> get copyWith => _AuthDatabaseSessionCopyWithImpl<
          AuthDatabaseSession, AuthDatabaseSession>(
      this as AuthDatabaseSession, $identity, $identity);
  @override
  String toString() {
    return AuthDatabaseSessionMapper.ensureInitialized()
        .stringifyValue(this as AuthDatabaseSession);
  }

  @override
  bool operator ==(Object other) {
    return AuthDatabaseSessionMapper.ensureInitialized()
        .equalsValue(this as AuthDatabaseSession, other);
  }

  @override
  int get hashCode {
    return AuthDatabaseSessionMapper.ensureInitialized()
        .hashValue(this as AuthDatabaseSession);
  }
}

extension AuthDatabaseSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthDatabaseSession, $Out> {
  AuthDatabaseSessionCopyWith<$R, AuthDatabaseSession, $Out>
      get $asAuthDatabaseSession => $base.as(
          (v, t, t2) => _AuthDatabaseSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthDatabaseSessionCopyWith<$R, $In extends AuthDatabaseSession,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {Uint8List? id,
      Uint8List? userId,
      String? token,
      String? deviceInfo,
      String? ipAddress,
      DateTime? createdAt,
      DateTime? expiresAt,
      DateTime? lastAccessedAt,
      bool? isActive});
  AuthDatabaseSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthDatabaseSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthDatabaseSession, $Out>
    implements AuthDatabaseSessionCopyWith<$R, AuthDatabaseSession, $Out> {
  _AuthDatabaseSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthDatabaseSession> $mapper =
      AuthDatabaseSessionMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          Uint8List? userId,
          String? token,
          String? deviceInfo,
          Object? ipAddress = $none,
          DateTime? createdAt,
          DateTime? expiresAt,
          Object? lastAccessedAt = $none,
          bool? isActive}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (userId != null) #userId: userId,
        if (token != null) #token: token,
        if (deviceInfo != null) #deviceInfo: deviceInfo,
        if (ipAddress != $none) #ipAddress: ipAddress,
        if (createdAt != null) #createdAt: createdAt,
        if (expiresAt != null) #expiresAt: expiresAt,
        if (lastAccessedAt != $none) #lastAccessedAt: lastAccessedAt,
        if (isActive != null) #isActive: isActive
      }));
  @override
  AuthDatabaseSession $make(CopyWithData data) => AuthDatabaseSession(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      token: data.get(#token, or: $value.token),
      deviceInfo: data.get(#deviceInfo, or: $value.deviceInfo),
      ipAddress: data.get(#ipAddress, or: $value.ipAddress),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      expiresAt: data.get(#expiresAt, or: $value.expiresAt),
      lastAccessedAt: data.get(#lastAccessedAt, or: $value.lastAccessedAt),
      isActive: data.get(#isActive, or: $value.isActive));

  @override
  AuthDatabaseSessionCopyWith<$R2, AuthDatabaseSession, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AuthDatabaseSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthDatabaseRoleMapper extends ClassMapperBase<AuthDatabaseRole> {
  AuthDatabaseRoleMapper._();

  static AuthDatabaseRoleMapper? _instance;
  static AuthDatabaseRoleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthDatabaseRoleMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthDatabaseRole';

  static Uint8List? _$id(AuthDatabaseRole v) => v.id;
  static const Field<AuthDatabaseRole, Uint8List> _f$id =
      Field('id', _$id, opt: true);
  static String _$name(AuthDatabaseRole v) => v.name;
  static const Field<AuthDatabaseRole, String> _f$name = Field('name', _$name);
  static String? _$description(AuthDatabaseRole v) => v.description;
  static const Field<AuthDatabaseRole, String> _f$description =
      Field('description', _$description, opt: true);
  static List<String> _$permissions(AuthDatabaseRole v) => v.permissions;
  static const Field<AuthDatabaseRole, List<String>> _f$permissions =
      Field('permissions', _$permissions, opt: true, def: const []);
  static DateTime _$createdAt(AuthDatabaseRole v) => v.createdAt;
  static const Field<AuthDatabaseRole, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);

  @override
  final MappableFields<AuthDatabaseRole> fields = const {
    #id: _f$id,
    #name: _f$name,
    #description: _f$description,
    #permissions: _f$permissions,
    #createdAt: _f$createdAt,
  };

  static AuthDatabaseRole _instantiate(DecodingData data) {
    return AuthDatabaseRole(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        description: data.dec(_f$description),
        permissions: data.dec(_f$permissions),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthDatabaseRole fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthDatabaseRole>(map);
  }

  static AuthDatabaseRole fromJson(String json) {
    return ensureInitialized().decodeJson<AuthDatabaseRole>(json);
  }
}

mixin AuthDatabaseRoleMappable {
  String toJson() {
    return AuthDatabaseRoleMapper.ensureInitialized()
        .encodeJson<AuthDatabaseRole>(this as AuthDatabaseRole);
  }

  Map<String, dynamic> toMap() {
    return AuthDatabaseRoleMapper.ensureInitialized()
        .encodeMap<AuthDatabaseRole>(this as AuthDatabaseRole);
  }

  AuthDatabaseRoleCopyWith<AuthDatabaseRole, AuthDatabaseRole, AuthDatabaseRole>
      get copyWith =>
          _AuthDatabaseRoleCopyWithImpl<AuthDatabaseRole, AuthDatabaseRole>(
              this as AuthDatabaseRole, $identity, $identity);
  @override
  String toString() {
    return AuthDatabaseRoleMapper.ensureInitialized()
        .stringifyValue(this as AuthDatabaseRole);
  }

  @override
  bool operator ==(Object other) {
    return AuthDatabaseRoleMapper.ensureInitialized()
        .equalsValue(this as AuthDatabaseRole, other);
  }

  @override
  int get hashCode {
    return AuthDatabaseRoleMapper.ensureInitialized()
        .hashValue(this as AuthDatabaseRole);
  }
}

extension AuthDatabaseRoleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthDatabaseRole, $Out> {
  AuthDatabaseRoleCopyWith<$R, AuthDatabaseRole, $Out>
      get $asAuthDatabaseRole => $base
          .as((v, t, t2) => _AuthDatabaseRoleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthDatabaseRoleCopyWith<$R, $In extends AuthDatabaseRole, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get permissions;
  $R call(
      {Uint8List? id,
      String? name,
      String? description,
      List<String>? permissions,
      DateTime? createdAt});
  AuthDatabaseRoleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthDatabaseRoleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthDatabaseRole, $Out>
    implements AuthDatabaseRoleCopyWith<$R, AuthDatabaseRole, $Out> {
  _AuthDatabaseRoleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthDatabaseRole> $mapper =
      AuthDatabaseRoleMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
      get permissions => ListCopyWith(
          $value.permissions,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(permissions: v));
  @override
  $R call(
          {Object? id = $none,
          String? name,
          Object? description = $none,
          List<String>? permissions,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (name != null) #name: name,
        if (description != $none) #description: description,
        if (permissions != null) #permissions: permissions,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  AuthDatabaseRole $make(CopyWithData data) => AuthDatabaseRole(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      description: data.get(#description, or: $value.description),
      permissions: data.get(#permissions, or: $value.permissions),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  AuthDatabaseRoleCopyWith<$R2, AuthDatabaseRole, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthDatabaseRoleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthDatabaseCredentialsMapper
    extends ClassMapperBase<AuthDatabaseCredentials> {
  AuthDatabaseCredentialsMapper._();

  static AuthDatabaseCredentialsMapper? _instance;
  static AuthDatabaseCredentialsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AuthDatabaseCredentialsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthDatabaseCredentials';

  static String _$username(AuthDatabaseCredentials v) => v.username;
  static const Field<AuthDatabaseCredentials, String> _f$username =
      Field('username', _$username);
  static String _$password(AuthDatabaseCredentials v) => v.password;
  static const Field<AuthDatabaseCredentials, String> _f$password =
      Field('password', _$password);
  static bool _$rememberMe(AuthDatabaseCredentials v) => v.rememberMe;
  static const Field<AuthDatabaseCredentials, bool> _f$rememberMe =
      Field('rememberMe', _$rememberMe, opt: true, def: false);
  static String _$deviceInfo(AuthDatabaseCredentials v) => v.deviceInfo;
  static const Field<AuthDatabaseCredentials, String> _f$deviceInfo =
      Field('deviceInfo', _$deviceInfo);
  static String? _$ipAddress(AuthDatabaseCredentials v) => v.ipAddress;
  static const Field<AuthDatabaseCredentials, String> _f$ipAddress =
      Field('ipAddress', _$ipAddress, opt: true);

  @override
  final MappableFields<AuthDatabaseCredentials> fields = const {
    #username: _f$username,
    #password: _f$password,
    #rememberMe: _f$rememberMe,
    #deviceInfo: _f$deviceInfo,
    #ipAddress: _f$ipAddress,
  };

  static AuthDatabaseCredentials _instantiate(DecodingData data) {
    return AuthDatabaseCredentials(
        username: data.dec(_f$username),
        password: data.dec(_f$password),
        rememberMe: data.dec(_f$rememberMe),
        deviceInfo: data.dec(_f$deviceInfo),
        ipAddress: data.dec(_f$ipAddress));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthDatabaseCredentials fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthDatabaseCredentials>(map);
  }

  static AuthDatabaseCredentials fromJson(String json) {
    return ensureInitialized().decodeJson<AuthDatabaseCredentials>(json);
  }
}

mixin AuthDatabaseCredentialsMappable {
  String toJson() {
    return AuthDatabaseCredentialsMapper.ensureInitialized()
        .encodeJson<AuthDatabaseCredentials>(this as AuthDatabaseCredentials);
  }

  Map<String, dynamic> toMap() {
    return AuthDatabaseCredentialsMapper.ensureInitialized()
        .encodeMap<AuthDatabaseCredentials>(this as AuthDatabaseCredentials);
  }

  AuthDatabaseCredentialsCopyWith<AuthDatabaseCredentials,
          AuthDatabaseCredentials, AuthDatabaseCredentials>
      get copyWith => _AuthDatabaseCredentialsCopyWithImpl<
              AuthDatabaseCredentials, AuthDatabaseCredentials>(
          this as AuthDatabaseCredentials, $identity, $identity);
  @override
  String toString() {
    return AuthDatabaseCredentialsMapper.ensureInitialized()
        .stringifyValue(this as AuthDatabaseCredentials);
  }

  @override
  bool operator ==(Object other) {
    return AuthDatabaseCredentialsMapper.ensureInitialized()
        .equalsValue(this as AuthDatabaseCredentials, other);
  }

  @override
  int get hashCode {
    return AuthDatabaseCredentialsMapper.ensureInitialized()
        .hashValue(this as AuthDatabaseCredentials);
  }
}

extension AuthDatabaseCredentialsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthDatabaseCredentials, $Out> {
  AuthDatabaseCredentialsCopyWith<$R, AuthDatabaseCredentials, $Out>
      get $asAuthDatabaseCredentials => $base.as((v, t, t2) =>
          _AuthDatabaseCredentialsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthDatabaseCredentialsCopyWith<
    $R,
    $In extends AuthDatabaseCredentials,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? username,
      String? password,
      bool? rememberMe,
      String? deviceInfo,
      String? ipAddress});
  AuthDatabaseCredentialsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthDatabaseCredentialsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthDatabaseCredentials, $Out>
    implements
        AuthDatabaseCredentialsCopyWith<$R, AuthDatabaseCredentials, $Out> {
  _AuthDatabaseCredentialsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthDatabaseCredentials> $mapper =
      AuthDatabaseCredentialsMapper.ensureInitialized();
  @override
  $R call(
          {String? username,
          String? password,
          bool? rememberMe,
          String? deviceInfo,
          Object? ipAddress = $none}) =>
      $apply(FieldCopyWithData({
        if (username != null) #username: username,
        if (password != null) #password: password,
        if (rememberMe != null) #rememberMe: rememberMe,
        if (deviceInfo != null) #deviceInfo: deviceInfo,
        if (ipAddress != $none) #ipAddress: ipAddress
      }));
  @override
  AuthDatabaseCredentials $make(CopyWithData data) => AuthDatabaseCredentials(
      username: data.get(#username, or: $value.username),
      password: data.get(#password, or: $value.password),
      rememberMe: data.get(#rememberMe, or: $value.rememberMe),
      deviceInfo: data.get(#deviceInfo, or: $value.deviceInfo),
      ipAddress: data.get(#ipAddress, or: $value.ipAddress));

  @override
  AuthDatabaseCredentialsCopyWith<$R2, AuthDatabaseCredentials, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AuthDatabaseCredentialsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthDatabaseRegistrationMapper
    extends ClassMapperBase<AuthDatabaseRegistration> {
  AuthDatabaseRegistrationMapper._();

  static AuthDatabaseRegistrationMapper? _instance;
  static AuthDatabaseRegistrationMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = AuthDatabaseRegistrationMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthDatabaseRegistration';

  static String _$username(AuthDatabaseRegistration v) => v.username;
  static const Field<AuthDatabaseRegistration, String> _f$username =
      Field('username', _$username);
  static String _$email(AuthDatabaseRegistration v) => v.email;
  static const Field<AuthDatabaseRegistration, String> _f$email =
      Field('email', _$email);
  static String _$password(AuthDatabaseRegistration v) => v.password;
  static const Field<AuthDatabaseRegistration, String> _f$password =
      Field('password', _$password);
  static String? _$displayName(AuthDatabaseRegistration v) => v.displayName;
  static const Field<AuthDatabaseRegistration, String> _f$displayName =
      Field('displayName', _$displayName, opt: true);

  @override
  final MappableFields<AuthDatabaseRegistration> fields = const {
    #username: _f$username,
    #email: _f$email,
    #password: _f$password,
    #displayName: _f$displayName,
  };

  static AuthDatabaseRegistration _instantiate(DecodingData data) {
    return AuthDatabaseRegistration(
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        password: data.dec(_f$password),
        displayName: data.dec(_f$displayName));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthDatabaseRegistration fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthDatabaseRegistration>(map);
  }

  static AuthDatabaseRegistration fromJson(String json) {
    return ensureInitialized().decodeJson<AuthDatabaseRegistration>(json);
  }
}

mixin AuthDatabaseRegistrationMappable {
  String toJson() {
    return AuthDatabaseRegistrationMapper.ensureInitialized()
        .encodeJson<AuthDatabaseRegistration>(this as AuthDatabaseRegistration);
  }

  Map<String, dynamic> toMap() {
    return AuthDatabaseRegistrationMapper.ensureInitialized()
        .encodeMap<AuthDatabaseRegistration>(this as AuthDatabaseRegistration);
  }

  AuthDatabaseRegistrationCopyWith<AuthDatabaseRegistration,
          AuthDatabaseRegistration, AuthDatabaseRegistration>
      get copyWith => _AuthDatabaseRegistrationCopyWithImpl<
              AuthDatabaseRegistration, AuthDatabaseRegistration>(
          this as AuthDatabaseRegistration, $identity, $identity);
  @override
  String toString() {
    return AuthDatabaseRegistrationMapper.ensureInitialized()
        .stringifyValue(this as AuthDatabaseRegistration);
  }

  @override
  bool operator ==(Object other) {
    return AuthDatabaseRegistrationMapper.ensureInitialized()
        .equalsValue(this as AuthDatabaseRegistration, other);
  }

  @override
  int get hashCode {
    return AuthDatabaseRegistrationMapper.ensureInitialized()
        .hashValue(this as AuthDatabaseRegistration);
  }
}

extension AuthDatabaseRegistrationValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthDatabaseRegistration, $Out> {
  AuthDatabaseRegistrationCopyWith<$R, AuthDatabaseRegistration, $Out>
      get $asAuthDatabaseRegistration => $base.as((v, t, t2) =>
          _AuthDatabaseRegistrationCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthDatabaseRegistrationCopyWith<
    $R,
    $In extends AuthDatabaseRegistration,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? username, String? email, String? password, String? displayName});
  AuthDatabaseRegistrationCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthDatabaseRegistrationCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthDatabaseRegistration, $Out>
    implements
        AuthDatabaseRegistrationCopyWith<$R, AuthDatabaseRegistration, $Out> {
  _AuthDatabaseRegistrationCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthDatabaseRegistration> $mapper =
      AuthDatabaseRegistrationMapper.ensureInitialized();
  @override
  $R call(
          {String? username,
          String? email,
          String? password,
          Object? displayName = $none}) =>
      $apply(FieldCopyWithData({
        if (username != null) #username: username,
        if (email != null) #email: email,
        if (password != null) #password: password,
        if (displayName != $none) #displayName: displayName
      }));
  @override
  AuthDatabaseRegistration $make(CopyWithData data) => AuthDatabaseRegistration(
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password),
      displayName: data.get(#displayName, or: $value.displayName));

  @override
  AuthDatabaseRegistrationCopyWith<$R2, AuthDatabaseRegistration, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AuthDatabaseRegistrationCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
