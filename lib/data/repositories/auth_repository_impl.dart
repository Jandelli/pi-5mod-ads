// auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dartz/dartz.dart' show Either, Right;
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart' as app_user;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/local_storage_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource firebaseAuthDataSource;
  final LocalStorageDataSource localStorageDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.firebaseAuthDataSource,
    required this.localStorageDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, app_user.User>> signInWithEmail(
    String email,
    String password,
  ) async {
    return Right(
      app_user.User(
        id: 'dummy',
        email: 'dummy@example.com',
        name: 'dummy',
        userType: 'dummy',
      ),
    );
  }

  @override
  Future<Either<Failure, app_user.User>> signUp(
    String email,
    String password,
    String name,
    String userType,
  ) async {
    return Right(
      app_user.User(
        id: 'dummy',
        email: 'dummy@example.com',
        name: 'dummy',
        userType: 'dummy',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> signOut() async {
    return Right(true);
  }

  @override
  Future<Either<Failure, app_user.User>> getCurrentUser() async {
    return Right(
      app_user.User(
        id: 'dummy',
        email: 'dummy@example.com',
        name: 'dummy',
        userType: 'dummy',
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    return Right(true);
  }

  @override
  Future<Either<Failure, app_user.User>> signInWithGoogle() async {
    return Right(
      app_user.User(
        id: 'dummy_google',
        email: 'google@example.com',
        name: 'Google User',
        userType: 'google',
      ),
    );
  }

  @override
  Future<Either<Failure, app_user.User>> signUpWithDetails(
    String email,
    String password,
    String name,
  ) async {
    return Right(
      app_user.User(
        id: 'dummy_signup',
        email: email,
        name: name,
        userType: 'default',
      ),
    );
  }
}
