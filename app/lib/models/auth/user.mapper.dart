// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user.dart';

class AuthUserMapper extends ClassMapperBase<AuthUser> {
  AuthUserMapper._();

  static AuthUserMapper? _instance;
  static AuthUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthUser';

  static String _$id(AuthUser v) => v.id;
  static const Field<AuthUser, String> _f$id = Field('id', _$id);
  static String _$username(AuthUser v) => v.username;
  static const Field<AuthUser, String> _f$username =
      Field('username', _$username);
  static String _$email(AuthUser v) => v.email;
  static const Field<AuthUser, String> _f$email = Field('email', _$email);
  static String? _$displayName(AuthUser v) => v.displayName;
  static const Field<AuthUser, String> _f$displayName =
      Field('displayName', _$displayName, opt: true);
  static String? _$profileImage(AuthUser v) => v.profileImage;
  static const Field<AuthUser, String> _f$profileImage =
      Field('profileImage', _$profileImage, opt: true);
  static List<String> _$roles(AuthUser v) => v.roles;
  static const Field<AuthUser, List<String>> _f$roles =
      Field('roles', _$roles, opt: true, def: const ['user']);
  static DateTime _$createdAt(AuthUser v) => v.createdAt;
  static const Field<AuthUser, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static DateTime _$lastLoginAt(AuthUser v) => v.lastLoginAt;
  static const Field<AuthUser, DateTime> _f$lastLoginAt =
      Field('lastLoginAt', _$lastLoginAt);

  @override
  final MappableFields<AuthUser> fields = const {
    #id: _f$id,
    #username: _f$username,
    #email: _f$email,
    #displayName: _f$displayName,
    #profileImage: _f$profileImage,
    #roles: _f$roles,
    #createdAt: _f$createdAt,
    #lastLoginAt: _f$lastLoginAt,
  };

  static AuthUser _instantiate(DecodingData data) {
    return AuthUser(
        id: data.dec(_f$id),
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        displayName: data.dec(_f$displayName),
        profileImage: data.dec(_f$profileImage),
        roles: data.dec(_f$roles),
        createdAt: data.dec(_f$createdAt),
        lastLoginAt: data.dec(_f$lastLoginAt));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthUser>(map);
  }

  static AuthUser fromJson(String json) {
    return ensureInitialized().decodeJson<AuthUser>(json);
  }
}

mixin AuthUserMappable {
  String toJson() {
    return AuthUserMapper.ensureInitialized()
        .encodeJson<AuthUser>(this as AuthUser);
  }

  Map<String, dynamic> toMap() {
    return AuthUserMapper.ensureInitialized()
        .encodeMap<AuthUser>(this as AuthUser);
  }

  AuthUserCopyWith<AuthUser, AuthUser, AuthUser> get copyWith =>
      _AuthUserCopyWithImpl<AuthUser, AuthUser>(
          this as AuthUser, $identity, $identity);
  @override
  String toString() {
    return AuthUserMapper.ensureInitialized().stringifyValue(this as AuthUser);
  }

  @override
  bool operator ==(Object other) {
    return AuthUserMapper.ensureInitialized()
        .equalsValue(this as AuthUser, other);
  }

  @override
  int get hashCode {
    return AuthUserMapper.ensureInitialized().hashValue(this as AuthUser);
  }
}

