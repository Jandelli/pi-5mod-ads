import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart' as app_user;

abstract class AuthRepository {
  Future<Either<Failure, app_user.User>> signInWithEmail(
    String email,
    String password,
  );
  Future<Either<Failure, app_user.User>> signUp(
    String email,
    String password,
    String name,
    String userType,
  );
  Future<Either<Failure, bool>> signOut();
  Future<Either<Failure, app_user.User>> getCurrentUser();
  Future<Either<Failure, bool>> isSignedIn();
  Future<Either<Failure, app_user.User>> signInWithGoogle();
  Future<Either<Failure, app_user.User>> signUpWithDetails(
    String email,
    String password,
    String name,
  );
}
