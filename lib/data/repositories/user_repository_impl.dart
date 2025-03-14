import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore_user_datasource.dart';
import '../datasources/local_storage_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreUserDataSource firestoreUserDataSource;
  final LocalStorageDataSource localStorageDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.firestoreUserDataSource,
    required this.localStorageDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUserProfile(String userId) async {
    if (!(await networkInfo.isConnected())) {
      return Left(ServerFailure(message: 'No internet connection'));
    }
    try {
      final userData = await firestoreUserDataSource.getUserProfile(userId);
      final user = User.fromJson(userData);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserProfile(
    UserProfile userProfile,
  ) async {
    if (!(await networkInfo.isConnected())) {
      return Left(ServerFailure(message: 'No internet connection'));
    }
    try {
      await firestoreUserDataSource.updateUserProfile(
        userProfile.id,
        userProfile.toJson(),
      );
      return Right(true);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers(List<String> userIds) async {
    if (!(await networkInfo.isConnected())) {
      return Left(ServerFailure(message: 'No internet connection'));
    }
    try {
      List<User> users = [];
      for (var id in userIds) {
        final userData = await firestoreUserDataSource.getUserProfile(id);
        users.add(User.fromJson(userData));
      }
      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
