// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth.dart';

class AuthStateMapper extends ClassMapperBase<AuthState> {
  AuthStateMapper._();

  static AuthStateMapper? _instance;
  static AuthStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthStateMapper._());
      AuthInitialMapper.ensureInitialized();
      AuthLoadingMapper.ensureInitialized();
      AuthAuthenticatedMapper.ensureInitialized();
      AuthUnauthenticatedMapper.ensureInitialized();
      AuthErrorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthState';

  @override
  final MappableFields<AuthState> fields = const {};

  static AuthState _instantiate(DecodingData data) {
    throw MapperException.missingConstructor('AuthState');
  }

  @override
  final Function instantiate = _instantiate;

  static AuthState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthState>(map);
  }

  static AuthState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthState>(json);
  }
}

mixin AuthStateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  AuthStateCopyWith<AuthState, AuthState, AuthState> get copyWith;
}

abstract class AuthStateCopyWith<$R, $In extends AuthState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  AuthStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class AuthInitialMapper extends ClassMapperBase<AuthInitial> {
  AuthInitialMapper._();

  static AuthInitialMapper? _instance;
  static AuthInitialMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthInitialMapper._());
      AuthStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthInitial';

  @override
  final MappableFields<AuthInitial> fields = const {};

  static AuthInitial _instantiate(DecodingData data) {
    return AuthInitial();
  }

  @override
  final Function instantiate = _instantiate;

  static AuthInitial fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthInitial>(map);
  }

  static AuthInitial fromJson(String json) {
    return ensureInitialized().decodeJson<AuthInitial>(json);
  }
}

mixin AuthInitialMappable {
  String toJson() {
    return AuthInitialMapper.ensureInitialized()
        .encodeJson<AuthInitial>(this as AuthInitial);
  }

  Map<String, dynamic> toMap() {
    return AuthInitialMapper.ensureInitialized()
        .encodeMap<AuthInitial>(this as AuthInitial);
  }

  AuthInitialCopyWith<AuthInitial, AuthInitial, AuthInitial> get copyWith =>
      _AuthInitialCopyWithImpl<AuthInitial, AuthInitial>(
          this as AuthInitial, $identity, $identity);
  @override
  String toString() {
    return AuthInitialMapper.ensureInitialized()
        .stringifyValue(this as AuthInitial);
  }

  @override
  bool operator ==(Object other) {
    return AuthInitialMapper.ensureInitialized()
        .equalsValue(this as AuthInitial, other);
  }

  @override
  int get hashCode {
    return AuthInitialMapper.ensureInitialized().hashValue(this as AuthInitial);
  }
}

