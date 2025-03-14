import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';

abstract class AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final dynamic signInWithEmail;
  final dynamic signInWithGoogle;
  final dynamic signUp;
  final dynamic signOut;

  AuthBloc({
    required this.authRepository,
    required this.signInWithEmail,
    required this.signInWithGoogle,
    required this.signUp,
    required this.signOut,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>((event, emit) async {
      // handle authentication status check
    });
  }
}
