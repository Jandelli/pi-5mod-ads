import 'dart:async';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/auth/user.dart';
import '../services/auth_service.dart';

part 'auth.mapper.dart';

// Auth Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final LoginCredentials credentials;

  const AuthLoginRequested(this.credentials);

  @override
  List<Object> get props => [credentials];
}

class AuthRegisterRequested extends AuthEvent {
  final RegistrationCredentials credentials;

  const AuthRegisterRequested(this.credentials);

  @override
  List<Object> get props => [credentials];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthUserUpdated extends AuthEvent {
  final AuthUser user;

  const AuthUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}

// Auth State
@MappableClass()
abstract class AuthState with AuthStateMappable {
  const AuthState();
}

@MappableClass()
class AuthInitial extends AuthState with AuthInitialMappable {
  const AuthInitial();
}

@MappableClass()
class AuthLoading extends AuthState with AuthLoadingMappable {
  const AuthLoading();
}

@MappableClass()
class AuthAuthenticated extends AuthState with AuthAuthenticatedMappable {
  final AuthUser user;
  final AuthSession session;

  const AuthAuthenticated({
    required this.user,
    required this.session,
  });
}

@MappableClass()
class AuthUnauthenticated extends AuthState with AuthUnauthenticatedMappable {
  const AuthUnauthenticated();
}

@MappableClass()
class AuthError extends AuthState with AuthErrorMappable {
  final String message;

  const AuthError(this.message);
}

// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  late final StreamSubscription<AuthSession?> _authSubscription;

  AuthBloc(this._authService) : super(const AuthInitial()) {
    // Listen to auth state changes
    _authSubscription = _authService.authStateChanges.listen((session) {
      if (session != null && session.isValid) {
        add(AuthUserUpdated(session.user));
      } else {
        if (state is! AuthUnauthenticated && state is! AuthInitial) {
          add(AuthLogoutRequested());
        }
      }
    });

    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authService.initialize();
      final isValid = await _authService.validateSession();

      if (isValid && _authService.currentSession != null) {
        emit(AuthAuthenticated(
          user: _authService.currentUser!,
          session: _authService.currentSession!,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError('Failed to check authentication: ${e.toString()}'));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authService.login(event.credentials);
      if (user != null && _authService.currentSession != null) {
        emit(AuthAuthenticated(
          user: user,
          session: _authService.currentSession!,
        ));
      } else {
        emit(const AuthError('Login failed'));
      }
    } catch (e) {
      // Extract the actual error message from the exception
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage =
            errorMessage.substring(11); // Remove 'Exception: ' prefix
      }
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await _authService.register(event.credentials);
      if (user != null && _authService.currentSession != null) {
        emit(AuthAuthenticated(
          user: user,
          session: _authService.currentSession!,
        ));
      } else {
        emit(const AuthError('Registration failed'));
      }
    } catch (e) {
      // Extract the actual error message from the exception
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage =
            errorMessage.substring(11); // Remove 'Exception: ' prefix
      }
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authService.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Logout failed: ${e.toString()}'));
    }
  }

  void _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    if (_authService.currentSession != null) {
      emit(AuthAuthenticated(
        user: event.user,
        session: _authService.currentSession!,
      ));
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