extension AuthUserValueCopy<$R, $Out> on ObjectCopyWith<$R, AuthUser, $Out> {
  AuthUserCopyWith<$R, AuthUser, $Out> get $asAuthUser =>
      $base.as((v, t, t2) => _AuthUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthUserCopyWith<$R, $In extends AuthUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get roles;
  $R call(
      {String? id,
      String? username,
      String? email,
      String? displayName,
      String? profileImage,
      List<String>? roles,
      DateTime? createdAt,
      DateTime? lastLoginAt});
  AuthUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthUser, $Out>
    implements AuthUserCopyWith<$R, AuthUser, $Out> {
  _AuthUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthUser> $mapper =
      AuthUserMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get roles =>
      ListCopyWith($value.roles, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(roles: v));
  @override
  $R call(
          {String? id,
          String? username,
          String? email,
          Object? displayName = $none,
          Object? profileImage = $none,
          List<String>? roles,
          DateTime? createdAt,
          DateTime? lastLoginAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (username != null) #username: username,
        if (email != null) #email: email,
        if (displayName != $none) #displayName: displayName,
        if (profileImage != $none) #profileImage: profileImage,
        if (roles != null) #roles: roles,
        if (createdAt != null) #createdAt: createdAt,
        if (lastLoginAt != null) #lastLoginAt: lastLoginAt
      }));
  @override
  AuthUser $make(CopyWithData data) => AuthUser(
      id: data.get(#id, or: $value.id),
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      displayName: data.get(#displayName, or: $value.displayName),
      profileImage: data.get(#profileImage, or: $value.profileImage),
      roles: data.get(#roles, or: $value.roles),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      lastLoginAt: data.get(#lastLoginAt, or: $value.lastLoginAt));

  @override
  AuthUserCopyWith<$R2, AuthUser, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class LoginCredentialsMapper extends ClassMapperBase<LoginCredentials> {
  LoginCredentialsMapper._();

  static LoginCredentialsMapper? _instance;
  static LoginCredentialsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginCredentialsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginCredentials';

  static String _$username(LoginCredentials v) => v.username;
  static const Field<LoginCredentials, String> _f$username =
      Field('username', _$username);
  static String _$password(LoginCredentials v) => v.password;
  static const Field<LoginCredentials, String> _f$password =
      Field('password', _$password);
  static bool _$rememberMe(LoginCredentials v) => v.rememberMe;
  static const Field<LoginCredentials, bool> _f$rememberMe =
      Field('rememberMe', _$rememberMe, opt: true, def: false);

  @override
  final MappableFields<LoginCredentials> fields = const {
    #username: _f$username,
    #password: _f$password,
    #rememberMe: _f$rememberMe,
  };

  static LoginCredentials _instantiate(DecodingData data) {
    return LoginCredentials(
        username: data.dec(_f$username),
        password: data.dec(_f$password),
        rememberMe: data.dec(_f$rememberMe));
  }

  @override
  final Function instantiate = _instantiate;

  static LoginCredentials fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginCredentials>(map);
  }

  static LoginCredentials fromJson(String json) {
    return ensureInitialized().decodeJson<LoginCredentials>(json);
  }
}

mixin LoginCredentialsMappable {
  String toJson() {
    return LoginCredentialsMapper.ensureInitialized()
        .encodeJson<LoginCredentials>(this as LoginCredentials);
  }

  Map<String, dynamic> toMap() {
    return LoginCredentialsMapper.ensureInitialized()
        .encodeMap<LoginCredentials>(this as LoginCredentials);
  }

  LoginCredentialsCopyWith<LoginCredentials, LoginCredentials, LoginCredentials>
      get copyWith =>
          _LoginCredentialsCopyWithImpl<LoginCredentials, LoginCredentials>(
              this as LoginCredentials, $identity, $identity);
  @override
  String toString() {
    return LoginCredentialsMapper.ensureInitialized()
        .stringifyValue(this as LoginCredentials);
  }

  @override
  bool operator ==(Object other) {
    return LoginCredentialsMapper.ensureInitialized()
        .equalsValue(this as LoginCredentials, other);
  }

  @override
  int get hashCode {
    return LoginCredentialsMapper.ensureInitialized()
        .hashValue(this as LoginCredentials);
  }
}

extension LoginCredentialsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginCredentials, $Out> {
  LoginCredentialsCopyWith<$R, LoginCredentials, $Out>
      get $asLoginCredentials => $base
          .as((v, t, t2) => _LoginCredentialsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginCredentialsCopyWith<$R, $In extends LoginCredentials, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? username, String? password, bool? rememberMe});
  LoginCredentialsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _LoginCredentialsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginCredentials, $Out>
    implements LoginCredentialsCopyWith<$R, LoginCredentials, $Out> {
  _LoginCredentialsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginCredentials> $mapper =
      LoginCredentialsMapper.ensureInitialized();
  @override
  $R call({String? username, String? password, bool? rememberMe}) =>
      $apply(FieldCopyWithData({
        if (username != null) #username: username,
        if (password != null) #password: password,
        if (rememberMe != null) #rememberMe: rememberMe
      }));
  @override
  LoginCredentials $make(CopyWithData data) => LoginCredentials(
      username: data.get(#username, or: $value.username),
      password: data.get(#password, or: $value.password),
      rememberMe: data.get(#rememberMe, or: $value.rememberMe));

  @override
  LoginCredentialsCopyWith<$R2, LoginCredentials, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LoginCredentialsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RegistrationCredentialsMapper
    extends ClassMapperBase<RegistrationCredentials> {
  RegistrationCredentialsMapper._();

  static RegistrationCredentialsMapper? _instance;
  static RegistrationCredentialsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = RegistrationCredentialsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RegistrationCredentials';

  static String _$username(RegistrationCredentials v) => v.username;
  static const Field<RegistrationCredentials, String> _f$username =
      Field('username', _$username);
  static String _$email(RegistrationCredentials v) => v.email;
  static const Field<RegistrationCredentials, String> _f$email =
      Field('email', _$email);
  static String _$password(RegistrationCredentials v) => v.password;
  static const Field<RegistrationCredentials, String> _f$password =
      Field('password', _$password);
  static String? _$displayName(RegistrationCredentials v) => v.displayName;
  static const Field<RegistrationCredentials, String> _f$displayName =
      Field('displayName', _$displayName, opt: true);

  @override
  final MappableFields<RegistrationCredentials> fields = const {
    #username: _f$username,
    #email: _f$email,
    #password: _f$password,
    #displayName: _f$displayName,
  };

  static RegistrationCredentials _instantiate(DecodingData data) {
    return RegistrationCredentials(
        username: data.dec(_f$username),
        email: data.dec(_f$email),
        password: data.dec(_f$password),
        displayName: data.dec(_f$displayName));
  }

  @override
  final Function instantiate = _instantiate;

  static RegistrationCredentials fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RegistrationCredentials>(map);
  }

  static RegistrationCredentials fromJson(String json) {
    return ensureInitialized().decodeJson<RegistrationCredentials>(json);
  }
}

mixin RegistrationCredentialsMappable {
  String toJson() {
    return RegistrationCredentialsMapper.ensureInitialized()
        .encodeJson<RegistrationCredentials>(this as RegistrationCredentials);
  }

  Map<String, dynamic> toMap() {
    return RegistrationCredentialsMapper.ensureInitialized()
        .encodeMap<RegistrationCredentials>(this as RegistrationCredentials);
  }

  RegistrationCredentialsCopyWith<RegistrationCredentials,
          RegistrationCredentials, RegistrationCredentials>
      get copyWith => _RegistrationCredentialsCopyWithImpl<
              RegistrationCredentials, RegistrationCredentials>(
          this as RegistrationCredentials, $identity, $identity);
  @override
  String toString() {
    return RegistrationCredentialsMapper.ensureInitialized()
        .stringifyValue(this as RegistrationCredentials);
  }

  @override
  bool operator ==(Object other) {
    return RegistrationCredentialsMapper.ensureInitialized()
        .equalsValue(this as RegistrationCredentials, other);
  }

  @override
  int get hashCode {
    return RegistrationCredentialsMapper.ensureInitialized()
        .hashValue(this as RegistrationCredentials);
  }
}

extension RegistrationCredentialsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RegistrationCredentials, $Out> {
  RegistrationCredentialsCopyWith<$R, RegistrationCredentials, $Out>
      get $asRegistrationCredentials => $base.as((v, t, t2) =>
          _RegistrationCredentialsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RegistrationCredentialsCopyWith<
    $R,
    $In extends RegistrationCredentials,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? username, String? email, String? password, String? displayName});
  RegistrationCredentialsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _RegistrationCredentialsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RegistrationCredentials, $Out>
    implements
        RegistrationCredentialsCopyWith<$R, RegistrationCredentials, $Out> {
  _RegistrationCredentialsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RegistrationCredentials> $mapper =
      RegistrationCredentialsMapper.ensureInitialized();
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
  RegistrationCredentials $make(CopyWithData data) => RegistrationCredentials(
      username: data.get(#username, or: $value.username),
      email: data.get(#email, or: $value.email),
      password: data.get(#password, or: $value.password),
      displayName: data.get(#displayName, or: $value.displayName));

  @override
  RegistrationCredentialsCopyWith<$R2, RegistrationCredentials, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _RegistrationCredentialsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthSessionMapper extends ClassMapperBase<AuthSession> {
  AuthSessionMapper._();

  static AuthSessionMapper? _instance;
  static AuthSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthSessionMapper._());
      AuthUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthSession';

  static String _$token(AuthSession v) => v.token;
  static const Field<AuthSession, String> _f$token = Field('token', _$token);
  static AuthUser _$user(AuthSession v) => v.user;
  static const Field<AuthSession, AuthUser> _f$user = Field('user', _$user);
  static DateTime _$expiresAt(AuthSession v) => v.expiresAt;
  static const Field<AuthSession, DateTime> _f$expiresAt =
      Field('expiresAt', _$expiresAt);
  static bool _$rememberMe(AuthSession v) => v.rememberMe;
  static const Field<AuthSession, bool> _f$rememberMe =
      Field('rememberMe', _$rememberMe, opt: true, def: false);

  @override
  final MappableFields<AuthSession> fields = const {
    #token: _f$token,
    #user: _f$user,
    #expiresAt: _f$expiresAt,
    #rememberMe: _f$rememberMe,
  };

  static AuthSession _instantiate(DecodingData data) {
    return AuthSession(
        token: data.dec(_f$token),
        user: data.dec(_f$user),
        expiresAt: data.dec(_f$expiresAt),
        rememberMe: data.dec(_f$rememberMe));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthSession>(map);
  }

  static AuthSession fromJson(String json) {
    return ensureInitialized().decodeJson<AuthSession>(json);
  }
}

mixin AuthSessionMappable {
  String toJson() {
    return AuthSessionMapper.ensureInitialized()
        .encodeJson<AuthSession>(this as AuthSession);
  }

  Map<String, dynamic> toMap() {
    return AuthSessionMapper.ensureInitialized()
        .encodeMap<AuthSession>(this as AuthSession);
  }

  AuthSessionCopyWith<AuthSession, AuthSession, AuthSession> get copyWith =>
      _AuthSessionCopyWithImpl<AuthSession, AuthSession>(
          this as AuthSession, $identity, $identity);
  @override
  String toString() {
    return AuthSessionMapper.ensureInitialized()
        .stringifyValue(this as AuthSession);
  }

  @override
  bool operator ==(Object other) {
    return AuthSessionMapper.ensureInitialized()
        .equalsValue(this as AuthSession, other);
  }

  @override
  int get hashCode {
    return AuthSessionMapper.ensureInitialized().hashValue(this as AuthSession);
  }
}

extension AuthSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthSession, $Out> {
  AuthSessionCopyWith<$R, AuthSession, $Out> get $asAuthSession =>
      $base.as((v, t, t2) => _AuthSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthSessionCopyWith<$R, $In extends AuthSession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AuthUserCopyWith<$R, AuthUser, AuthUser> get user;
  $R call(
      {String? token, AuthUser? user, DateTime? expiresAt, bool? rememberMe});
  AuthSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthSession, $Out>
    implements AuthSessionCopyWith<$R, AuthSession, $Out> {
  _AuthSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthSession> $mapper =
      AuthSessionMapper.ensureInitialized();
  @override
  AuthUserCopyWith<$R, AuthUser, AuthUser> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call(
          {String? token,
          AuthUser? user,
          DateTime? expiresAt,
          bool? rememberMe}) =>
      $apply(FieldCopyWithData({
        if (token != null) #token: token,
        if (user != null) #user: user,
        if (expiresAt != null) #expiresAt: expiresAt,
        if (rememberMe != null) #rememberMe: rememberMe
      }));
  @override
  AuthSession $make(CopyWithData data) => AuthSession(
      token: data.get(#token, or: $value.token),
      user: data.get(#user, or: $value.user),
      expiresAt: data.get(#expiresAt, or: $value.expiresAt),
      rememberMe: data.get(#rememberMe, or: $value.rememberMe));

  @override
  AuthSessionCopyWith<$R2, AuthSession, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