extension AuthInitialValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthInitial, $Out> {
  AuthInitialCopyWith<$R, AuthInitial, $Out> get $asAuthInitial =>
      $base.as((v, t, t2) => _AuthInitialCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthInitialCopyWith<$R, $In extends AuthInitial, $Out>
    implements AuthStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AuthInitialCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthInitialCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthInitial, $Out>
    implements AuthInitialCopyWith<$R, AuthInitial, $Out> {
  _AuthInitialCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthInitial> $mapper =
      AuthInitialMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AuthInitial $make(CopyWithData data) => AuthInitial();

  @override
  AuthInitialCopyWith<$R2, AuthInitial, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthInitialCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthLoadingMapper extends ClassMapperBase<AuthLoading> {
  AuthLoadingMapper._();

  static AuthLoadingMapper? _instance;
  static AuthLoadingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthLoadingMapper._());
      AuthStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthLoading';

  @override
  final MappableFields<AuthLoading> fields = const {};

  static AuthLoading _instantiate(DecodingData data) {
    return AuthLoading();
  }

  @override
  final Function instantiate = _instantiate;

  static AuthLoading fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthLoading>(map);
  }

  static AuthLoading fromJson(String json) {
    return ensureInitialized().decodeJson<AuthLoading>(json);
  }
}

mixin AuthLoadingMappable {
  String toJson() {
    return AuthLoadingMapper.ensureInitialized()
        .encodeJson<AuthLoading>(this as AuthLoading);
  }

  Map<String, dynamic> toMap() {
    return AuthLoadingMapper.ensureInitialized()
        .encodeMap<AuthLoading>(this as AuthLoading);
  }

  AuthLoadingCopyWith<AuthLoading, AuthLoading, AuthLoading> get copyWith =>
      _AuthLoadingCopyWithImpl<AuthLoading, AuthLoading>(
          this as AuthLoading, $identity, $identity);
  @override
  String toString() {
    return AuthLoadingMapper.ensureInitialized()
        .stringifyValue(this as AuthLoading);
  }

  @override
  bool operator ==(Object other) {
    return AuthLoadingMapper.ensureInitialized()
        .equalsValue(this as AuthLoading, other);
  }

  @override
  int get hashCode {
    return AuthLoadingMapper.ensureInitialized().hashValue(this as AuthLoading);
  }
}

extension AuthLoadingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthLoading, $Out> {
  AuthLoadingCopyWith<$R, AuthLoading, $Out> get $asAuthLoading =>
      $base.as((v, t, t2) => _AuthLoadingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthLoadingCopyWith<$R, $In extends AuthLoading, $Out>
    implements AuthStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AuthLoadingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthLoadingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthLoading, $Out>
    implements AuthLoadingCopyWith<$R, AuthLoading, $Out> {
  _AuthLoadingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthLoading> $mapper =
      AuthLoadingMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AuthLoading $make(CopyWithData data) => AuthLoading();

  @override
  AuthLoadingCopyWith<$R2, AuthLoading, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthLoadingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthAuthenticatedMapper extends ClassMapperBase<AuthAuthenticated> {
  AuthAuthenticatedMapper._();

  static AuthAuthenticatedMapper? _instance;
  static AuthAuthenticatedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthAuthenticatedMapper._());
      AuthStateMapper.ensureInitialized();
      AuthUserMapper.ensureInitialized();
      AuthSessionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthAuthenticated';

  static AuthUser _$user(AuthAuthenticated v) => v.user;
  static const Field<AuthAuthenticated, AuthUser> _f$user =
      Field('user', _$user);
  static AuthSession _$session(AuthAuthenticated v) => v.session;
  static const Field<AuthAuthenticated, AuthSession> _f$session =
      Field('session', _$session);

  @override
  final MappableFields<AuthAuthenticated> fields = const {
    #user: _f$user,
    #session: _f$session,
  };

  static AuthAuthenticated _instantiate(DecodingData data) {
    return AuthAuthenticated(
        user: data.dec(_f$user), session: data.dec(_f$session));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthAuthenticated fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthAuthenticated>(map);
  }

  static AuthAuthenticated fromJson(String json) {
    return ensureInitialized().decodeJson<AuthAuthenticated>(json);
  }
}

mixin AuthAuthenticatedMappable {
  String toJson() {
    return AuthAuthenticatedMapper.ensureInitialized()
        .encodeJson<AuthAuthenticated>(this as AuthAuthenticated);
  }

  Map<String, dynamic> toMap() {
    return AuthAuthenticatedMapper.ensureInitialized()
        .encodeMap<AuthAuthenticated>(this as AuthAuthenticated);
  }

  AuthAuthenticatedCopyWith<AuthAuthenticated, AuthAuthenticated,
          AuthAuthenticated>
      get copyWith =>
          _AuthAuthenticatedCopyWithImpl<AuthAuthenticated, AuthAuthenticated>(
              this as AuthAuthenticated, $identity, $identity);
  @override
  String toString() {
    return AuthAuthenticatedMapper.ensureInitialized()
        .stringifyValue(this as AuthAuthenticated);
  }

  @override
  bool operator ==(Object other) {
    return AuthAuthenticatedMapper.ensureInitialized()
        .equalsValue(this as AuthAuthenticated, other);
  }

  @override
  int get hashCode {
    return AuthAuthenticatedMapper.ensureInitialized()
        .hashValue(this as AuthAuthenticated);
  }
}

extension AuthAuthenticatedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthAuthenticated, $Out> {
  AuthAuthenticatedCopyWith<$R, AuthAuthenticated, $Out>
      get $asAuthAuthenticated => $base
          .as((v, t, t2) => _AuthAuthenticatedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthAuthenticatedCopyWith<$R, $In extends AuthAuthenticated,
    $Out> implements AuthStateCopyWith<$R, $In, $Out> {
  AuthUserCopyWith<$R, AuthUser, AuthUser> get user;
  AuthSessionCopyWith<$R, AuthSession, AuthSession> get session;
  @override
  $R call({AuthUser? user, AuthSession? session});
  AuthAuthenticatedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthAuthenticatedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthAuthenticated, $Out>
    implements AuthAuthenticatedCopyWith<$R, AuthAuthenticated, $Out> {
  _AuthAuthenticatedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthAuthenticated> $mapper =
      AuthAuthenticatedMapper.ensureInitialized();
  @override
  AuthUserCopyWith<$R, AuthUser, AuthUser> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  AuthSessionCopyWith<$R, AuthSession, AuthSession> get session =>
      $value.session.copyWith.$chain((v) => call(session: v));
  @override
  $R call({AuthUser? user, AuthSession? session}) => $apply(FieldCopyWithData(
      {if (user != null) #user: user, if (session != null) #session: session}));
  @override
  AuthAuthenticated $make(CopyWithData data) => AuthAuthenticated(
      user: data.get(#user, or: $value.user),
      session: data.get(#session, or: $value.session));

  @override
  AuthAuthenticatedCopyWith<$R2, AuthAuthenticated, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthAuthenticatedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthUnauthenticatedMapper extends ClassMapperBase<AuthUnauthenticated> {
  AuthUnauthenticatedMapper._();

  static AuthUnauthenticatedMapper? _instance;
  static AuthUnauthenticatedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthUnauthenticatedMapper._());
      AuthStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthUnauthenticated';

  @override
  final MappableFields<AuthUnauthenticated> fields = const {};

  static AuthUnauthenticated _instantiate(DecodingData data) {
    return AuthUnauthenticated();
  }

  @override
  final Function instantiate = _instantiate;

  static AuthUnauthenticated fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthUnauthenticated>(map);
  }

  static AuthUnauthenticated fromJson(String json) {
    return ensureInitialized().decodeJson<AuthUnauthenticated>(json);
  }
}

mixin AuthUnauthenticatedMappable {
  String toJson() {
    return AuthUnauthenticatedMapper.ensureInitialized()
        .encodeJson<AuthUnauthenticated>(this as AuthUnauthenticated);
  }

  Map<String, dynamic> toMap() {
    return AuthUnauthenticatedMapper.ensureInitialized()
        .encodeMap<AuthUnauthenticated>(this as AuthUnauthenticated);
  }

  AuthUnauthenticatedCopyWith<AuthUnauthenticated, AuthUnauthenticated,
      AuthUnauthenticated> get copyWith => _AuthUnauthenticatedCopyWithImpl<
          AuthUnauthenticated, AuthUnauthenticated>(
      this as AuthUnauthenticated, $identity, $identity);
  @override
  String toString() {
    return AuthUnauthenticatedMapper.ensureInitialized()
        .stringifyValue(this as AuthUnauthenticated);
  }

  @override
  bool operator ==(Object other) {
    return AuthUnauthenticatedMapper.ensureInitialized()
        .equalsValue(this as AuthUnauthenticated, other);
  }

  @override
  int get hashCode {
    return AuthUnauthenticatedMapper.ensureInitialized()
        .hashValue(this as AuthUnauthenticated);
  }
}

extension AuthUnauthenticatedValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthUnauthenticated, $Out> {
  AuthUnauthenticatedCopyWith<$R, AuthUnauthenticated, $Out>
      get $asAuthUnauthenticated => $base.as(
          (v, t, t2) => _AuthUnauthenticatedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthUnauthenticatedCopyWith<$R, $In extends AuthUnauthenticated,
    $Out> implements AuthStateCopyWith<$R, $In, $Out> {
  @override
  $R call();
  AuthUnauthenticatedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _AuthUnauthenticatedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthUnauthenticated, $Out>
    implements AuthUnauthenticatedCopyWith<$R, AuthUnauthenticated, $Out> {
  _AuthUnauthenticatedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthUnauthenticated> $mapper =
      AuthUnauthenticatedMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  AuthUnauthenticated $make(CopyWithData data) => AuthUnauthenticated();

  @override
  AuthUnauthenticatedCopyWith<$R2, AuthUnauthenticated, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _AuthUnauthenticatedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AuthErrorMapper extends ClassMapperBase<AuthError> {
  AuthErrorMapper._();

  static AuthErrorMapper? _instance;
  static AuthErrorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthErrorMapper._());
      AuthStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthError';

  static String _$message(AuthError v) => v.message;
  static const Field<AuthError, String> _f$message =
      Field('message', _$message);

  @override
  final MappableFields<AuthError> fields = const {
    #message: _f$message,
  };

  static AuthError _instantiate(DecodingData data) {
    return AuthError(data.dec(_f$message));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthError fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthError>(map);
  }

  static AuthError fromJson(String json) {
    return ensureInitialized().decodeJson<AuthError>(json);
  }
}

mixin AuthErrorMappable {
  String toJson() {
    return AuthErrorMapper.ensureInitialized()
        .encodeJson<AuthError>(this as AuthError);
  }

  Map<String, dynamic> toMap() {
    return AuthErrorMapper.ensureInitialized()
        .encodeMap<AuthError>(this as AuthError);
  }

  AuthErrorCopyWith<AuthError, AuthError, AuthError> get copyWith =>
      _AuthErrorCopyWithImpl<AuthError, AuthError>(
          this as AuthError, $identity, $identity);
  @override
  String toString() {
    return AuthErrorMapper.ensureInitialized()
        .stringifyValue(this as AuthError);
  }

  @override
  bool operator ==(Object other) {
    return AuthErrorMapper.ensureInitialized()
        .equalsValue(this as AuthError, other);
  }

  @override
  int get hashCode {
    return AuthErrorMapper.ensureInitialized().hashValue(this as AuthError);
  }
}

extension AuthErrorValueCopy<$R, $Out> on ObjectCopyWith<$R, AuthError, $Out> {
  AuthErrorCopyWith<$R, AuthError, $Out> get $asAuthError =>
      $base.as((v, t, t2) => _AuthErrorCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthErrorCopyWith<$R, $In extends AuthError, $Out>
    implements AuthStateCopyWith<$R, $In, $Out> {
  @override
  $R call({String? message});
  AuthErrorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthErrorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthError, $Out>
    implements AuthErrorCopyWith<$R, AuthError, $Out> {
  _AuthErrorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthError> $mapper =
      AuthErrorMapper.ensureInitialized();
  @override
  $R call({String? message}) =>
      $apply(FieldCopyWithData({if (message != null) #message: message}));
  @override
  AuthError $make(CopyWithData data) =>
      AuthError(data.get(#message, or: $value.message));

  @override
  AuthErrorCopyWith<$R2, AuthError, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthErrorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
