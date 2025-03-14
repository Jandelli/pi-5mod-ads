import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.signOut();
      return Right(null);
    } catch (error) {
      // Use a concrete subclass of Failure or make sure Failure is not abstract
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
