import 'package:dartz/dartz.dart';
import 'package:flutter_pi/core/error/failures.dart';
import 'package:flutter_pi/domain/entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, User>> call(String userId) {
    return repository.getUserProfile(userId);
  }
}
