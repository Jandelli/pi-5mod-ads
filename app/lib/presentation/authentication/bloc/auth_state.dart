part of 'auth_bloc.dart';

abstract class AuthStateClass {
  const AuthStateClass();

  List<Object?> get props => [];
}

class AuthInitialStateClass extends AuthStateClass {}

class AuthLoadingStateClass extends AuthStateClass {}

class AuthenticatedStateClass extends AuthStateClass {
  final String userId;
  final String userType;

  const AuthenticatedStateClass({required this.userId, required this.userType});

  @override
  List<Object> get props => [userId, userType];
}

class UnauthenticatedStateClass extends AuthStateClass {}

class UserTypeSelectionRequiredStateClass extends AuthStateClass {
  final String userId;

  const UserTypeSelectionRequiredStateClass({required this.userId});

  @override
  List<Object> get props => [userId];
}

class AuthErrorStateClass extends AuthStateClass {
  final String message;

  const AuthErrorStateClass({required this.message});

  @override
  List<Object> get props => [message];
}
