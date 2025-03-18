import '../entities/job.dart';
import '../repositories/job_repository.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

class GetRecommendedJobs {
  final JobRepository repository;

  GetRecommendedJobs(this.repository);

  Future<Either<Failure, List<Job>>> call(String userId) {
    return repository.getRecommendedJobs(userId);
  }
}
