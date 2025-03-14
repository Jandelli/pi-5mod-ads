part of 'auth_bloc.dart';

abstract class AuthEventBase {
  const AuthEventBase();

  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEventBase {}

class SignInWithEmailEvent extends AuthEventBase {
  final String email;
  final String password;

  const SignInWithEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthEventBase {}

class SignUpEvent extends AuthEventBase {
  final String email;
  final String password;
  final String name;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class SignOutEvent extends AuthEventBase {}

class UserTypeSelectedEvent extends AuthEventBase {
  final String userId;
  final String userType;

  const UserTypeSelectedEvent({required this.userId, required this.userType});

  @override
  List<Object> get props => [userId, userType];
}
