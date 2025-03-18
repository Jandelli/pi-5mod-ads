import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/job.dart';
import '../repositories/job_repository.dart';

class GetJobsUsecase {
  final JobRepository repository;

  GetJobsUsecase(this.repository);

  Future<Either<Failure, List<Job>>> call(String userId) {
    return repository.getRecommendedJobs(userId);
  }
}
