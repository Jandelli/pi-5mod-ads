import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile(String userId);
  Future<Either<Failure, bool>> updateUserProfile(UserProfile userProfile);
  Future<Either<Failure, List<User>>> getUsers(List<String> userIds);
}
